//
//  OrdersDataProvider.swift
//  CopperChallenge
//
//  Created by David Pasztor on 19/02/2022.
//

import Combine
import Foundation
import CoreData
import OSLog

protocol OrdersDataProviderProtocol {
    /// `Publisher` emitting a list of orders
    func ordersPublisher() -> AnyPublisher<[OrderResponseModel], OrdersError>

    func fetchOrders() async throws
}

final class Order: NSManagedObject {
    @NSManaged var amount: NSDecimalNumber
    @NSManaged var createdAt: Date
    @NSManaged var currency: String
    @NSManaged var orderId: String
    @NSManaged var status: String
    @NSManaged var type: String
}

final class RemoteOrdersDataProvider: OrdersDataProviderProtocol {
    private let network: NetworkProtocol
    private let cachedOrdersDataProvider: CachedOrdersDataProvider

    /**
     Designated initialiser.
     - parameter network: `NetworkProtocol` instance to use for the networking. If no value is passed in, a default instance will be created.
     */
    init(network: NetworkProtocol? = nil) {
        self.network = network ?? Network()
        self.cachedOrdersDataProvider = CachedOrdersDataProvider.shared
    }

    func ordersPublisher() -> AnyPublisher<[OrderResponseModel], OrdersError> {
        let url: URL
        do {
            url = try CopperEndpoint.orders.url
        } catch let ordersError as OrdersError {
            return Fail(error: ordersError).eraseToAnyPublisher()
        } catch {
            return Fail(error: .generic(error)).eraseToAnyPublisher()
        }

        return network
            .decodableRequestPublisher(for: url, responseModelType: OrdersResponseModel.self)
            .map(\.orders)
            .mapError { networkingError in .networking(networkingError) }
            .eraseToAnyPublisher()
    }

    func fetchOrders() async throws {
        let url = try CopperEndpoint.orders.url
        let rootResponse = try await network.decodableRequest(for: url, responseModelType: OrdersResponseModel.self)
        try await cachedOrdersDataProvider.cacheOrders(rootResponse.orders)
    }
}

final class CachedOrdersDataProvider {
    static let shared = CachedOrdersDataProvider()

    /// A persistent container to set up the Core Data stack.
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CopperChallenge")

        guard let description = container.persistentStoreDescriptions.first else {
            fatalError("Failed to retrieve a persistent store description.")
        }

        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }

        // Enable persistent store remote change notifications
        description.setOption(true as NSNumber,
                              forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)

        // Enable persistent history tracking
        description.setOption(true as NSNumber,
                              forKey: NSPersistentHistoryTrackingKey)

        container.viewContext.automaticallyMergesChangesFromParent = false
        container.viewContext.name = "viewContext"
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.undoManager = nil
        container.viewContext.shouldDeleteInaccessibleFaults = true
        return container
    }()

    private let logger = Logger(subsystem: "David.Pasztor.Copper", category: "persistence")

    /// A persistent history token used for fetching transactions from the store.
    private var lastToken: NSPersistentHistoryToken?
    private var persistentStoreRemoteChangeSubscription: AnyCancellable?

    private init() {
        persistentStoreRemoteChangeSubscription = NotificationCenter.default.publisher(for: .NSPersistentStoreRemoteChange).sink { _ in
            Task {
                await self.fetchPersistentHistory()
            }
        }
    }

    fileprivate func cacheOrders(_ orders: [OrderResponseModel]) async throws {
        guard !orders.isEmpty else { return }

        logger.debug("caching \(orders.count) orders")

        let taskContext = newTaskContext()
        // Add name and author to identify source of persistent history changes.
        taskContext.name = "cacheContext"
        taskContext.transactionAuthor = "cacheOrders"

        try await taskContext.perform {
            let batchInsertRequest = self.newBatchInsertRequest(orders: orders)
            self.logger.debug("NSBatchInsertRequest created, about to execute it")
            let fetchResult = try taskContext.execute(batchInsertRequest)
            self.logger.debug("NSBatchInsertRequest executed")
            if let batchInsertResult = fetchResult as? NSBatchInsertResult,
               let success = batchInsertResult.result as? Bool, success {
                return
            }
            throw OrdersError.dataPersistenceError
        }
    }

    private func newBatchInsertRequest(orders: [OrderResponseModel]) -> NSBatchInsertRequest {
        var index = 0
        let total = orders.count

        logger.debug("creating NSBatchInsertRequest")

        // Provide one dictionary at a time when the closure is called.
        let batchInsertRequest = NSBatchInsertRequest(entity: Order.entity(), dictionaryHandler: { dictionary in
            guard index < total else { return true }
            dictionary.addEntries(from: orders[index].dictionaryValue)
            index += 1
            return false
        })
        return batchInsertRequest
    }

    func fetchPersistentHistory() async {
        do {
            try await fetchPersistentHistoryTransactionsAndChanges()
        } catch {
            logger.debug("\(error.localizedDescription)")
        }
    }

    private func fetchPersistentHistoryTransactionsAndChanges() async throws {
        let taskContext = newTaskContext()
        taskContext.name = "persistentHistoryContext"
        logger.debug("Start fetching persistent history changes from the store...")

        try await taskContext.perform {
            // Execute the persistent history change since the last transaction.
            let changeRequest = NSPersistentHistoryChangeRequest.fetchHistory(after: self.lastToken)
            let historyResult = try taskContext.execute(changeRequest) as? NSPersistentHistoryResult
            if let history = historyResult?.result as? [NSPersistentHistoryTransaction],
               !history.isEmpty {
                self.mergePersistentHistoryChanges(from: history)
                return
            }

            self.logger.debug("No persistent history transactions found.")
            throw OrdersError.dataPersistenceError
        }

        logger.debug("Finished merging history changes.")
    }

    private func mergePersistentHistoryChanges(from history: [NSPersistentHistoryTransaction]) {
        self.logger.debug("Received \(history.count) persistent history transactions.")
        // Update view context with objectIDs from history change request.
        let viewContext = container.viewContext
        viewContext.perform {
            for transaction in history {
                viewContext.mergeChanges(fromContextDidSave: transaction.objectIDNotification())
                self.lastToken = transaction.token
            }
        }
    }

    /// Creates and configures a private queue context.
    private func newTaskContext() -> NSManagedObjectContext {
        // Create a private queue context.
        let taskContext = container.newBackgroundContext()
        taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return taskContext
    }
}

private extension OrderResponseModel {
    var dictionaryValue: [String: Any] {
        [
            "amount": NSDecimalNumber(decimal: amount),
            "createdAt": createdAt,
            "currency": currency,
            "orderId": orderId,
            "status": status.rawValue,
            "type": type.rawValue
        ]
    }
}

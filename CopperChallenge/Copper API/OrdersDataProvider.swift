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
    func fetchOrders() async throws
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

        container.viewContext.automaticallyMergesChangesFromParent = false
        container.viewContext.name = "viewContext"
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.undoManager = nil
        container.viewContext.shouldDeleteInaccessibleFaults = true
        return container
    }()

    private let logger = Logger(subsystem: "David.Pasztor.Copper", category: "persistence")

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

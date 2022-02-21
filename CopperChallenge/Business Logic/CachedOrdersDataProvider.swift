//
//  CachedOrdersDataProvider.swift
//  CopperChallenge
//
//  Created by David Pasztor on 21/02/2022.
//

import CoreData

/// A persistent storage for orders
protocol OrdersPersistentStorage {
    /// Whether there are cached orders in the storage
    func hasCachedOrders() throws -> Bool
    /// Cache the passed in orders to a persistent storage
    func cacheOrders(_ orders: [OrderResponseModel]) async throws
}

final class CachedOrdersDataProvider: OrdersPersistentStorage {
    static let shared = CachedOrdersDataProvider()

    /// A `CachedOrdersDataProvider` to be used by SwiftUI previews
    static let preview: CachedOrdersDataProvider = {
        let provider = CachedOrdersDataProvider(inMemory: true)
        Order.makePreviews(count: 10, provider: provider)
        return provider
    }()

    /// A persistent container to set up the Core Data stack.
    lazy private(set) var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CopperChallenge")

        guard let description = container.persistentStoreDescriptions.first else {
            fatalError("Failed to retrieve a persistent store description.")
        }

        if inMemory {
            description.url = URL(fileURLWithPath: "/dev/null")
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

    private let inMemory: Bool

    private init(inMemory: Bool = false) {
        self.inMemory = inMemory
    }

    func hasCachedOrders() throws -> Bool {
        let fetchRequest = NSFetchRequest<Order>(entityName: "Order")
        let context = container.viewContext
        let orders = try context.fetch(fetchRequest)
        return !orders.isEmpty
    }

    /// Cache the passed in orders to a persistent storage
    func cacheOrders(_ orders: [OrderResponseModel]) async throws {
        guard !orders.isEmpty else { return }

        // Create a new background context using a private queue so that we don't block the main thread will saving the data
        let taskContext = newTaskContext()

        let mainContext = container.viewContext

        // Asynchronously perform the batch insertions
        try await taskContext.perform {
            // Use an NSBatchInsertRequest, which operates at the SQL level and doesn't load objects into memory and is faster then the other insertion methods
            let batchInsertRequest = self.newBatchInsertRequest(orders: orders)
            batchInsertRequest.resultType = .objectIDs
            let fetchResult = try taskContext.execute(batchInsertRequest)
            if let batchInsertResult = fetchResult as? NSBatchInsertResult,
               let insertedIDs = batchInsertResult.result as? [NSManagedObjectID], !insertedIDs.isEmpty {
                // We ran the batch insert on a background context, so we need to sync the changes to the viewContext as well
                NSManagedObjectContext.mergeChanges(fromRemoteContextSave: [NSInsertedObjectsKey: insertedIDs], into: [mainContext])
            } else {
                throw OrdersError.dataPersistenceError
            }
        }
    }

    /// Create a batch insert request for the specified orders
    private func newBatchInsertRequest(orders: [OrderResponseModel]) -> NSBatchInsertRequest {
        var index = 0
        let total = orders.count

        let batchInsertRequest = NSBatchInsertRequest(entity: Order.entity(), managedObjectHandler: { managedObject in
            guard index < total else { return true }

            if let order = managedObject as? Order {
                let orderResponseModel = orders[index]
                order.amount = NSDecimalNumber(decimal: orderResponseModel.amount)
                order.currency = orderResponseModel.currency
                order.createdAt = orderResponseModel.createdAt
                order.orderId = orderResponseModel.orderId
                order.status = orderResponseModel.status.rawValue
                order.type = orderResponseModel.type.rawValue
            }

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

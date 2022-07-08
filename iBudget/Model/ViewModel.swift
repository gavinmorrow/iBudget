//
//  ViewModel.swift
//  iBudget
//
//  Created by Gavin Morrow on 7/2/22.
//

import Foundation
import CoreData

@MainActor class ViewModel: ObservableObject {
	// MARK: Core Data
	let container: NSPersistentContainer
	var moc: NSManagedObjectContext! = nil
	
	@Published private(set) var transactions: [Transaction] = []
	@Published private(set) var stores: [Store] = []
	
	init() {
		// Create container
		container = NSPersistentContainer(name: "iBudget")
		container.loadPersistentStores { description, error in
			if let error = error {
				print("Error loading Core Data: \(error.localizedDescription)")
				return
			}
			
			self.moc = self.container.viewContext
			self.moc.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
		}
		
		// Load data
		loadData()
	}
	
	func loadData() {
		let transactionsFetchRequest = NSFetchRequest<Transaction>(entityName: "Transaction")
		let storesFetchRequest = NSFetchRequest<Store>(entityName: "Store")
		
		do {
			//                                                        Sort reverse date order
			//                                                            (newest on top)
			transactions = try moc.fetch(transactionsFetchRequest).sorted { $0.date > $1.date }
			stores = try moc.fetch(storesFetchRequest)
		} catch {
			print("Error loading Core Data data: \(error.localizedDescription)")
		}
	}
	
	/// Save data to disk
	func save() {
		if moc.hasChanges {
			do {
				try moc.save()
				loadData()
				print("Saved data! :)")
			} catch {
				print("Error saving: \(error.localizedDescription)")
			}
		}
	}
	
	/// Add a transaction to the transactions array.
	///
	/// Adds a transaction to the beginning of the transactions array.
	/// - Precondition: `amount` must be > 0
	func addTransaction(amount: Double, type: TransactionType = .debt, store: Store, notes: String = "", date: Date = Date()) {
		guard amount > 0 else {
			return
		}
		
		// Add it to the list
		let transaction = Transaction(context: moc)
		transaction.id = UUID()
		transaction.amount = amount
		transaction.type = type
		transaction.store = store
		transaction.notes = notes
		transaction.date = date
		
		save()
	}
	
	/// Add a store
	func addStore(name: String, notes: String = "") {
		let store = Store(context: moc)
		store.id = UUID()
		store.name = name
		store.notes = notes
		
		save()
	}
	
	/// Remove transactions from the transactions array.
	func removeTransactions(at offsets: IndexSet) {
		for offset in offsets {
			moc.delete(transactions[offset])
		}
		
		save()
	}
	
	/// Remove stores from the stores array.
	///
	/// Removes stores from the array. Any transactions that were attached to the store will have a `nil` store property.
	func removeStores(at offsets: IndexSet) {
		for offset in offsets {
			moc.delete(stores[offset])
		}
		
		save()
	}
	
	/// Filter out the results of a Core Data model.
	///
	/// - Parameters:
	///   + key: The key to filter the value.
	///   + value: The value to filter
	///   + comparison: How to match the value. Defaults to `"=="`
	/// - Precondition: `comparison` must  be a valid `NSPredicate` way to match the value.
	/// - Precondition: `entityName` must be a valid entity name in Core Data.
	func filtered<T: NSManagedObject, Value: CVarArg>(entityName: String, key: String, value: Value, by comparison: String = "==") -> [T] {
		let fetchRequest = NSFetchRequest<T>(entityName: entityName)
		fetchRequest.predicate = NSPredicate(format: "%K \(comparison) %@", key, value)
		
		let fetchedResults = (try? moc.fetch(fetchRequest)) as [T]?
		return fetchedResults ?? []
	}
	
	// MARK: State
	@Published var isUnlocked = false
}

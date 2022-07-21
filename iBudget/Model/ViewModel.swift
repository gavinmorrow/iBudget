//
//  ViewModel.swift
//  iBudget
//
//  Created by Gavin Morrow on 7/2/22.
//

import Foundation
import CoreData
import WidgetKit

@MainActor class ViewModel: ObservableObject {
	@Published private(set) var transactions: [Transaction] = dataController.loadDataArray(
		sortDescriptors: [
			NSSortDescriptor(keyPath: \Transaction.optionalDate, ascending: false)
		]
	)
	@Published private(set) var stores: [Store] = dataController.loadDataArray()
	
	var typedAccountBalance: Double {
		transactions.reduce(0.0, +)
	}
	var accountBalance: (amount: Double, type: TransactionType) {
		(amount: abs(typedAccountBalance), type: typedAccountBalance < 0 ? .debt : .credit)
	}
	
	func updateData() {
		transactions = dataController.loadDataArray(
			sortDescriptors: [
				NSSortDescriptor(keyPath: \Transaction.optionalDate, ascending: false)
			]
		)
		
		stores = dataController.loadDataArray()
	}
	
	/// Save data to disk
	/// - Returns: `true` if the data was saved correctly, `false` if there was an error or no data to save.
	@discardableResult
	func save() -> Bool {
		if dataController.moc.hasChanges {
			do {
				try dataController.moc.save()
				updateData()
				dPrint("Saved data! :)")
				return true
			} catch {
				dPrint("Error saving: \(error.localizedDescription)")
				return false
			}
		}
		
		return false
	}
	
	/// Add a transaction to the transactions array.
	///
	/// Adds a transaction to the beginning of the transactions array.
	/// - Precondition: `amount` must be > 0
	@discardableResult
	func addTransaction(
		amount: Double,
		type: TransactionType = .debt,
		store: Store,
		notes: String = "",
		date: Date = Date()
	) -> Transaction {
		precondition(amount > 0, "`amount` must be greater than 0")
		
		// Add it to the list
		let transaction = Transaction(context: dataController.moc)
		transaction.id = UUID()
		transaction.amount = amount
		transaction.type = type
		transaction.store = store
		transaction.notes = notes
		transaction.date = date
		
		save()
		updateWidgets(forKind: .balance)
		
		return transaction
	}
	
	/// Remove transactions from the transactions array.
	func removeTransactions(at offsets: IndexSet) {
		for offset in offsets {
			dataController.moc.delete(transactions[offset])
		}
		
		save()
		updateWidgets(forKind: .balance)
	}
	
	/// Add a store
	@discardableResult
	func addStore(name: String, notes: String = "") -> Store {
		let store = Store(context: dataController.moc)
		store.id = UUID()
		store.name = name
		store.notes = notes
		
		save()
		
		return store
	}
	
	/// Remove stores from the stores array.
	///
	/// Removes stores from the array. Any transactions that were attached to the store will have a `nil` store property.
	func removeStores(at offsets: IndexSet) {
		for offset in offsets {
			dataController.moc.delete(stores[offset])
		}
		
		save()
	}
	
	enum WidgetKind: String {
		case balance = "BalanceWidget"
	}
	
	func updateWidgets(forKind kind: WidgetKind) {
		WidgetCenter.shared.reloadTimelines(ofKind: "com.gm.iBudget.\(kind.rawValue)")
	}
	
	@Published var isUnlocked = false
}

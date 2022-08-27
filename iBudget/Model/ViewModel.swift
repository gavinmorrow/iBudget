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
	@Published private(set) var transactions: [Transaction]! = nil
	@Published private(set) var stores: [Store]! = nil
	
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
	
	func save() {
		dataController.save()
		updateData()
	}
	
	init() {
		updateData()
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
		date: Date = Date.now
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
		WidgetsController.updateWidget(ofKind: .balance)
		
		return transaction
	}
	
	/// Remove transactions from the transactions array.
	func removeTransactions(at offsets: IndexSet) {
		for offset in offsets {
			dataController.moc.delete(transactions[offset])
		}
		
		save()
		WidgetsController.updateWidget(ofKind: .balance)
	}
	
	func editTransaction(
		_ transaction: Transaction,
		newAmount amount: Double? = nil,
		newType type: TransactionType? = nil,
		newStore store: Store? = nil,
		newNotes notes: String? = nil,
		newDate date: Date? = nil
	) {
		transaction.id = UUID()
		if let amount = amount { transaction.amount = amount }
		if let type   = type   { transaction.type   = type }
		if let store  = store  { transaction.store  = store }
		if let notes  = notes  { transaction.notes  = notes }
		if let date   = date   { transaction.date   = date }
		
		save()
		WidgetsController.updateWidget(ofKind: .balance)
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
	
	@Published var isUnlocked = false
}

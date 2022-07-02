//
//  Transactions.swift
//  BudgetTracker
//
//  Created by Gavin Morrow on 7/1/22.
//

import Foundation

/// A class to hold the central array of transactions for the app.
///
/// Handles the loading and saving of the array of transactions.
class Transactions: ObservableObject {
	/// The central array of transactions.
	@Published private(set) var transactions: [Transaction]
	
	/// The path the transactions data is saved at.
	let savePath = FileManager.documentsDirectory
		.appendingPathComponent("transactions.json")
	
	init() {
		guard let data: [Transaction] = try? FileManager().read(from: savePath) else {
			transactions = []
			return
		}
		
		transactions = data
	}
	
	/// Save the transactions array to disk
	func save() {
		// Write with encryption b/c transactions should be private.
		try? FileManager().write(
			transactions,
			to: savePath,
			options: [.atomic, .completeFileProtection]
		)
	}
	
	/// Add a transaction to the transactions array.
	///
	/// Adds a transaction to the beginning of the transactions array.
	func add(transaction: Transaction) {
		transactions.insert(transaction, at: 0)
		save()
	}
	
	/// Remove transactions from the transactions array.
	func remove(at offsets: IndexSet) {
		transactions.remove(atOffsets: offsets)
		save()
	}
	
	/// Get all the transactions in a given time span
	func transactions(in range: ClosedRange<Date>) -> [Transaction] {
		transactions.filter { _ in true }
	}
}

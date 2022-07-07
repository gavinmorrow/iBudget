//
//  ViewModel.swift
//  iBudget
//
//  Created by Gavin Morrow on 7/2/22.
//

import Foundation

@MainActor class ViewModel: ObservableObject {
	init() {
		do {
			guard let data: [Transaction] = try? FileManager().read(from: transactionsSavePath) else {
				self.transactions = []
				
				struct ExitScope: Error {}
				throw ExitScope()
			}
			
			self.transactions = data
		} catch {}
		
		self.budget = Budget(amount: 30)
		
		let amountSpent = self.transactions.reduce(0) { sum, transaction in
			sum + transaction.amount
		}
		// Negatate the amount b/c it is stored as a negative if is it being spent,
		// but the `spend` function takes a positive about for being spent.
		budget.spend(-amountSpent)
	}
	
	// MARK: Transactions
	@Published private(set) var transactions: [Transaction]
	
	/// The path the transactions data is saved at.
	let transactionsSavePath: URL = FileManager().documentsDirectory
		.appendingPathComponent("transactions.json")
	
	/// Save data to disk
	func save() {
		// Write with encryption b/c transactions should be private.
		try? FileManager().write(
			transactions,
			to: transactionsSavePath,
			options: [.atomic, .completeFileProtection]
		)
	}
	
	/// Add a transaction to the transactions array.
	///
	/// Adds a transaction to the beginning of the transactions array.
	func add(transaction: Transaction) {
		// Update budget
		// Negatate the amount b/c it is stored as a negative if is it being spent,
		// but the `spend` function takes a positive about for being spent.
		budget.spend(-transaction.amount)
		
		// Add it to the list
		transactions.insert(transaction, at: 0)
		
		save()
	}
	
	/// Remove transactions from the transactions array.
	func remove(at offsets: IndexSet) {
		// Update budget
		offsets.forEach { index in
			let transaction = transactions[index]
			budget.gain(-transaction.amount)
		}
		
		// Remove it from the list
		transactions.remove(atOffsets: offsets)
		
		save()
	}
	
	/// Get all the transactions in a given time span
	func transactions(in range: ClosedRange<Date>) -> [Transaction] {
		transactions.filter { range.contains($0.date) }
	}
	
	/// Get all the transactions in a given time span
	func transactions(in range: Range<Date>) -> [Transaction] {
		transactions.filter { range.contains($0.date) }
	}
	
	
	// MARK: Budget
	@Published var budget: Budget
	
	
	// MARK: State
	@Published var showingSheet = false
	@Published var isUnlocked = false
}
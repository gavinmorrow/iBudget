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
		
		
		}
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
		
		// Add it to the list
		transactions.insert(transaction, at: 0)
		
		save()
	}
	
	/// Remove transactions from the transactions array.
	func remove(at offsets: IndexSet) {
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
	
	// MARK: State
	@Published var showingSheet = false
	@Published var isUnlocked = false
}

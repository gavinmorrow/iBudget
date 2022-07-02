//
//  ContentView-ViewModel.swift
//  iBudget
//
//  Created by Gavin Morrow on 7/2/22.
//

import Foundation

extension ContentView {
	@MainActor class ViewModel: ObservableObject {
		
		// MARK: Transactions
		@Published private(set) var transactions: [Transaction]
		
		/// The path the transactions data is saved at.
		let transactionsSavePath = FileManager.documentsDirectory
			.appendingPathComponent("transactions.json")
		
		init() {
			guard let data: [Transaction] = try? FileManager().read(from: transactionsSavePath) else {
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
				to: transactionsSavePath,
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
}

//
//  ListView.swift
//  BudgetTracker
//
//  Created by Gavin Morrow on 7/1/22.
//

import SwiftUI

struct ListView: View {
	@EnvironmentObject var transactions: Transactions
	
	var body: some View {
		List {
			ForEach(transactions.transactions) { transaction in
				NavigationLink {
					TransactionDetailView(transaction: transaction)
				} label: {
					TransactionRow(transaction: transaction)
				}
			}
			.onDelete(perform: transactions.remove)
		}
	}
}

struct ListView_Previews: PreviewProvider {
	static var previews: some View {
		NavigationView {
			ListView()
				.navigationTitle("Budget Tracker")
				.environmentObject({ () -> Transactions in
					let transactions = Transactions()
					
					transactions.transactions.forEach {
						transactions.remove(
							at: IndexSet(integer: transactions.transactions.firstIndex(of: $0)!)
						)
					}
					
					for _ in 0..<5 {
						transactions.add(transaction: Transaction.example)
					}
					
					return transactions
				}())
		}
	}
}

//
//  ListView.swift
//  BudgetTracker
//
//  Created by Gavin Morrow on 7/1/22.
//

import SwiftUI

struct ListView: View {
	@EnvironmentObject var viewModel: ContentView.ViewModel
	
	var body: some View {
		List {
			ForEach(viewModel.transactions) { transaction in
				NavigationLink {
					TransactionDetailView(transaction: transaction)
				} label: {
					TransactionRow(transaction: transaction)
				}
			}
			.onDelete { offsets in
				Task { @MainActor in
					viewModel.remove(at: offsets)
				}
			}
		}
	}
}

struct ListView_Previews: PreviewProvider {
	static var previews: some View {
		NavigationView {
			ListView()
				.navigationTitle("Budget Tracker")
				.environmentObject({ () -> ContentView.ViewModel in
					let viewModel = ContentView.ViewModel()
					
					viewModel.transactions.forEach {
						viewModel.remove(
							at: IndexSet(integer: viewModel.transactions.firstIndex(of: $0)!)
						)
					}
					
					for _ in 0..<5 {
						viewModel.add(transaction: Transaction.example)
					}
					
					return viewModel
				}())
		}
	}
}

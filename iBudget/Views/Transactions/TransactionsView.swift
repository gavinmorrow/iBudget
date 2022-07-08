//
//  TransactionsView.swift
//  iBudget
//
//  Created by Gavin Morrow on 7/2/22.
//

import SwiftUI

struct TransactionsView: View {
	@EnvironmentObject var viewModel: ViewModel
	
	@State private var showingSheet = false
	
	var body: some View {
		NavigationView {
			// TODO: balance in account
			List {
				Section {
					ForEach(viewModel.transactions.sorted { $0.date > $1.date }) { transaction in
						NavigationLink {
							TransactionDetailView(transaction: transaction)
						} label: {
							TransactionRow(transaction: transaction)
						}
					}
					.onDelete { offsets in
						Task { @MainActor in
							viewModel.removeTransactions(at: offsets)
						}
					}
				}
			}
			.navigationTitle("Transactions")
			.sheet(isPresented: $showingSheet) {
				CreateTransactionView(viewModel: viewModel)
			}
			.toolbar {
				ToolbarItem(placement: .navigationBarLeading) {
					EditButton()
				}
				
				ToolbarItem(placement: .navigationBarTrailing) {
					Button {
						showingSheet = true
					} label: {
						Label("New Transaction", systemImage: "plus")
					}
				}
			}
		}
	}
}

//struct TransactionsView_Previews: PreviewProvider {
//	static var previews: some View {
//		TransactionsView()
//			.navigationTitle("iBudget")
//			.environmentObject({ () -> ViewModel in
//				let viewModel = ViewModel()
//
//				viewModel.transactions.forEach {
//					viewModel.remove(
//						at: IndexSet(integer: viewModel.transactions.firstIndex(of: $0)!)
//					)
//				}
//
//				for _ in 0..<5 {
//					viewModel.add(transaction: Transaction.example)
//				}
//
//				return viewModel
//			}())
//	}
//}

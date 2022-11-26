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
			VStack(alignment: .leading) {
				Group {
					Text(viewModel.accountBalance.type == .debt ? "Your account is " : "You have ")
					+ Text(viewModel.accountBalance.amount, format: .currency(code: Locale.current.currencyCode ?? "USD"))
					+ Text(viewModel.accountBalance.type == .debt ? " in debt." : " left in your account.")
				}
				.padding(.horizontal)
				
				List {
					Section(header: Text("Transactions")) {
						ForEach(viewModel.transactions) { transaction in
							NavigationLink {
								TransactionView(transaction: transaction)
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
				.listStyle(.plain)
			}
			.navigationTitle("iBudget")
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

struct TransactionsView_Previews: PreviewProvider {
	static var previews: some View {
		let viewModel = ViewModel()
		let store = viewModel.addStore(name: "Test Store")
		
		viewModel.removeTransactions(at: IndexSet(integersIn: 0..<viewModel.transactions.count))
		
		for i in 1...5 {
			viewModel.addTransaction(amount: Double(i), type: i % 2 == 1 ? .credit : .debt, store: store)
		}
		
		return TransactionsView()
			.navigationTitle("iBudget")
			.environmentObject(viewModel)
	}
}

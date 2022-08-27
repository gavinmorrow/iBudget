//
//  TransactionView.swift
//  iBudget
//
//  Created by Gavin Morrow on 8/27/22.
//

import SwiftUI

struct TransactionView: View {
	@StateObject var transaction: Transaction
	@State private var editing: Bool = false
	@EnvironmentObject var viewModel: ViewModel
	
	var body: some View {
		NavigationView {
			TransactionDetailView(transaction: transaction)
				.toolbar {
					Button("Edit") {
						editing = true
					}
				}
		}
		.sheet(isPresented: $editing) {
			TransactionEditView(
				transaction: transaction
			)
		}
	}
}

struct TransactionView_Previews: PreviewProvider {
	static var previews: some View {
		let viewModel = ViewModel()
		
		viewModel.removeTransactions(
			at: IndexSet(
				integersIn: 0 ..< viewModel.transactions.count
			)
		)
		
		viewModel.removeStores(
			at: IndexSet(
				integersIn: 0 ..< viewModel.stores.count
			)
		)
		
		let store = viewModel.addStore(
			name: "Test Store",
			notes: "Just a test :)"
		)
		
		viewModel.addStore(
			name: "Test Store II",
			notes: "Another test :)"
		)
		
		let transaction = viewModel.addTransaction(
			amount: 5,
			type: .debt,
			store: store,
			notes: "Just a test :)"
		)
		
		return TransactionView(
			transaction: transaction
		)
		.environmentObject(viewModel)
	}
}

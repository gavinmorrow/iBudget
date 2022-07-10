//
//  StoreDetailView.swift
//  iBudget
//
//  Created by Gavin Morrow on 7/7/22.
//

import SwiftUI

struct StoreDetailView: View {
	let store: Store
	
	var body: some View {
		List {
			Text(store.notes)
			
			Section(header: Text("Transactions")) {
				ForEach(store.transactions.sorted()) { transaction in
					NavigationLink {
						TransactionDetailView(transaction: transaction)
					} label: {
						TransactionRow(transaction: transaction)
					}
				}
			}
		}
		.listStyle(.inset)
		.padding()
		.navigationTitle(store.name)
		.navigationBarTitleDisplayMode(.large)
	}
}

struct StoreDetailView_Previews: PreviewProvider {
	static var previews: some View {
		let viewModel = ViewModel()
		
		viewModel.removeStores(at: IndexSet(0..<viewModel.stores.count))
		
		let store = viewModel.addStore(name: "Test Store", notes: "Just a test :)")
		
		for i in 1...5 {
			viewModel.addTransaction(
				amount: Double(i),
				type: i % 2 == 1 ? .credit : .debt,
				store: store,
				notes: "amount: \(i)"
			)
		}
		
		return NavigationView {
			StoreDetailView(store: store)
		}
	}
}

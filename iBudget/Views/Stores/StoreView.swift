//
//  StoreView.swift
//  iBudget
//
//  Created by Gavin Morrow on 8/27/22.
//

import SwiftUI

struct StoreView: View {
	@StateObject var store: Store
	@State private var editing: Bool = false
	@EnvironmentObject var viewModel: ViewModel
	
	var body: some View {
		StoreDetailView(store: store)
			.toolbar {
				Button("Edit") {
					editing = true
				}
			}
			.sheet(isPresented: $editing) {
				StoreEditView(
					store: store
				)
			}
	}
}

struct StoreView_Previews: PreviewProvider {
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
		
		viewModel.addTransaction(
			amount: 5,
			type: .debt,
			store: store,
			notes: "Just a test :)"
		)
		
		return NavigationView {
			StoreView(store: store)
				.environmentObject(viewModel)
		}
	}
}

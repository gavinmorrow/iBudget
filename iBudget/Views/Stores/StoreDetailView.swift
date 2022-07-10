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
		VStack(alignment: .leading) {
			Text(store.name)
				.font(.largeTitle)
			Divider()
			
			ScrollView {
				Text(store.notes)
			}
		}
		.padding()
		.navigationTitle(store.name)
		.navigationBarTitleDisplayMode(.inline)
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

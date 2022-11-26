//
//  StoresView.swift
//  iBudget
//
//  Created by Gavin Morrow on 7/7/22.
//

import SwiftUI

struct StoresView: View {
	@EnvironmentObject var viewModel: ViewModel
	
	@State private var showingSheet = false
	
	var body: some View {
		NavigationView {
			List {
				ForEach(viewModel.stores) { store in
					NavigationLink {
						StoreView(store: store)
					} label: {
						Text(store.name)
					}
				}
				.onDelete { offsets in
					Task { @MainActor in
						viewModel.removeStores(at: offsets)
					}
				}
			}
			.listStyle(.plain)
			.navigationTitle("Stores")
			.sheet(isPresented: $showingSheet) {
				CreateStoresView(viewModel: viewModel)
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

struct StoresView_Previews: PreviewProvider {
	static var previews: some View {
		let viewModel = ViewModel()
		viewModel.addStore(name: "Sing's", notes: "Fav deli")
		viewModel.addStore(name: "Bagel Bob's", notes: "Yummy bagels!")
		
		return StoresView()
			.environmentObject(viewModel)
	}
}

//
//  StoreEditView.swift
//  iBudget
//
//  Created by Gavin Morrow on 8/27/22.
//

import SwiftUI

struct StoreEditView: View {
	let store: Store
	@State private var name: String
	@State private var notes: String
	
	@EnvironmentObject var viewModel: ViewModel
	@Environment(\.dismiss) var dismiss
	
	init(store: Store) {
		self.store = store
		
		self._name = State(initialValue: store.name)
		self._notes = State(initialValue: store.notes)
	}
	
	var body: some View {
		NavigationView {
			Form {
				Section {
					TextField("Name", text: $name)
				}
				
				Section(header: Text("Notes (optional)")) {
					TextEditor(text: $notes)
				}
			}
			.navigationTitle("Edit Transaction")
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .navigationBarLeading) {
					Button("Cancel") {
						dismiss()
					}
				}
				
				ToolbarItem(placement: .navigationBarTrailing) {
					Button("Done") {
						viewModel.editStore(
							store,
							newName: name,
							newNotes: notes
						)
						
						dismiss()
					}
				}
		}
		}
	}
}

struct StoreEditView_Previews: PreviewProvider {
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
		
		return StoreEditView(
			store: store
		).environmentObject(viewModel)
		
	}
}

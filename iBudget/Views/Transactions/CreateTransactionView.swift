//
//  CreateTransactionView.swift
//  BudgetTracker
//
//  Created by Gavin Morrow on 6/27/22.
//

import SwiftUI

let currencyFormatter = FloatingPointFormatStyle<Double>.Currency
	.currency(code: Locale.current.currencyCode ?? "USD")

struct CreateTransactionView: View {
	@ObservedObject var viewModel: ViewModel
	
	@Environment(\.dismiss) var dismiss
	
	@State private var amount = 1.0
	@State private var type: TransactionType = .debt
	@State private var date = Date()
	@State private var notes = ""
	
	// Default value of nil will be changed to a valid `Store` in init stage 2
	@State private var storeName: String! = nil
	@State private var selectedStore: Store?
	@State private var showingNewStoreSheet = false
	
	@FocusState private var amountHasFocus: Bool
	@FocusState private var typeHasFocus: Bool
	@FocusState private var storeHasFocus: Bool
	
	@State private var storeSearchTerm = ""
	
	var body: some View {
		NavigationView {
			Form {
				Section {
					TextField("Amount", value: $amount, format: currencyFormatter)
						.keyboardType(.decimalPad)
						.focused($amountHasFocus)
					
					Picker("Type", selection: $type) {
						ForEach(TransactionType.allCases) { type in
							Text(type.rawValue)
						}
					}
					.pickerStyle(.segmented)
					.focused($typeHasFocus)
					
					Picker("Store", selection: $selectedStore) {
						// TODO: option to make a new store
						
						if viewModel.stores.count > 0 {
							ForEach(viewModel.stores.sorted()) { store in
								Text(store.name)
									.tag(store as Store?) // Optional to match @State property
							}
						} else {
							Text("You must create a store first.")
						}
					}
					.focused($storeHasFocus)
					.onAppear {
						if viewModel.stores.count > 0 && storeName == nil {
							storeName = viewModel.stores[0].name
						}
					}
					
					DatePicker("Date", selection: $date)
				} header: {
					Text("Required")
				}
				
				Section {
					TextEditor(text: $notes)
				} header: {
					Text("Notes (optional)")
				}
				
				Section {
					Button("Create") {
						guard let store = selectedStore else { return }
						
						guard amount > 0 else {
							amountHasFocus = true
							return
						}
						
						viewModel.addTransaction(amount: amount, type: type, store: store, notes: notes, date: date)
						
						dismiss()
					}
				}
			}
			.navigationTitle("New Transaction")
			.navigationBarTitleDisplayMode(.inline)
		}
	}
}

struct CreateTransactionView_Previews: PreviewProvider {
	static var previews: some View {
		let viewModel = ViewModel()
		
		return CreateTransactionView(viewModel: viewModel)
	}
}

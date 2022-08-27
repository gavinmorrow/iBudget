//
//  TransactionEditView.swift
//  iBudget
//
//  Created by Gavin Morrow on 8/27/22.
//

import SwiftUI

struct TransactionEditView: View {
	@EnvironmentObject var viewModel: ViewModel
	
	let transaction: Transaction
	@State private var amount: Double
	@State private var type: TransactionType
	@State private var store: Store
	@State private var date: Date
	@State private var notes: String
	
	@Environment(\.dismiss) private var dismiss
	
	init(transaction: Transaction) {
		self.transaction = transaction
		
		self._amount = State(initialValue: transaction.amount)
		self._type   = State(initialValue: transaction.type)
		self._store  = State(initialValue: transaction.store!)
		self._date   = State(initialValue: transaction.date)
		self._notes  = State(initialValue: transaction.notes)
	}
	
	var body: some View {
		NavigationView {
			Form {
				Section {
					TextField("Amount", value: $amount, format: currencyFormatter)
						.keyboardType(.decimalPad)
					
					Picker("Type", selection: $type) {
						ForEach(TransactionType.allCases) { type in
							Text(type.rawValue)
						}
					}
					.pickerStyle(.segmented)
					
					Picker("Store", selection: $store) {
						// TODO: option to make a new store
						
						ForEach(viewModel.stores.sorted()) { store in
							Text(store.name)
								.tag(store)
						}
					}
					
					DatePicker("Date", selection: $date)
				}
				
				Section {
					TextEditor(text: $notes)
				} header: {
					Text("Notes")
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
						viewModel.editTransaction(
							transaction,
							newAmount: amount,
							newType: type,
							newStore: store,
							newNotes: notes,
							newDate: date
						)
						
						dismiss()
					}
				}
			}
		}
	}
}

struct TransactionEditView_Previews: PreviewProvider {
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
		
		let transaction = viewModel.addTransaction(
			amount: 5,
			type: .debt,
			store: store,
			notes: "Just a test :)"
		)
		
		return TransactionEditView(
			transaction: transaction
		)
		.environmentObject(viewModel)
	}
}

//
//  CreateView.swift
//  BudgetTracker
//
//  Created by Gavin Morrow on 6/27/22.
//

import SwiftUI

let currencyFormatter = FloatingPointFormatStyle<Double>.Currency
	.currency(code: Locale.current.currencyCode ?? "USD")

struct CreateView: View {
	var viewModel: ViewModel
	
	@Environment(\.dismiss) var dismiss
	
	@State private var amount = -0.0
	@State private var person = ""
	@State private var date = Date.now
	@State private var notes = ""
	
    var body: some View {
		Form {
			Section {
				TextField("Amount", value: $amount, format: currencyFormatter)
					.keyboardType(.decimalPad)
				
				TextField("Person", text: $person)
				
				DatePicker("Date & Time", selection: $date)
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
					let transaction = Transaction(amount: amount, person: person, date: date, notes: notes)
					viewModel.add(transaction: transaction)
					
					dismiss()
				}
			}
		}
    }
}

struct CreateView_Previews: PreviewProvider {
    static var previews: some View {
		CreateView(viewModel: ViewModel())
    }
}

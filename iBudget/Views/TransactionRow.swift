//
//  TransactionListRow.swift
//  BudgetTracker
//
//  Created by Gavin Morrow on 6/23/22.
//

import SwiftUI

struct TransactionRow: View {
	let transaction: Transaction
	
	@Environment(\.accessibilityDifferentiateWithoutColor)
	private var differentiateWithoutColor
	@Environment(\.horizontalSizeClass)
	private var horizontalSizeClass
	@Environment(\.sizeCategory)
	private var typeSize
	
	var showsExtraInfo: Bool {
		typeSize < .accessibilityLarge
	}
	
	var body: some View {
		HStack {
			AmountView(transaction: transaction)
				.font(.headline.monospaced().weight(.light))
			// Prevent the amount from shrinking
			// The person and notes will skrink to make up for it.
				.fixedSize()
			
			
			if showsExtraInfo {
				Divider()
					.fixedSize()
				
				Text(transaction.person)
					.fontWeight(.light)
					.lineLimit(1)
				
				Spacer()
				Divider()
				
				Text(transaction.date, style: .date)
					.foregroundColor(.secondary)
					.font(.footnote)
					.lineLimit(1)
			}
		}
	}
}

struct TransactionRow_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			NavigationView {
				List {
					NavigationLink {
						Text(Transaction.example.notes)
					} label: {
						TransactionRow(transaction: Transaction.example)
					}
				}
				.navigationTitle("Budget")
			}
		}
	}
}

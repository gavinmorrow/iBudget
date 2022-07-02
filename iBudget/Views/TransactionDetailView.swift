//
//  TransactionDetailView.swift
//  BudgetTracker
//
//  Created by Gavin Morrow on 6/23/22.
//

import SwiftUI

struct TransactionDetailView: View {
	let transaction: Transaction
	
	@Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
	@Environment(\.horizontalSizeClass) var horizontalSizeClass
	@Environment(\.sizeCategory) var typeSize
	
	var body: some View {
		ScrollView {
			VStack {
				Group {
					if typeSize > .extraExtraExtraLarge && horizontalSizeClass == .compact {
						VStack {
							MainInfoView(transaction: transaction)
						}
					} else {
						HStack {
							MainInfoView(transaction: transaction)
						}
					}
				}
				
				Text(transaction.date, format: .dateTime)
					.foregroundColor(.secondary)
					.font(.caption)
				
				Divider()
				
				Text(transaction.notes)
			}
			.padding()
		}
		.background(differentiateWithoutColor
					? nil
					: (
						(transaction.isPositive ? Color.green : Color.red)
							.opacity(0.05)
							.ignoresSafeArea()
					)
		)
		.navigationTitle("\(transaction.amountString), \(transaction.person)")
		.navigationBarTitleDisplayMode(.inline)
	}
	
	struct MainInfoView: View {
		let transaction: Transaction
		
		var body: some View {
			Group {
				AmountView(transaction: transaction)
					.font(.largeTitle.monospaced())
					.fixedSize(horizontal: true, vertical: false)
					.padding(.trailing)
				
				Divider()
				
				Text(transaction.person)
					.font(.largeTitle)
					.padding(.leading)
			}
		}
	}
}

struct TransactionDetailView_Previews: PreviewProvider {
	static var previews: some View {
		TransactionDetailView(transaction: Transaction.example)
	}
}
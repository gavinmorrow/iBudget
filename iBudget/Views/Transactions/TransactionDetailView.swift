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
			
			List {
				if !transaction.notes.isEmpty {
					Text(transaction.notes)
				}
				
				if let store = transaction.store {
					StoreNavigationLink(store: store)
				}
			}
			.listStyle(.plain)
		}
		.padding()
		.navigationTitle("\(transaction.localizedAmount) \(transaction.type.rawValue)")
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
					.fixedSize()
				
				Text(transaction.store?.name ?? "Unknown Store")
					.font(.largeTitle)
					.padding(.leading)
			}
		}
	}
}

fileprivate struct StoreNavigationLink: View {
	let store: Store
	
	var body: some View {
		NavigationLink {
			StoreDetailView(store: store)
		} label: {
			Text(store.name)
		}
	}
}

struct TransactionDetailView_Previews: PreviewProvider {
	static var previews: some View {
		let viewModel = ViewModel()
		
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
		
		return NavigationView {
			TransactionDetailView(transaction: transaction)
		}
	}
}

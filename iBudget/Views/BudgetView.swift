//
//  BudgetView.swift
//  iBudget
//
//  Created by Gavin Morrow on 7/3/22.
//

import SwiftUI

struct BudgetView: View {
	@EnvironmentObject var viewModel: ContentView.ViewModel
	
	@State var isEditing: Bool = false
	
	var body: some View {
		NavigationView {
			ZStack {
				if isEditing {
					Form {
						TextField(
							"Amount",
							value: $viewModel.budget.amount,
							format: .currency(code: Locale.current.currencyCode ?? "USD")
						)
						
						Picker("Time Span", selection: $viewModel.budget.timeSpan) {
							ForEach(Budget.BudgetInterval.allCases) { interval in
								Text(interval.rawValue.capitalized)
									.tag(interval)
							}
						}
					}
				} else {
					List {
						Text("You get \(viewModel.budget.amountString) \(viewModel.budget.timeSpanString)")
					}
				}
			}
			.navigationTitle("Your Budget")
			.toolbar {
				Button(isEditing ? "Done" : "Edit") {
					withAnimation { isEditing.toggle() }
				}
			}
		}
	}
}

struct BudgetView_Previews: PreviewProvider {
	static var previews: some View {
				BudgetView()
					.environmentObject({ () -> ContentView.ViewModel in
						let viewModel = ContentView.ViewModel()
		
						viewModel.transactions.forEach {
							viewModel.remove(
								at: IndexSet(integer: viewModel.transactions.firstIndex(of: $0)!)
							)
						}
		
						for _ in 0..<5 {
							viewModel.add(transaction: Transaction.example)
						}
		
						return viewModel
					}())
	}
}

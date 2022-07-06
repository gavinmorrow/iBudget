//
//  BudgetView.swift
//  iBudget
//
//  Created by Gavin Morrow on 7/3/22.
//

import SwiftUI

struct BudgetView: View {
	@EnvironmentObject var viewModel: ViewModel
	@State var isEditing: Bool = true
	
	var body: some View {
		NavigationView {
			ZStack {
				if isEditing {
					Form {
						Section {
							TextField(
								"Amount",
								value: $viewModel.budget.amount,
								format: .currency(code: Locale.current.currencyCode ?? "USD")
							)
							
							Picker("Repeats", selection: $viewModel.budget.timeSpan) {
								ForEach(RepeatingTimeInterval.allCases) { interval in
									Text(RepeatingTimeInterval.rawValue(for: interval).capitalized)
										.tag(interval)
								}
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
			.environmentObject({ () -> ViewModel in
				let viewModel = ViewModel()
				
				viewModel.transactions.forEach {
					viewModel.remove(
						at: IndexSet(integer: viewModel.transactions.firstIndex(of: $0)!)
					)
				}
				
				for _ in 0..<5 {
					viewModel.add(transaction: Transaction.example)
				}
				
//				viewModel.budget.timeSpan = .custom(interval: 0)
				
				return viewModel
			}())
	}
}

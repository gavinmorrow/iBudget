//
//  TransactionsView.swift
//  iBudget
//
//  Created by Gavin Morrow on 7/2/22.
//

import SwiftUI

struct TransactionsView: View {
	@EnvironmentObject var viewModel: ContentView.ViewModel
	
	var body: some View {
		NavigationView {
			ListView()
				.navigationTitle("iBudget")
				.toolbar {
					ToolbarItem(placement: .navigationBarLeading) {
						EditButton()
					}
					
					ToolbarItem(placement: .navigationBarTrailing) {
						Button {
							viewModel.showingSheet = true
						} label: {
							Label("New Transaction", systemImage: "plus")
						}
					}
				}
		}
	}
}

struct TransactionsView_Previews: PreviewProvider {
	static var previews: some View {
		TransactionsView()
			.navigationTitle("iBudget")
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

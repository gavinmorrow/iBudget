//
//  ContentView.swift
//  BudgetTracker
//
//  Created by Gavin Morrow on 6/23/22.
//

import SwiftUI
import LocalAuthentication

struct ContentView: View {
	@StateObject var viewModel = ViewModel()
	
	var body: some View {
		TabView {
			TransactionsView()
				.tabItem {
					Label("Transactions", systemImage: "list.star")
						.symbolVariant(.none)
				}
			
			BudgetView()
				.tabItem {
					Label("Budget", systemImage: "dollarsign")
						.symbolVariant(.none.circle)
				}
		}
		.environmentObject(viewModel)
		.sheet(isPresented: $viewModel.showingSheet) {
			CreateView(viewModel: viewModel)
		}
	}
	
	func authenticate() {
		let context = LAContext()
		var error: NSError?
		
		if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
			let reason = "Unlock your transactions."
			
			context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { sucess, authenticationError in
				Task { @MainActor in
					self.viewModel.isUnlocked = sucess
				}
			}
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}


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
		NavigationView {
			ListView()
				.navigationTitle("Expenses")
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

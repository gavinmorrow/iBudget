//
//  BudgetTrackerApp.swift
//  BudgetTracker
//
//  Created by Gavin Morrow on 6/23/22.
//

import SwiftUI

@main
struct IBudgetApp: App {
	var body: some Scene {
		WindowGroup {
			ContentView()
				.onAppear {
					// For warnings related to this: https://www.hackingwithswift.com/forums/100-days-of-swiftui/unable-to-simultaneously-satisfy-constraints-warning-when-adding-a-navigation-title/12883/15365
#if DEBUG
					UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
#endif
				}
		}
	}
}

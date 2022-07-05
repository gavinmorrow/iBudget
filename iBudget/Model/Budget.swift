//
//  Budget.swift
//  iBudget
//
//  Created by Gavin Morrow on 7/2/22.
//

import Foundation

@MainActor class Budget: ObservableObject {
	enum BudgetInterval: String, Hashable, Identifiable, CaseIterable {
		case none
		case daily
		case weekly
		case monthly
		case yearly
		
		// TODO: Implement custom
		// Maybe make an optional property that is only active if it is custom?
//		case custom(interval: TimeInterval)
		
		var id: Self { self }
	}
	
	init(amount: Double, timeSpan: BudgetInterval = .weekly, amountSpent: Double = 0) {
		self.amount = amount
		self.amountSpent = amountSpent
		self.amountLeft = amount - amountSpent
		
		self.timeSpan = timeSpan
	}
	
	@Published var amount: Double
	@Published private(set) var amountSpent: Double
	@Published private(set) var amountLeft: Double
	
	@Published var timeSpan: BudgetInterval = .weekly
	
	func spend(_ amount: Double) {
		amountSpent += amount
		amountLeft -= amount
	}
	func gain(_ amount: Double) {
		amountSpent -= amount
		amountLeft += amount
	}
}

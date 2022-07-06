//
//  Budget.swift
//  iBudget
//
//  Created by Gavin Morrow on 7/2/22.
//

import Foundation

@MainActor class Budget: ObservableObject {
	init(amount: Double, timeSpan: RepeatingTimeInterval = .weekly, amountSpent: Double = 0) {
		self.amount = amount
		self.amountSpent = amountSpent
		self.amountLeft = amount - amountSpent
		
		self.timeSpan = timeSpan
	}
	
	@Published var amount: Double
	var amountString: String {
		let formatter = NumberFormatter()
		formatter.numberStyle = .currency
		return formatter.string(from: amount as NSNumber) ?? "n/a"
	}
	@Published private(set) var amountSpent: Double
	@Published private(set) var amountLeft: Double
	
	@Published var timeSpan: RepeatingTimeInterval = .weekly
	var timeSpanString: String {
		RepeatingTimeInterval.rawValue(for: timeSpan)
	}
	
	func spend(_ amount: Double) {
		amountSpent += amount
		amountLeft -= amount
	}
	func gain(_ amount: Double) {
		amountSpent -= amount
		amountLeft += amount
	}
}

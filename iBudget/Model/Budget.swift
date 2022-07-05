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
	var amountString: String {
		let formatter = NumberFormatter()
		formatter.numberStyle = .currency
		return formatter.string(from: amount as NSNumber) ?? "n/a"
	}
	@Published private(set) var amountSpent: Double
	@Published private(set) var amountLeft: Double
	
	@Published var timeSpan: BudgetInterval = .weekly
	var timeSpanString: String {
		switch timeSpan {
			case .none:
				return ""
			case .daily:
				return "daily"
			case .weekly:
				return "weekly"
			case .monthly:
				return "monthly"
			case .yearly:
				return "yearly"
//			case .custom(var interval):
//				// TODO: clean up this code
//				
//				func round(_ num: Double, places: Int = 2)-> Double {
//					guard places > 0 else { return 0 }
//					return (num * pow(10.0, Double(places))).rounded() / pow(10.0, Double(places))
//				}
//				
//				// test for minutes
//				guard interval / 60 >= 1 else { return "every \(round(interval)) second(s)"}
//				interval /= 60
//				
//				// test for hours
//				guard interval / 60 >= 1 else { return "every \(round(interval)) minute(s)"}
//				interval /= 60
//				
//				// test for days
//				guard interval / 24 >= 1 else { return "every \(round(interval)) hour(s)"}
//				interval /= 24
//				
//				// test for weeks
//				guard interval / 7 >= 1 else { return "every \(round(interval)) day(s)"}
//				interval /= 7
//				
//				// test for ~months
//				guard interval / 30 >= 1 else { return "every \(round(interval)) week(s)"}
//				interval /= 30
//				
//				// test for years
//				guard interval / 365 >= 1 else { return "every \(round(interval)) month(s)"}
//				interval /= 365
//				
//				return "every \(interval) year(s)"
		}
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

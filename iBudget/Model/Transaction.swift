//
//  Transaction.swift
//  BudgetTracker
//
//  Created by Gavin Morrow on 6/23/22.
//

import Foundation

/// A struct with all the data about a transaction.
struct Transaction: Codable, Identifiable, Comparable, Equatable {
	// MARK: Main properties
	/// The unique id of the transaction
	var id = UUID()
	
	/// The amount of money that was transfered in the transaction.
	var amount: Double
	
	/// The person the transaction was with.
	var person: String
	
	/// The date and time the transaction took place.
	var date: Date
	
	/// Extra notes about the transaction.
	///
	/// Any extra notes about the transaction. For example, it could describe what the transaction was for.
	var notes: String = ""
	
	
	// MARK: Convenience” properties
	/// The numerical sign of the amount.
	///
	/// - "`-`" when negative
	/// - "`+`" when positive
	/// - "` `" when zero
	var sign: String {
		if amount < 0 {
			return "-"
		} else if amount > 0 {
			return "+"
		} else {
			return " "
		}
	}
	
	/// `amount` in a localized string form.
	var amountString: String {
		NumberFormatter.localizedString(from: amount as NSNumber, number: .currency)
	}
	
	/// A `Bool` representing whether or not `amount` is positive
	///
	/// `true` when `amount` is greater than zero.
	/// It is equal to `amount > 0`
	var isPositive: Bool { amount > 0 }
	
	/// A `Bool` representing whether or not `amount` is negative
	///
	/// `true` when `amount` is less than zero.
	/// It is equal to `amount < 0`
	var isNegative: Bool { amount < 0 }
	
	/// A `Bool` representing whether or not `amount` is zero
	///
	/// `true` when `amount` is equal to zero.
	/// It is equal to `amount.isZero`
	var isZero: Bool { amount.isZero }
	
	
	// MARK: Protocol conformance
	// Comparable
	/// Compares two transactions based on their amounts.
	static func <(lhs: Transaction, rhs: Transaction) -> Bool {
		lhs.amount < rhs.amount
	}
	
	// Equatable
	/// Compares two transactions based on their ids.
	/// If the ids are the same, the transactions should be the same.
	static func ==(lhs: Transaction, rhs: Transaction) -> Bool {
		lhs.id == rhs.id
	}
	
	
	// MARK: Example transaction
	/// An example transaction
	static var example: Transaction {
		Transaction(
			amount: Double.random(in: -6...6),
			person: "John Doe",
			date: Date.now,
			notes: "Some info about this (totally real) transaction."
		)
	}
}

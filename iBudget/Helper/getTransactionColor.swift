//
//  getTransactionColor.swift
//  BudgetTracker
//
//  Created by Gavin Morrow on 6/30/22.
//

import SwiftUI

/// Get the SwiftUI color of the transaction.
func getColor(of transaction: Transaction) -> Color {
	switch transaction.amount {
		case let amount where amount < 0:
			return .red
		case let amount where amount > 0:
			return .green
		default:
			return .gray
	}
}

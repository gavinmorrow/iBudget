//
//  getTransactionColor.swift
//  BudgetTracker
//
//  Created by Gavin Morrow on 6/30/22.
//

import SwiftUI

/// Get the SwiftUI color of the transaction.
func getColor(of transaction: Transaction) -> Color {
	switch transaction.type {
		case .debt:
			return .red
		case .credit:
			return .green
	}
}

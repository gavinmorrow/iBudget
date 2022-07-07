//
//  AmountView.swift
//  BudgetTracker
//
//  Created by Gavin Morrow on 6/24/22.
//

import SwiftUI

/// A view to display the amount in the transaction.
struct AmountView: View {
	let transaction: Transaction
	
	@Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
	
	var body: some View {
		Group {
			Text(transaction.sign)
			// Make the amount positive because the sign is added above
			+ Text(abs(transaction.amount), format: .currency(code: Locale.current.currencyCode ?? "USD"))
		}
		.foregroundColor(differentiateWithoutColor ? .black : getColor(of: transaction))
	}
}

struct AmountView_Previews: PreviewProvider {
    static var previews: some View {
		AmountView(transaction: Transaction.example)
    }
}

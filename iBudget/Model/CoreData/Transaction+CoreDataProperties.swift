//
//  Transaction+CoreDataProperties.swift
//  iBudget
//
//  Created by Gavin Morrow on 7/7/22.
//
//

import Foundation
import CoreData


extension Transaction {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Transaction> {
        return NSFetchRequest<Transaction>(entityName: "Transaction")
    }

    @NSManaged public var cents: Int64
    @NSManaged public var optionalId: UUID?
	@NSManaged public var optionalDate: Date?
    @NSManaged public var optionalNotes: String?
    @NSManaged public var isDebt: Bool
    @NSManaged public var store: Store?

	
	public var id: UUID {
		get { optionalId ?? UUID() }
		set {
			log("id changing")
			objectWillChange.send()
			optionalId = newValue
		}
	}
	
	public var amount: Double {
		get { Double(cents) / 100.0 }
		set {
			objectWillChange.send()
			cents = Int64(min(newValue * 100, Double(Int64.max)))
		}
	}
	
	/// The amount taking into consideration the `type` of the transaction.
	///
	/// - If it is a debt, the amount returned will be neative.
	/// - If it is a credit, the amount returned will be positive.
	public var typedAmount: Double {
		if type == .debt {
			return amount * -1
		} else {
			return amount
		}
	}
	
	public var localizedAmount: String {
		amount.formatted(.currency(code: Locale.current.currencyCode ?? "USD"))
	}
	
	public var date: Date {
		get { optionalDate ?? Date() }
		set {
			objectWillChange.send()
			optionalDate = newValue
		}
	}
	
	public var notes: String {
		get { optionalNotes ?? "" }
		set {
			objectWillChange.send()
			optionalNotes = newValue
		}
	}
	
	public var type: TransactionType {
		get { isDebt ? .debt : .credit }
		set {
			objectWillChange.send()
			isDebt = newValue == .debt
		}
	}
}

extension Transaction: Comparable {
	public static func <(lhs: Transaction, rhs: Transaction) -> Bool {
		if lhs.type == rhs.type {
			return lhs.amount < rhs.amount
		}
		return lhs.type == .debt
	}
}

extension Transaction {
	public static func + (lhs: Transaction, rhs: Transaction) -> Double {
		lhs.typedAmount + rhs.typedAmount
	}
	
	public static func + (lhs: Double, rhs: Transaction) -> Double {
		lhs + rhs.typedAmount
	}
}

extension Transaction /* Equatable */ {
	public static func ==(lhs: Transaction, rhs: Transaction) -> Bool {
		lhs.id == rhs.id
	}
}

extension Transaction : Identifiable {

}

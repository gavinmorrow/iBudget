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

    @NSManaged public var cents: Int32
    @NSManaged public var optionalId: UUID?
	@NSManaged public var optionalDate: Date?
    @NSManaged public var optionalNotes: String?
    @NSManaged public var isDebt: Bool
    @NSManaged public var store: Store?

	
	public var id: UUID {
		get { optionalId ?? UUID() }
		set { optionalId = newValue }
	}
	
	public var amount: Double {
		get { Double(cents) / 100.0 }
		set { cents = Int32(newValue * 100) }
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
		let formatter = NumberFormatter()
		formatter.currencyCode = Locale.current.currencyCode ?? "USD"
		return formatter.string(from: amount as NSNumber)!
	}
	
	public var date: Date {
		get { optionalDate ?? Date() }
		set { optionalDate = newValue}
	}
	
	public var notes: String {
		get { optionalNotes ?? "" }
		set { optionalNotes = newValue}
	}
	
	public var type: TransactionType {
		get { isDebt ? .debt : .credit }
		set { isDebt = newValue == .debt}
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

extension Transaction /* Equatable */ {
	public static func ==(lhs: Transaction, rhs: Transaction) -> Bool {
		lhs.id == rhs.id
	}
}

extension Transaction : Identifiable {

}

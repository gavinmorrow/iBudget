//
//  Store+CoreDataProperties.swift
//  iBudget
//
//  Created by Gavin Morrow on 7/7/22.
//
//

import Foundation
import CoreData


extension Store {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Store> {
        return NSFetchRequest<Store>(entityName: "Store")
    }

    @NSManaged public var optionalId: UUID?
    @NSManaged public var optionalName: String?
    @NSManaged public var optionalNotes: String?
    @NSManaged public var transactionsNSSet: NSSet?
	
	public var id: UUID {
		get { optionalId ?? UUID() }
		set { optionalId = newValue }
	}
	
	public var name: String {
		get { optionalName ?? "Unknown Store" }
		set { optionalName = newValue }
	}
	
	public var notes: String {
		get { optionalNotes ?? "" }
		set { optionalNotes = newValue}
	}

	public var transactions: [Transaction] {
		let set = transactionsNSSet as? Set<Transaction> ?? []
		return set.sorted()
	}
}

extension Store: Comparable {
	public static func < (lhs: Store, rhs: Store) -> Bool {
		lhs.name < rhs.name
	}
}

// MARK: Generated accessors for transaction
extension Store {

    @objc(addTransactionObject:)
    @NSManaged public func addToTransactions(_ value: Transaction)

    @objc(removeTransactionObject:)
    @NSManaged public func removeFromTransactions(_ value: Transaction)

    @objc(addTransaction:)
    @NSManaged public func addToTransactions(_ values: NSSet)

    @objc(removeTransaction:)
    @NSManaged public func removeFromTransactions(_ values: NSSet)

}

extension Store : Identifiable {

}

//
//  loadData.swift
//  iBudget
//
//  Created by Gavin Morrow on 7/10/22.
//

import Foundation
import CoreData

func loadCDContainer() -> NSPersistentContainer {
	// Create container
	let container = NSPersistentContainer(name: "iBudget")
	container.loadPersistentStores { description, error in
		if let error = error {
			print("Error loading Core Data: \(error.localizedDescription)")
			return
		}
		container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
	}
	
	return container
}

func loadCDMoc() -> NSManagedObjectContext {
	let container: NSPersistentContainer = loadCDContainer()
	return container.viewContext
}

func loadTransactions() -> [Transaction] {
	let moc = loadCDMoc()
	let request = NSFetchRequest<Transaction>(entityName: "Transaction")
	
	//                                                              Sort reverse date order
	//                                                                 (newest on top)
	let transactions = try? moc.fetch(request).sorted { $0.date > $1.date }
	
	return transactions ?? []
}

func loadStores() -> [Store] {
	let moc = loadCDMoc()
	let request = NSFetchRequest<Store>(entityName: "Store")
	
	let stores = try? moc.fetch(request).sorted()
	
	return stores ?? []
}

func loadData() -> (
	container: NSPersistentContainer,
	moc: NSManagedObjectContext,
	transactions: [Transaction],
	stores: [Store]
) {
	(
		container: loadCDContainer(),
		moc: loadCDMoc(),
		transactions: loadTransactions(),
		stores: loadStores()
	)
}

//
//  DataController.swift
//  iBudget
//
//  Created by Gavin Morrow on 7/12/22.
//

import Foundation
import CoreData

let dataController = DataController(name: "iBudget")

class DataController {
	let persistenContainerName: String
	
	lazy var persistentContainer: NSPersistentContainer = { () -> NSPersistentContainer in
		// Create container
		let container = NSPersistentContainer(name: persistenContainerName)
		container.loadPersistentStores { description, error in
			if let error = error {
				print("Error loading Core Data: \(error.localizedDescription)")
				return
			}
			container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
		}
		
		return container
	}()
	
	var moc: NSManagedObjectContext { persistentContainer.viewContext }
	
	init(name: String) {
		persistenContainerName = name
	}
}

extension DataController {
	/// A function to load generic data from CoreData.
	/// - Parameter defaultValue: The default value for the data if it can't be found. Defaults to `nil`.
	/// - Precondition: There must be only one instance of the data. If not, the first one will be returned.
	func loadData<T: NSManagedObject>(predicate: NSPredicate = NSPredicate(), defaultValue: T? = nil) -> T? {
		let fetchedResults: [T] = loadDataArray(predicate: predicate)
		
		guard fetchedResults.count > 0 else {
			print("WARNING: No CoreData results were found.")
			return defaultValue
		}
		
		if fetchedResults.count != 1 {
			print("WARNING: There is more than 1 CoreData fetched result. Only the first one will be returned.")
		}
		
		return fetchedResults[0]
	}
	
	/// A function to load a generic array of data from CoreData.
	/// - Parameter defaultValue: The default value for the data if it can't be found. Defaults to an empty array of the type.
	func loadDataArray<T: NSManagedObject>(predicate: NSPredicate = NSPredicate(), defaultValue: [T] = []) -> [T] {
		let fetchRequest = NSFetchRequest<T>()
		fetchRequest.predicate = predicate
		
		return (try? moc.fetch(fetchRequest)) ?? defaultValue
	}
}

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


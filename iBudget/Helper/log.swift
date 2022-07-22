//
//  log.swift
//  iBudget
//
//  Created by Gavin Morrow on 7/20/22.
//

import CoreData

/// A function to print debug messages to the console.
/// - Parameters:
///   - msg: The message to print.
///   - terminator: The thing to print after all the items.
///
/// This will print `|>` followed by the log level before the items (seperated by `" "`),
/// to make it more noticeable among all the other logs.
func log(_ msg: String, terminator: String = "\n") {
#if DEBUG
	print("|>", msg, terminator: terminator)
#endif
}

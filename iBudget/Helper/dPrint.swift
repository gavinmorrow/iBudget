//
//  dPrint.swift
//  iBudget
//
//  Created by Gavin Morrow on 7/20/22.
//

import CoreData

/// A function to debug by printing.
/// - Parameters:
///   - items: The things to print.
///   - seperator: The seperator between items.
///   - terminator: The thing to print after all the items.
///
/// This will print `|>` before the items (seperated by `" "`),
/// to make it more noticeable among all the other logs.
func dPrint(_ items: Any..., seperator: String = " ", terminator: String = "\n") {
#if DEBUG
	print(
		"|>",
		items.map { "\($0)" }
			.joined(separator: " "),
		separator: seperator,
		terminator: terminator
	)
#endif
}

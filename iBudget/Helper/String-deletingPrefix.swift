//
//  String-deletingPrefix.swift
//  iBudget
//
//  Created by Gavin Morrow on 7/5/22.
//

import Foundation

extension String {
	func deletingPrefix(_ prefix: String) -> String {
		guard self.hasPrefix(prefix) else { return self }
		return String(self.dropFirst(prefix.count))
	}
}

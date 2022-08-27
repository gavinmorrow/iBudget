//
//  Double-rounded.swift
//  iBudget
//
//  Created by Gavin Morrow on 7/12/22.
//

import Foundation

extension Double {
	public func rounded(to places: Int) -> Double {
		let power = Double(truncating: pow(10, places) as NSNumber)
		return (self * power).rounded() / power
	}
}

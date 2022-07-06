//
//  RepeatingTimeInterval.swift
//  iBudget
//
//  Created by Gavin Morrow on 7/5/22.
//

import Foundation

/// A wrapper around TimeInterval for usual (repeating) amounts of time.
///
/// An enum that contains cases for most common repeating amounts of time.
enum RepeatingTimeInterval: Hashable, Identifiable, CaseIterable {
	static var allCases: [Self] = [.none, .daily, .weekly, .monthly, .yearly]
	
	// raw value inplementationx
	static func rawValue(for timeSpan: Self) -> String {
		switch timeSpan {
			case .none:
				return "never"
			case .daily:
				return "daily"
			case .weekly:
				return "weekly"
			case .monthly:
				return "monthly"
			case .yearly:
				return "yearly"
//			case .custom(var interval):
//				func round(_ num: Double, places: Int = 2)-> Double {
//					guard places > 0 else { return 0 }
//					return (num * pow(10.0, Double(places))).rounded() / pow(10.0, Double(places))
//				}
//
//				// test for minutes
//				guard interval / 60 >= 1 else { return "every \(round(interval)) second(s)"}
//				interval /= 60
//
//				// test for hours
//				guard interval / 60 >= 1 else { return "every \(round(interval)) minute(s)"}
//				interval /= 60
//
//				// test for days
//				guard interval / 24 >= 1 else { return "every \(round(interval)) hour(s)"}
//				interval /= 24
//
//				// test for weeks
//				guard interval / 7 >= 1 else { return "every \(round(interval)) day(s)"}
//				interval /= 7
//
//				// test for ~months
//				guard interval / 30 >= 1 else { return "every \(round(interval)) week(s)"}
//				interval /= 30
//
//				// test for years
//				guard interval / 365 >= 1 else { return "every \(round(interval)) month(s)"}
//				interval /= 365
//
//				return "every \(interval) year(s)"
		}
	}
	init?(rawValue: String) {
		switch rawValue {
			case "":
				self = .none
			case "daily":
				self =  .daily
			case "weekly":
				self =  .weekly
			case "monthly":
				self = .monthly
			case "yearly":
				self = .yearly
			default:
				return nil
//			case let string:
//				let custom = string.deletingPrefix("every ").split(separator: " ")
//				guard custom.count == 2, Double(custom[0]) != nil else { return nil }
//
//				var time = Double(custom[0])!
//				let unit = String(custom[1])
//
//				switch unit {
//					case _ where unit.hasSuffix("year(s)"):
//						time /= 365
//						fallthrough
//					case _ where unit.hasSuffix("month(s)"):
//						time /= 30
//						fallthrough
//					case _ where unit.hasSuffix("week(s)"):
//						time /= 7
//						fallthrough
//					case _ where unit.hasSuffix("day(s)"):
//						time /= 24
//						fallthrough
//					case _ where unit.hasSuffix("hour(s)"):
//						time /= 60
//						fallthrough
//					case _ where unit.hasSuffix("minute(s)"):
//						time /= 60
//						fallthrough
//					case _ where unit.hasSuffix("seconds(s)"):
//						self = .custom(interval: time)
//					default:
//						return nil
//				}
		}
	}
	
	case none
	case daily
	case weekly
	case monthly
	case yearly
//	case custom(interval: TimeInterval)
	
	var id: Self { self }
}

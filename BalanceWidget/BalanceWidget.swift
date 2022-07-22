//
//  BalanceWidget.swift
//  BalanceWidget
//
//  Created by Gavin Morrow on 7/10/22.
//

import WidgetKit
import SwiftUI
import Intents
import CoreData

struct Provider: IntentTimelineProvider {
	func placeholder(in context: Context) -> SimpleEntry {
		SimpleEntry(date: Date(), configuration: TimeSpanIntent())
	}
	
	func getSnapshot(for configuration: TimeSpanIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
		let entry = SimpleEntry(date: Date(), configuration: configuration)
		completion(entry)
	}
	
	func getTimeline(for configuration: TimeSpanIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
		let entries: [SimpleEntry] = [
			SimpleEntry(date: Date(), configuration: configuration)
		]
		
		let timeline = Timeline(entries: entries, policy: .never)
		completion(timeline)
	}
}

struct SimpleEntry: TimelineEntry {
	let date: Date
	let configuration: TimeSpanIntent
	
	var transactions: [Transaction]
	var balance: Double { transactions.reduce(0, +) }
	
	/// The balance in a human readable format.
	var localizedBalance: String {
		let currencyCode = Locale.current.currencyCode ?? "USD"
		
		if balance < 1_000 /* 1 thousand */ {
			return balance.formatted(.currency(code: currencyCode))
		}
		
		let numbers = ["Thousand", "Million", "Billion", "Trillion", "Quadrillion", "Quintillion"]
		
		var i = 0
		var num = 1_000.0 /* 1 thousand */
		while balance / 1_000 > num {
			i += 1
			num *= 1_000
		}
		
		return "\((balance / num).rounded(to: configuration.decimalPlaces as! Int)) \(numbers[i])"
	}
	
	init(date: Date, configuration: TimeSpanIntent) {
		log("Starting Widget...")
		
		// Init date & config
		self.date = date
		self.configuration = configuration
		
		let timeSpan: Date? = {
			let calendar = Calendar.current
			let date = Date.now
			
			switch configuration.timeSpan {
				case .unknown, .allTime:
					return .distantPast
				case .calendarWeek:
					return calendar.dateInterval(of: .weekOfYear, for: date)?.start
				case .calendarMonth:
					return calendar.dateComponents([.year, .month], from: date).date
				case .calendarYear:
					return calendar.dateComponents([.year], from: date).date
				case .week:
					let components = DateComponents(weekOfYear: -1)
					return calendar.date(byAdding: components, to: date)
				case .month:
					let components = DateComponents(month: -1)
					return calendar.date(byAdding: components, to: date)
				case .year:
					let components = DateComponents(year: -1)
					return calendar.date(byAdding: components, to: date)
			}
		}()
		
		log(timeSpan?.debugDescription ?? "No time span")
		
		transactions = dataController.loadDataArray(
			predicate: NSPredicate(format: "optionalDate >= %@", argumentArray: [timeSpan ?? .distantPast])
		)
	}
}

struct BalanceWidgetEntryView : View {
	var entry: Provider.Entry
	
	var body: some View {
		VStack(alignment: .leading) {
			Text("Balance:")
				.font(.headline)
				.foregroundColor(.secondary)
			
			Text(entry.localizedBalance)
				.font(.largeTitle)
				.lineLimit(3)
				.minimumScaleFactor(0.5)
				.allowsTightening(true)
				.scaledToFit()
			
			Spacer()
		}
		.frame(maxWidth: .infinity, alignment: .leading)
		.padding()
	}
}

@main
struct BalanceWidget: Widget {
	let kind: String = "com.gm.iBudget.BalanceWidget"
	
	var body: some WidgetConfiguration {
		IntentConfiguration(kind: kind, intent: TimeSpanIntent.self, provider: Provider()) { entry in
			BalanceWidgetEntryView(entry: entry)
		}
		.configurationDisplayName("Balance")
		.description("View your current account balance.")
	}
}

struct BalanceWidget_Previews: PreviewProvider {
	static var previews: some View {
		BalanceWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: TimeSpanIntent()))
			.previewContext(WidgetPreviewContext(family: .systemSmall))
	}
}

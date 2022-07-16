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
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
	
	var transactions: [Transaction]
	var balance: Double { transactions.reduce(4_242_424_242.42, +) }
	
	init(date: Date, configuration: ConfigurationIntent) {
		// Init date & config
		self.date = date
		self.configuration = configuration
		
		transactions = dataController.loadDataArray()
	}
}

struct BalanceWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
		VStack(alignment: .leading) {
			Text("Balance:")
				.font(.headline)
				.foregroundColor(.secondary)
			
			Text(entry.balance, format: .currency(code: Locale.current.currencyCode ?? "USD"))
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
    let kind: String = "BalanceWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            BalanceWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct BalanceWidget_Previews: PreviewProvider {
    static var previews: some View {
        BalanceWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

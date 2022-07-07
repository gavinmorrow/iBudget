//
//  TransactionsWidget.swift
//  TransactionsWidget
//
//  Created by Gavin Morrow on 7/6/22.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
	func placeholder(in context: Context) -> SimpleEntry {
		SimpleEntry()
	}
	
	func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
		let entry = SimpleEntry()
		completion(entry)
	}
	
	func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
		let timeline = Timeline(entries: [SimpleEntry()], policy: .never)
		completion(timeline)
	}
}

struct SimpleEntry: TimelineEntry {
	let date: Date
	var transactions: [Transaction]
	let transactionsSavePath: URL
	
	init(date: Date) {
		self.date = date
		self.transactionsSavePath = FileManager().documentsDirectory
			.appendingPathComponent("transactions.json")
		self.transactions = (try? FileManager().read(from: transactionsSavePath)) ?? []
		
		print(transactionsSavePath.absoluteString)
	}
	init() {
		self.init(date: Date())
	}
}

struct TransactionsWidgetEntryView : View {
	var entry: Provider.Entry
	
	@Environment(\.widgetFamily) private var widgetFamily
	
	var transactionsTrimmed: [Transaction] {
		let amountToTrim: Int
		switch widgetFamily {
			case .systemMedium:
				amountToTrim = 3
			case .systemLarge:
				amountToTrim = 6
			case .systemExtraLarge:
				amountToTrim = 12
			default:
				amountToTrim = 1
		}
		return Array(entry.transactions.prefix(amountToTrim))
	}
	
	var body: some View {
		Group {
			if widgetFamily == .systemExtraLarge {
				HStack {
					ListView(transactions: Array(transactionsTrimmed.prefix(6)))
					
					if transactionsTrimmed.count > 6 {
						ListView(
							transactions: Array(
								transactionsTrimmed.suffix(
									max(transactionsTrimmed.count - 6, 0)
								)
							)
						)
					}
				}
			} else {
				ListView(transactions: transactionsTrimmed)
			}
		}
		.padding()
		.frame(maxWidth: .infinity, maxHeight: .infinity)
	}
	
	struct ListView: View {
		let transactions: [Transaction]
		var count: Int { transactions.count }
		var body: some View {
			VStack(alignment: .leading, spacing: 0) {
				if transactions.isEmpty {
					Text("No transactions.")
				} else {
					ForEach(Array(transactions.enumerated()), id: \.element) { index, transaction in
						AmountView(transaction: transaction)
							.padding(.vertical)
						
						// Don't show the divider on the last element
						if index < count - 1 { Divider() }
					}
				}
			}
		}
	}

}

@main
struct TransactionsWidget: Widget {
	let kind: String = "TransactionsWidget"
	
	var body: some WidgetConfiguration {
		StaticConfiguration(kind: kind, provider: Provider()) { entry in
			TransactionsWidgetEntryView(entry: entry)
		}
		.configurationDisplayName("Transactions")
		.description("A list of your most recent transactions. ")
		.supportedFamilies([.systemMedium, .systemLarge, .systemExtraLarge])
	}
}

struct TransactionsWidget_Previews: PreviewProvider {
	static var previews: some View {
		let viewModel = ViewModel()
		for i in 0..<16 {
			viewModel.add(transaction: Transaction(amount: -Double(i), person: "Person \(i)", date: Date()))
		}
		
		return Group {
			TransactionsWidgetEntryView(entry: SimpleEntry(date: Date()))
				.previewContext(WidgetPreviewContext(family: .systemMedium))
			
			TransactionsWidgetEntryView(entry: SimpleEntry(date: Date()))
				.previewContext(WidgetPreviewContext(family: .systemLarge))
			
			TransactionsWidgetEntryView(entry: SimpleEntry(date: Date()))
				.previewContext(WidgetPreviewContext(family: .systemExtraLarge))
		}
	}
}

//
//  WidgetsController.swift
//  iBudget
//
//  Created by Gavin Morrow on 7/21/22.
//

import class WidgetKit.WidgetCenter

enum WidgetsController {
	enum WidgetKind: String {
		case balance = "com.gm.iBudget.BalanceWidget"
	}
	
	static func updateAllWidgets() {
		log("Reloading all widgets.")
		WidgetCenter.shared.reloadAllTimelines()
	}
	
	static func updateWidget(ofKind kind: String) {
		log("Reloading widget of kind \(kind)")
		WidgetCenter.shared.reloadTimelines(ofKind: kind)
	}
	
	static func updateWidget(ofKind kind: WidgetKind) {
		updateWidget(ofKind: kind.rawValue)
	}
}

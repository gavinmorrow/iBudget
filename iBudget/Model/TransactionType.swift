//
//  TransactionType.swift
//  iBudget
//
//  Created by Gavin Morrow on 7/7/22.
//

import Foundation

public enum TransactionType: String, CaseIterable, Identifiable, Hashable, Codable, Equatable {
	case debt
	case credit
	
	public var id: Self { self }
}

//
//  FileManager-Extension.swift
//  BudgetTracker
//
//  Created by Gavin Morrow on 6/30/22.
//

import Foundation

extension FileManager {
	/// The documents directory for the app.
	static var documentsDirectory: URL {
		// find all possible documents directories for this user
		let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		
		// just send back the first one, which should be the only one
		return paths[0]
	}
	
	/// Read a file from disk
	/// - Parameter path: The URL of the file being read from.
	/// - Returns: The data from the file. The data type must conform to `Decodable`.
	func read<T: Decodable>(from path: URL) throws -> T {
		let data = try Data(contentsOf: path)
		return try JSONDecoder().decode(T.self, from: data)
	}
	
	/// Write data to disk
	/// - Parameter data: The data being written to disk. Must conform to `Encodable`.
	/// - Parameter path: The URL of the file being written to.
	/// - Parameter options: Options for writing data to disk. By default it will write atomically.
	func write<T: Encodable>(_ data: T, to path: URL, options: Data.WritingOptions = [.atomic]) throws {
		let data = try JSONEncoder().encode(data)
		try data.write(to: path, options: options)
	}
}

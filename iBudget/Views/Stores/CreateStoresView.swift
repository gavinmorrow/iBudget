//
//  CreateStoresView.swift
//  iBudget
//
//  Created by Gavin Morrow on 7/7/22.
//

import SwiftUI

struct CreateStoresView: View {
	@ObservedObject var viewModel: ViewModel
	@Environment(\.dismiss) var dismiss
	
	@State private var name: String = ""
	@State private var notes: String = ""
	
	@FocusState private var nameHasFocus
	
    var body: some View {
		Form {
			Section(header: Text("Required")) {
				TextField("Name", text: $name)
					.focused($nameHasFocus)
			}
			
			Section(header: Text("Notes (optional)")) {
				TextEditor(text: $notes)
			}
			
			Section {
				Button("Create") {
					guard !name.isEmpty else {
						nameHasFocus = true
						return
					}
					
					viewModel.addStore(name: name, notes: notes)
					dismiss()
				}
			}
		}
    }
}

struct CreateStoresView_Previews: PreviewProvider {
    static var previews: some View {
		let viewModel = ViewModel()
		viewModel.addStore(name: "Sing's", notes: "Fav deli")
		viewModel.addStore(name: "Bagel Bob's", notes: "Yummy bagels!")
		
		return CreateStoresView(viewModel: viewModel)
    }
}

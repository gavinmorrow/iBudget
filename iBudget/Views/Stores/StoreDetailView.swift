//
//  StoreDetailView.swift
//  iBudget
//
//  Created by Gavin Morrow on 7/7/22.
//

import SwiftUI

struct StoreDetailView: View {
	let store: Store
	
	var body: some View {
		VStack(alignment: .leading) {
			Text(store.name)
				.font(.largeTitle)
			Divider()
			
			ScrollView {
				Text(store.notes)
			}
		}
		.padding()
		.navigationTitle(store.name)
		.navigationBarTitleDisplayMode(.inline)
	}
}

//struct StoreDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        StoreDetailView()
//    }
//}

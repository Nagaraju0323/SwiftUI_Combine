//
//  ContentView.swift
//  Combine_Swiftui
//
//  Created by Nagaraju on 05/11/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var ViewModel = ProductViewModel()
    var body: some View {
        VStack {
            List {
                ForEach(ViewModel.prodcuts,id:\.self){ products in 
                    Text("\(products.title)")
                }
            }.listStyle(.plain)
        }.onAppear() {
//          ViewModel.loading()
            ViewModel.loadingCombine()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

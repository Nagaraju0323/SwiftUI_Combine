//
//  ProductViewModel.swift
//  Combine_Swiftui
//
//  Created by Nagaraju on 05/11/24.
//

import Foundation
import SwiftUI
import Combine

class ProductViewModel:ObservableObject {
    @Published private(set) var prodcuts = [ProductModel]()
    var apiRequest : HttpRequest
    init(apiRequest: HttpRequest = APIService()) {
        self.apiRequest = apiRequest
    }
    private var cancelled = Set<AnyCancellable>()
    
    func loading() {
       Task {
            let result = try await apiRequest.fetchDetails(url:"https://fakestoreapi.com/products" ,
                                                           type: [ProductModel].self)
           DispatchQueue.main.async{
               self.prodcuts = result
           }
        }
    }
    
    func loadingCombine() {
          apiRequest.fetchDetailsCombine(url:"https://fakestoreapi.com/products" ,
                                         type: [ProductModel].self)
               .receive(on: RunLoop.main)
               .sink(receiveCompletion: {_ in 
                   print("complete the Data Task ")
               }, receiveValue: { response in
                   self.prodcuts = response
               }).store(in: &cancelled)
    }
    
}

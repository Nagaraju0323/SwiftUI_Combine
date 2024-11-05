//
//  ProductModel.swift
//  Combine_Swiftui
//
//  Created by Nagaraju on 05/11/24.
//

struct ProductModel: Codable,Hashable{
    let id: Int
    let title: String
    let price: Double
    let description: String
    let category: Category
    let image: String
    let rating: Rating
    static func == (lhs:ProductModel,rhs:ProductModel) -> Bool{
        return lhs.id == rhs.id
    }
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
}

enum Category: String, Codable {
    case electronics = "electronics"
    case jewelery = "jewelery"
    case menSClothing = "men's clothing"
    case womenSClothing = "women's clothing"
}

// MARK: - Rating
struct Rating: Codable {
    let rate: Double
    let count: Int
}



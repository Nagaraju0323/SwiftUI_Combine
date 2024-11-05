//
//  APIService.swift
//  Combine_Swiftui
//
//  Created by Nagaraju on 05/11/24.
//

import Foundation
import Combine


enum ErrorRepsonse:Error {
    case badURL,NodataFound,ModelDataError
    var errorMessage:String {
        switch self {
        case .NodataFound:
            return "NoDataFound"
        case .badURL:
            return "BadURL"
        case .ModelDataError:
            return "ModelDataError"
        }
    }
}

protocol HttpRequest {
    func fetchDetails<T:Decodable>(url:String?,type:T.Type) async throws -> T
    func fetchDetailsCombine<T:Decodable>(url:String?,type:T.Type) -> AnyPublisher<T,Error>
}


class APIService:HttpRequest{
    func fetchDetails<T:Decodable>(url:String?,type:T.Type) async throws -> T {
        guard let url = url else { throw ErrorRepsonse.badURL }
        do {
            let (data,response) = try await URLSession.shared.data(from: URL(string: url)!)
            guard let response = response as? HTTPURLResponse,(200...299).contains(response.statusCode) else { throw ErrorRepsonse.NodataFound }
            let jsonData = try JSONDecoder().decode(type.self, from: data)
            return jsonData
        }catch _ {
            throw ErrorRepsonse.NodataFound
        }
    }
    
    func fetchDetailsCombine<T:Decodable>(url:String?,type:T.Type) -> AnyPublisher<T,Error> {
        guard let url = url else {
            return Fail(outputType: type, failure: ErrorRepsonse.badURL).eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: URLRequest(url: URL(string: url)!))
            .subscribe(on:DispatchQueue.global(qos: .background))
            .tryMap{ data,response -> Data in
                guard let response = response as? HTTPURLResponse,(200...299).contains(response.statusCode) else {
                    throw ErrorRepsonse.NodataFound
                }
                return data
            }
            .decode(type: type.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    
}

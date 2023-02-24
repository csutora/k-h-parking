//
//  HttpController.swift
//  K&H Parking
//
//  Created by Nara Csutora on 2023. 02. 24..
//

import Foundation
import SwiftUI

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case decodingError
    case serverError(Int)
    case unknownError
    case invalidCredentials
}

//struct HttpHandler {
//
//
//
//
//
//    var items: [Item] = []
//
//    func fetchData() async throws -> [Item] {
//            guard let url = URL(string: "https://example.com/api/items") else {
//                throw APIError.invalidURL
//            }
//
//            let (data, _) = try await URLSession.shared.data(from: url)
//
//            let decoder = JSONDecoder()
//            let items = try decoder.decode([Item].self, from: data)
//
//            return items
//        }
//
//}

struct LoginRequest: Encodable {
    let email: String
    let password: String
}

struct LoginResponse: Decodable {
    let statusCode: Int
    let token: String
    let name: String
    let licensePlates: [String]
}

class AuthenticationHandler: ObservableObject {
    @Published var loginError: Error?
    @Published var token: String?
    @Published var name: String?
    @Published var licensePlates: [String]?
    
    func login(email: String, password: String) async {
        guard let url = URL(string: "http://143.42.22.73:3000/employee/fasz") else {
            self.loginError = APIError.invalidURL
            return
        }
        
        //let request = LoginRequest(email: email, password: password)
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //urlRequest.httpBody = try? JSONEncoder().encode(request)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            
            switch httpResponse.statusCode {
            case 200..<300:
                let decoder = JSONDecoder()
                let loginResponse = try decoder.decode(LoginResponse.self, from: data)
                self.token = loginResponse.token
                self.name = loginResponse.name
                self.licensePlates = loginResponse.licensePlates
                self.loginError = nil
            case 400..<500:
                self.loginError = APIError.invalidCredentials
            case 500..<600:
                self.loginError = APIError.serverError(httpResponse.statusCode)
            default:
                self.loginError = APIError.unknownError
            }
        } catch {
            self.loginError = error
        }
    }
}


//
//    .task {
//                do {
//                    let fetchedItems = try await fetchData()
//                    self.items = fetchedItems
//                } catch {
//                    print("Error fetching data: \(error.localizedDescription)")
//                }
//            }

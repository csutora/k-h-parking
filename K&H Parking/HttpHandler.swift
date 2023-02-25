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

//TODO login, logout, session, sign up --> AUTH
//AUTH/login lesz majd

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

//week- availibility, reserve, give-up

struct ScheduleResponse: Decodable {
    let statusCode: Int
    let emptySpots: [Int]
    let reservedDays: [Bool]
    let queueDays: [Bool]
    let priorityDays: [Bool]
}

class ScheduleHandler: ObservableObject {
    @Published var httpError: Error?
    @Published var calendar: CalendarStorage?
    
    func getSchedule(token: String) async {
        guard let url = URL(string: "http://143.42.22.73:3000/schedule/week_availability") else {
            self.httpError = APIError.invalidURL
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            
            switch httpResponse.statusCode {
            case 200..<300:
                let decoder = JSONDecoder()
                let httpResponse = try decoder.decode(ScheduleResponse.self, from: data)
                self.calendar?.emptySpots = httpResponse.emptySpots
                self.calendar?.reservedDays = httpResponse.reservedDays
                self.calendar?.queueDays = httpResponse.queueDays
                self.calendar?.priorityDays = httpResponse.priorityDays
                self.httpError = nil
            case 400..<500:
                self.httpError = APIError.invalidCredentials
            case 500..<600:
                self.httpError = APIError.serverError(httpResponse.statusCode)
            default:
                self.httpError = APIError.unknownError
            }
        } catch {
            self.httpError = error
        }
    }
}

//EMPLOYEE: current, all, schedule





//
//    .task {
//                do {
//                    let fetchedItems = try await fetchData()
//                    self.items = fetchedItems
//                } catch {
//                    print("Error fetching data: \(error.localizedDescription)")
//                }
//            }

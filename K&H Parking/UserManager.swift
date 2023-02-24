//
//  UserManager.swift
//  K&H Parking
//
//  Created by Török Péter on 2023. 02. 23..
//

import Foundation


final class UserManager {
    
    static let shared = UserManager()
    
    private let persistenceController = PersistenceController.shared
    
    private init() {}
    
    var currentUser: User? {
        persistenceController.loadUser()
    }

}

import Foundation
import UIKit
import CoreData

//a test

struct Session: Codable {
    var token: String
    var name: String
    var email: String
    var licensePlates: [String]
    var favoriteNames: [String]
    var favoriteEmails: [String]
}

struct Settings: Codable {
    var notifEnabled: Bool
    var notifAutomatic: Bool
    var notifTime: Date
}



@objc(User)
class User: NSManagedObject {
    @NSManaged var name: String
    @NSManaged var email: String
    @NSManaged var licensePlates: [String]
}

@objc(UserStorage)
class UserStorage: NSManagedObject {
    @NSManaged var users: [User]
}

@objc(CalendarStorage)
class CalendarStorage: NSManagedObject {
    @NSManaged var emptySpots: [Int]
    @NSManaged var reservedDays: [Bool]
    @NSManaged var queueDays: [Bool]
    @NSManaged var priorityDays: [Bool]

}


class PersistenceController {
    static let shared = PersistenceController()
    
    private let sessionKey = "session"
    private let settingsKey = "settings"
    
    //Settings and Session -> UserDefaults
    
    func saveSettings(settings: Settings) {
        do {
            let data = try JSONEncoder().encode(settings)
            UserDefaults.standard.set(data, forKey: settingsKey)
        } catch {
            print("Failed to encode settings: \(error.localizedDescription)")
        }
    }
    
    func loadSettings() -> Settings? {
        guard let data = UserDefaults.standard.data(forKey: settingsKey) else {
            return nil
        }
        do {
            let settings = try JSONDecoder().decode(Settings.self, from: data)
            return settings
        } catch {
            print("Failed to decode settings: \(error.localizedDescription)")
            return nil
        }
    }
    
    func saveSession(_ session: Session) {
            do {
                let data = try JSONEncoder().encode(session)
                UserDefaults.standard.set(data, forKey: sessionKey)
            } catch {
                print("Failed to encode session: \(error.localizedDescription)")
            }
    }
    
    func loadSession() -> Session? {
            guard let data = UserDefaults.standard.data(forKey: sessionKey) else {
                return nil
            }
            do {
                let session = try JSONDecoder().decode(Session.self, from: data)
                return session
            } catch {
                print("Failed to decode session: \(error.localizedDescription)")
                return nil
            }
    }
    
    
    // Users and Calendar -> CoreData
    
    
    
}


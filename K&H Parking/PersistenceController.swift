import Foundation
import UIKit
import CoreData

@objc(User)
class User: NSManagedObject {
    @NSManaged var name: String
    @NSManaged var email: String
    @NSManaged var licensePlates: [String]
}

@objc(Users)
class Users: NSManagedObject {
    @NSManaged var users: [User]
}

@objc(CalendarStorage)
class CalendarStorage: NSManagedObject {
    @NSManaged var emptySpots: [Int]
    @NSManaged var reservedDays: [Bool]
    @NSManaged var queueDays: [Bool]
    @NSManaged var priorityDays: [Bool]

}

struct Session: Codable {
    var token: String
    var name: String
    var email: String
    var licensePlates: [String]
    var favoriteNames: [String]
    var favoriteEmails: [String]
}


class PersistenceController {
    static let shared = PersistenceController()
    
    private let notificationTimeKey = "notificationTime"
    private let sessionKey = "session"
    
    
    var notificationTime: Date? {
        get {
            return UserDefaults.standard.object(forKey: notificationTimeKey) as? Date
        }
        set {
            UserDefaults.standard.set(newValue, forKey: notificationTimeKey)
        }
    }
    
    func saveNotificationTime(notificationTime: Date) {
        self.notificationTime = notificationTime
    }
    
    func loadNotificationTime() -> Date? {
        if let notificationTime = notificationTime {
            return notificationTime
        } else {
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
    
}


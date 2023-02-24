import Foundation
import UIKit

struct User: Codable {
    var name: String
    var licensePlates: [String]
    var email: String
    var token: String
}

struct Favorites{
    var favoritePersons: [User]
}

struct CalendarStore {
    var dates: [Date: ReservationStatus] = [:]
    
    enum ReservationStatus {
        case reserved
        case waitlisted
        case rejected
        case noAnswer
    }
    
    mutating func reserveDate(_ date: Date) -> Bool {
        if dates[date] == nil {
            dates[date] = .reserved
            return true
        }
        return false
    }
    
    mutating func waitlistDate(_ date: Date) -> Bool {
        if dates[date] == nil {
            dates[date] = .waitlisted
            return true
        }
        return false
    }
    
    mutating func rejectDate(_ date: Date) -> Bool {
        if dates[date] == nil {
            dates[date] = .rejected
            return true
        }
        return false
    }
    
    mutating func markDateNoAnswer(_ date: Date) -> Bool {
        if dates[date] == nil {
            dates[date] = .noAnswer
            return true
        }
        return false
    }
}

class PersistenceController {
    
    static let shared = PersistenceController()
    
    private let notificationTimeKey = "notificationTime"
    private let userKey = "user"
    
    
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
    func saveUser(_ user: User) {
            do {
                let data = try JSONEncoder().encode(user)
                UserDefaults.standard.set(data, forKey: userKey)
            } catch {
                print("Failed to encode user: \(error.localizedDescription)")
            }
    }
    func loadUser() -> User? {
            guard let data = UserDefaults.standard.data(forKey: userKey) else {
                return nil
            }
            do {
                let user = try JSONDecoder().decode(User.self, from: data)
                return user
            } catch {
                print("Failed to decode user: \(error.localizedDescription)")
                return nil
            }
    }
        
    func deleteUser() {
            UserDefaults.standard.removeObject(forKey: userKey)
    }
    
}


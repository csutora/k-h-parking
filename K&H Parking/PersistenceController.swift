import Foundation
import UIKit

struct Session: Codable {
    var token: String
    var name: String
    var email: String
    var licensePlates: [String]
    var favoriteNames: [String]
}

struct Settings: Codable {
    var notifEnabled: Bool
    var notifAutomatic: Bool
    var notifTime: Date
}

struct DayData: Identifiable, Codable {
    var isSelected: Bool = false
    
    var day: Date
    var id: Int
    var emptySpotCount: Int = 0
    var isReserved: Bool = false
    var isQueue: Bool = false
    var isPriority: Bool = false
    
    init(day: Date, id: Int) {
        self.day = day
        self.id = id
    }
}

struct CalendarStatus: Codable {
    var days: [DayData]
}

class PersistenceController {
    static let shared = PersistenceController()
    
    private let sessionKey = "session"
    private let settingsKey = "settings"
    private let calendarStatusKey = "calendarStatus"
    
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
    
    func saveCalendarStatus(_ calendarStatus: CalendarStatus) {
            do {
                let data = try JSONEncoder().encode(calendarStatus)
                UserDefaults.standard.set(data, forKey: calendarStatusKey)
            } catch {
                print("Failed to encode calendar status: \(error.localizedDescription)")
            }
    }
    
    func loadCalendarStatus() -> CalendarStatus? {
            guard let data = UserDefaults.standard.data(forKey: calendarStatusKey) else {
                return nil
            }
            do {
                let calendarStatus = try JSONDecoder().decode(CalendarStatus.self, from: data)
                return calendarStatus
            } catch {
                print("Failed to decode calendar status: \(error.localizedDescription)")
                return nil
            }
    }
    
    
    
}


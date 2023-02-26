//
//  NotificationManager.swift
//  K&H Parking
//
//  Created by Török Péter on 2023. 02. 24..
//

import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    private let notificationTimeKey = "notificationTime"
    private let userKey = "user"
    
    private init() {}
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Notification authorization granted")
            } else {
                print("Notification authorization denied")
            }
        }
    }
    func setCategories() {
            let giveToAnyone = UNNotificationAction(
                identifier: "giveToAnyone",
                title: "Helyed átadása bárkinek",
                options: [.foreground]
               // icon: UNNotificationActionIcon(systemImageName: "person.3")
            )
            
            let giveToFriend_1 = UNNotificationAction(
                identifier: "giveToFriend1",
                title: "Freund Lászlónak",
                options: [.foreground],
                icon: UNNotificationActionIcon(systemImageName: "star")
            )
            let giveToFriend_2 = UNNotificationAction(
                identifier: "giveToFriend2",
                title: "Csutora Narának",
                options: [.foreground],
                icon: UNNotificationActionIcon(systemImageName: "star")
            )
            let giveToFriend_3 = UNNotificationAction(
                identifier: "giveToFriend3",
                title: "Török Péternek",
                options: [.foreground],
                icon: UNNotificationActionIcon(systemImageName: "star")
            )
            let category = UNNotificationCategory(
                identifier: "message",
                actions: [giveToAnyone,giveToFriend_1,giveToFriend_2,giveToFriend_3],
                intentIdentifiers: [],
                options: [.customDismissAction]
            )
            
            let center = UNUserNotificationCenter.current()
            center.setNotificationCategories([category])
    }
    
    static func scheduleNotification(at notificationTime: Date) {
        NotificationManager.shared.setCategories()
        let center = UNUserNotificationCenter.current()
       // center.removeAllPendingNotificationRequests()
        center.removePendingNotificationRequests(withIdentifiers: ["notification"])
        
        let content = UNMutableNotificationContent()
        content.title = "Emlékeztető"
        content.body = "136 kollégád vár parkolóhelyre, ne felejtsd el lemondani"
        content.sound = UNNotificationSound.default
        content.badge = 1
        content.categoryIdentifier = "message"
        
        // extract hour and minute components from notificationTime
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: notificationTime)
        let minute = calendar.component(.minute, from: notificationTime)
        
        // create date components based on hour and minute
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        // create trigger based on date components
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        // create request using trigger and content
        let request = UNNotificationRequest(identifier: "notification", content: content, trigger: trigger)
        
        // schedule request
        center.add(request)
        
        // save notification time to user defaults
        let defaults = UserDefaults.standard
        defaults.set(notificationTime, forKey: "notificationTime")
        
    }
    static func scheduleAlternateNotification() {
        
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["alternate"])
        
        let content = UNMutableNotificationContent()
        content.title = "Értesítés"
        content.body = "Holnap lesz parkolóhelyed a mélygarázsban!"
        content.sound = UNNotificationSound.default
        // create date components based on hour and minute
        //sets the test notification date
        
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.hour = 3
        dateComponents.minute = 48
        let alternativeNotifTime = calendar.date(from: dateComponents)!
        
        // create trigger based on date components
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        // create request using trigger and content
        let request = UNNotificationRequest(identifier: "alternate", content: content, trigger: trigger)
        
        // schedule request
        center.add(request)
        
        // save notification time to user defaults
        let defaults = UserDefaults.standard
        defaults.set(alternativeNotifTime, forKey: "alternatieNotificationTime")
        
    }
    
}

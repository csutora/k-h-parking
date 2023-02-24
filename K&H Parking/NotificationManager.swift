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
    
    static func scheduleNotification(at notificationTime: Date) {
        
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests() // remove all previously scheduled notifications

        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        content.body = "Don't forget to check out your app today!"
        content.sound = UNNotificationSound.default
        
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
}

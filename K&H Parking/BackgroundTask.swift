//
//  BackgroundTask.swift
//  K&H Parking
//
//  Created by Török Péter on 2023. 02. 25..
//

import Foundation
import UserNotifications
import BackgroundTasks

class BackgroundManager {

    static let shared = BackgroundManager()

    func requestBackgroundExecution() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "io.csum.backgroundtask", using: nil) { task in
            self.handleBackgroundTask(task: task as! BGProcessingTask)
        }
    }

    func scheduleBackgroundTask() {
        let taskRequest = BGProcessingTaskRequest(identifier: "io.csum.backgroundtask")
        taskRequest.requiresNetworkConnectivity = true
        taskRequest.requiresExternalPower = false

        do {
            try BGTaskScheduler.shared.submit(taskRequest)
            print("Background task scheduled successfully")
        } catch {
            print("Error scheduling background task: \(error.localizedDescription)")
        }
    }

    func handleBackgroundTask(task: BGProcessingTask) {
        task.expirationHandler = {
            task.setTaskCompleted(success: false)
        }
        
        let notificationManager = NotificationManager.shared
        let notificationTime: Date = Date().addingTimeInterval(60) //mock 1 min from now, TODO replace with http fetched value
        // call the method to send out notification using notificationManager instance
        // next

        task.setTaskCompleted(success: true)
    }

}


// kell egy http lacitol adatokkal,
// abbol date schedule notificationnek, ez alapjan a backgroundtask hivja meg a schedulenotificationt


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
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.yourapp.backgroundtask", using: nil) { task in
            self.handleBackgroundTask(task: task as! BGProcessingTask)
        }
    }

    func scheduleBackgroundTask() {
        let taskRequest = BGProcessingTaskRequest(identifier: "com.yourapp.backgroundtask")
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
        // call the method to send out notification using notificationManager instance
        // next

        task.setTaskCompleted(success: true)
    }

}

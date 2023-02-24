//
//  K_H_ParkingApp.swift
//  K&H Parking
//
//  Created by Nara Csutora on 2023. 02. 24..
//

import SwiftUI

@main
struct K_H_ParkingApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

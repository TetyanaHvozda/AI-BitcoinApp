//
//  BitcoinAppApp.swift
//  BitcoinApp
//
//  Created by Tetyana Hvozda on 23.07.25.
//

import SwiftUI
import UserNotifications
import UIKit

@main
struct BitcoinAppApp: App {
    let notificationDelegate = NotificationDelegate()
    
    init() {
            UNUserNotificationCenter.current().delegate = notificationDelegate
        }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate, ObservableObject {
    // Show notification while app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
}

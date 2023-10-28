//
//  NotificationManager.swift
//  Link
//
//  Created by Nathan Cree on 10/28/23.
//

import Foundation
import Firebase
import UserNotifications

@MainActor
class NotificationManager: ObservableObject {
    
    @Published private(set) var hasPermission = false;
    
    init() {
        Task {
            await getAuthStatus()
        }
    }
    
    func request() async {
        do {
            try await UNUserNotificationCenter.current()
                .requestAuthorization(options: [.alert,. badge])
        } catch {
            print(error)
        }
    }
    
    func getAuthStatus() async {
        let status = await UNUserNotificationCenter.current().notificationSettings()
        switch status.authorizationStatus {
        case .authorized,
                .provisional,
                .ephemeral:
            hasPermission = true
        default: hasPermission = false
        }
        
    }
//    func registerForPushNotifications() {
//        UNUserNotificationCenter.current()
//            .requestAuthorization(options: [.alert,. badge]) { granted, _ in
//                guard granted else { return }
//                self.getNotificationSettings()
//            }
//    }
//
//    func getNotificationSettings() {
//        UNUserNotificationCenter.current().getNotificationSettings { settings in
//            guard settings.authorizationStatus == .authorized else { return }
//            DispatchQueue.main.async {
//                UIApplication.shared.registerForRemoteNotifications()
//            }
//        }
//    }
}

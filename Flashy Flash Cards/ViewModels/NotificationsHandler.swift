//
//  NotificationsHandler.swift
//  Flashy Flash Cards
//
//  Created by Simon Matome on 09/09/2024.
//

import Foundation
import UserNotifications

final class NotificationsHandler: ObservableObject {
    static let instance = NotificationsHandler()
    
    init() {
        requestAuthorization()
    }
    
    /// Method to ask user permission
    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { success, error in
            if let error {
                print(error)
            } else {
                print("success")
            }
        }
    }
    
    /// Method to schedule notification
    func scheudleNotification(time: Double, topic: String, rating: FileRating) {
        let content = UNMutableNotificationContent()
        content.title = "Review Time"
        content.subtitle = "\(topic) cards are ready"
        content.body = "Time to review \(topic) cards in the \(rating.name) box"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: time, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error {
                print(error)
            } else {
                print("It works, now find a way to get functionality here")
            }
        }
        
//        let center = UNUserNotificationCenter.current()
//        Task {
//            do {
//                try await center.setBadgeCount(count)
//            } catch {
//                print(error)
//            }
//        }
    }
}

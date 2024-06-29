import Foundation
import UserNotifications

class NotificationService: ObservableObject {
        
    @Published private(set) var hasPermission = false
    @Published var isNotificationEnabled = false
    
    static let shared = NotificationService()
    
    init() {
        Task {
            await getAuthStatus()
        }
    }
    
    func requestAuthorization() async {
        do {
            self.hasPermission = try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
            print("Permissions: \(self.hasPermission)")
        } catch {
            print(error)
        }
    }
    
    func getAuthStatus() async {
        let status = await UNUserNotificationCenter.current().notificationSettings()
        switch status.authorizationStatus {
        case .authorized, .provisional, .ephemeral:
            hasPermission = true
        default:
            hasPermission = false
        }
    }
    
    func scheduleNotification(hour: Int = 18, minute: Int = 0) {
        if isNotificationEnabled {
            // Cancel previously scheduled notification
            cancelNotification()
            
            let content = UNMutableNotificationContent()
            content.title = "Kilde er klar med dagens"
            content.body = "Your notification message"
            
            var dateComponents = DateComponents()
            dateComponents.hour = hour
            dateComponents.minute = minute
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            
            let request = UNNotificationRequest(identifier: "dailyNotification", content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Error scheduling notification: \(error)")
                } else {
                    print("Notification scheduled successfully")
                }
            }
        } else {
            print("Notifications are disabled")
        }
    }
    
    func cancelNotification() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["dailyNotification"])
        print("Notification canceled")
    }
    
    func toggleNotifications(_ isEnabled: Bool) {
        isNotificationEnabled = isEnabled
        if isEnabled {
            // Schedule notifications if the toggle is enabled
            scheduleNotification()
        } else {
            // Cancel notifications if the toggle is disabled
            cancelNotification()
        }
    }
    
}

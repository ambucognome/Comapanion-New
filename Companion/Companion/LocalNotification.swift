//
//  LocalNotification.swift
//  Companion
//
//  Created by Ambu Sangoli on 11/05/23.
//

import Foundation
import UserNotifications

let reminder = "reminder"

class LocalNotification: NSObject {
    
    static let shared = LocalNotification()
    
    let hour : Int = 9
    let minute : Int = 0
    let second : Int = 0
    
    func initateLocalNotification(){
        let content = UNMutableNotificationContent()
//        content.title = "\(Localized.localized(keyName: "HELLO")) \(User.getUserName())"
//        content.body = Localized.localized(keyName: "TAKE_READING_REMINDER")
        content.sound = .default
        let gregorian = Calendar(identifier: .gregorian)
        let now = Date()
        var components = gregorian.dateComponents([.year, .month, .day, .hour, .minute, .second], from: now)
        // Change the time to 7:00:00 in your locale
        components.hour = hour
        components.minute = minute
        components.second = second
        let date = gregorian.date(from: components)!
        let triggerDaily = Calendar.current.dateComponents([.hour,.minute,.second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: true)

        let request = UNNotificationRequest(identifier: reminder, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: {(error) in
    if let error = error {
        print("SOMETHING WENT WRONG \(error.localizedDescription)")
        
    }
    
})
        
    }
    
    func invalidateNotification(){  UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [reminder])
        
    }
    
}




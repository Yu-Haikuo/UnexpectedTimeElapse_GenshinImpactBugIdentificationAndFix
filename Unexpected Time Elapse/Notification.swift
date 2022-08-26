//
//  Notification.swift
//  Unexpected Time Elapse
//
//  Created by HAIKUO YU on 25/8/22.
//

import Foundation

class NotificationBroadcast {
    
    public func post(_ name: String, object: Any?) {
        let notificationName = Notification.Name(rawValue: name)
        NotificationCenter.default.post(name: notificationName, object: object)
    }
    
    public func addObserver<NotificationName>(_ observer: Any, _ selector: Selector, _ name: NotificationName, object: Any?) {
        if name is String {
            let notificationName = Notification.Name(rawValue: name as! String)
            NotificationCenter.default.addObserver(observer, selector: selector, name: notificationName, object: object)
        } else if name is Notification.Name {
            let notificationName = name as! NSNotification.Name
            NotificationCenter.default.addObserver(observer, selector: selector, name: notificationName , object: object)
        } else {
            print("Notification Name Type Error!")
            return
        }
    }
    
    public func removeObserver(_ observer: Any, _ name: String, object: Any?) {
        let notificationName = Notification.Name(rawValue: name)
        NotificationCenter.default.removeObserver(observer, name: notificationName, object: object)
    }
    
    public func removeAllObserverFrom(_ observer: Any) {
        NotificationCenter.default.removeObserver(observer)
    }
}

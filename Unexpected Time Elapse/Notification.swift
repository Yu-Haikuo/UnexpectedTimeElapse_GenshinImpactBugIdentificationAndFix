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
        switch name {
        case _ where name is String:
            let notificationName = Notification.Name(rawValue: name as! String)
            NotificationCenter.default.addObserver(observer, selector: selector, name: notificationName, object: object)
            
        case _ where name is Notification.Name:
            let notificationName = name as! NSNotification.Name
            NotificationCenter.default.addObserver(observer, selector: selector, name: notificationName , object: object)
            
        default:
            print("Notification Name Type Error!")
        }
    }
    
    public func removeObserver<NotificationName>(_ observer: Any, _ name: NotificationName, object: Any?) {
        switch name {
        case _ where name is String:
            let notificationName = Notification.Name(rawValue: name as! String)
            NotificationCenter.default.removeObserver(observer, name: notificationName, object: object)
            
        case _ where name is Notification.Name:
            let notificationName = name as! Notification.Name
            NotificationCenter.default.removeObserver(self, name: notificationName, object: object)
            
        default:
            print("Notification Name Type Error!")
        }
    }
    
    public func removeAllObserverFrom(_ observer: Any) {
        NotificationCenter.default.removeObserver(observer)
    }
}

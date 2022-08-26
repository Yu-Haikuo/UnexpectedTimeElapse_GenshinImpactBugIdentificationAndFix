//
//  ViewController.swift
//  Unexpected Time Elapse
//
//  Created by HAIKUO YU on 22/8/22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var beforeFixProgressView: UIProgressView!
    @IBOutlet weak var afterFixProgressView: UIProgressView!
    @IBOutlet weak var beforeFixLabel: UILabel!
    @IBOutlet weak var afterFixLabel: UILabel!
    
    private let notification = NotificationBroadcast()
    private let beforeFixTimer = ColdValueIncrementTimer(refreshRate: 60, tolerance: 1 / 600, totalDurationInSeconds: 20)
    private let afterFixTimer = FixedColdValueIncrementTimer(refreshRate: 60, tolerance: 1 / 600, totalDurationInSeconds: 20)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSLayoutConstraint.activate([
            beforeFixProgressView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -80),
            beforeFixProgressView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -60),
            
            afterFixProgressView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 80),
            afterFixProgressView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -60)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        notification.addObserver(self, #selector(updateBeforeFixProgressView(notification:)), "Before Fix Cold Value Increment", object: nil)
        notification.addObserver(self, #selector(updateAfterFixProgressView(notification:)), "After Fix Cold Value Increment", object: nil)
        notification.addObserver(self, #selector(updateBeforeFixLabel(notification:)), "Before Fix Cold Value Increment", object: nil)
        notification.addObserver(self, #selector(updateAfterFixLabel(notification:)), "After Fix Cold Value Increment", object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        beforeFixTimer.start()
        afterFixTimer.start()
        
        if #available(iOS 13.0, *) {
            notification.addObserver(self, #selector(applicationWillBecomeInactive), UIScene.willDeactivateNotification, object: nil)
            notification.addObserver(self, #selector(applicationDidBecomeActive), UIScene.didActivateNotification, object: nil)
        } else {
            notification.addObserver(self, #selector(applicationWillBecomeInactive), UIApplication.willResignActiveNotification, object: nil)
            notification.addObserver(self, #selector(applicationDidBecomeActive), UIApplication.didBecomeActiveNotification, object: nil)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        beforeFixTimer.end()
        afterFixTimer.end()
        notification.removeAllObserverFrom(self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    
    @objc private func updateBeforeFixProgressView(notification: Notification) {
        guard let coldValue = notification.object as? UInt else {
            return
        }
        beforeFixProgressView.progress = Float(coldValue) / beforeFixTimer.COLDVALUE_MAX
    }
    
    @objc private func updateAfterFixProgressView(notification: Notification) {
        guard let coldValue = notification.object as? UInt else {
            return
        }
        afterFixProgressView.progress = Float(coldValue) / afterFixTimer.COLDVALUE_MAX
    }
    
    @objc private func updateBeforeFixLabel(notification: Notification) {
        guard let coldValue = notification.object as? UInt else {
            return
        }
        
        let percentage: Float = (Float(coldValue) / beforeFixTimer.COLDVALUE_MAX) * 100
        beforeFixLabel.text = String(format: "Cold Value Before Fix: %.2f", percentage)
        
        if percentage >= 100 {
            beforeFixTimer.end()
        }
    }
    
    @objc private func updateAfterFixLabel(notification: Notification) {
        guard let coldValue = notification.object as? UInt else {
            return
        }
        
        let percentage: Float = (Float(coldValue) / afterFixTimer.COLDVALUE_MAX) * 100
        afterFixLabel.text = String(format: "Cold Value After Fix: %.2f", percentage)
        
        if percentage >= 100 {
            afterFixTimer.end()
        }
    }
}

// Added functions that fix the unwanted time elapse problem.
// They will be triggered when the application active state changes.
extension ViewController {
    
    @objc private func applicationWillBecomeInactive() {
        afterFixTimer.pause()
        print("Application will lose focus!")
    }
    
    @objc private func applicationDidBecomeActive() {
        afterFixTimer.resume()
        print("Application will enter foreground!")
    }
}


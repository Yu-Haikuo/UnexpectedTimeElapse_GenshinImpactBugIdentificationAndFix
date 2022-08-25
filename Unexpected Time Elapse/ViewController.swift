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
        NotificationCenter.default.addObserver(self, selector: #selector(updateBeforeFixProgressView(notification:)), name: Notification.Name("Before Fix Cold Value Increment"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateAfterFixProgressView(notification:)), name: Notification.Name("After Fix Cold Value Increment"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateBeforeFixLabel(notification:)), name: Notification.Name("Before Fix Cold Value Increment"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateAfterFixLabel(notification:)), name: Notification.Name("After Fix Cold Value Increment"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        beforeFixTimer.start()
        afterFixTimer.start()
        
        if #available(iOS 13.0, *) {
            NotificationCenter.default.addObserver(self, selector: #selector(applicationWillBecomeInactive), name: UIScene.willDeactivateNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: UIScene.didActivateNotification, object: nil)
        } else {
            NotificationCenter.default.addObserver(self, selector: #selector(applicationWillBecomeInactive), name: UIApplication.willResignActiveNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        beforeFixTimer.end()
        afterFixTimer.end()
        NotificationCenter.default.removeObserver(self)
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


//
//  CauseAndFix.swift
//  Unexpected Time Elapse
//
//  Created by HAIKUO YU on 22/8/22.
//

import Foundation

class ColdValueIncrementTimer {
    
    internal var counter: UInt = 0
    internal var timer: Timer?
    
    internal let tolerance: Double
    internal let refreshRate: Double
    internal let totalDurationInSeconds: Float
    
    internal let COLDVALUE_MAX: Float
    
    init(refreshRate: Double, tolerance: Double, totalDurationInSeconds: Float) {
        self.refreshRate = refreshRate
        self.tolerance = tolerance
        self.totalDurationInSeconds = totalDurationInSeconds
        self.COLDVALUE_MAX = totalDurationInSeconds * 60
    }
    
    deinit {
        timer?.invalidate()
        counter = 0
    }
    
    // To be called by external function like GameCharacter:: didEnterDragonSpine().
    internal func start() {
        counter = 0
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(timeInterval: 1 / refreshRate, target: self, selector: #selector(coldValueIncrement), userInfo: nil, repeats: true)
        timer?.tolerance = tolerance
        RunLoop.current.add(timer!, forMode: .common)
    }
    
    internal func end() {
        timer?.invalidate()
        counter = 0
    }
    
    @objc internal func coldValueIncrement() {
        counter = counter &+ 1
        NotificationCenter.default.post(name: Notification.Name("Before Fix Cold Value Increment"), object: counter)
    }
}

// Added resume() and pause() and overrided coldValueIncrement() to fix unwanted time elapse.
class FixedColdValueIncrementTimer: ColdValueIncrementTimer {
    
    internal func resume() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1 / refreshRate, target: self, selector: #selector(coldValueIncrement), userInfo: nil, repeats: true)
        timer?.tolerance = tolerance
        RunLoop.current.add(timer!, forMode: .common)
    }
    
    internal func pause() {
        timer?.invalidate()
    }
    
    override func coldValueIncrement() {
        counter = counter &+ 1
        NotificationCenter.default.post(name: Notification.Name("After Fix Cold Value Increment"), object: counter)
    }
}

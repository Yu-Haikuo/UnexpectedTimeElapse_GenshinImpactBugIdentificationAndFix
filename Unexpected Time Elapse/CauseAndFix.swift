//
//  CauseAndFix.swift
//  Unexpected Time Elapse
//
//  Created by HAIKUO YU on 22/8/22.
//

import Foundation

class ColdValueIncrementTimer {
    
    private var counter: UInt = 0
    private var timer: Timer?
    
    private let tolerance: Double
    private let refreshRate: Double
    
    internal let COLDVALUE_MAX: Float = 60 * 20
    
    init(refreshRate: Double, tolerance: Double) {
        self.refreshRate = refreshRate
        self.tolerance = tolerance
    }
    
    deinit {
        timer?.invalidate()
        counter = 0
    }
    
    // To be called by external function like GameCharacter:: didEnterDragonSpine().
    internal func start() {
        counter = 0
        
        timer = Timer.scheduledTimer(timeInterval: 1 / refreshRate, target: self, selector: #selector(coldValueIncrement), userInfo: nil, repeats: true)
        timer?.tolerance = tolerance
        RunLoop.current.add(timer!, forMode: .common)
    }
    
    internal func end() {
        timer?.invalidate()
        counter = 0
    }
    
    @objc private func coldValueIncrement() {
        counter = counter &+ 1
        NotificationCenter.default.post(name: Notification.Name("Cold Value Increment"), object: counter)
    }
}

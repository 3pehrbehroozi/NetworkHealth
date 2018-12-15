//
//  PingHelper.swift
//  NetHealth
//
//  Created by Sepehr Behroozi on 12/12/18.
//  Copyright © 2018 Sepehr. All rights reserved.
//

import Foundation
import PlainPing

protocol PingHelperDelegate {
    func pingHelperDidReceiveResult(lastPingTime: Int?, averageTime: Int)
}

fileprivate let interval: TimeInterval = 1.0

class PingHelper {
    fileprivate static var sharedInstance: PingHelper?
    
    var delegate: PingHelperDelegate?
    var elapsedTimes = [Int]()
    
    var isRunning: Bool {
        return timer?.isValid ?? false
    }

    private var timer: Timer?
    
    class var shared: PingHelper {
        if sharedInstance == nil {
            sharedInstance = PingHelper()
        }
        return sharedInstance!
    }
    
    private init() {
        
    }
    
    func reset() {
        self.elapsedTimes.removeAll()
    }
    
    func start() {
        self.timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true, block: { _ in
            PlainPing.ping("8.8.8.8") { (timeElapsed, error) in
                let average = self.elapsedTimes.isEmpty ? 0 : self.elapsedTimes.reduce(0, { $0 + $1 }) / self.elapsedTimes.count
                if let time = timeElapsed, error == nil {
                    self.elapsedTimes.append(Int(time))
                    self.delegate?.pingHelperDidReceiveResult(lastPingTime: Int(time), averageTime: average)
                } else {
                    self.delegate?.pingHelperDidReceiveResult(lastPingTime: nil, averageTime: average)
                }
            }
        })
    }
    
    func stop() {
        self.timer?.invalidate()
        self.timer = nil
    }
}

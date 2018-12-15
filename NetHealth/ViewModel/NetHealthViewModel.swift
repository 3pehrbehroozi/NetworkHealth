//
//  NetHealthViewModel.swift
//  NetHealth
//
//  Created by Sepehr Behroozi on 12/12/18.
//  Copyright © 2018 Sepehr. All rights reserved.
//

import Foundation
import AppKit
import Cocoa


class NetHealthViewModel {
    var isStarted: DynamicType<Bool>
    var averagePingTime: DynamicType<Int>
    var lastPingTime: DynamicType<Int>
    var networkHealth: DynamicType<NetHealth>
    
    class var appDelegate: AppDelegate? {
        return NSApp.delegate as? AppDelegate
    }
    
    init() {
        self.isStarted = DynamicType(NetHealthViewModel.appDelegate?.isServiceStarted ?? false)
        self.averagePingTime = DynamicType(0)
        self.lastPingTime = DynamicType(0)
        self.networkHealth = DynamicType(.moderate)
        
        NetHealthViewModel.appDelegate?.averagePingTime.bind { [weak self] time in
            self?.averagePingTime.set(to: time)
        }
        NetHealthViewModel.appDelegate?.lastPingTime.bind { [weak self] time in
            self?.lastPingTime.set(to: time)
            if time < 50 {
                self?.networkHealth.set(to: .perfect)
            } else if time >= 50 && time < 200 {
                self?.networkHealth.set(to: .good)
            } else if time >= 200 && time < 500 {
                self?.networkHealth.set(to: .moderate)
            } else if time >= 500 && time < 1200 {
                self?.networkHealth.set(to: .bad)
            } else {
                self?.networkHealth.set(to: .poor)
            }
        }
    }
    
    func startStopButtonPressed() {
        if isStarted.value {
            NetHealthViewModel.appDelegate?.stopService()
            self.isStarted.set(to: false)
        } else {
            NetHealthViewModel.appDelegate?.startService()
            self.isStarted.set(to: true)
        }
    }
    
    func resetButtonPressed() {
        NetHealthViewModel.appDelegate?.reset()
    }
    
    enum NetHealth: String {
        case perfect = "Perfect"
        case good = "Good"
        case moderate = "Moderate"
        case bad = "Bad"
        case poor = "Poor"
        
        var titleColor: NSColor {
            switch self {
            case .perfect:
                return #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            case .good:
                return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            case .moderate:
                return #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            case .bad:
                return #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
            case .poor:
                return #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1)
            }
        }
        
        var title: String {
            return self.rawValue
        }
    }
}

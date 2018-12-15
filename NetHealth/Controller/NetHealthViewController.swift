//
//  NetHealthViewController.swift
//  NetHealth
//
//  Created by Sepehr Behroozi on 12/12/18.
//  Copyright © 2018 Sepehr. All rights reserved.
//

import Cocoa
import PlainPing


class NetHealthViewController: NSViewController {
    @IBOutlet private weak var startStopButton: NSButton!
    @IBOutlet private weak var resetButton: NSButton!
    @IBOutlet weak var healthStatusLabel: NSTextField!
    @IBOutlet weak var lastPingLabel: NSTextField!
    @IBOutlet weak var averagePingLabel: NSTextField!
    
    var viewModel = NetHealthViewModel()
    
    class var identifier: String {
        return String.init(describing: self)
    }
    
    class func instantiate() -> NetHealthViewController {
        return NSStoryboard.init(name: "Main", bundle: nil).instantiateController(withIdentifier: NSStoryboard.SceneIdentifier.init(NetHealthViewController.identifier)) as! NetHealthViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel.isStarted.bind { [weak self] (isStarted) in
            self?.startStopButton.cell?.title = isStarted ? "Stop" : "Start"
        }
        self.viewModel.averagePingTime.bind { [unowned self] (averageTime) in
            self.averagePingLabel.cell?.title = "\(averageTime)"
        }
        
        self.viewModel.lastPingTime.bind { [unowned self] (lastTime) in
            self.lastPingLabel.cell?.title = "\(lastTime)"
        }
        
        self.viewModel.networkHealth.bind { [unowned self] (health) in
            self.healthStatusLabel.cell?.title = health.title
            self.healthStatusLabel.textColor = health.titleColor
        }
    }
    
    
    @IBAction func startStopButtonPressed(_ sender: NSButton) {
        self.viewModel.startStopButtonPressed()
    }
    
    @IBAction func resetButtonPressed(_ sender: NSButton) {
        self.viewModel.resetButtonPressed()
    }
    
    @IBAction func quitButtonPressed(_ sender: NSButton) {
        exit(0)
    }
}

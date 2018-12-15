//
//  AppDelegate.swift
//  NetHealth
//
//  Created by Sepehr Behroozi on 12/12/18.
//  Copyright © 2018 Sepehr. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    let popover = NSPopover()
    var eventMonitor: EventMonitor?
    var isServiceStarted: Bool {
        return PingHelper.shared.isRunning
    }
    
    var lastPingTime: DynamicType<Int>! = DynamicType(0)
    var averagePingTime: DynamicType<Int>! = DynamicType(0)

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        if let button = self.statusItem.button {
            button.image = NSImage(named: NSImage.Name("PlusIcon"))
            button.action = #selector(buttonDidPressed)
        }
        popover.contentViewController = NetHealthViewController.instantiate()
        
        self.eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown], handler: { [weak self] (event) in
            if let strongSelf = self, strongSelf.popover.isShown {
                strongSelf.closePopover(event)
            }
        })
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


    @objc private func buttonDidPressed() {
        if self.popover.isShown {
            self.closePopover(nil)
        } else {
            self.showPopover()
        }
    }
    
    private func showPopover() {
        if let button = self.statusItem.button {
            self.popover.show(relativeTo: button.frame, of: button, preferredEdge: NSRectEdge.minY)
            self.eventMonitor?.start()
        }
    }
    
    private func closePopover(_ sender: Any?) {
        self.popover.performClose(sender)
        self.eventMonitor?.stop()
    }
    
    func startService() {
        PingHelper.shared.delegate = self
        PingHelper.shared.start()
    }
    
    func stopService() {
        PingHelper.shared.stop()
    }
    
    func reset() {
        PingHelper.shared.reset()
    }
}


extension AppDelegate: PingHelperDelegate {
    func pingHelperDidReceiveResult(lastPingTime: Int?, averageTime: Int) {
        if let lastTime = lastPingTime {
            self.lastPingTime.set(to: lastTime)
            self.averagePingTime.set(to: averageTime)
        }
    }
}

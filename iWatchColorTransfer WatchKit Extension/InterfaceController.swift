//
//  InterfaceController.swift
//  iWatchColorTransfer WatchKit Extension
//
//  Created by Carlos Duclos on 1/14/18.
//  Copyright © 2018 Carlos Duclos. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController {
    
    @IBOutlet var view: WKInterfaceGroup!
    var currentColor = 0
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        guard WCSession.isSupported() else {
            return
        }
        
        let session = WCSession.default
        session.delegate = self
        session.activate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    @IBAction func tapGroup(_ sender: Any) {
        currentColor = (currentColor == colors.count - 1) ? 0 : currentColor + 1
        
        Manager.sendMessage(["color" : currentColor], success: {
            DispatchQueue.main.async {
                self.view.setBackgroundColor(colors[self.currentColor])
            }
        })
        
    }
}

extension InterfaceController: WCSessionDelegate {
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        switch activationState {
        case .activated:
            break
        default:
            print("fue :(", activationState)
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        guard let colorIndex = message["color"] as? Int else {
            replyHandler([:])
            return
        }
        
        replyHandler(["success": 1])
        
        DispatchQueue.main.async {
            self.view.setBackgroundColor(colors[colorIndex])
        }
    }
    
}

//
//  ViewController.swift
//  iWatchColorTransfer
//
//  Created by Carlos Duclos on 1/14/18.
//  Copyright © 2018 Carlos Duclos. All rights reserved.
//

import UIKit
import WatchConnectivity

class ViewController: UIViewController {

    var currentColor = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard WCSession.isSupported() else {
            return
        }
        
        let session = WCSession.default
        session.delegate = self
        session.activate()
        
        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        currentColor = (currentColor == colors.count - 1) ? 0 : currentColor + 1
        
        Manager.sendMessage(["color" : currentColor], success: {
            DispatchQueue.main.async {
                self.view.backgroundColor = colors[self.currentColor]
            }
        })
    }

}

extension ViewController: WCSessionDelegate {
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        guard let colorIndex = message["color"] as? Int else {
            replyHandler([:])
            return
        }
        
        replyHandler(["success": 1])
        
        DispatchQueue.main.async {
            self.view.backgroundColor = colors[colorIndex]
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("activationDidCompleteWith", activationState)
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
}

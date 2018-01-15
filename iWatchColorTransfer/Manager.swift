//
//  Manager.swift
//  iWatchColorTransfer
//
//  Created by Carlos Duclos on 1/15/18.
//  Copyright © 2018 Carlos Duclos. All rights reserved.
//

import Foundation
import WatchConnectivity

class Manager {
    
    static func sendMessage(_ message: [String: Any], success: @escaping () -> Void) {
        let session = WCSession.default
        session.sendMessage(message, replyHandler: { response in
            guard let result = response["success"] else {
                return
            }
            
            guard let value = result as? Int else {
                return
            }
            
            if value == 1 {
                success()
            }
        }, errorHandler: { error in
            
        })
    }
    
}

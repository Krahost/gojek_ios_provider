//
//  BackGroundRequestManager.swift
//  GoJekProvider
//
//  Created by Rajes on 02/05/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import Foundation

enum BackGroundRequestType {
    case CommonRequest
    case ModuleWise
}

class BackGroundRequestManager {
    
    static var share = BackGroundRequestManager()
    
    private weak var timer:Timer!
    
    var requestCallback: (() -> ())? = nil
    
    func startBackGroundRequest(type: BackGroundRequestType, roomId: String, listener: RoomListener) {
        
        print("startBackGroundRequest")
        if !XSocketIOManager.sharedInstance.socketIsConnected() {
            
            XSocketIOManager.sharedInstance.establishSocketConnection()
            initiateTimerFunction(type: type, roomId: roomId, listener: listener)
            self.requestCallback?()
            
        } else if !XSocketIOManager.sharedInstance.connectedWithRoom || XSocketIOManager.sharedInstance.connectedRoomType != roomId {
            resetBackGroudTask()
            XSocketIOManager.sharedInstance.connectedWithRoom = false
            checkSocketConnection(requesType: type,roomID:roomId, moduleKey: listener)
        }
    }
    
    func initiateTimerFunction(type: BackGroundRequestType, roomId: String,listener: RoomListener) {
        let context = ["RequestType": type,"roomID": roomId,"ListenerKey": listener] as [String : Any]
        if self.timer == nil {
            self.timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(timerFunction), userInfo: context, repeats: true)
            print("Background thread initiated")
        }
    }
    
    func checkSocketConnection(requesType:BackGroundRequestType,roomID:String,moduleKey:RoomListener) {
        
        if XSocketIOManager.sharedInstance.socketIsConnected() {
            
            if (XSocketIOManager.sharedInstance.connectedWithRoom ) { stopBackGroundRequest() }
            
            switch requesType {
            case .CommonRequest:
                initiateCommonRoomRequest(roomID: roomID, listener: moduleKey)
            case .ModuleWise:
                initiatePrivateRoomtRequest(roomID: roomID, listener: moduleKey)
            }
        } else {
            
            DispatchQueue.main.async {
                XSocketIOManager.sharedInstance.establishSocketConnection()
                self.checkSocketConnection(requesType: requesType, roomID: roomID,moduleKey: moduleKey)
            }
        }
    }
    
    func initiateCommonRoomRequest(roomID: String,listener:RoomListener) {
        XSocketIOManager.sharedInstance.checkSocketRequest(inputValue: (Constant.CommonRoomKey,roomID,listener)) {
            self.requestCallback?()
        }
    }
    
    func initiatePrivateRoomtRequest(roomID: String,listener:RoomListener) {
        XSocketIOManager.sharedInstance.checkSocketRequest(inputValue: (Constant.PrivateRoomKey,roomID,listener)) {
            self.requestCallback?()
        }
    }
    
    @objc func timerFunction(timerData: Timer) {
        
        print("socket not connected timer alive")
        guard let context = timerData.userInfo as? [String: Any] else { return }
        if XSocketIOManager.sharedInstance.socketIsConnected() && XSocketIOManager.sharedInstance.connectedWithRoom {
            stopBackGroundRequest()
        } else {
            if let type = context["RequestType"] as? BackGroundRequestType,let key = context["roomID"] as? String,
                let listener = context["ListenerKey"] as? RoomListener {
                
                startBackGroundRequest(type: type, roomId: key, listener: listener)
            }
            requestCallback?()
        }
    }
    
    func resetBackGroudTask() {
        stopBackGroundRequest()
        XSocketIOManager.sharedInstance.connectedWithRoom = false
        XSocketIOManager.sharedInstance.leaveCurrentRoom()
    }
    
    func stopBackGroundRequest() {
        
        DispatchQueue.main.async {
            if let _ = self.timer {
                self.timer.invalidate()
                self.timer = nil
                self.stopBackGroundRequest()
                print("stopBackGroundRequest")
            }
        }
    }
}

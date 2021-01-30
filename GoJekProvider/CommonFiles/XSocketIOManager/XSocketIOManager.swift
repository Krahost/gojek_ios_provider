//
//  XSocketIOManager.swift
//  GoJekProvider
//
//  Created by apple on 22/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import SocketIO

typealias SocketInputTuple = (RoomKey: String, RoomID: String, listenerKey: RoomListener)

class XSocketIOManager: NSObject {
    
    static let sharedInstance = XSocketIOManager()
    
    let manager = SocketManager(socketURL: URL(string: APPConstant.socketBaseUrl)!, config: [.log(false), .compress])
    var socket: SocketIOClient?
    var connectedWithRoom = false
    var connectedRoomType:String!
    
    override init() {
        super.init()
        socket = manager.defaultSocket
    }
    
    //Connect socket
    func establishSocketConnection() {
//        if socket?.status != SocketIOStatus.connected ||  socket?.status != SocketIOStatus.connecting {
//            socket?.connect()
//        }
        
        switch socket?.status ??  SocketIOStatus.notConnected {
        case .notConnected,.disconnected:
            socket?.connect()
        case .connecting,.connected:
            break
        }
    }
    
    //Disconnect socket
    func closeSocketConnection() {
        
        print("Manually disconnect socket")
        connectedWithRoom = false
        socket?.disconnect()
    }
    
    func socketIsConnected() -> Bool {
        if socket?.status == SocketIOStatus.connected  {
            return true
        }
        else {
            return false
        }
    }
    
    func sendSocketRequest(requestId: Int,serviceType: ActiveStatus,listenerType: RoomListener,completion: @escaping ()->Void){
        if XSocketIOManager.sharedInstance.connectedWithRoom { return }
        let saltKey = APPConstant.saltKeyValue.fromBase64() ?? ""
        BackGroundRequestManager.share.startBackGroundRequest(type: .ModuleWise, roomId: "room_\(saltKey)_R\(requestId)_\(serviceType.rawValue)", listener: listenerType)
        BackGroundRequestManager.share.requestCallback = {
            completion()
            print("socket call back")
        }
    }
    
    
    //Get data from main check request data
    func getHomeCheckRequestData(completionHandler: @escaping (_ response: [[String: Any]]?) -> Void) {
        
        self.socket?.emit("add", ["client": 1, "conversation": 1])
        
        self.socket?.on("message") { (data, ack) in
            let jsonData = try? JSONSerialization.data(withJSONObject: data)
            guard let responseString = String.init(data: jsonData!, encoding: String.Encoding.utf8) else {
                return
            }
            
            print(responseString)
        }
    }
    
    func checkSocketRequest(inputValue: SocketInputTuple, completionHandler: @escaping() -> Void) {
        
        print("listener Key for Room \(inputValue.RoomID) : \(inputValue.listenerKey.rawValue)")
        if socket?.status == SocketIOStatus.notConnected || socket?.status == SocketIOStatus.disconnected {
            establishSocketConnection()
        } else if !(self.connectedWithRoom) {
            
            print("emit data key: \(inputValue.RoomKey) ID: \(inputValue.RoomID)")
            socket?.emit(inputValue.RoomKey, inputValue.RoomID, completion: {
                print("Socekt public room connected success")
            })
            
            guard let providerDetail = AppManager.share.getUserDetails() else {
                return
            }
            //room_provider_{COMPANY_ID}_{PROVIDER_ID}
            guard let compayId = providerDetail.service?.company_id else {
                return
            }
            guard let providerId = providerDetail.id else {
                return
            }
            
            let room = "room_provider_\(compayId)_\(providerId)"
            socket?.emit(Constant.CommonRoomProvider, room, completion: {
                print("Socket common provider room connected")
            })
            
            self.socket?.on(Constant.SocketStatus, callback: { (data, ack) in
                print("Socket status \(data)")
                self.connectedWithRoom = true
                self.connectedRoomType = inputValue.RoomID
            })
            socket?.on(Constant.Approval, callback: { (data, ack) in
                print("Socket status \(data)")
                completionHandler()
            })
            socket?.on(Constant.SettingUpdate, callback: { (data, ack) in
                print("Socket status \(data)")
                completionHandler()
            })
            
            self.socket?.on(inputValue.listenerKey.rawValue, callback: { (data, ack) in
                print("listener status \(data)")
                completionHandler()
            })
        }
    }
    
    //Check new incoming message
    func chatCheckSocketRequest(input: String, completionHandler: @escaping(_ result: ChatDataEntity) -> Void) {
        if socket?.status == SocketIOStatus.notConnected {
            establishSocketConnection()
        } else {
            socket?.emit(Constant.JoinPrivateChatRoom, input, completion: {
                print("Chat Socket room connected")
            })
            
            self.socket?.on(Constant.NewMessage, callback: { (data, ack) in
                print("Chat listener status \(data)")
                guard let dict = data[0] as? [String: Any] else { return }
                guard let messageDetail = ChatDataEntity.init(JSON: dict) else { return }
                completionHandler(messageDetail)
            })
        }
    }
    
    //Send message via socket room
    func setChatToSocketRequest(input: Dictionary<String, Any>) {
        if socket?.status == SocketIOStatus.notConnected {
            establishSocketConnection()
        } else {
            self.socket?.emit(Constant.JoinPrivateChatRoom, input, completion: {
                print("Chat cocket room connected")
            })
            
            self.socket?.emit(Constant.SendMessage, input, completion: {
                print("Send meesage chat socket room")
            })
        }
    }
    
    //Update current location via socket room
    
    func sendCurrentLocationToSocket(input: Dictionary<String, Any>) {
        if socket?.status == SocketIOStatus.notConnected {
            establishSocketConnection()
        } else {
            
            self.socket?.emit(Constant.UpdateLocation, input, completion: {
                print("Location socket room connected")
            })
            
            self.socket?.emit(Constant.SendLocation, input, completion: {
                print("Send location Socket room")
            })
        }
    }
    
    func leaveCurrentRoom() {
        
        guard let conectedRoom = connectedRoomType else { return }
        print("emit laeve room data key: \(conectedRoom) ")
        socket?.emit(Constant.LeaveRoom, conectedRoom, completion: {
            print("Socket emit data success")
        })
        
        self.socket?.on(Constant.SocketStatus, callback: { (data, ack) in
            print("Socket status \(data)")
            
        })
    }
}

class SocketUtitils {
    class func construtRoomKey(requestID:String,serviceType:ActiveStatus) -> String {
        let saltKey = APPConstant.saltKeyValue.fromBase64() ?? ""
        return "room_\(saltKey)_R\(requestID)_\(serviceType.rawValue)"
    }
}

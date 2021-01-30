//
//  XSocketIOManager.swift
//  GoJekProvider
//
//  Created by apple on 22/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import SocketIO

let commonRoomKey = "joinCommonRoom"
let PrivateRoomKey = "joinPrivateRoom"
let SocketStatus = "socketStatus"
let NewRequest = "newRequest"
let PrivateRoomListener = "serveRequest"

enum RoomListener: String {
    case Transport = "rideRequest"
    case Service = "serveRequest"
    case Order = "orderRequest"
    case common = "newRequest"
}
typealias SocketInputTuple = (RoomKey: String, RoomID: String,listenerKey:RoomListener)

class XSocketIOManager: NSObject {
    
    static let sharedInstance = XSocketIOManager()

    let manager = SocketManager(socketURL: URL(string: APPConstant.AppDetails.socketBaseUrl)!, config: [.log(false), .compress])
    var socket: SocketIOClient?
    var connectedWithRoom = false
    var connectedRoomType:String!
    
    override init() {
        super.init()
        socket = manager.defaultSocket
    }
    
    //Connect socket
    func establishSocketConnection() {
        if socket?.status != SocketIOStatus.connected ||  socket?.status != SocketIOStatus.connecting {
            socket?.connect()
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
        } else {
            return false
        }
    }
    //Get data from main check request data
    func getHomeCheckRequestData(completionHandler: @escaping (_ response: [[String: Any]]?) -> Void) {
        
        self.socket?.emit("add", ["client": 1, "conversation": 1])
        
        self.socket?.on("message") {data, ack in
            let jsonData = try? JSONSerialization.data(withJSONObject: data)
            guard let responseString = String.init(data: jsonData!, encoding: String.Encoding.utf8) else {
                return
            }
            print(responseString)
        }
    }
    
  
    func checkSocketRequest(inputValue:SocketInputTuple,completionHandler: @escaping() -> Void) {
       
        print("listener Key for Room \(inputValue.RoomID) : \(inputValue.listenerKey.rawValue)")
        if socket?.status == SocketIOStatus.notConnected || socket?.status == SocketIOStatus.disconnected {
            establishSocketConnection()
        } else if !(self.connectedWithRoom ?? true) {
            socket?.emit(inputValue.RoomKey, inputValue.RoomID, completion: {
                
            })
            
            self.socket?.on(SocketStatus, callback: { (data, ack) in
                print("Socket status \(data)")
                self.connectedWithRoom = true
                self.connectedRoomType = inputValue.RoomKey
            })
            
            self.socket?.on(inputValue.listenerKey.rawValue, callback: { (data, ack) in
                print("listener status \(data)")
                completionHandler()
            })
        }
    }
    
    func chatCheckSocketRequest(input: String, completionHandler: @escaping(_ result: ChatDataEntity) -> Void) {
        if socket?.status == SocketIOStatus.notConnected {
            establishSocketConnection()
        }
        else {
            socket?.emit("joinPrivateChatRoom", input, completion: {
                print("Chat Socket room connected")
            })
            
            self.socket?.on(SocketStatus, callback: { (data, ack) in
                print("Chat Socket status \(data)")
            })
            
            self.socket?.on("new_message", callback: { (data, ack) in
                print("Chat listener status \(data)")
                guard let dict = data[0] as? [String: Any] else { return }
                guard let messageDetail = ChatDataEntity.init(JSON: dict) else { return }
                completionHandler(messageDetail)
            })
            
        }
    }
    
    func setChatToSocketRequest(input: Dictionary<String, Any>, completionHandler: @escaping(_ result: ChatDataEntity) -> Void) {
        if socket?.status == SocketIOStatus.notConnected {
            establishSocketConnection()
        }
        else {
            socket?.emit("joinPrivateChatRoom", input, completion: {
                print("Chat Socket room connected")
            })
            
            self.socket?.on(SocketStatus, callback: { (data, ack) in
                print("Chat Socket status \(data)")
            })
            
            self.socket?.emit("send_message", input, completion: {
                print("Send meesage Socket room connected")
            })
        }
    }
}

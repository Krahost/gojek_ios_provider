//
//  ChatViewController.swift
//  GoJekUser
//
//  Created by CSS15 on 10/05/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire
import IQKeyboardManagerSwift

class ChatViewController: UIViewController {
    
    fileprivate weak var chatTypeMsgView: ChatTypeMessageView?
    fileprivate weak var chatCollectionView: UICollectionView?
    fileprivate weak var typeMessageViewBottomConstraint: NSLayoutConstraint?
    fileprivate weak var bottomConstraint:  NSLayoutConstraint?

    var messageMutableArray: [ChatDataEntity] = []
    
    var requestId: String?
    var userName: String?
    var providerName: String?
    var userId: String?
    var providerId: String?
    var chatRequestFrom: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLeftBarButtonWith(color: .blackColor)
        title = userName ?? TaxiConstant.chat
        getAllUserChatHistory()
        setUpSubView()
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.enable = false
//        KeyboardManager.shared.keyBoardShowHide(view: self.view)
        hideKeyboardWhenTappedAround()
        self.view.backgroundColor = .backgroundColor
        chatCollectionView?.backgroundColor = .backgroundColor
        NotificationCenter.default.addObserver(self,
           selector: #selector(self.keyboardWasShown(notification:)),
           name: UIResponder.keyboardWillShowNotification,
           object: nil)
        NotificationCenter.default.addObserver(self,
                 selector: #selector(self.keyboardWasHide(notification:)),
                 name: UIResponder.keyboardDidHideNotification,
                 object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)

    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
      }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.enable = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setSocket()
        navigationController?.isNavigationBarHidden = false
        hideTabBar()
    }
}

extension ChatViewController {
    
    fileprivate func setUpSubView() {
        
        self.view.backgroundColor = .white
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        let collecttionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        collecttionView.translatesAutoresizingMaskIntoConstraints = false
        collecttionView.showsVerticalScrollIndicator = false
        collecttionView.showsHorizontalScrollIndicator = false
        collecttionView.delegate = self
        collecttionView.dataSource = self
        collecttionView.backgroundColor = .white
        collecttionView.keyboardDismissMode = .interactive
        collecttionView.register(ChatUserCollectionViewCell.self, forCellWithReuseIdentifier: Constant.ChatUserCollectionViewCell)
        self.view.addSubview(collecttionView)
        self.chatCollectionView = collecttionView
        let chatTypeView = ChatTypeMessageView()
        chatTypeView.messageTextView.delegate = self
        chatTypeView.sendBtn?.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        self.view.addSubview(chatTypeView)
        self.chatTypeMsgView = chatTypeView
        
        setupViewContraints()
    }
    
    
    
    
    func setupViewContraints() {
        
        
      
        if #available(iOS 11.0, *) {
            
            self.chatCollectionView?.topAnchor.constraint(equalTo: ((chatCollectionView?.superview!.safeAreaLayoutGuide.topAnchor)!)).isActive = true
            
//            self.typeMessageViewBottomConstraint = chatTypeMsgView?.bottomAnchor.constraint(equalTo: (chatTypeMsgView?.superview?.safeAreaLayoutGuide.bottomAnchor)!)
            self.typeMessageViewBottomConstraint =  chatTypeMsgView?.bottomAnchor.constraint(equalTo: (chatTypeMsgView?.superview?.bottomAnchor)!)

            self.chatCollectionView?.contentInsetAdjustmentBehavior = .never
            self.chatCollectionView?.contentInset = .init(top: 30, left: 0, bottom: 25, right: 0)
            
        } else {
            
            self.automaticallyAdjustsScrollViewInsets = false
            self.chatCollectionView?.topAnchor.constraint(equalTo: (self.chatCollectionView?.superview?.topAnchor)!).isActive = true
            self.typeMessageViewBottomConstraint =  chatTypeMsgView?.bottomAnchor.constraint(equalTo: (chatTypeMsgView?.superview?.bottomAnchor)!)
        }
        
        self.typeMessageViewBottomConstraint?.isActive = true
        
        //chatCollectionView
        self.chatCollectionView?.leadingAnchor.constraint(equalTo: (self.chatCollectionView?.superview?.leadingAnchor)!).isActive = true
        self.chatCollectionView?.trailingAnchor.constraint(equalTo: (self.chatCollectionView?.superview?.trailingAnchor)!).isActive = true
        self.chatCollectionView?.bottomAnchor.constraint(equalTo: (self.chatTypeMsgView?.topAnchor)!).isActive = true
        
        //chatTypeMessageView
        self.chatTypeMsgView?.leadingAnchor.constraint(equalTo: (self.chatTypeMsgView?.superview?.leadingAnchor)!, constant: 0).isActive = true
        self.chatTypeMsgView?.trailingAnchor.constraint(equalTo: (self.chatTypeMsgView?.superview?.trailingAnchor)!, constant: 0).isActive = true
    }
    
    func getAllUserChatHistory() {
        
        //Get all messae
        let param: Parameters = [Constant.adminService: chatRequestFrom!.uppercased(),
                                 Constant.id: requestId!]
        homePresenter?.getUserChatHistory(param: param)
        
        //room_{window.room}_{id}_{user_id}_{provider_id}_{admin_service_id}

    }
    
    
    func setSocket(){
        let saltKey = APPConstant.saltKeyValue.fromBase64()
        let inputString = "room_\(saltKey!)_R\(requestId ?? String.Empty)_U\(userId ?? String.Empty)_P\(providerId ?? String.Empty)_\(chatRequestFrom?.uppercased() ?? String.Empty)"
        print(inputString)
        XSocketIOManager.sharedInstance.chatCheckSocketRequest(input: inputString) { (response) in
//            self.messageMutableArray.append(response)
//             //            self.chatTypeMsgView?.textViewHeightConstraint?.constant = ScreenConstants.proportionalValueForValue(value: 40.0)
//            self.chatTypeMsgView?.textViewHeightConstraint?.constant = 40
//            self.chatTypeMsgView?.layoutIfNeeded()
//            self.retriveMessageData()
            
            self.getAllUserChatHistory()
        }
    }
    
    
    @objc func keyboardWasShown(notification: NSNotification) {
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        self.typeMessageViewBottomConstraint?.constant = -(keyboardFrame.size.height)
    }
    
    
    @objc func keyboardWasHide(notification: NSNotification) {
        self.typeMessageViewBottomConstraint?.constant = 0
    }
    
    
    func retriveMessageData() {
        
        UIView.animate(withDuration: 0.0, animations: {
            
            self.chatCollectionView?.reloadData()
            
        }, completion: { (finished) in
            
            if self.messageMutableArray.count > 0 {
                self.chatCollectionView?.scrollToLastItem(animated: false)
            }
        })
    }
    
    func trimWhiteSpace(_ textView: UITextView) -> String {
        
        return textView.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    @objc func willEnterForeground() {
//        BackGroundRequestManager.share.resetBackGroudTask()
          setSocket()
//        self.viewDidDisappear(true)
//        self.viewDidLoad()
//        self.viewWillAppear(true)
        getAllUserChatHistory()
    }
    
}

//MARK: - IBAction

extension ChatViewController {
    
    
    public func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissMyKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func dismissMyKeyboard() {
            self.typeMessageViewBottomConstraint?.constant = 0
            self.chatTypeMsgView?.messageTextView.resignFirstResponder()
    }
    
    
    
    @objc func valuechanged(_ textView: UITextView) {
        
        let count = trimWhiteSpace(textView).count
        if (count > 0) {
            chatTypeMsgView?.sendBtn?.backgroundColor = .appPrimaryColor
            chatTypeMsgView?.sendBtn?.isUserInteractionEnabled = true
        }
        else {
            chatTypeMsgView?.sendBtn?.backgroundColor = .lightGray
            chatTypeMsgView?.sendBtn?.isUserInteractionEnabled = false
        }
    }
    
    @objc func sendMessage(_ sender: UIButton) {
        
        guard let messge = chatTypeMsgView?.messageTextView.text else {
            return
        }
        
        let baseUrl = AppConfigurationManager.shared.getBaseUrl()
        let saltKey = APPConstant.saltKeyValue
        let inputString = "room_\(saltKey.fromBase64() ?? .Empty)_R\(requestId ?? String.Empty)_U\(userId ?? String.Empty)_P\(providerId ?? String.Empty)_\(chatRequestFrom?.uppercased() ?? .Empty)"
        let socketMessagew = [Constant.adminServiceId: chatRequestFrom?.uppercased() ?? String.Empty,
                              Constant.saltkey: saltKey,
                              Constant.PUrl: baseUrl+URLConstant.KChat,
                              Constant.id: requestId ?? .Empty,
                              Constant.provider: providerName ?? .Empty,
                              Constant.user: userName ?? .Empty,
                              Constant.message: messge,
                              Constant.type: Constant.provider,
                              Constant.room: inputString]
        
        XSocketIOManager.sharedInstance.setChatToSocketRequest(input: socketMessagew as Dictionary<String, Any>)
        DispatchQueue.main.async {
            self.chatTypeMsgView?.messageTextView.text = .Empty
            self.chatTypeMsgView?.sendBtn?.backgroundColor = .lightGray
            self.chatTypeMsgView?.sendBtn?.isUserInteractionEnabled = false
            self.chatTypeMsgView?.textViewHeightConstraint?.constant = 40
            self.chatTypeMsgView?.layoutIfNeeded()

        }
    }
    
}

//MARK: - UITextViewDelegate
extension ChatViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        self.valuechanged(textView)

        let numLines = Int(textView.contentSize.height) / Int((textView.font?.lineHeight)!)
        if(numLines <= 6) {
        chatTypeMsgView?.textViewHeightConstraint?.constant = textView.contentSize.height + 10
        }
    }
    
   
}

//MARK: - UICollectionViewDataSource

extension ChatViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return messageMutableArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.ChatUserCollectionViewCell, for: indexPath) as? ChatUserCollectionViewCell
        
        let chatDetail = messageMutableArray[indexPath.row]
        let message = chatDetail.message ?? String.Empty
        let currentUser = chatDetail.type?.uppercased() == Constant.provider.uppercased() ? true : false
        cell?.loadChatMessages(message: message, currentUser: currentUser)
        return cell!
    }
}

//MARK: - UICollectionViewDelegate

extension ChatViewController: UICollectionViewDelegate {
   
}

//MARK: - UICollectionViewDelegateFlowLayout

extension ChatViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if (messageMutableArray.count > 0) {
            let chatDetail = messageMutableArray[indexPath.row]
            let message = chatDetail.message
            let text = message?.trimmingCharacters(in: .whitespacesAndNewlines)
            let maximumWidth = collectionView.bounds.width - ScreenConstants.proportionalValueForValue(value: 100.0)
            let messageRect = NSString(string: text!).boundingRect(with: CGSize(width: maximumWidth, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: UIFont.setCustomFont(name: .light, size: .x16)], context: nil)
            
            let textMessageContentHeight = messageRect.height
            let messageHeight = (textMessageContentHeight + ScreenConstants.proportionalValueForValue(value: 40.0))
            return CGSize(width: collectionView.frame.width, height: messageHeight)
        }
        else {
            return CGSize(width: 0, height: 0)
        }
    }
}

//MARK: - AccountPresenterToAccountViewProtocol

extension ChatViewController: HomePresenterToHomeViewProtocol {
    
    func getUserChatHistoryResponse(chatEntity: ChatEntity) {
        let chatList = chatEntity.responseData?.first
        messageMutableArray = []
        messageMutableArray = chatList?.data ?? []
        self.retriveMessageData()
    }
}

//
//  ChatRoom.swift
//  ripLove
//
//  Created by 文　裕誠 on 2020/06/05.
//  Copyright © 2020 文　裕誠. All rights reserved.
//

import UIKit
import Firebase

class ChatRoomController: UIViewController {

    @IBOutlet weak var chatRoomTableView: UITableView!
    
    private let CellId = "CellId"
    private var messages:[MessageModel] = []
    
    var chatroom: ChatRoomModel?
    var user: AppUser?
    
    // インスタンスを生成
    private lazy var chatInputAccessoryView: ChatInputAccessoryView = {
        let view = ChatInputAccessoryView()
        view.frame = .init(x: 0, y: 0, width: view.frame.width, height: 100)
        // 自作のdelegate
        view.delegate? = self as ChatInputAccessoryViewDelegate as! ChatInputAccessoryView
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chatRoomTableView.delegate = self
        chatRoomTableView.dataSource = self
        chatRoomTableView.register(UINib(nibName: "ChatRoomCell", bundle: nil), forCellReuseIdentifier:CellId)
        chatRoomTableView.backgroundColor = .rgb(red: 118, green: 140, blue: 180)
        featchMessages()
        // tableViewを見切れないようにする
        chatRoomTableView.contentInset = .init(top: 0, left: 0, bottom: 40, right: 0)
        chatRoomTableView.scrollIndicatorInsets =  .init(top: 0, left: 0, bottom: 40, right: 0)
    }
    
    override var inputAccessoryView: UIView?{
        get{
            return chatInputAccessoryView
        }
    }
    
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
    private func featchMessages() {
        Firestore.firestore().collection("chatRooms").document().collection("messages").addSnapshotListener {
            (snapshot, error) in
            if let error = error {
             print("メッセージの取得に失敗しました\(error)")
                return
            }
            snapshot?.documentChanges.forEach({ (documentChange) in
                switch documentChange.type{
                    
                case .added:
                    let dic = documentChange.document.data()

                    let message = MessageModel(dic: dic)
                    message.partnerUser = self.chatroom?.partnerUser
                    self.messages.append(message)
                    // 日付順に並び替え
                    self.messages.sort { (m1, m2) -> Bool in
                        let m1Date = m1.createdAt.dateValue()
                        let m2Date = m2.createdAt.dateValue()
                        return m1Date < m2Date
                    }
                    
                    self.chatRoomTableView.reloadData()
                    // メッセージ画面を開いたら自動的に一番下までスクロールする
                    self.chatRoomTableView.scrollToRow(at: IndexPath(index: self.messages.count - 1), at: UITableView.ScrollPosition(rawValue: 0)!, animated: true)
                default:
                    break
                }
            })
        }
    }
}
// 自作のdelegate
extension ChatRoomController: ChatInputAccessoryViewDelegate{
    
    func tappedsendButton(text: String) {
        addMessageToFirestore(text)
    }
    
    private func addMessageToFirestore(_ text:String) {
        
        guard let chatroomDocId = chatroom?.documentId else {return}
        guard let name = user?.userName else {return}
        guard let uid = Auth.auth().currentUser?.uid else {return}
        chatInputAccessoryView.removeText()
        let messageId = randomString(length: 20)
        
        let docData = [
            "name": name,
            "createdAt": Timestamp() ,
            "uid": uid,
            "message": text
            ] as [String : Any]
        
        Firestore.firestore().collection("chatRooms").document(chatroomDocId).collection("messages").document(messageId).setData(docData) {
            (error) in
            if let error = error {
                print("メッセージの読み込みに失敗しました\(error)")
                return
            }
            
            let latestMessageData = [
                "latestMessageId": messageId,
                ] as [String : Any]
            
            Firestore.firestore().collection("chatRooms").document(chatroomDocId).updateData(latestMessageData) {
                (error) in
                if let error = error {
                    print("最新メッセージの保存に失敗しました\(error)")
                }
            }
            print("メッセージの保存に成功")
        }
    }
    // ランダムに文字列を作成するメソッド
    func randomString(length: Int) -> String {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        return randomString
    }
    
}

extension ChatRoomController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  messages.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        chatRoomTableView.estimatedRowHeight = 20
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatRoomTableView.dequeueReusableCell(withIdentifier: CellId, for: indexPath) as! ChatRoomCell
        cell.backgroundColor = UIColor.clear
        cell.messageText = messages[indexPath.row]
        return cell
        
    }
}

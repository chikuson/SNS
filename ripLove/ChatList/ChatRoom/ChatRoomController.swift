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
    private var messages:[String] = []
    
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
    }
    override var inputAccessoryView: UIView?{
        get{
            return chatInputAccessoryView
        }
    }
    override var canBecomeFirstResponder: Bool{
        return true
    }
}
// 自作のdelegate
extension ChatRoomController: ChatInputAccessoryViewDelegate{
    
    func tappedsendButton(text: String) {
//        messages.append(text)
//        chatInputAccessoryView.removeText()
//        // 送信したら空にする
//        chatInputAccessoryView.chatTextView.text = ""
//        chatRoomTableView.reloadData()
        Firestore.firestore().collection("chatRooms").document()
        
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

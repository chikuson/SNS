//
//  ChatListViewController.swift
//  ripLove
//
//  Created by 文　裕誠 on 2020/06/05.
//  Copyright © 2020 文　裕誠. All rights reserved.
//

import UIKit
import Firebase
import Nuke

class ChatListViewController: UIViewController {

    let CellId = "Cell"
    private var chatrooms = [ChatRoomModel]()
    
    private var users: AppUser?{
        didSet{
            navigationItem.title = users?.userName
        }
    }
    
    @IBOutlet weak var chatListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        fetchLoginUserInfo()
        fetchChatRoomInfoFromFirestore()
    }
    
    private func fetchChatRoomInfoFromFirestore() {
        Firestore.firestore().collection("chatRooms").addSnapshotListener {
            (snapshot, err) in
            
            if let err = err {
                // TODO: エラーハンドリング、ダイアログ
                print("失敗\(err)")
            }
            
            snapshot?.documentChanges.forEach({ (documentChanges) in
                switch documentChanges.type {
                case .added:
                    self.handleAddedDocumentChange(documentChanges)
                    
                default:
                    break
                }
                
            })
            
        }
    }
    
    private func handleAddedDocumentChange(_ documentChanges:DocumentChange) {
        let dic = documentChanges.document.data()
        let chatRoom = ChatRoomModel(dic: dic)
        chatRoom.documentId = documentChanges.document.documentID
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        chatRoom.members.forEach { (memberUid) in
            if memberUid != uid {
                // ユーザー情報取得
                Firestore.firestore().collection("users").document(memberUid).getDocument {
                    (snapshot, error) in
                    if let error = error {
                        print("取得に失敗しました\(error)")
                        return
                    }
                    guard let dic = snapshot?.data() else {return}
                    let user = AppUser(data: dic)
                    user.uid = snapshot?.documentID
                    
                    chatRoom.partnerUser = user
                    self.chatrooms.append(chatRoom)
                    self.chatListTableView.reloadData()
                }
            }
        }
    }
    
    func setUpViews() {
        chatListTableView.tableFooterView = UIView()
        chatListTableView.dataSource = self
        chatListTableView.delegate = self
        
        navigationController?.navigationBar.barTintColor = .rgb(red: 39, green: 49, blue: 69)
        navigationItem.title = "トーク"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        let rightBarButton = UIBarButtonItem(title: "新規チャット", style: .plain, target: self, action: #selector(tappedRightBarButton))
        navigationItem.rightBarButtonItem = rightBarButton
        navigationItem.rightBarButtonItem?.tintColor = .white
    }
    
    // ユーザー登録情報の確認
    private func ConfirmLoginUser() {
        if Auth.auth().currentUser?.uid == nil {
            let storyBoard = UIStoryboard(name: "SignUp", bundle: nil)
            let SignUpViewController = storyBoard.instantiateViewController(identifier: "SignUpViewController") as! SignUpViewController
            SignUpViewController.modalPresentationStyle = .fullScreen
            self.present(SignUpViewController, animated: true, completion: nil)
        }

    }
    
    @objc func tappedRightBarButton() {
        let storyboard = UIStoryboard.init(name: "UserList", bundle: nil)
        let userList = storyboard.instantiateViewController(identifier: "UserListViewController")
        let navi = UINavigationController.init(rootViewController: userList)
        self.present(navi, animated: true, completion: nil)
    }
    
    private func fetchLoginUserInfo(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("users").document(uid).getDocument {
            (snapShot, err) in
            if let err = err {
             print("読み込みに失敗しました\(err)")
            }

            guard let snapshot = snapShot, let dic = snapShot?.data() else { return }

            let user = AppUser(data: dic)
            self.users = user
            //self.users.append(user)
            self.chatListTableView.reloadData()
            
        }
    }
}

// MARK -- TableViewCell
extension ChatListViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatrooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatListTableView.dequeueReusableCell(withIdentifier: CellId, for: indexPath) as! ChatListTableViewCell
        cell.chatroom = chatrooms[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard.init(name: "ChatRoom", bundle: nil)
        let chatRoomController = storyBoard.instantiateViewController(withIdentifier: "ChatRoom") as! ChatRoomController
        chatRoomController.chatroom = chatrooms[indexPath.row]
        chatRoomController.user = users
        navigationController?.pushViewController(chatRoomController, animated: true)
    }
}

class ChatListTableViewCell: UITableViewCell {
    
    var chatroom: ChatRoomModel? {
        didSet{
            if let chatroom = chatroom {
                partnerLabel.text = chatroom.partnerUser?.userName
                
                guard let url = URL(string: chatroom.partnerUser?.url ?? "") else {return}
                Nuke.loadImage(with: url, into: userImageView)
        
                dateLabel.text = Util.dateFormatter(date: chatroom.createdAt.dateValue())
            }
        }
    }
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var latestMessageLabel: UILabel!
    @IBOutlet weak var partnerLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userImageView.layer.cornerRadius =  30
        
    }
}

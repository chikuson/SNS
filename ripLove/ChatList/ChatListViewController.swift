//
//  ChatListViewController.swift
//  ripLove
//
//  Created by 文　裕誠 on 2020/06/05.
//  Copyright © 2020 文　裕誠. All rights reserved.
//

import UIKit
import Firebase

class ChatListViewController: UIViewController {

    let CellId = "Cell"
//    private var users: AppUser?{
//        didSet{
//            navigationItem.title = users?.userName
//        }
//    }
    
    var users: [AppUser] = []
    
    
    @IBOutlet weak var chatListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        
        // ログインユーザーの読み込み
        //fetchLoginUserInfo()
        fetchuserInfoFromFirestore()
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
    
//    private func fetchLoginUserInfo(){
//        guard let uid = Auth.auth().currentUser?.uid else { return }
//        Firestore.firestore().collection("users").document(uid).getDocument {
//            (snapShot, err) in
//            if let err = err {
//             print("読み込みに失敗しました\(err)")
//            }
//
//            guard let snapshot = snapShot, let dic = snapShot?.data() else { return }
//
//            let user = AppUser(data: dic)
//            self.users.append(user)
//            self.users = user
//            self.chatListTableView.reloadData()
//        }
//    }

    private func fetchuserInfoFromFirestore() {
        Firestore.firestore().collection("users").getDocuments {
            (snapshots, error) in
            if let error = error {
                print("読み込み失敗")
                return
            }
            snapshots?.documents.forEach({
                (snapshots) in
                let dic = snapshots.data()
                let user = AppUser.init(data: dic)
                self.users.append(user)
                
                self.chatListTableView.reloadData()
                
//                self.users.forEach { (AppUser) in
//                    print(AppUser.userName)
//                }
            })
        }
    }
}
// MARK -- TableViewCell
extension ChatListViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatListTableView.dequeueReusableCell(withIdentifier: CellId, for: indexPath) as! ChatListTableViewCell
        // ユーザー情報渡す
        cell.user = users[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard.init(name: "ChatRoom", bundle: nil)
        let chatRoomController = storyBoard.instantiateViewController(withIdentifier: "ChatRoom") as! ChatRoomController
        navigationController?.pushViewController(chatRoomController, animated: true)
    }
    
}

class ChatListTableViewCell: UITableViewCell {
    
    var user: AppUser?{
        didSet{
            if let user = user {
                partnerLabel.text = user.userName
                dateLabel.text = dateFormatter(date: (user.createdAt.dateValue()))
                latestMessageLabel.text = user.email
                // todo ユーザー画像を表示
                
                
            }
        }
    }
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var latestMessageLabel: UILabel!
    @IBOutlet weak var partnerLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userImageView.layer.cornerRadius =  35
        
    }
    
    private func dateFormatter(date: Date) -> String{
        let formatter  = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.string(from: date)
    }
    
}

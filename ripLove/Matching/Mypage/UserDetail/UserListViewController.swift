//
//  UserListViewController.swift
//  ripLove
//
//  Created by 文　裕誠 on 2020/06/27.
//  Copyright © 2020 文　裕誠. All rights reserved.
//

import UIKit
import Firebase
import Nuke

class UserListViewController: UIViewController {

    @IBOutlet weak var userListTableView: UITableView!
    @IBOutlet weak var startChatBtn: UIButton!
    
    private let cellId = "cellId"
    private var users = [AppUser]()
     
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userListTableView.delegate = self
        userListTableView.dataSource = self
        
        startChatBtn.layer.cornerRadius = 15
        
        navigationController?.navigationBar.barTintColor = .rgb(red: 39, green: 49, blue: 69)
        
        userListTableView.register(UserListTableViewCell.self, forCellReuseIdentifier: cellId)
        
        fetchuserInfoFromFirestore()
    }
    
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
                
                guard let uid = Auth.auth().currentUser?.uid else { return }
                
                // 同じユーザーの場合 ロードしない
                if uid == snapshots.documentID {
                    return
                }
                
                self.users.append(user)
                print(user)
                self.userListTableView.reloadData()
                
                self.users.forEach { (AppUser) in
                    print(AppUser.userName)
                }
            })
        }
    }
}
extension UserListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = userListTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserListTableViewCell
        cell.user = users[indexPath.row]
        return cell
    }
}

class UserListTableViewCell: UITableViewCell {
    
    var user: AppUser?{
        didSet{
            if let user = user {
                userNameLabel.text = user.userName
                
            }
            if let url = URL(string: user?.url ?? ""){
                Nuke.loadImage(with: url, into: userImageIcon)
            }
        }
    }
    
    @IBOutlet weak var userImageIcon: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userImageIcon.layer.cornerRadius = 25
    }
}

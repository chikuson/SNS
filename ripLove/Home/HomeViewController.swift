//
//  HomeViewController.swift
//  ripLove
//
//  Created by 文　裕誠 on 2020/05/16.
//  Copyright © 2020 文　裕誠. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
    
    @IBOutlet weak var timeLine: UITableView!
    
    var dateBase: Firestore!
    var users :AppUser!
    
    var postArray:[Post] = []
        
    private let TYPE_NOMAL_CELL = "HomeCell"
    private let TYPE_LOADING_CELL = "LodingCell"
    private let TYPE_EMPTY_CELL = "EmptyCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 初期値を入れる
        dateBase = Firestore.firestore()
        timeLine.delegate = self
        timeLine.dataSource = self
         timeLine.register(UINib(nibName: TYPE_NOMAL_CELL, bundle: nil), forCellReuseIdentifier: TYPE_NOMAL_CELL)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        // 掲示板投稿のでーた読み取り
        dateBase.collection("posts").getDocuments { (snapshot, error) in
            if error == nil, let snapshot = snapshot {
                
                self.postArray = []
                
                for document in snapshot.documents {
                    let data = document.data()
                    let post = Post(data: data)
                    self.postArray.append(post)
                    
                }
                self.timeLine.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! PostTimeLineController // segue.destinationで遷移先のViewControllerが取得可能。
        destination.users = sender as? Post
    }
    
    @IBAction func toAddpost(_ sender: UIButton) {
         performSegue(withIdentifier: "Add", sender: users)
    }
}

/*
---------------  TableView class ----------------------------------
*/

extension HomeViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = timeLine.dequeueReusableCell(withIdentifier: TYPE_NOMAL_CELL, for: indexPath) as! HomeCell
        cell.userMessage.text = (postArray[indexPath.row]).content
        // 　userimageはここで　Nukeをつかっていれる
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        
        
    }
}

extension HomeViewController: UITableViewDelegate{
    
}




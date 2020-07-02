//
//  HomeCell.swift
//  ripLove
//
//  Created by 文　裕誠 on 2020/05/17.
//  Copyright © 2020 文　裕誠. All rights reserved.
//

import UIKit

class HomeCell: UITableViewCell {
    
    @IBOutlet weak var userIcon: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userMessage: UILabel!
    @IBOutlet weak var postTime: UILabel!
    
    
    let nowtime = Date()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userIcon.layer.cornerRadius = 20
        postTime.text = Date.dateString(date: nowtime)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    // セルにユーザー情報を埋め込む枠
    func setCell(userMessage: String, userName: String, currentPost: Any, userIcon: String) {
        self.userMessage.text = userMessage
        self.userName.text = userName
        self.userIcon.image = UIImage(named: userIcon)
        self.postTime.text =  currentPost as? String
    }
}

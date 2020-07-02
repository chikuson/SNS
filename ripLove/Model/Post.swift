//
//  Post.swift
//  ripLove
//
//  Created by 文　裕誠 on 2020/05/18.
//  Copyright © 2020 文　裕誠. All rights reserved.
//

import Foundation
import Firebase

struct Post {
    
   // let userName: String
    let content: String // 投稿内容
    let postID: String //投稿ごとのID
    //let senderID: String  // 投稿者のUserID
    let createdAt: Timestamp // 投稿が作成された時間
    let updatedAt: Timestamp //投稿が更新された時間

    init(data: [String: Any]) {
        //userName = data["userName"] as! String
        content = data["content"] as! String
        postID = data["postID"] as! String //
        //senderID = data["senderID"] as? String ?? "" // 送信元
        createdAt = data["createdAt"] as! Timestamp //
        updatedAt = data["updatedAt"] as! Timestamp //
    }
}

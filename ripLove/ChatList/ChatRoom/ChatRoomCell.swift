//
//  ChatRoomCell.swift
//  ripLove
//
//  Created by 文　裕誠 on 2020/06/05.
//  Copyright © 2020 文　裕誠. All rights reserved.
//

import UIKit
import Firebase
import Nuke


class ChatRoomCell: UITableViewCell {

    @IBOutlet weak var userIcon: UIImageView!
    @IBOutlet weak var myMessageTextView: UITextView!
    @IBOutlet weak var myDateLabel: UILabel!
    @IBOutlet weak var partnerMessageTextView: UITextView!
    @IBOutlet weak var partnerDateLabel: UILabel!
    @IBOutlet weak var messageTextViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var myMessageTextViewWidthConstraint: NSLayoutConstraint!
    
    // メッセージのテキストの横制約を可変にする
    var messageText: MessageModel? {
        didSet{
//            if let message = messageText {
//                partnerMessageTextView.text = message.message
//                let witdh = estimateFrameForTextView(text: message.message).width
//                messageTextViewWidthConstraint.constant = witdh
//                partnerDateLabel.text = Util.dateFormatter(date: message.createdAt.dateValue())
//            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.clear
        userIcon.layer.cornerRadius = 30
        partnerMessageTextView.layer.cornerRadius = 15
        myMessageTextView.layer.cornerRadius = 15
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    private func checkWitchUserMessage() {
        guard let uid = Auth.auth().currentUser?.uid  else { return }
        
        // TODO: XIB Cellで切り分ける
        if uid == messageText?.uid {
            
            partnerMessageTextView.isHidden = true
            partnerDateLabel.isHidden = true
            userIcon.isHidden = true
            
            myMessageTextView.isHidden = false
            myDateLabel.isHidden = false
            if let urlString = messageText?.partnerUser?.url,
               let url = URL(string: urlString) {
                
                Nuke.loadImage(with: url, into: userIcon)
            }
            
            // 自分のテキスト
            if let message = messageText {
                myMessageTextView.text = message.message
                let witdh = estimateFrameForTextView(text: message.message).width
                myMessageTextViewWidthConstraint.constant = witdh
                myDateLabel.text = Util.dateFormatter(date: message.createdAt.dateValue())
            }
        }else{
            
            partnerMessageTextView.isHidden = false
            partnerDateLabel.isHidden = false
            userIcon.isHidden = false
            myMessageTextView.isHidden = true
            myDateLabel.isHidden = true
            
            // 相手のテキスト
            if let message = messageText {
                partnerMessageTextView.text = message.message
                let witdh = estimateFrameForTextView(text: message.message).width
                messageTextViewWidthConstraint.constant = witdh
                partnerDateLabel.text = Util.dateFormatter(date: message.createdAt.dateValue())
            }
        }
    }
    
    // 幅計算のメソッド
    private func estimateFrameForTextView(text:String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes:[NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)] , context: nil)
    }

}

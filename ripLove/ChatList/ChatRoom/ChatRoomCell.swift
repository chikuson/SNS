//
//  ChatRoomCell.swift
//  ripLove
//
//  Created by 文　裕誠 on 2020/06/05.
//  Copyright © 2020 文　裕誠. All rights reserved.
//

import UIKit

class ChatRoomCell: UITableViewCell {

    @IBOutlet weak var userIcon: UIImageView!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var messageTextViewWidthConstraint: NSLayoutConstraint!
    
    // メッセージのテキストの横制約を可変にする
    var messageText: MessageModel? {
        didSet{
            if let message = messageText {
                messageTextView.text = message.message
                let witdh = estimateFrameForTextView(text: message.message).width
                messageTextViewWidthConstraint.constant = witdh
                dateLabel.text = Util.dateFormatter(date: message.createdAt.dateValue())   
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.clear
        userIcon.layer.cornerRadius = 30
        messageTextView.layer.cornerRadius = 15
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    // 幅計算のメソッド
    private func estimateFrameForTextView(text:String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes:[NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)] , context: nil)
    }

}

//
//  ChatInputAccessoryView.swift
//  ripLove
//
//  Created by 文　裕誠 on 2020/06/08.
//  Copyright © 2020 文　裕誠. All rights reserved.
//

import Foundation

protocol ChatInputAccessoryViewDelegate: class {
    func tappedsendButton(text:String)
}

class ChatInputAccessoryView: UIView {

    @IBOutlet weak var chatTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    
    
    // 自作のdelegate
    @IBAction func tappedsendButton(_ sender: Any) {
        guard let text = chatTextView.text else { return }
        delegate?.tappedsendButton(text)
    }
    
    weak var delegate: ChatInputAccessoryView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        nibInit()
        setupView()
        // textViewを可変にする
        autoresizingMask = .flexibleHeight
    }
    
    
    private func setupView(){
        chatTextView.layer.cornerRadius = 15
        chatTextView.layer.borderColor = UIColor.rgb(red: 230, green: 230, blue: 230).cgColor
        sendButton.layer.cornerRadius = 15
        sendButton.imageView?.contentMode = .scaleAspectFill
        sendButton.contentHorizontalAlignment = .fill
        sendButton.contentVerticalAlignment = .fill
        sendButton.isEnabled = false
        chatTextView.text = ""
        chatTextView.delegate = self
    }
    
    
    func removeText(){
        chatTextView.text = ""
        sendButton.isEnabled = false
    }
    
    // textViewを可変にする
    override var intrinsicContentSize: CGSize{
        return .zero
    }
    
    // nib
    private func nibInit() {
        let nib = UINib(nibName: "ChatInputAccessoryView", bundle: nil)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else {return}
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(view)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension ChatInputAccessoryView: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
    
        if textView.text.isEmpty {
            sendButton.isEnabled = false
        }else{
            sendButton.isEnabled = true
        }
    }
}

//
//  PostTimeLineController.swift
//  ripLove
//
//  Created by 文　裕誠 on 2020/05/18.
//  Copyright © 2020 文　裕誠. All rights reserved.
//

import UIKit
import Firebase

class PostTimeLineController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    var me : AppUser!
    var users: Post!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! PostTimeLineController // segue.destinationで遷移先のViewControllerが取得可能。
        destination.me = sender as? AppUser
    }
    
    
    func setupTextView() {
        let toolBar = UIToolbar() // キーボードの上に置くツールバーの生成
        let flexibleSpaceBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) // 今回は、右端にDoneボタンを置きたいので、左に空白を入れる
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard)) // Doneボタン
        toolBar.items = [flexibleSpaceBarButton, doneButton] // ツールバーにボタンを配置
        toolBar.sizeToFit()
        textView.inputAccessoryView = toolBar // テキストビューにツールバーをセット
    }

    // キーボードを閉じる処理。
    @objc func dismissKeyboard() {
        textView.resignFirstResponder()
    }
    
    // 投稿処理
    @IBAction func postContens(_ sender: UIButton) {
        let contents = textView.text!
        let saveDocument = Firestore.firestore().collection("posts").document()
        saveDocument.setData([
            "content": contents,
            "postID": saveDocument.documentID,
            //"senderID": users.senderID,
            "createdAt": FieldValue.serverTimestamp(),
            "updatedAt": FieldValue.serverTimestamp()
        ]) {
            
            error in
            if error == nil {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}

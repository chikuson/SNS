//
//  MypageViewController.swift
//  ripLove
//
//  Created by 文　裕誠 on 2020/05/26.
//  Copyright © 2020 文　裕誠. All rights reserved.
//

import UIKit
import FirebaseStorage
import Firebase
import SCLAlertView
import SDWebImage
import RxSwift
import RxCocoa

class MypageViewController: UITableViewController {

    @IBOutlet weak var userIcon: UIImageView!
    @IBOutlet weak var UserName: UIView!
    @IBOutlet weak var genderType: UISegmentedControl!
    @IBOutlet weak var userId: UILabel!
    @IBOutlet weak var password: UILabel!
    
    
    var userData: AppUser!
    var dateBase: Firestore!
    var ref:DatabaseReference!
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateBase = Firestore.firestore()
        ref = Database.database().reference()
        imagePicker.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func setUserInfo() {
        // 掲示板投稿のでーた読み取り
        dateBase.collection("posts").getDocuments { (snapshot, error) in
            if error == nil, let snapshot = snapshot {
                
            }
        }
    }

    // 画像のアップロード
     func setImage(uid: String, imageView: UIImageView?){
        let storageRef = Storage.storage().reference()
        let ref = storageRef.child("\(uid).jpg")
        imageView?.sd_setImage(with: ref, placeholderImage: nil)
    }
    
    // 画像の読み込み
    func setImageBySDWebImage(with url: URL, imageView: UIImageView) {
        imageView.sd_setImage(with: url) {
            [weak self] image, error, _, _ in
            if error == nil, let image = image {
                imageView.image = image
            } else {
                
                let dialog = SCLAlertView()
                dialog.showError("エラー", subTitle: "もう一度やりなおしてください")
            }
        }
        let data = url.absoluteString
        self.ref.child("userData").updateChildValues(["imageURL": data])
    }
    
    
    // 名前の変更メソッド
    func modifyName(){
        
        let alert = SCLAlertView()
        let txt = alert.addTextField("Enter your name")
        alert.addButton("OK") {
            self.userId.text = txt.text
        }
        alert.showEdit("名前を編集", subTitle: "")
        // 書き込み
        self.ref.child("userData").childByAutoId().setValue(["username": self.userId.text])
    }
    
    @IBAction func changeImageBtn(_ sender: UIButton) {
                
                let alert: UIAlertController = UIAlertController(title: "写真を追加します", message: "", preferredStyle: UIAlertController.Style.actionSheet)
                // 写真を選択
                let photoSelect: UIAlertAction = UIAlertAction(title: "写真を選択", style: UIAlertAction.Style.default, handler: {
                    (action: UIAlertAction!) -> Void in
                    
                    // 写真を選ぶビュー
                    let pickerView = UIImagePickerController()
                    // 写真の選択元をフォトライブラリにする
                    pickerView.sourceType = .photoLibrary
                    // デリゲート
                    pickerView.delegate = self
                    // ビューに表示
                    self.present(pickerView, animated: true)
                })
                
                let cancel: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler: {
                    (action: UIAlertAction!) -> Void in
                })
                
                
                alert.addAction(photoSelect)
                alert.addAction(cancel)
                
                // Alertを表示
                present(alert, animated: true, completion: nil)
        
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Table view data source
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MypageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // 画像選択時の処理
        if let pickedImage = info[.originalImage] as? UIImage {
            
            //Storageの参照（"Item"という名前で保存）
            let date = Date()
            let currentTimeStampInSecond = UInt64(floor(date.timeIntervalSince1970 * 1000))
            let storageref = Storage.storage().reference(forURL: "gs://riplove-15efe.appspot.com").child("image").child("\(currentTimeStampInSecond).jpg")
            //imageをNSDataに変換
            let data = pickedImage.jpegData(compressionQuality: 1.0)! as NSData
            let meta = StorageMetadata()
            meta.contentType = "image/jpeg"

            //Storageに保存
            storageref.putData(data as Data, metadata: meta) {
                metadata, error in
                if error != nil {
                    self.setImage(uid: "\(currentTimeStampInSecond)", imageView: self.userIcon)
                    return
                }else{
                    storageref.downloadURL {
                        (url, error) in
                        self.setImageBySDWebImage(with: url!, imageView: self.userIcon)
                    }
                }
            }
            
            // 完了ダイアログ
            let dialog = SCLAlertView()
            dialog.showInfo("アップロード完了", subTitle: "しばらくお待ち下さい")
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // キャンセルボタンを押下時の処理
        picker.dismiss(animated: true, completion: nil)
    }
}

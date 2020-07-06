//
//  ViewController.swift
//  ripLove
//
//  Created by 文　裕誠 on 2020/05/12.
//  Copyright © 2020 文　裕誠. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import SVProgressHUD
import FirebaseStorage
import RxSwift
import RxCocoa

class SignUpViewController: UIViewController,FUIAuthDelegate {

    @IBOutlet weak var mailTextFiled: UITextField!
    @IBOutlet weak var passwordFiled: UITextField!
    @IBOutlet weak var displayedPasswordLabel: UILabel!
    @IBOutlet weak var alertPasswordLabel: UILabel!
    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet weak var userNameTextFiled: UITextField!
    //TODO: 装飾　DSFloatingButton
    @IBOutlet weak var registerButton: UIButton!
    
    // ユーザー情報
    var user: AppUser!

    // RxSwift関連
    private let signModel = SignUpModel()
    private let disposeBag = DisposeBag()
    private var minimumInputLength: Int = 6

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        registerSkip()
        userRegisterInfoBind()
    }
    
    func setUpView() {
        passwordFiled.isSecureTextEntry = true // 文字を非表示に
        alertPasswordLabel.text = "6文字以上入力してください"
        alertPasswordLabel.textColor = UIColor.red
        
        profileImageButton.layer.cornerRadius = 100
        profileImageButton.layer.borderWidth = 1
        profileImageButton.layer.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240).cgColor
        profileImageButton.addTarget(self, action: #selector(tappedProfileImageButton), for: .touchUpInside)
        
        registerButton.addTarget(self, action: #selector(tappedRegisterButton), for: .touchUpInside)
        registerButton.isEnabled = false
        registerButton.backgroundColor = .rgb(red: 100, green: 100, blue: 100)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextViewController = segue.destination as! PostTimeLineController
        let user = sender as! AppUser
        nextViewController.me = AppUser(data: ["userID": UD.userid as Any])
    }
    
    func registerSkip(){
        // ユーザー登録スキップ
        if Auth.auth().currentUser?.uid != nil || UD.userid != nil {
            MainTabViewController.instance?.tabSetup()
            Util.gotoStroboard(storyBoardName: "Tab")
        }else{
            // TODO: エラー時のダイアログ表示
        }
    }
    
    func userRegisterInfoBind() {
        
        Observable.combineLatest(
        passwordFiled.rx.text.asObservable(),
        mailTextFiled.rx.text.asObservable(),
        userNameTextFiled.rx.text.asObservable())
            
        .subscribe { [weak self] in
            let userName = self?.userNameTextFiled.text?.isEmpty ?? false
            let mail = self?.mailTextFiled.text?.isEmpty ?? false
            guard let text = $0.element else {return}
            
            // passwordFiled 値の更新通知を行う
            self?.signModel.setUserRegisterInfo(userNameText: text.1 ?? "", passwordText: text.0 ?? "", mailText: text.2 ?? "")
            
            if text.0?.count ?? 0 < self?.minimumInputLength ?? 6 || userName || mail {
                
                self?.registerButton.isEnabled = false
                self?.registerButton.backgroundColor = .rgb(red: 100, green: 100, blue: 100)
                self?.alertPasswordLabel.textColor = UIColor.red
                
            }else{
                
                self?.alertPasswordLabel.textColor = UIColor.lightGray
                let enable: Bool = ((self?.signModel.isEnableButton()) != nil)
                self?.registerButton.isEnabled = enable
                self?.registerButton.backgroundColor = .rgb(red: 0, green: 185, blue: 0)
            
            }
        }.disposed(by: disposeBag)
        
        signModel.password.asObservable()
            .subscribe {
                [weak self] in
                // signModelの更新処理をする
                self?.displayedPasswordLabel.text = $0.element
        }.disposed(by: disposeBag)
    }
    // 画像タップ時の処理
    @objc private func tappedProfileImageButton(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    // ユーザー作成
    private func createUser(UserIcon:String){
        
        guard let mailAdress = mailTextFiled.text else { return }
        guard let password = passwordFiled.text else { return }
        
        SVProgressHUD.show(withStatus: "読み込み中")
        Auth.auth().createUser(withEmail: mailAdress, password: password) {
            (res, error) in
            if let error = error {
                SVProgressHUD.dismiss()
                return
            }
            
            guard let uid = res?.user.uid else { return }
            guard let userName = self.userNameTextFiled.text else { return }
            UD.userid = uid
            
            let docData = [
                "mail":mailAdress,
                "password":password,
                "userName":userName,
                "createdAt":Timestamp(),
                "userIconUrlString": UserIcon
                ] as [String : Any]
            
            Firestore.firestore().collection("users").document(uid).setData(docData){
                (error) in
                SVProgressHUD.dismiss()
                if let error = error{
                    print("firestoreに保存できませんでした\(error)")
                }
                // 画面遷移
                MainTabViewController.instance?.tabSetup()
                Util.gotoStroboard(storyBoardName: "Tab")
            }
        }
    }
    // ユーザー登録ボタンをおしたら
    @objc private func tappedRegisterButton(){
        
        guard let image = profileImageButton.imageView?.image else { return }
        guard let uploadImage = image.jpegData(compressionQuality: 0.3) else { return }
        
        let fileName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("user_icon").child(fileName)
            
        storageRef.putData(uploadImage, metadata: nil) {
            (metaData, error) in
            
            if let error = error {
                // TODO: エラー時のダイアログ表示
                return
            }
            
            storageRef.downloadURL {
                (url, error) in
                if let error = error {
                    // TODO: エラー時のダイアログ表示
                    return
                }
                guard let urlString = url?.absoluteString else { return }
                self.createUser(UserIcon: urlString)
            }
        }
    }

    @IBAction func tappedLoginButton(_ sender: UIButton) {
        if UD.userid != "" {
            // ユーザー作成
            MainTabViewController.instance?.tabSetup()
            Util.gotoStroboard(storyBoardName: "Tab")
        }
    }
    //　メール登録
    @IBAction func registerMailAccount() {
        guard let email = mailTextFiled.text else { return }
        guard let password = passwordFiled.text else { return }
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if error == nil, let result = result {
                result.user.sendEmailVerification(completion: { (error) in
                    if error == nil {
                        let alert = UIAlertController(title: "仮登録を行いました。", message: "入力したメールアドレス宛に確認メールを送信しました。", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                })
            }
        }
    }

    //　ログアウト
    func logout() {
        do {
            //do-try-catchの中で、FIRAuth.auth()?.signOut()を呼ぶだけで、ログアウトが完了
            try Auth.auth().signOut()
            //先頭のNavigationControllerに遷移
            let storyboard = UIStoryboard(name: "SignUp", bundle: nil).instantiateViewController(withIdentifier: "Nav")
            self.present(storyboard, animated: true, completion: nil)
        } catch let error as NSError {
            print("\(error.localizedDescription)")
        }
    }
}

// MARK-- UIimagePicker
extension SignUpViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editImage = info[.editedImage] as? UIImage{
            // editImageは画像のサイズなど変更を行ったあとの画像
            profileImageButton.setImage(editImage.withRenderingMode(.alwaysOriginal), for: .normal)
            
        }else if let originalImage = info[.originalImage] as? UIImage {
            // originalImageはそのままの画像サイズで使用　（加工なし）
          profileImageButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
            
        }
        
        profileImageButton.setTitle("", for: .normal)
        profileImageButton.imageView?.contentMode = .scaleAspectFill
        profileImageButton.contentHorizontalAlignment = .fill
        profileImageButton.contentVerticalAlignment = .fill
        profileImageButton.clipsToBounds = true
        
        dismiss(animated: true, completion: nil)
    }
}

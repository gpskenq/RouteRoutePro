//
//  SignUpController.swift
//  RouteRoutePro
//
//  Created by 安齋洸也 on 2018/11/09.
//  Copyright © 2018年 安齋洸也. All rights reserved.
//

import Foundation
import UIKit

class SignUpController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var userid: UITextField!
    @IBOutlet weak var password: UITextField!
    
    private lazy var userModel = UserModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.name.delegate = self
        self.userid.delegate = self
        self.password.delegate = self
    }
    
    //complete keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    
    //hide keyborad
    @IBAction func tapView(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    @IBAction func signup(_ sender: UIButton) {
        let user = User()
        user.name = self.name.text
        user.userid = self.userid.text
        user.password = self.password.text
        guard user.name != "" else {
            CBToast.showToastAction(message: "ユーザー名が空いている")
            return
        }
        guard user.userid != "" else {
            CBToast.showToastAction(message: "ユーザーid空")
            return
        }
        guard user.password != "" else {
            CBToast.showToastAction(message: "パスワードは空")
            return
        }
        let pattern = "^[a-zA-Z0-9_]{2,16}$"
        let matcher = MyRegex(pattern)
        if !matcher.match(input: user.name!) {
            CBToast.showToastAction(message: "ユーザーIDアルファベット、数字、下線を許す")
            return
        }
        user.password = user.password?.md5()
        userModel.signup(user: user) { (UserResult) in
            CBToast.showToastAction(message: "Signup Success")
            self.presentingViewController!.dismiss(animated: true, completion: nil)
        }
    }
}


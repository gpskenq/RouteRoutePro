//
//  ViewController.swift
//  RouteRoutePro
//
//  Created by 安齋洸也 on 2018/11/09.
//  Copyright © 2018年 安齋洸也. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    //signup
    @IBAction func touchSignUp(_ sender: Any) {
        self.performSegue(withIdentifier: "goSignUp", sender: self)
    }
    
    //login
    @IBAction func touchlogin(_ sender: Any) {
        self.performSegue(withIdentifier: "goLogin", sender: self)
    }
    
    //戻る実装
    @IBAction func myUnwindAction(segue: UIStoryboardSegue) {
        
        
    }
}


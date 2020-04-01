//
//  FacebookLogin.swift
//  dteproof
//
//  Created by 陳昱豪 on 2020/3/4.
//  Copyright © 2020 Chen_Yu_Hao. All rights reserved.
//

import Foundation
import FacebookLogin
class ViewController: UIViewController {
   @IBAction func login(_ sender: Any) {
        let manager = LoginManager()
        manager.logIn(permissions: [.publicProfile], viewController: self) { (result) in
            if case LoginResult.success(granted: _, declined: _, token: _) = result {
                print("login ok")
            } else {
                print("login fail")
            }
        }
        
    }
}
    
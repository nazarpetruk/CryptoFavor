//
//  AuthVC.swift
//  CryptoFavor
//
//  Created by Nazar Petruk on 02/10/2019.
//  Copyright © 2019 Nazar Petruk. All rights reserved.
//

import UIKit
import LocalAuthentication

class AuthVC: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.3450980392, green: 0.6941176471, blue: 0.6235294118, alpha: 1)
        presentAuth()
    }
    
    
    func presentAuth(){
        LAContext().evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Wallet is protected") { (succes, error) in
            if succes {
                DispatchQueue.main.async {
                    let cryptoVC = CryptoVC()
                    let navController = UINavigationController(rootViewController: cryptoVC)
                    let navigationBarAppearance = UINavigationBar.appearance()
                    navigationBarAppearance.tintColor = #colorLiteral(red: 0.1725490196, green: 0.2274509804, blue: 0.2784313725, alpha: 1)
                    navigationBarAppearance.barTintColor = #colorLiteral(red: 0.3450980392, green: 0.6941176471, blue: 0.6235294118, alpha: 1)
                    navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.font:UIFont(name: "Futura-Bold", size: 25)!, NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.1725490196, green: 0.2274509804, blue: 0.2784313725, alpha: 1)]
                    navController.modalPresentationStyle = .fullScreen
                    self.present(navController, animated: true, completion: nil)
                }
            }else{
                self.presentAuth()
            }
        }
    }
}

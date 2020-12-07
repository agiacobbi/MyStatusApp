//
//  ViewController.swift
//  Doorbell
//
//  Created by Giacobbi, Alexander T on 11/27/20.
//

import UIKit
import FirebaseUI

class ViewController: UIViewController, FUIAuthDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
    }

    @IBAction func loginButtonPressed(_ sender: UIButton) {
        let authUI = FUIAuth.defaultAuthUI()
        guard authUI != nil else { return }
        authUI?.delegate = self
        let providers: [FUIAuthProvider] = [
            FUIEmailAuth(),
        ]
        authUI?.providers = providers
        let authViewController = authUI!.authViewController()
        
        present(authViewController, animated: true, completion: nil)
        
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        if error != nil {
            return
        }
        
        performSegue(withIdentifier: "segueToLoggedIn", sender: self)
    }
    
    
}


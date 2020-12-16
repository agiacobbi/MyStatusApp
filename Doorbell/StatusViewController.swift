//
//  StatusViewController.swift
//  Doorbell
//
//  Created by Giacobbi, Alexander T on 12/6/20.
//

import UIKit
import Firebase

class StatusViewController: UIViewController {
    var ref: DatabaseReference! = Database.database().reference()
    var user: User = Auth.auth().currentUser!
    @IBOutlet weak var statusSwitch: UISwitch!
    @IBOutlet weak var statusLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addUserIfNotExists()

        // Do any additional setup after loading the view.
        ref.child("users").child(user.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            if let status = value?["status"] as? Bool {
                print("status: \(status)")
                self.statusSwitch.isOn = status
            }
            
            self.updateStatus()
        })

    }
    
    
    
    func addUserIfNotExists() {
        ref.child("users").child(user.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if !snapshot.exists() {
                print("user not found in the db...adding user")
                
                self.ref.child("users").child(self.user.uid).setValue([
                    "username": self.user.displayName!,
                    "status": self.statusSwitch.isOn,
                    "email": self.user.email!
                ])
                
                self.ref.child("following").child(self.user.uid).setValue([self.user.uid: true])
            }
        })
    }
    
    
    func updateStatus() {
        self.ref.child("users").child(user.uid).child("status").setValue(statusSwitch.isOn)
        
        if statusSwitch.isOn {
            self.view.backgroundColor = .systemGreen
            statusLabel.text = "Available"
        } else {
            self.view.backgroundColor = .systemOrange
            statusLabel.text = "Busy"
        }
    }
    
    @IBAction func switchToggled() {
        updateStatus()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

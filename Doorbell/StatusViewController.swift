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
    var red: UIColor = UIColor(red: CGFloat(240.0), green: CGFloat(190.0), blue: CGFloat(170.0), alpha: CGFloat(1.0))
    var green: UIColor = UIColor(red: CGFloat(190.0), green: CGFloat(240.0), blue: CGFloat(170.0), alpha: CGFloat(1.0))
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    
    func updateStatus() {
        self.ref.child("users").child(user.uid).setValue([
            "username": user.displayName!,
            "status": statusSwitch.isOn,
            "email": user.email!
        ])
        
        if statusSwitch.isOn {
            self.view.backgroundColor = red
            statusLabel.text = "Available"
        } else {
            self.view.backgroundColor = green
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

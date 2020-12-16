//
//  FriendsViewController.swift
//  Doorbell
//
//  Created by Giacobbi, Alexander T on 12/6/20.
//

import UIKit
import Firebase

class FriendsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var friends: [(name: String, email: String, status: Bool)] = []
    var ref: DatabaseReference! = Database.database().reference()
    var user: User = Auth.auth().currentUser!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadFriends()
        listenForChanges()
    }
    
    
    func loadFriends() {
        ref.child("following").child(user.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            let usersDict = snapshot.value as! [String: AnyObject]

            for key in usersDict.keys {
                self.ref.child("users").child(key).observeSingleEvent(of: .value, with: { (dataSnap) in
                    let info = dataSnap.value as! [String: AnyObject]
                    let userName = info["username"] as! String
                    let userEmail = info["email"] as! String
                    let userStatus = info["status"] as! Bool
                    self.friends.append((userName, userEmail, userStatus))
                    self.tableView.reloadData()
                })
            }
        })
    }
    
    
    func listenForChanges() {
        ref.child("users").observe(.childChanged, with: { (snapshot) in
            let change = snapshot.value as! [String: AnyObject]
            
            for i in 0..<self.friends.count {
                if self.friends[i].email == change["email"] as! String {
                    self.friends[i].status = change["status"] as! Bool
                }
            }
            
            self.tableView.reloadData()
        })
    }
    
    
    @IBAction func addFriendButtonPressed(_ sender: Any) {
        var alertTextField = UITextField()
        let alert = UIAlertController(title: "Add New Friend", message: "Search for a friend by their email", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Email Address"
            alertTextField = textField
        }
        
        let action = UIAlertAction(title: "Add Friend", style: .default, handler: { _ in
            let email = alertTextField.text!
            
            self.ref.child("users").queryOrdered(byChild: "email").queryEqual(toValue: email).observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.exists() {
                    let usersDict = snapshot.value as! [String: [String: AnyObject]]

                    for key in usersDict.keys {
                        print(key)
                        let userEntry = usersDict[key]
                        let userName = userEntry?["username"] as! String
                        let userEmail = userEntry?["email"] as! String
                        let userStatus = userEntry?["status"] as! Bool
                        self.friends.append((userName, userEmail, userStatus))
                        self.ref.child("following").child(self.user.uid).child(key).setValue(true)
                        self.tableView.reloadData()
                    }
                
                } else {
                    print("user not found")
                    let errorAlert = UIAlertController(title: "Couldn't find user", message: "A person associated with the email you provided does not exist in our system", preferredStyle: .alert)
                    errorAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                    self.present(errorAlert, animated: true, completion: nil)
                }
            })
        })
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return friends.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let friend = friends[row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! PersonTableViewCell
        
        cell.update(friend.name, withStatus: friend.status, email: friend.email)
        
        return cell
    }

}

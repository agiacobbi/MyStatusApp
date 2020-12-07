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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadFriends()
        listenForChanges()
    }
    
    
    func loadFriends() {
        ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            let usersDict = snapshot.value as! [String: [String: AnyObject]]

            for key in usersDict.keys {
                let userEntry = usersDict[key]
                let userName = userEntry?["username"] as! String
                let userEmail = userEntry?["email"] as! String
                let userStatus = userEntry?["status"] as! Bool
                self.friends.append((userName, userEmail, userStatus))
            }
            
            self.tableView.reloadData()
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

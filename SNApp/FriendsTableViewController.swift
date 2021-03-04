//
//  FriendsTableViewController.swift
//  SNApp
//
//  Created by ALEKSANDR GRIGOREV on 25.02.2021.
//

import UIKit
import RealmSwift


class FriendsTableViewController: UITableViewController {
    var friends: [Friend] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.reloadData()
    }

    func reloadData() {
        self.friends = []
        do {
            //try FileManager.default.removeItem(at: Realm.Configuration.defaultConfiguration.fileURL!)
            let realm = try Realm()
            self.friends = Array(realm.objects(Friend.self))
        }
        catch {
            print(error)
        }
        tableView.reloadData()
    }

    @IBAction func refreshFriends(_ sender: Any) {
        let url = URL(string: "https://api.vk.com/method/friends.get?v=5.130&fields=city,photo_50&user_id=\(Session.instance.userId)&access_token=\(Session.instance.token)")
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            sleep(1)

            if let friendsResponse = try? JSONDecoder().decode(FriendsResponse.self, from: data!) {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    //self.friends = friendsResponse.response.items
                    
                    do {
                        let realm = try Realm()
                        //print(realm.configuration.fileURL)
                        realm.beginWrite()
                        realm.delete(realm.objects(Friend.self))
                        try realm.commitWrite()
                        for friend in friendsResponse.response.items {
                            realm.beginWrite()
                            realm.add(friend)
                            try realm.commitWrite()
                        }
                    }
                    catch {
                        print(error)
                    }
                    
                    self.reloadData()
                    //self.tableView.reloadData()
                    self.refreshControl?.endRefreshing()
                }
            }
            else {
                print("Cannot parse friends response")
            }
        }
        task.resume()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return friends.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsCell", for: indexPath)
        
        cell.textLabel?.text = "\(friends[indexPath.row].last_name) \(friends[indexPath.row].first_name) \(friends[indexPath.row].last_name)"
        
        if let url = URL(string: friends[indexPath.row].photo_50), let data = try? Data(contentsOf: url) {
            cell.imageView?.image = UIImage(data: data)
        }
        else {
            cell.imageView?.image = nil
        }
        //cell.imageView?.image = UIImage(
        // Configure the cell...
 
        return cell
        
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "FriendPhotos" {
            let vc = segue.destination as! PhotosCollectionViewController
            if let index = tableView.indexPathForSelectedRow {
                vc.userId = 248708684 //friends[index.row].id
            }
        }
    }

}

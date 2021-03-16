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
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
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
        NetworkService.instance.loadFriends { [weak self] in
            guard let self = self else { return }
            //self.friends = friendsResponse.response.items
            
            self.reloadData()
            self.refreshControl?.endRefreshing()
        }
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
        cell.imageView?.image = CacheManager.getImage(friends[indexPath.row].photo_50)
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
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            let vc = segue.destination as! PhotosCollectionViewController
            if let index = tableView.indexPathForSelectedRow {
                vc.userId = friends[index.row].id // 248708684
            }
        }
    }

}

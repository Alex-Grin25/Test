//
//  FriendsTableViewController.swift
//  SNApp
//
//  Created by ALEKSANDR GRIGOREV on 25.02.2021.
//

import UIKit

struct FriendsResponse: Codable {
    struct Response: Codable {
        let items: [Friend]
    }
    
    let response: Response
}

struct Friend: Codable {
    let id: Int
    let first_name: String
    let last_name: String
    let city: City?
    
    struct City:Codable {
        let title: String
        
    }
}




class FriendsTableViewController: UITableViewController {
    var friends:[Friend]=[]
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    
        self.refreshControl?.beginRefreshing()
        self.refreshFriends(self)
    }

    @IBAction func refreshFriends(_ sender: Any) {
        let url = URL(string: "https://api.vk.com/method/friends.get?v=5.130&fields=city&user_id=\(Session.instance.userId)&access_token=\(Session.instance.token)")
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            sleep(1)

            if let friendsResponse = try? JSONDecoder().decode(FriendsResponse.self, from: data!) {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.friends = friendsResponse.response.items
                    self.tableView.reloadData()
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
        
        cell.textLabel?.text = "\(friends[indexPath.row].first_name) \(friends[indexPath.row].last_name)"
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
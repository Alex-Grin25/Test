//
//  GroupsTableViewController.swift
//  SNApp
//
//  Created by ALEKSANDR GRIGOREV on 24.02.2021.
//

import UIKit

struct GroupsResponse: Codable {
    struct Response: Codable {
        let items: [Group]
    }
    
    let response: Response
}

struct Group: Codable {
    let id: Int
    let name: String
}

class GroupsTableViewController: UITableViewController {
    
    var groups:[Group] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.refreshControl?.beginRefreshing()
        self.refresh(self)
    }
    
    @IBAction func refresh(_ sender: Any) {
        let url = URL(string: "https://api.vk.com/method/groups.get?v=5.130&extended=1&user_id=\(Session.instance.userId)&access_token=\(Session.instance.token)")
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            sleep(1)

            if let groupsResponse = try? JSONDecoder().decode(GroupsResponse.self, from: data!) {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.groups = groupsResponse.response.items
                    self.tableView.reloadData()
                    self.refreshControl?.endRefreshing()
                }
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
        return groups.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupNameCell", for: indexPath)

        cell.textLabel?.text = groups[indexPath.row].name

        return cell
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

//
//  GroupsTableViewController.swift
//  SNApp
//
//  Created by ALEKSANDR GRIGOREV on 24.02.2021.
//

import UIKit
import RealmSwift

class GroupsTableViewController: UITableViewController, UISearchResultsUpdating {
    let searchController = UISearchController()
    var groups: [Group] = []
    var filteredGroups: [Group] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        searchController.searchResultsUpdater = self
        tableView.tableHeaderView = searchController.searchBar
        
        //self.refreshControl?.beginRefreshing()
        //self.refresh(self)
        self.reloadData()
    }
    
    func reloadData() {
        self.groups = []
        do {
            let realm = try Realm()
            self.groups = Array(realm.objects(Group.self))
        } catch {
            print(error)
        }
        self.tableView.reloadData()
    }
    
    @IBAction func refresh(_ sender: Any) {
        NetworkService.instance.loadGroups { [weak self] in
            guard let self = self else { return }
            //self.groups = groupsResponse.response.items
            self.reloadData()
            self.refreshControl?.endRefreshing()
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, searchText.count >= 3 {
            filteredGroups = groups.filter{group in
                return group.name.lowercased().contains(searchText.lowercased())
            }
        }
        tableView.reloadData()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return searchController.isActive ? filteredGroups.count : groups.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupNameCell", for: indexPath)

        cell.textLabel?.text = (searchController.isActive ? filteredGroups : groups)[indexPath.row].name

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

//
//  PostsTableViewController.swift
//  SNApp
//
//  Created by ALEKSANDR GRIGOREV on 09.03.2021.
//

import UIKit
import RealmSwift
import SwiftyJSON

class PostsTableViewController: UITableViewController {
    var allLoaded = false
        
    let postLoadCount = 10
    var posts: [Post] = []

    func reloadData() {
        self.posts = []
        do {
            //try FileManager.default.removeItem(at: Realm.Configuration.defaultConfiguration.fileURL!)
            let realm = try Realm()
            self.posts = Array(realm.objects(Post.self))
        }
        catch {
            print(error)
        }
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.reloadData()
    }

    func loadPosts(count: Int, offset: Int, recreate: Bool) {
        let url = URL(string: "https://api.vk.com/method/newsfeed.get?v=5.130&filters=post&count=\(count)&start_from=\(offset)&access_token=\(Session.instance.token)")
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            sleep(1)
            
            if let json = try? JSON(data: data!) {
                let groupsJSON = json["response"]["groups"].arrayValue
                var groups: [Group] = []
                for groupJSON in groupsJSON {
                    groups.append(Group(json: groupJSON))
                }
                
                let allLoaded = json["response"]["next_from"].string == nil
                
                let posts = json["response"]["items"].arrayValue
                do {
                    let realm = try Realm()
                    realm.beginWrite()
                    if (recreate) {
                        realm.delete(realm.objects(Post.self))
                    }
                    for postData in posts {
                        let post = Post(json: postData, groups: groups)
                        realm.add(post)
                    }
                    try realm.commitWrite()
                }
                catch {
                    print(error)
                }
                
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.allLoaded = allLoaded
                    self.reloadData()
                    self.refreshControl?.endRefreshing()
                }
            }
            else {
                print("Cannot parse friends response")
            }
        }
        task.resume()
    }
    
    @IBAction func reload(_ sender: Any) {
        loadPosts(count: postLoadCount, offset: 0, recreate: true)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return posts.count + (self.allLoaded ? 1 : 0)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (!allLoaded && indexPath.row == self.tableView(tableView, numberOfRowsInSection: indexPath.section) - 1) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "loading")!
            cell.textLabel?.text = "Loading..."
            loadPosts(count: postLoadCount, offset: self.posts.count, recreate: false)
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "post", for: indexPath) as! PostTableViewCell
            cell.configure(post: self.posts[indexPath.row])
            return cell
        }
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
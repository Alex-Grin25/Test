//
//  PhotosCollectionViewController.swift
//  SNApp
//
//  Created by ALEKSANDR GRIGOREV on 02.03.2021.
//

import UIKit

private let reuseIdentifier = "PhotoCell"

struct PhotosResponse: Codable {
    struct Error: Codable {
        let error_code: Int
        let error_msg: String
    }
    struct Response: Codable {
        let items: [Photo]
    }
    
    let response: Response?
    let error: Error?
}

struct Photo: Codable {
    struct Size: Codable {
        let height: Int
        let width: Int
        let url: String
        let type: String
    }
    
    let id: Int
    let sizes: [Size]
}

class PhotosCollectionViewController: UICollectionViewController {

    var userId: Int?
    var photos:[Photo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        if let userId = userId {
            let url = URL(string: "https://api.vk.com/method/photos.getAll?v=5.130&skip_hidden=1&&owner_id=\(userId)&access_token=\(Session.instance.token)")
            let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
                sleep(1)

                if let photosResponse = try? JSONDecoder().decode(PhotosResponse.self, from: data!) {
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        self.photos = photosResponse.response?.items ?? []
                        self.collectionView.reloadData()
                        //self.refreshControl?.endRefreshing()
                    }
                }
                else {
                    print("Cannot parse friends response")
                }
            }
            task.resume()
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        if let cell2 = cell as? PhotoCollectionViewCell {
            // Configure the cell
            cell2.configure()
            if let urlString = photos[indexPath.row].sizes.last?.url,
               let url = URL(string: urlString),
               let data = try? Data(contentsOf: url) {
                cell2.imageView?.image = UIImage(data: data)
            }
            else {
                cell2.imageView?.image = nil
            }
        }
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}

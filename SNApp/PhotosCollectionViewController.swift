//
//  PhotosCollectionViewController.swift
//  SNApp
//
//  Created by ALEKSANDR GRIGOREV on 02.03.2021.
//

import UIKit
import RealmSwift

private let reuseIdentifier = "PhotoCell"

class PhotosCollectionViewController: UICollectionViewController {

    var userId: Int = 0
    var photos: [Photo] = []
    
    func reloadData() {
        /*
        self.photos = []
        do {
            let realm = try Realm()
            self.photos = Array(realm.objects(Photo.self).filter("userId == %@", userId))
        }
        catch {
            print(error)
        }
         */
        self.collectionView.reloadData()
    }
    
    func loadFromServer() {
        NetworkService.instance.loadPhotos(userId: userId) { [weak self] (photos) in
            guard let self = self else { return }
            self.photos = photos ?? []
            self.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        self.reloadData()
        if self.photos.count == 0 {
            self.loadFromServer()
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
            
            if let urlString = photos[indexPath.row].sizes.last?.url {
                cell2.loadImage(urlString: urlString)
            }
            /*
            if let urlString = photos[indexPath.row].sizes.last?.url,
               let url = URL(string: urlString),
               let data = try? Data(contentsOf: url) {
                cell2.imageView?.image = UIImage(data: data)
            }
            else {
                cell2.imageView?.image = nil
            }
            */
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

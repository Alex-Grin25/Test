//
//  NetworkService.swift
//  SNApp
//
//  Created by ALEKSANDR GRIGOREV on 16.03.2021.
//

import Foundation
import RealmSwift
import SwiftyJSON

class NetworkService {
    
    private struct FriendsResponse: Codable {
        struct Response: Codable {
            let items: [Friend]
        }
        
        let response: Response
    }

    private struct PhotosResponse: Codable {
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

    private struct GroupsResponse: Codable {
        struct Response: Codable {
            let items: [Group]
        }
        
        let response: Response
    }
    
    var queue: DispatchQueue = DispatchQueue.init(label: "VK Images")
    static let instance = NetworkService()
    
    private init() {}
    
    public func loadPhotoAsync(urlString: String, completionHandler: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else { return }
        
        DispatchQueue.global(qos: .utility).async {
            self.queue.sync {
                var image: UIImage?
                sleep(3)
                if let data = try? Data(contentsOf: url) {
                    image = UIImage(data: data)
                }
                DispatchQueue.main.async {
                    completionHandler(image)
                }
            }
        }
    }
    
    private func runRequest(urlString: String, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        
        let url = URL(string: "\(urlString)&access_token=\(Session.instance.token)")
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            sleep(1)
            completionHandler(data, response, error)
        }
        task.resume()
    }
    
    func loadPosts(count: Int, offset: Int, recreate: Bool, completionHandler: @escaping (Bool) -> Void) {
        let urlString = "https://api.vk.com/method/newsfeed.get?v=5.130&filters=post&count=\(count)&start_from=\(offset)"
        runRequest(urlString: urlString) { (data, response, error) in
            
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
                
                DispatchQueue.main.async {
                    completionHandler(allLoaded)
                }
            }
            else {
                print("Cannot parse friends response")
            }
        }
    }
    
    func loadPhotos(userId: Int, completionHandler: @escaping ([Photo]?) -> Void) {
        let urlString = "https://api.vk.com/method/photos.getAll?v=5.130&skip_hidden=1&&owner_id=\(userId)"
        runRequest(urlString: urlString) { (data, response, error) in
            //if let json = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) {
            if let photosResponse = try? JSONDecoder().decode(PhotosResponse.self, from: data!) {
                //  let photosResponse = try! JSONDecoder().decode(PhotosResponse.self, from: data!)
                DispatchQueue.main.async {
                    completionHandler(photosResponse.response?.items)
                }
            }
            else {
                print("Cannot parse friends response")
            }
        }
    }
    
    func loadGroups(completionHandler: @escaping () -> Void) {
        let urlString = "https://api.vk.com/method/groups.get?v=5.130&extended=1&user_id=\(Session.instance.userId)"
        runRequest(urlString: urlString) { (data, response, error) in
            
            if let groupsResponse = try? JSONDecoder().decode(GroupsResponse.self, from: data!) {
                DispatchQueue.main.async {
                    do {
                        let realm = try Realm()
                        realm.beginWrite()
                        realm.delete(realm.objects(Group.self))
                        for group in groupsResponse.response.items {
                            realm.add(group)
                        }
                        try realm.commitWrite()
                    } catch {
                        print(error)
                    }
                    completionHandler()
                }
            }
        }
    }
    
    func loadFriends(completionHandler: @escaping () -> Void) {
        let urlString = "https://api.vk.com/method/friends.get?v=5.130&fields=city,photo_50&user_id=\(Session.instance.userId)"
        runRequest(urlString: urlString) { (data, response, error) in
            
            if let friendsResponse = try? JSONDecoder().decode(FriendsResponse.self, from: data!) {
                DispatchQueue.main.async {
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
                    completionHandler()
                }
            }
            else {
                print("Cannot parse friends response")
            }
        }
    }
}

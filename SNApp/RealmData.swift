//
//  RealmData.swift
//  SNApp
//
//  Created by ALEKSANDR GRIGOREV on 04.03.2021.
//

import Foundation
import RealmSwift
import SwiftyJSON

class Friend: Object, Codable {
    @objc dynamic var id: Int = 0
    @objc dynamic var first_name: String = ""
    @objc dynamic var last_name: String = ""
    @objc dynamic var city: City?
    @objc dynamic var photo_50: String = ""
}

class City: Object, Codable {
    @objc dynamic var title: String = ""
}

struct Photo: Codable {
    let id: Int
    //let userId: Int
    let sizes: [PhotoSize]
}

struct PhotoSize: Codable {
    let height: Int
    let width: Int
    let url: String
    let type: String
}
/*
class PhotoSize: Object, Codable {
    @objc dynamic var height: Int = 0
    @objc dynamic var width: Int = 0
    @objc dynamic var url: String = ""
    @objc dynamic var type: String = ""
}
*/
class PhotoData: Object, Codable {
    @objc dynamic var url: String = ""
    @objc dynamic var data: Data?
}


class Group: Object, Codable {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var photo_100: String = ""
    
    convenience init(json: JSON) {
        self.init()
        
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
        self.photo_100 = json["photo_100"].stringValue
    }
}

class Post: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var author: String = ""
    @objc dynamic var avatar: String = ""
    @objc dynamic var text: String = ""
    @objc dynamic var likes: Int = 0
    @objc dynamic var comments: Int = 0
    
    convenience init(json: JSON, groups: [Group]) {
        self.init()
        
        self.author = "Test author"
        let sourceId = json["source_id"].intValue
        if (sourceId < 0) {
            for group in groups {
                if group.id == -sourceId {
                    self.author = group.name
                    self.avatar = group.photo_100
                    break
                }
            }
        }
        
        self.id = json["post_id"].intValue
        self.text = json["text"].stringValue
        self.likes = json["likes"]["count"].intValue
        self.comments = json["comments"]["count"].intValue
    }
}

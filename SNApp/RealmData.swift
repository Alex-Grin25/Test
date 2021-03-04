//
//  RealmData.swift
//  SNApp
//
//  Created by ALEKSANDR GRIGOREV on 04.03.2021.
//

import Foundation
import RealmSwift

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
}

//
//  APIModel.swift
//  SNApp
//
//  Created by ALEKSANDR GRIGOREV on 04.03.2021.
//

import Foundation

struct FriendsResponse: Codable {
    struct Response: Codable {
        let items: [Friend]
    }
    
    let response: Response
}

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

struct GroupsResponse: Codable {
    struct Response: Codable {
        let items: [Group]
    }
    
    let response: Response
}

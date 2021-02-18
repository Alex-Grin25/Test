//
//  Settings.swift
//  SNApp
//
//  Created by ALEKSANDR GRIGOREV on 18.02.2021.
//

import Foundation

struct Auth {
    var login: String
    var password: String
}

let authData:[Auth] = [
    Auth(login: "admin", password: "admin"),
    Auth(login:"user", password: "pass")
]

/*
let authData = [
    ["admin", "admin"],
    ["user", "pass"]
]
 */

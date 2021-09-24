//
//  Model.swift
//  instaProfile
//
//  Created by mac on 19.08.2021.
//

import Foundation

struct User {
    let id = UUID().uuidString
    var name: String = ""
    var avatar: String = "defaultAvatar"
    var subscribes: Int
    var followers: Int
    var publications: [Post] = []
}

struct Post {
    let id = UUID().uuidString
    var image: String
    var caption: String?
    var isExpanded: Bool = false
    var likes: Int = 0
    var comments: [String]?
    let date: Date = Date()
}


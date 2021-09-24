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
    var image: String
    var caption: String?
    var likes: Int = 0
    var comments: [String]?
    let date: Date = Date()
}

//struct InfoToSend {
//    var userName: String
//    var userAvatar: String
//    var indexPath: IndexPath
//    var posts: [Post]
//}

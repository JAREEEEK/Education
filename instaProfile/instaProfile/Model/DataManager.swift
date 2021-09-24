//
//  DataManager.swift
//  instaProfile
//
//  Created by mac on 20.08.2021.
//
import Foundation

protocol DataManagerProtocol {    
    func getUsersArray() -> [User]?
    
    func getUser(index: Int, completion: ((User) -> Void)?)
    
    func getUser(userId: String, completion: ((User) -> Void)?)
    
    func getUserPublication(userId: String, completion: (([Post]) -> Void)?)
    
    func append(user: User)
    
    func delete(userId: String) -> User?
    
    func findIndex(userId: String) -> Int?
}

class DataManager : DataManagerProtocol {

    private var users: [User] = []
    static var shared = DataManager(getData())
    //private static var obj: DataManager?
    
    private init() {}
    private init(_ users: [User]) {
        self.users = users
    }

    public func syncSave(userId: String, post: Post, _ queue: DispatchQueue = DispatchQueue.global()) {
        queue.sync {
            if let index = findIndex(userId: userId) {
                users[index].publications.append(post)
            }
        }
    }
    
    public func asyncSave(userId: String, post: Post) {
       
    }
    
    public func getUsersArray() -> [User]? {
        return users
    }
    
    public func getUser(index: Int, completion: ((User) -> Void)?) {
        if index < users.count {
            completion?(users[index])
        }
    }
    
    public func getUser(userId: String, completion: ((User) -> Void)?) {
        users.forEach( {
            if $0.id == userId {
                completion?($0)
            }
        } )
    }
    
    public func getUserPublication(userId: String, completion: (([Post]) -> Void)?)  {
        getUser(userId: userId) { user in
            completion?(user.publications)
        }
    }
    
    public func append(user: User) {
        users.append(user)
    }
    
    public func delete(userId: String) -> User? {
        if let index = findIndex(userId: userId) {
            return users.remove(at: index)
        }
        return nil
    }
    
    public func findIndex(userId: String) -> Int? {
        for index in 0 ... users.count {
            if users[index].id == userId {
                return index
            }
        }
        return nil
    }
    
    private static func getData() -> [User] {
        return [User(
                    name: "Phoebe",
                    avatar: "bay",
                    subscribes: Int.random(in: 100..<250),
                    followers: Int.random(in: 600..<800),
                    publications: [
                        Post(
                            image: "tram",
                             caption: "Its a tram",
                             likes: Int.random(in: 2...10),
                             comments: ["Amazing!", "Beautifull!!!!", "Ddjjwda jn ndjn wj nnwj ad hdhw vdj wh vdv dada wadadad!!!"]),
                        Post(
                            image: "bay",
                            caption: "BAYYYY",
                            likes: Int.random(in: 7...15),
                            comments: ["WOW!!!", "O-O"]),
                        Post(
                            image: "boat",
                            caption: "My boat",
                            likes: Int.random(in: 9...18),
                            comments: ["Swiming time?"]),
                        Post(
                            image: "bay",
                            caption: "BAYYYY",
                            likes: Int.random(in: 7...15),
                            comments: ["WOW!!!", "O-O"]),
                        Post(
                            image: "littlePrince",
                            caption: nil,
                            likes: Int.random(in: 10...20),
                            comments: nil),
                        Post(
                            image: "chapel",
                            caption: "My trip",
                            likes: Int.random(in: 7...15),
                            comments: ["JESUS!!!"]),
                        Post(
                            image: "bay",
                            caption: "BAYYYY",
                            likes: Int.random(in: 7...15),
                            comments: ["WOW!!!", "O-O"]),
                        Post(
                            image: "littlePrince",
                            caption: nil,
                            likes: Int.random(in: 10...20),
                            comments: nil),
                        Post(
                            image: "boat",
                            caption: "My boat",
                            likes: Int.random(in: 9...18),
                            comments: ["Swiming time?"]),
                        Post(
                            image: "chapel",
                            caption: "My trip",
                            likes: Int.random(in: 7...15),
                            comments: ["JESUS!!!"])
                    ]),
                
                User(
                    name: "Joan",
                    avatar: "littlePrince",
                    subscribes: Int.random(in: 1..<100),
                    followers: Int.random(in: 1..<50),
                    publications: [
                        Post(
                            image: "chapel",
                            caption: "My trip",
                            likes: Int.random(in: 7...15),
                            comments: ["JESUS!!!"]),
                        Post(
                            image: "bay",
                            caption: "BAYYYY",
                            likes: Int.random(in: 7...15),
                            comments: ["WOW!!!", "O-O"]),
                        Post(
                            image: "littlePrince",
                            caption: nil,
                            likes: Int.random(in: 10...20),
                            comments: nil),
                        Post(
                            image: "tram",
                             caption: "Its a tram",
                             likes: Int.random(in: 2...10),
                             comments: ["Amazing!", "Beautifull!!!!", "Ddjjwda jn ndjn wj nnwj ad hdhw vdj wh vdv dada wadadad!!!"]),
                        Post(
                            image: "boat",
                            caption: "My boat",
                            likes: Int.random(in: 9...18),
                            comments: ["Swiming time?"])
                    ]),
                User(
                    name: "Miley",
                    avatar: "boat",
                    subscribes: Int.random(in: 150..<200),
                    followers: Int.random(in: 150..<200),
                    publications: [
                        Post(
                            image: "littlePrince",
                            caption: nil,
                            likes: Int.random(in: 10...20),
                            comments: nil),
                        Post(
                            image: "chapel",
                            caption: "My trip",
                            likes: Int.random(in: 7...15),
                            comments: ["JESUS!!!"]),
                        Post(
                            image: "bay",
                            caption: "BAYYYY",
                            likes: Int.random(in: 7...15),
                            comments: ["WOW!!!", "O-O"]),
                        Post(
                            image: "tram",
                             caption: "Its a tram",
                             likes: Int.random(in: 2...10),
                             comments: ["Amazing!", "Beautifull!!!!", "Ddjjwda jn ndjn wj nnwj ad hdhw vdj wh vdv dada wadadad!!!"])
                    ])]
    }
}



//
//  DataManager.swift
//  instaProfile
//
//  Created by mac on 20.08.2021.
//
import Foundation

protocol DataManagerProtocol {
    func syncSave(userId: String, post: Post)
    func asyncSave(userId: String, post: Post, completion: (([Post]) -> Void))
    
    func getUserPostSync(userId: String, index: Int, completion: @escaping ((Post) -> Void))
    func getUserPostAsync(userId: String, index: Int, completion: @escaping ((Post) -> Void))
    
    func deletePostSync(userId: String, postId: String)
    func deletePostAsync(userId: String, postId: String, completion: @escaping (Post) -> Void)
    
    func findPostsContainingStringSync(caption: String, userId: String, completion: @escaping ([Post]) -> Void)
    func findPostsContainingStringAsync(caption: String, userId: String, completion: ([Post]) -> Void)

    func getUsers() -> [User]?
    
    func getUserSync(index: Int, completion: @escaping ((User) -> Void))
    func getUserAsync(index: Int, completion: ((User) -> Void))
    
    func getUserSync(userId: String, completion: ((User) -> Void)?)
    func getUserAsync(userId: String, completion: ((User) -> Void)?)

    func getUserPosts(userId: String) -> [Post]?
    
    func append(user: User)
    
    func delete(userId: String) -> User?
    
    func findIndex(userId: String) -> Int?
}

class DataManager : DataManagerProtocol {

    private var users: [User] = []
    static var shared = DataManager(getData())
    
    private init() {}
    private init(_ users: [User]) {
        self.users = users
    }

    public func syncSave(userId: String, post: Post) {
        DispatchQueue.global().sync {
            if let index = findIndex(userId: userId) {
                users[index].publications.append(post)
            }
        }
    }
    
    public func asyncSave(userId: String, post: Post, completion: (([Post]) -> Void)) {
       let operationQ = OperationQueue()
        operationQ.qualityOfService = .userInitiated
        
        var publications: [Post]?
        let operationBlock = BlockOperation { [weak self] in
            if let index = self?.findIndex(userId: userId) {
                self?.users[index].publications.append(post)
                publications = self?.users[index].publications
            }
        }
        operationQ.addOperations([operationBlock], waitUntilFinished: true)
        
        if let publications = publications {
            completion(publications)
        }
    }
    
    func getUserPosts(userId: String) -> [Post]? {
        if let index = findIndex(userId: userId) {
            return users[index].publications
        }
        return nil
    }
    
    
    public func getUserSync(index: Int, completion: @escaping ((User) -> Void)) {
        DispatchQueue.global().sync { [weak self] in
            guard let self = self else { return }

            if index < self.users.count {
                DispatchQueue.main.async {
                    completion(self.users[index])
                }
            }
        }
    }

    public func getUserAsync(index: Int, completion: ((User) -> Void)) {
        let operationQ = OperationQueue()
        operationQ.qualityOfService = .userInitiated

        if index < self.users.count {
            completion(self.users[index])
        }

    }
    

    
    
    public func getUserPostSync(userId: String, index: Int, completion: @escaping ((Post) -> Void))  {
        DispatchQueue.global().sync {

            getUserSync(userId: userId) { user in
                if index < user.publications.count - 1 {
                    DispatchQueue.main.async {
                        completion(user.publications[index])
                    }
                }
            }
            
        }
    }
    
    public func getUserPostAsync(userId: String, index: Int, completion: @escaping ((Post) -> Void))  {
        let operationQ = OperationQueue()
        operationQ.qualityOfService = .userInitiated
        
        operationQ.addOperation { [weak self] in
            self?.getUserAsync(userId: userId) { user in
                if index < user.publications.count - 1 {
                    completion(user.publications[index])
                }
            }
        }
        
    }
    
    public func deletePostSync(userId: String, postId: String) {
        DispatchQueue.global().sync {
            getUserSync(userId: userId) { [weak self] user in
                guard let self = self else { return }
                
                let index = self.findIndex(userId: userId)
                
                if let index = index {
                    self.users[index].publications.enumerated().forEach() {
                        if $0.element.id == postId {
                            self.users[index].publications.remove(at: $0.offset)
                        }
                    }
                }
                
            }
        }
    }
    
    public func deletePostAsync(userId: String, postId: String, completion: @escaping (Post) -> Void) {
        let operationQ = OperationQueue()
        operationQ.qualityOfService = .userInitiated
        var post: Post?
        
        let operationBlock = BlockOperation() { [weak self] in
            guard let self = self else { return }
            
            let index = self.findIndex(userId: userId)
            
            if let index = index {
                self.users[index].publications.enumerated().forEach() {
                    if $0.element.id == postId {
                        post = self.users[index].publications.remove(at: $0.offset)
                    }
                }
            }
        }
        
        operationQ.addOperations([operationBlock], waitUntilFinished: true)
        
        if let post = post {
            completion(post)
        }
    }
    
    public func findPostsContainingStringSync(caption: String, userId: String, completion: @escaping ([Post]) -> Void) {
        DispatchQueue.global().sync {
            var postsArray: [Post] = []
            
            getUserSync(userId: userId) { user in
                user.publications.forEach {
                    if let postCaption = $0.caption {
                        if postCaption.contains(caption) {
                            postsArray.append($0)
                        }
                    }
                }
            }
            
            DispatchQueue.main.async {
                completion(postsArray)
            }
        }
    }
    
    public func findPostsContainingStringAsync(caption: String, userId: String, completion: ([Post]) -> Void) {
        let operationQ = OperationQueue()
        operationQ.qualityOfService = .userInitiated
        
        var postsArray: [Post] = []
        
        let operationBlock = BlockOperation { [weak self] in
            self?.getUserAsync(userId: userId) { user in
                user.publications.forEach {
                    if let postCaption = $0.caption {
                        if postCaption.contains(caption) {
                            postsArray.append($0)
                        }
                    }
                }
            }
        }
        
        operationQ.addOperations([operationBlock], waitUntilFinished: true)
        
        completion(postsArray)
    }
    
    public func getUsers() -> [User]? {
            return users
    }
    
//    public func getUser(userId: String, completion: ((User) -> Void)?) {
//        users.forEach( {
//            if $0.id == userId {
//                completion?($0)
//            }
//        } )
//    }
    
    public func getUserSync(userId: String, completion: ((User) -> Void)?) {
        DispatchQueue.global().sync {
            users.forEach( { user in
                
                if user.id == userId {
                    DispatchQueue.main.async {
                        completion?(user)
                    }
                }
                
            } )
        }
    }
    
    public func getUserAsync(userId: String, completion: ((User) -> Void)?) {
        let operationQ = OperationQueue()
        operationQ.qualityOfService = .userInitiated
        
        operationQ.addOperation { [weak self] in
            self?.users.forEach( { user in
                
                if user.id == userId {
                    DispatchQueue.main.async {
                        completion?(user)
                    }
                }
                
            } )
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



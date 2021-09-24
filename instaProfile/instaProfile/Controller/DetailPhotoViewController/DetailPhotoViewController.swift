//
//  DetailPhotoViewController.swift
//  instaProfile
//
//  Created by mac on 27.08.2021.
//

import UIKit

class DetailPhotoViewController: UIViewController {
    
   // @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    //var getCellData: ((_ userName: String, _ userAvatar: UIImage, _ indexPath: IndexPath, _ post: [Post]) -> ())?
    private var name: String?
    private var avatar: String?
    private var indexPath: IndexPath?
    private var posts: [Post]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.registerCustomCell(cell: DetailPhotoTableViewCell.self)
        
        if let index = indexPath {
            tableView.scrollToRow(at: index, at: .top, animated: false)
        }
    }

    func setFields(userName: String, userId: String, userAvatar: String, indexPath: IndexPath) {
        name = userName
        avatar = userAvatar
        self.indexPath = indexPath
        DataManager.shared.getUserPublication(userId: userId) { [weak self] posts in
            self?.posts = posts
        }
    }
    
    /// sets the image to the UIImageView outlet
    /// - Parameter image: image that will be assigned to the UIImageView outlet
//    func config(image: UIImage?) {
//        self.image = image
//    }

}

extension DetailPhotoViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: DetailPhotoTableViewCell.idCell()) as? DetailPhotoTableViewCell {
            
            if let name = name, let avatar = avatar, let posts = posts {
                cell.config(name: name, avatar: avatar, post: posts[indexPath.row])
            }
            return cell
            
        } else {
            return UITableViewCell()
        }
    }
}

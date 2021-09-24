//
//  DetailPhotoTableViewCell.swift
//  instaProfile
//
//  Created by mac on 12.09.2021.
//

import UIKit

class DetailPhotoTableViewCell: UITableViewCell, CustomCell {
    
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var imagePost: UIImageView!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var caption: UILabel!
    
    @IBAction func isPressedEditButton(_ sender: Any) {
    }
    @IBAction func isPressedCommentButton(_ sender: Any) {
    }
    
    private var comments: [String]?
    let identifier = "commentCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: identifier)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func config(name: String, avatar: String, post: Post) {
        tableView.delegate = self
        tableView.dataSource = self
        
        comments = post.comments
        
        userAvatar.image = UIImage(named: avatar)
        userAvatar.layer.cornerRadius = userAvatar.frame.width / 2
        userAvatar.clipsToBounds = true
        
        userName.text = name
        imagePost.image = UIImage(named: post.image)
        caption.text = post.caption
        
        if let comments = post.comments {
            if comments.count < 2 {
                commentButton.isHidden = true
            }
            //tableView.register(UITableViewCell.self, forCellReuseIdentifier: identifier)
        } else {
           tableView.isHidden = true
        }
    }
    
}

extension DetailPhotoTableViewCell : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let commentsCount = comments?.count {
            if commentsCount > 2 {
                return 2
            } else {
                return commentsCount
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: identifier) {
            cell.textLabel?.text = "RandomUser" + String(Int.random(in: 0...100))
            cell.detailTextLabel?.text = comments?[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
    
    
}

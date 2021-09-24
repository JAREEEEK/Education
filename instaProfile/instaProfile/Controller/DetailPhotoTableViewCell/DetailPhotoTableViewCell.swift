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
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var caption: UILabel!
    
    var didChangeHeightCell: (() -> ())?
    var showAlert: (() -> ())?
    
    @IBAction func isPressedEditButton(_ sender: Any) {
        showAlert?()
    }
//    @IBAction func isPressedCommentButton(_ sender: Any) {
//    }
    
    @objc func showComments(_ sender: UIButton) {
        didChangeHeightCell?()
        stackView.layoutIfNeeded()
    }
    
    private var comments: [String]?
    let identifier = "commentCell"
    var onTableViewUpdate: (() -> ())?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        userAvatar.image = nil
        userName.text = nil
        imagePost.image = nil
        stackView.arrangedSubviews.forEach {
            stackView.removeArrangedSubview($0)
        }
        caption.text = nil
    }
    
    func config(userId: String, name: String, avatar: String, post: Post) {
        comments = post.comments
    
        userAvatar.image = UIImage(named: avatar)
        userAvatar.layer.cornerRadius = userAvatar.frame.width / 2
        userAvatar.clipsToBounds = true
        
        userName.text = name
        imagePost.image = UIImage(named: post.image)
        caption.text = post.caption
        

        
        if let comments = post.comments {
            let visibleComments = comments.count < 2 || post.isExpanded == true ? comments.count : 2
            
            for i in 0 ..< visibleComments {
                let view: CommentView = CommentView.fromNib()
                view.configure(title: "RandomUser" + String(Int.random(in: 0...100)), subtitle: comments[i])
                stackView.addArrangedSubview(view)
            }
            if comments.count > 2, !post.isExpanded {
                let button = UIButton(type: .system)
                button.setTitle("Показать все комментарии", for: .normal)
                button.addTarget(self, action: #selector(showComments(_:)), for: .touchUpInside)
                stackView.addArrangedSubview(button)
            }
        }
    }
    
}


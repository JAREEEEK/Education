//
//  CommentView.swift
//  instaProfile
//
//  Created by Yaroslav Nosyk on 14.09.2021.
//

import UIKit

class CommentView: UIView {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    
    func configure(title: String, subtitle: String) {
        self.title.text = title
        self.subtitle.text = subtitle
    }
}

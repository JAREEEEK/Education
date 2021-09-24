//
//  UserProfileViewController.swift
//  instaProfile
//
//  Created by mac on 01.08.2021.
//

import UIKit

class UserProfileViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var publicationsCountLabel: UILabel!
    @IBOutlet weak var subscribersCountLabel: UILabel!
    @IBOutlet weak var subscriptionsCountLabel: UILabel!
    @IBOutlet weak var userLogin: UILabel!
    
    struct CellsDefault {
       static let countCells = 3
       static let offset: CGFloat = 2.0
    }
    
    var user: User?
    var getCellData: ((_ indexPath: Int) -> UIImage)?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setVariables()
        setFields()

        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.registerCustomCell(cell: CollectionViewCell.self)
    }
    
    
    /// sets the value to the class variables
    
    private func setVariables() {
        DataManager.shared.getUser(index: 0) { [weak self] user in
            guard let self = self else { return }
            
            self.user = user
            
            self.getCellData = { index in
                var uiImageArray: [UIImage] = []
                    
                user.publications.forEach({ post in
                    if let image = UIImage(named: post.image) {
                            uiImageArray.append(image)
                        }
                    })
                
                if uiImageArray.count > 0 {
                    return uiImageArray[index]
                }
                return UIImage()
            }
        }
    }
    
    /// sets the value to the outlets
    
    private func setFields() {
        if let user = user {
            userImage.image = UIImage(named: user.avatar)
            userImage.layer.cornerRadius = userImage.frame.width / 2
            userImage.clipsToBounds = true
            publicationsCountLabel.text = String(user.publications.count)
            subscribersCountLabel.text = String(user.followers)
            subscriptionsCountLabel.text = String(user.subscribes)
            userLogin.text = user.name
        }
    }
    
}

extension UserProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return user?.publications.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.idCell(), for: indexPath) as? CollectionViewCell {
        
            if let image = getCellData?(indexPath.row) {
                cell.config(image: image)
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    //MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let frameCollectionView = collectionView.frame
        let widthCell = frameCollectionView.width / CGFloat(CellsDefault.countCells)
        let spacing = CGFloat(CellsDefault.countCells + 1) * CellsDefault.offset / CGFloat(CellsDefault.countCells)
        
        return CGSize(width: widthCell - spacing, height: widthCell - (CellsDefault.offset * 2))
    }
    
    //MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let user = user {
            let detailPhotoController = DetailPhotoViewController.loadFromNib()
            
            detailPhotoController.setFields(userName: user.name, userId: user.id, userAvatar: user.avatar, indexPath: indexPath)
            navigationController?.pushViewController(detailPhotoController, animated: true)
        }
    }
}

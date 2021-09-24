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
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var searchButtonOutlet: UIButton!
    
    private var userId: String?
    private var name: String?
    private var avatar: String?
    private var indexPath: IndexPath?
    private var posts: [Post]?
    private var searchingPosts: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 660
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.registerCustomCell(cell: DetailPhotoTableViewCell.self)
        
        searchField.delegate = self
        
        initConfigs()
    }
    
    @IBAction func isPressedSearchButton(_ sender: Any) {
        searchField.isHidden.toggle()
        
        if searchField.isHidden == false {
            searchButtonOutlet.setTitle("Закрыть", for: .normal)
            searchButtonOutlet.setTitleColor(UIColor.red, for: .normal)
        } else {
            searchButtonOutlet.setTitle("Поиск", for: .normal)
            searchButtonOutlet.setTitleColor(UIColor.blue, for: .normal)
        }
    }
    
    func setFields(userName: String, userId: String, userAvatar: String, indexPath: IndexPath) {
        self.userId = userId
        name = userName
        avatar = userAvatar
        self.indexPath = indexPath
    }
    
    private func initConfigs() {
        self.view.bringSubviewToFront(searchField)
        searchField.isHidden = true
        
        if let indexPath = indexPath, let userId = userId {
            self.posts = DataManager.shared.getUserPosts(userId: userId)
            tableView.scrollToRow(at: indexPath, at: .top, animated: false)
        }
    }
    
    private func tableUpdate() {
        if let userId = userId, let indexOld = indexPath {
            self.posts = DataManager.shared.getUserPosts(userId: userId)
            
            tableView.reloadData()
            let indexPath = indexOld.row > 0 ? IndexPath(row: indexOld.row - 1, section: indexOld.section) : IndexPath(row: indexOld.row, section: indexOld.section)
            tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
}

extension DetailPhotoViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchingPosts.isEmpty ? posts?.count ?? 0 : searchingPosts.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: DetailPhotoTableViewCell.idCell()) as? DetailPhotoTableViewCell {
            
            if let posts = searchingPosts.isEmpty == true ? self.posts : searchingPosts {
                if let name = name, let avatar = avatar, let userId = userId {
                    
                    cell.didChangeHeightCell = { [weak self] in
                        guard let self = self else { return }
                        
                        if self.searchingPosts.isEmpty == true {
                            self.posts?[indexPath.row].isExpanded = true
                        } else {
                            self.searchingPosts[indexPath.row].isExpanded = true
                        }
                        tableView.reloadRows(at: [indexPath], with: .automatic)
                    }
                    
                    cell.showAlert = {
                        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "Удалить", style: .destructive, handler: { action in
                            let confirmAlert = UIAlertController(title: "Подтверждение", message: "Вы действительно хотите удалить?", preferredStyle: .alert)
                            confirmAlert.addAction(UIAlertAction(title: "Удалить", style: .destructive, handler: { action in
                                
                                DataManager.shared.deletePostAsync(userId: userId, postId: posts[indexPath.row].id) { [weak self] post in
                                    guard let self = self else { return }
                                    
                                    self.tableUpdate()
                                    if let nav = self.navigationController {
                                        if let previousViewContoller = nav.viewControllers[nav.viewControllers.count - 2] as? UserProfileViewController {
                                            previousViewContoller.updateCollectionView?()
                                        }
                                    }
                                }
                            }))
                            
                            self.present(confirmAlert, animated: true, completion: nil)
                        }))
                        
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                    cell.config(userId: userId, name: name, avatar: avatar, post: posts[indexPath.row])
                }
            }
            return cell
            
        } else {
            return UITableViewCell()
        }
    }
}

extension DetailPhotoViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let text = textField.text, let userId = userId {
            DataManager.shared.findPostsContainingStringAsync(caption: text, userId: userId) { posts in
                searchingPosts.removeAll()
                searchingPosts.append(contentsOf: posts)
                tableView.reloadData()
            }
        }
    }
}


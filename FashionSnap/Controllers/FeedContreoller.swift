//
//  FeedContreoller.swift
//  FashionSnap
//
//  Created by Magdalena Samuel on 7/19/23.
//

import UIKit
import Firebase

private var reuseIdentifier = "Cell"

class FeedController: UICollectionViewController {
    
    //    var user = User?
    
    // MARK: - Properties
    private var posts = [Post]() {
        didSet {
            collectionView.reloadData()
        }
    }
    var post: Post? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
        fetchPosts()
        
        if post != nil {
            checkIfUserLikedPost()
        }
        
    }
    
    // MARK: - API
    
    func fetchPosts() {
        guard  post == nil else {return }
        //        PostService.fetchPosts { posts in
        //        }
        
        PostService.fetchFeedPostsForFollowed { posts in
            self.posts = posts
            self.collectionView.refreshControl?.endRefreshing()
            print("DEBUG: did fetched")
            self.checkIfUserLikedPost()
            //            self.collectionView.reloadData()
        }
        
    }
    
    func checkIfUserLikedPost() {
        if let post = post {
            PostService.checkIfLiked(post: post) { didLike in
                self.post?.didLike = didLike
            }
        } else {
            posts.forEach { post in
                PostService.checkIfLiked(post: post) { didLike in
                    if let index = self.posts.firstIndex(where: { $0.postId == post.postId }) {
                        self.posts[index].didLike = didLike }
                }
            }
        }
    }
    
    
    // MARK: - Actions
    
    @objc func handleRefresher() {
        posts.removeAll()
        fetchPosts()
    }
    
    @objc func handleLogout(){
        do {
            try Auth.auth().signOut()
            let controller = LoginController()
            controller.delegate = self.tabBarController as? MainTabController
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        } catch {
            print("DEBUG: Failed to sign out.")
        }
    }
    
    // MARK: - Helpers
    func configureUI() {
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
       navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout",style: .plain, target: self, action: #selector(handleLogout))
        

        navigationItem.title = "Feed"
        navigationController?.navigationBar.isTranslucent = true
        
        
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(handleRefresher), for: .valueChanged)
        collectionView.refreshControl = refresher
    }
}



// MARK: - UICollectionViewDataSource
extension FeedController {
    //how many cells to create
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return post == nil ? posts.count : 1
    }
    
    //how crate each cell
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FeedCell
        cell.delegate = self
        if let post = post  {
            cell.viewModel = PostViewModel(post: post)
        } else {
            cell.viewModel = PostViewModel(post: posts[indexPath.row])
        }
        return cell
    }
    
}

// MARK: - FeedController
extension FeedController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        var height = width + 8 + 40 + 8
        // 8 for spacing the uptop
        // 40 40 for the space, the size of the profile image.
        // eight for the spacing down below.
        height += 50 //for image view stuff
        height += 60 //for rest above
        return CGSize(width: width, height: height)
    }
}

// MARK: - FeedCellDelegate
extension FeedController: FeedCellDelegate {
    func cell(_ cell: FeedCell, wantsToShowUserProfile uid: String) {
        UserService.fetchUser(withUid: uid) { user in
            let controller = ProfileController(user: user)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func cell(_ cell: FeedCell, wantsToShowCommentsFor post: Post) {
        let controller = CommentController(post: post)
        navigationController?.pushViewController(controller, animated: true)
        
    }
    
    func cell(_ cell: FeedCell, didLike post: Post) {
        guard let tab = self.tabBarController as? MainTabController else { return }
        guard let user = tab.user else { return }
        
        cell.viewModel?.post.didLike.toggle()
        
        if post.didLike {
            PostService.unlikePost(post: post, completion: { _ in
                cell.likeButton.setImage(UIImage(named: "like_unselected"), for: .normal)
                cell.likeButton.tintColor = .black
                cell.viewModel?.post.likes = post.likes - 1
            })
        } else {
            PostService.likePost(post: post) { _ in
                cell.likeButton.setImage(UIImage(named: "like_selected"), for: .normal)
                cell.likeButton.tintColor = .red
                cell.viewModel?.post.likes = post.likes + 1
                
                NotificationService.uploadNotification(toUid: post.ownerUid, fromUser: user, type: .like, post: post)
            }
        }
        
    }
    
}

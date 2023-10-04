//
//  MainTabController.swift
//  FashionSnap
//
//  Created by Magdalena Samuel on 7/19/23.
//

import UIKit
import Firebase
import YPImagePicker

class MainTabController: UITabBarController {
    
    // MARK: - Properties
    
    //configure VC once user is fetched
    var user: User? {
        didSet {
            guard let user = user else { return }
            configureViewControllers(withUser: user)

        }
    }
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUser()
        //been rendered into App the time when view
        checkIfUserLogged()
        
//        logout()
        
    }
    // MARK: - Api
    
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return  }
        UserService.fetchUser(withUid: uid) { user in
            //done fetching we set user property
            self.user = user
        }
    }

    func checkIfUserLogged(){
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let controller = LoginController()
                controller.delegate = self
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
            
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("DEBUG: Failed to sign out.")
        }
    }
    // MARK: - Helper
    func configureViewControllers(withUser user: User) {
//        view.backgroundColor = .white
        self.delegate = self
        let layout = UICollectionViewFlowLayout()
        let feed = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "home_unselected"), selectedImage: #imageLiteral(resourceName: "home_selected"), rootViewController: FeedController(collectionViewLayout: layout))
        
        let search = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "search_unselected"), selectedImage: #imageLiteral(resourceName: "search_selected"), rootViewController: SearchController())
        
        let imagesSelector = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "plus_unselected"), selectedImage: #imageLiteral(resourceName: "plus_unselected"), rootViewController: ProfileController(user: user) )
        
        let profileController = ProfileController(user: user)
        let profile = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "profile_unselected"), selectedImage: #imageLiteral(resourceName: "profile_selected"), rootViewController: profileController)
        
        let notifications = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "like_unselected"), selectedImage: #imageLiteral(resourceName: "like_selected"), rootViewController: NotificationController())
        
        // embed in toolbar
        viewControllers = [feed, search, imagesSelector, notifications, profile]
        
        tabBar.tintColor = .black
    }
    
//helper function for tabBar icons
    func templateNavigationController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = unselectedImage
        nav.tabBarItem.selectedImage = selectedImage
        nav.navigationBar.tintColor = .black
        return nav
    }
    
    func didFinishPickingMedia( picker: YPImagePicker ){
        picker.didFinishPicking { items, _  in
            picker.dismiss(animated: false)
            guard let selectedImage = items.singlePhoto?.image else { return }
//            print("DEBUG: ⭐️selectedImage is \(selectedImage)")
            let controller = UploadPostController()
            controller.delegate = self
            controller.currentUser = self.user  
            controller.selectedImage = selectedImage
            
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: false, completion: nil)
        }
    }
}

//  MARK: - Extensions: AuthenticationDelegate
extension MainTabController: AuthenticationDelegate {
    func authenticationDidComplete() {
        fetchUser()
        print("DEBUG: Auth did complete, fetch user and update here⭐️")
        self.dismiss(animated: true, completion: nil)
    }
}
//  MARK: - Extensions: UITabBarControllerDelegate
extension MainTabController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.firstIndex(of: viewController)
        print("DEBUG: index of vc is \(index)")
        
        if index == 2 {
            var config = YPImagePickerConfiguration()
            config.library.mediaType = .photoAndVideo
            config.shouldSaveNewPicturesToAlbum = false
            config.startOnScreen = .library
            config.screens = [.library]
            config.hidesStatusBar = false
            config.hidesBottomBar = false
            config.library.maxNumberOfItems = 7
            
            config.video.fileType = .mov
            config.video.recordingTimeLimit = 60.0
            config.video.libraryTimeLimit = 60.0
            config.video.minimumTimeLimit = 3.0
            config.video.trimmerMaxDuration = 60.0
            config.video.trimmerMinDuration = 3.0
            
            let picker = YPImagePicker(configuration: config)
            picker.modalPresentationStyle = .fullScreen
            present(picker, animated: false, completion: nil)
            
            didFinishPickingMedia(picker: picker)
        }
        
        return true
    }
}

//  MARK: - Extensions: UploadPostControllerDelegate
extension MainTabController: UploadPostControllerDelegate {
    func controllerDidFinishUploadPost(_ controller: UploadPostController) {
        selectedIndex = 0
        controller.dismiss(animated: true, completion: nil)
        
        guard let feedNav = viewControllers?.first as? UINavigationController else { return }
        guard let feed = feedNav.viewControllers.first as? FeedController else { return }
        feed.handleRefresher()
    }
    
}

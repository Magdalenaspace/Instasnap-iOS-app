//
//  SearchController.swift
//  FashionSnap
//
//  Created by Magdalena Samuel on 7/19/23.
//

import  UIKit
 
private let reuseIdentifier = "UserCell"
private let postCellIdentifier = "ProfileCell"

class SearchController: UIViewController {
    // MARK: - Properties
    //empty array
    private let tableView = UITableView()
    private var users = [User]()
    private var filteredUsers = [User]()
    private var posts = [Post]()
    private let searchController = UISearchController(searchResultsController: nil)
    private var isSearchMode: Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.register(ProfileCell.self, forCellWithReuseIdentifier: postCellIdentifier)
        cv.backgroundColor = .white
        return cv
    }()
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = .white
        configureSearchController()
        configureUI()
        fetchUsers()
        fetchPost()
    }
    
    // MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "Explore"
        
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UserCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 64
        tableView.separatorStyle = .none
        
        view.addSubview(tableView)
        tableView.fillSuperview()
        tableView.isHidden = true
        
        view.addSubview(collectionView)
        collectionView.fillSuperview()
    }
    
    func configureSearchController(){
        //filter through search
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        definesPresentationContext = false
    }
    // MARK: - API
    func fetchUsers(){
        UserService.fetchUsers { users in
//            print("DEBUG:🐞USERS: \(users)")
            //set users -> reload data
            self.users = users
            self.tableView.reloadData()
        }
    }
    
    func fetchPost() {
        PostService.fetchPosts { posts in
            self.posts = posts
            self.collectionView.reloadData()
        }
    }
}
// MARK: - Extensions: UITableViewDataSource

extension SearchController: UITableViewDataSource {
 //how many rows
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearchMode ? filteredUsers.count : users.count
        
    }
//define what row is going to contain
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UserCell
        
        let user = isSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
        cell.viewModel = UserCellViewModel(user: user)
        cell.backgroundColor = .white
        return cell
    }
}
// MARK: - Extensions: UITableViewDelegate
//how go the clicked user profile
extension SearchController: UITableViewDelegate {
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let user = isSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
//        print("DEBUG:🐞User is \(users[indexPath.row].fullname)")
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
}
// MARK: - Extensions: UISearchResultsUpdating
extension SearchController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }
        
        filteredUsers = users.filter({
            $0.username.contains(searchText) ||
            $0.fullname.contains(searchText.lowercased())
        })
        print("DEBUG: Filtered user\(filteredUsers)")
        self.tableView.reloadData()
        
        
    }
}

// MARK: - Extensions:
extension SearchController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: postCellIdentifier, for: indexPath) as! ProfileCell
        cell.viewModel = PostViewModel(post: posts[indexPath.row])
        return cell
    }
    
    
    
}

// MARK: - UICollectionViewDelegate
extension SearchController: UICollectionViewDelegate {
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        controller.post = posts[indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SearchController: UICollectionViewDelegateFlowLayout {
    
    // Sizing space between columns (cells) and rows
    
    // Minimum interterm spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    // Minimum line spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    // Size for item at
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Each cell is 1/3 of the view's width
        let width = (view.frame.width - 2) / 3
        return CGSize(width: width, height: width)
    }
    
}

// MARK: - UISearchBarDelegate
extension SearchController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        collectionView.isHidden = true
        tableView.isHidden = false
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
        searchBar.text = nil
        collectionView.isHidden = false
        tableView.isHidden = true
        
    }
}

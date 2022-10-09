//
//  FollowersListViewController.swift
//  GitHubUsers
//
//  Created by APPLE on 10/8/22.
//

import UIKit

class FollowersListViewController: UIViewController, FollowersProtocol, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var viewNavigation: UIView!
    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblNavigation: UILabel!
    @IBOutlet weak var tblFollowers: UITableView!
    
    var userName = ""
    var activityIndicator = UIActivityIndicatorView()
    let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .systemChromeMaterialDark))
    
    var followersList = [ItemsListModel](){
        didSet {
            self.tblFollowers.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.doInitialize()
    }
 
    //----------------------------------------------------
    //------ MARK: - Initial function to assign data -----
    //----------------------------------------------------
    func doInitialize() {
        self.tblFollowers.delegate = self
        self.tblFollowers.dataSource = self
        self.viewNavigation.isHidden = true
        self.tblFollowers.isHidden = true
        self.getServerCallForSearchResult(userName: self.userName)
        self.activityIndicator(isActivity: 1)
    }
    
    //----------------------------------------------------
    //------ MARK: - To initialize activity indicator -----
    //----------------------------------------------------
    func activityIndicator(isActivity: Int) {
        if isActivity == 1 {
            activityIndicator.removeFromSuperview()
            effectView.removeFromSuperview()
            effectView.frame = CGRect(x: view.frame.midX-20, y: view.frame.midY, width: 46, height: 46)
            effectView.layer.cornerRadius = 15
            effectView.layer.masksToBounds = true
            activityIndicator = UIActivityIndicatorView(style: .white)
            activityIndicator.frame = CGRect(x: 0, y: 0, width: 46, height: 46)
            activityIndicator.startAnimating()
            effectView.contentView.addSubview(activityIndicator)
            view.addSubview(effectView)
        } else {
            activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            effectView.isHidden = true
        }
    }
    
    //-----------------------------------
    //      MARK: - Back Button Action
    //-----------------------------------
    @IBAction func btnBackClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //---------------------------------------------------------
    //------------ Get Followers Data From Server -------------
    //---------------------------------------------------------
    func getServerCallForSearchResult(userName: String) {
        DispatchQueue.main.async {
            FollowersViewModel.sharedInstance.getFollowersDataFromServer(delegate: self, userName: userName)
        }
    }
    
    //--------------------------------------------------------
    //---------- Followers List Success Delegate -------------
    //--------------------------------------------------------
    func didFetchUsersFollowers(responseData: Any) {
        FollowersViewModel.sharedInstance.didParseFollowersData(completion: { (followersList, isSuccess, message) in
            if isSuccess{
                DispatchQueue.main.async {
                    self.activityIndicator(isActivity: 0)
                }
                if let followers = followersList {
                    self.followersList = followers
                    self.viewNavigation.isHidden = false
                    self.tblFollowers.isHidden = false
                }
            }
        }, responseData: responseData)
    }
    
    //--------------------------------------------------------
    //---------- Followers List Failure Delegate -------------
    //--------------------------------------------------------
    func didFailUsersFollowersWithError(error: NSError) {
        print("Error: \(error)")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return followersList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FollowersListTableViewCell", for: indexPath) as! FollowersListTableViewCell
        
        if let userName = followersList[indexPath.row].name{
            cell.lblUserName.text = userName
        }
        
        if let userImage = followersList[indexPath.row].avatar_url{
            if let url = URL(string: userImage) {
            let data = try? Data(contentsOf: url)
                if let data = data {
                    cell.imgUser.image = UIImage(data: data)
                }
            }
        }
        
        cell.imgUser.layer.cornerRadius = 10
        cell.imgUser.clipsToBounds = true
        return cell
    }
    

}


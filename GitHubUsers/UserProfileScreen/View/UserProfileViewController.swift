//
//  UserProfileViewController.swift
//  GitHubUsers
//
//  Created by APPLE on 10/8/22.
//

import UIKit

class UserProfileViewController: UIViewController {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblUserId: UILabel!
    @IBOutlet weak var lblScore: UILabel!
    @IBOutlet weak var lblNodeId: UILabel?
    @IBOutlet weak var btnFollowers: UIButton!
    @IBOutlet weak var btnShareUser: UIButton!

    var itemModel: ItemsListModel?
    var followersName = ""
    var shareUrl = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.doInitialize()
    }
    
    //----------------------------------------------------
    //------ MARK: - Initial function to assign data -----
    //----------------------------------------------------
    func doInitialize(){
        if let name = itemModel?.name {
            self.followersName = name
            self.lblName.text = name
        }
        if let userImage = itemModel?.avatar_url {
            if let url = URL(string: userImage) {
            let data = try? Data(contentsOf: url)
                if let data = data {
                    self.imgUser.image = UIImage(data: data)
                }
            }
        }
        if let score = itemModel?.score {
            self.lblScore.text = String(score)
        }
        if let userId = itemModel?.id {
            self.lblUserId.text = String(userId)
        }
        if let nodeId = itemModel?.node_id {
            self.lblNodeId?.text = nodeId
        }
        if let shareUrl = itemModel?.url {
            self.shareUrl = shareUrl
        }
        self.imgUser.layer.cornerRadius = 30
        self.imgUser.clipsToBounds = true
    }
    
    //--------------------------------------
    //----- MARK: - Back Button Action -----
    //--------------------------------------
    @IBAction func btnBackClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //-----------------------------------------
    //      MARK: - Followers Button Action
    //-----------------------------------------
    @IBAction func btnFollowersClicked(_ sender: UIButton) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            if let objFollowers = storyboard.instantiateViewController(withIdentifier: "FollowersListViewController") as? FollowersListViewController {
                objFollowers.userName = self.followersName
            self.navigationController?.pushViewController( objFollowers, animated: true)
        }
    }
    
    //-----------------------------------------
    //      MARK: - Share Button Action
    //-----------------------------------------
    @IBAction func btnShareClicked(_ sender: Any) {
        
        // Setting description
        let firstActivityItem = self.followersName
        let secondActivityItem : NSURL = NSURL(string:  self.shareUrl)!
        
        // If you want to use an image
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [firstActivityItem, secondActivityItem], applicationActivities: nil)
        
        // This lines is for the popover you need to show in iPad
        activityViewController.popoverPresentationController?.sourceView = (sender as! UIButton)
        
        // This line remove the arrow of the popover to show in iPad
        activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.down
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
        
        // Pre-configuring activity items
        if #available(iOS 13.0, *) {
            activityViewController.activityItemsConfiguration = [
                UIActivity.ActivityType.message
            ] as? UIActivityItemsConfigurationReading
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 13.0, *) {
            activityViewController.activityItemsConfiguration = [
                UIActivity.ActivityType.message
            ] as? UIActivityItemsConfigurationReading
        } else {
            // Fallback on earlier versions
        }
        
        if #available(iOS 13.0, *) {
            activityViewController.isModalInPresentation = true
        } else {
            // Fallback on earlier versions
        }
        self.present(activityViewController, animated: true, completion: nil)
    }
}

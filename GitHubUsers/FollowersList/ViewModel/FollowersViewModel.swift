//
//  FollowersViewModel.swift
//  GitHubUsers
//
//  Created by APPLE on 10/8/22.
//

import Foundation
import ObjectMapper


@objc protocol FollowersProtocol
{
    @objc optional
    func didFetchUsersFollowers(responseData: Any) -> Void
    @objc optional
    func didFailUsersFollowersWithError(error: NSError) -> Void
}

class FollowersViewModel: TemplateMainService, AppMainServiceDelegate {
    
    weak var followersDelegate: FollowersProtocol?
    var message = ""
    var serverUrl: String?
    
    static let sharedInstance :FollowersViewModel =
    {
        let instance = FollowersViewModel()
        return instance
    }()
    
    func didFetchData(responseData: Any) {
        self.followersDelegate?.didFetchUsersFollowers?(responseData: responseData)
    }
    
    func didFailWithError(error: NSError) {
        self.followersDelegate?.didFailUsersFollowersWithError?(error: error)
    }
    
    // ----------------------------------------------------------------------
    // ----------------- Server call for Followers data ------------------
    //------------------------------------------------------------------------
    func getFollowersDataFromServer(delegate:FollowersProtocol, userName: String) -> Void {
        self.followersDelegate = delegate
        super.mainServerdelegate = self
        let baseUrl = "https://api.github.com/users/"
        let url = "\(baseUrl)\(userName)/followers"
        super.getCallWithAlamofire(serverUrl: url)
    }
    
    // ---------------------------------------------------------
    // ----------------- Parse Followers Data ------------------
    //----------------------------------------------------------
    func didParseFollowersData(completion: @escaping (([ItemsListModel]?, Bool, String) -> Void) , responseData:Any) {
        do {
        let jsonModel = try Mapper<ItemsListModel>().mapArray(JSONArray: responseData as! [[String : Any]])
            self.message = "Success"
            print("JsonModel\(jsonModel)")
            completion(jsonModel, true, self.message)
        }
        catch {
            print("Error")
        }
    }
}


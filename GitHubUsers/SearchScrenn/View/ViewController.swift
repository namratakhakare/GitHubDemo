//
//  ViewController.swift
//  GitHubUsers
//
//  Created by APPLE on 10/8/22.
//

import UIKit

class ViewController: UIViewController, SearchResultProtocol, UITextFieldDelegate {

    @IBOutlet weak var viewNavigation: UIView!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var imgSearch: UIImageView!
    @IBOutlet weak var btnClear: UIButton!
    @IBOutlet weak var imgClear: UIImageView!
    @IBOutlet weak var tableSearchResults: UITableView!
    
    var page = 1
    var textFieldChar = ""
    var pageSize = 30
    var searchData: SearchResultMainModel?
    var objSeatchList = [ItemsListModel](){
        didSet {
            self.tableSearchResults.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.doInitialize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        txtSearch.addTarget(self, action: #selector(self.textFieldDidEndEditing(_:)), for: .editingChanged)
        txtSearch.delegate = self
    }

    //----------------------------------------------------
    //------ MARK: - Initial function to assign data -----
    //----------------------------------------------------
    func doInitialize(){
        self.tableSearchResults.dataSource = self
        self.tableSearchResults.delegate = self
        self.tableSearchResults.isHidden = true
        self.viewSearch.layer.borderWidth = 1
        if ((self.txtSearch.text?.isEmpty) != nil) {
            self.btnClear.isHidden = true
            self.imgClear.isHidden = true
        }
        self.viewSearch.layer.borderColor = UIColor.gray.cgColor
        self.viewSearch.layer.cornerRadius = 20
    }
    
    //----------------------------------------
    //------ MARK: - Clear Button Action -----
    //----------------------------------------
    @IBAction func btnClearPressed(_ sender: UIButton) {
        self.txtSearch.text?.removeAll()
        self.btnClear.isHidden = true
        self.imgClear.isHidden = true
        self.view.endEditing(false)
        self.objSeatchList.removeAll()
        self.tableSearchResults.reloadData()
    }
    
    //---------------------------------------------------------
    //------------ Get Search Data From Server ----------------
    //---------------------------------------------------------
    func getServerCallForSearchReslut(query: String, page: Int) {
        DispatchQueue.main.async {
            SearchResultViewModel.sharedInstance.getSearchUsersResult(delegate: self, query: query, page: page)
        }
    }
    
    //--------------------------------------------------------
    //---------- Search Result Success Delegate --------------
    //--------------------------------------------------------
    func didFetchUsersResultData(responseData: Any) {
        SearchResultViewModel.sharedInstance.didParseSearchReasultData(completion: { (searchData, isSuccess, message) in
            if isSuccess{
                if let searchData = searchData {
                    self.tableSearchResults.isHidden = false
                    self.searchData = searchData
                    self.objSeatchList += searchData.items
                    self.tableSearchResults.reloadData()
                }
            } else {
                // No data found
            }
        }, responseData: responseData)
    }
    
    //--------------------------------------------------------
    //---------- Search Result Failure Delegate --------------
    //--------------------------------------------------------
    func didFailUsersResultDataWithError(error: NSError) {
        print("Error: \(error)")
    }
    
    @objc func textFieldDidEndEditing(_ textField: UITextField) {
        if self.txtSearch.text?.isEmpty == false {
            self.btnClear.isHidden = false
            self.imgClear.isHidden = false
            if let textFieldText = textField.text {
                self.textFieldChar = textFieldText
                self.getServerCallForSearchReslut(query: self.textFieldChar, page: 1)
            }
        } else {
            self.btnClear.isHidden = true
            self.imgClear.isHidden = true
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if self.txtSearch.text?.isEmpty == false {
            self.btnClear.isHidden = false
            self.imgClear.isHidden = false
        } else {
            self.btnClear.isHidden = true
            self.imgClear.isHidden = true
            self.objSeatchList.removeAll()
            self.tableSearchResults.reloadData()
        }
    }
    
    // -------------------------------------------------
    //       MARK:  Method For Pagination Call Data
    // -------------------------------------------------
    func paginationCallData() {
        self.page  += 1
        self.getServerCallForSearchReslut(query: self.textFieldChar, page: self.page)
    }
    
    @objc func btnFollowersPressed(_ sender : UIButton) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            if let objFollowers = storyboard.instantiateViewController(withIdentifier: "FollowersListViewController") as? FollowersListViewController {
                if let userName = self.objSeatchList[sender.tag].name {
                    objFollowers.userName =  userName
                }
            self.navigationController?.pushViewController( objFollowers, animated: true)
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objSeatchList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultTableViewCell", for: indexPath) as! SearchResultTableViewCell
        if let userName = objSeatchList[indexPath.row].name{
            cell.lblUserName.text = userName
        }
        
        if let userImage = objSeatchList[indexPath.row].avatar_url{
            if let url = URL(string: userImage) {
            let data = try? Data(contentsOf: url)
                if let data = data {
                    cell.imgUser.image = UIImage(data: data)
                }
            }
        }
        cell.imgUser.layer.cornerRadius = 10
        cell.imgUser.clipsToBounds = true
        cell.btnFollowers.tag = indexPath.row
        cell.btnFollowers.addTarget(self, action: #selector(btnFollowersPressed(_:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        if let objProfileView = storyboard.instantiateViewController(withIdentifier: "UserProfileViewController") as? UserProfileViewController {
            objProfileView.itemModel = self.objSeatchList[indexPath.row]
        self.navigationController?.pushViewController( objProfileView, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row ==  self.objSeatchList.count - 1 && (self.objSeatchList.count >= self.pageSize) {                self.paginationCallData()
        }
    }
}

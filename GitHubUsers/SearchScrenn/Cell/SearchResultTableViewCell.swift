//
//  SearchResultTableViewCell.swift
//  GitHubUsers
//
//  Created by APPLE on 10/8/22.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {

    @IBOutlet weak var viewBase: UIView!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var btnFollowers: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

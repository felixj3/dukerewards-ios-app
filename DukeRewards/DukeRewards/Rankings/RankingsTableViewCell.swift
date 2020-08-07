//
//  RankingsTableViewCell.swift
//  DukeRewards
//
//  Created by codeplus on 6/4/20.
//  Copyright © 2020 Duke University. All rights reserved.
//

import UIKit

class RankingsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var rankNumber: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var pointsNumber: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
   
   
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profilePic.layer.cornerRadius = profilePic.frame.height / 2
        profilePic.clipsToBounds = true
        layer.cornerRadius = 10
        clipsToBounds = true
        let verticalPadding: CGFloat = 8
        let maskLayer = CALayer()
        maskLayer.cornerRadius = 10
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.frame = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: bounds.width, height: bounds.height).insetBy(dx: 0, dy: verticalPadding/2)
        layer.mask = maskLayer
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

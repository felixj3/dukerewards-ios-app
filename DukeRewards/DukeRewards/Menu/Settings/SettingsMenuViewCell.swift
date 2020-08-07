//
//  SettingsMenuViewCell.swift
//  DukeRewards
//
//  Created by codeplus on 6/9/20.
//  Copyright © 2020 Duke University. All rights reserved.
//

import UIKit

class SettingsMenuViewCell: UITableViewCell {
    @IBOutlet weak var pushLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
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

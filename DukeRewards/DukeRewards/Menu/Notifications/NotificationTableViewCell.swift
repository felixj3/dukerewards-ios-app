//
//  NotificationTableViewCell.swift
//  DukeRewards
//
//  Created by Kyra Chan on 6/10/20.
//  Copyright © 2020 Duke University. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var notificationHeader: UILabel!
    @IBOutlet weak var notificationTime: UILabel!
    @IBOutlet weak var notificationDescription: UILabel!
    @IBOutlet weak var announcementCategory: UILabel!
    
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
    
    func colorCategoryLabel() {
        if announcementCategory.text == "  Athletics  " {
            announcementCategory.backgroundColor = UIColor(red: 0.95, green: 0.44, blue: 0.44, alpha: 1.00)
        }
        else if announcementCategory.text == "  Dining  " {
            announcementCategory.backgroundColor = UIColor(red: 1.00, green: 0.85, blue: 0.38, alpha: 1.00)
        }
        else {
            announcementCategory.backgroundColor = UIColor(red: 0.43, green: 0.76, blue: 0.89, alpha: 1.00)
        }
    }

}

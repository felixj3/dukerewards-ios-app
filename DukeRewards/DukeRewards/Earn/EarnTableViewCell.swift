//
//  EarnTableViewCell.swift
//  DukeRewards
//
//  Created by Kyra Chan on 6/4/20.
//  Copyright © 2020 Duke University. All rights reserved.
//

import UIKit

class EarnTableViewCell: UITableViewCell {

    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventTime: UILabel!
    @IBOutlet weak var eventLocation: UILabel!
    @IBOutlet weak var eventDescription: UILabel!
    @IBOutlet weak var eventCategory: UILabel!
    @IBOutlet weak var bookmarkButton: UIButton!
    @IBOutlet weak var eventPoints: UILabel!
    @IBOutlet weak var earnButton: UIButton!
    var link: EarnViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        eventPoints.adjustsFontSizeToFitWidth = true
        // Initialization code
        colorCategoryLabel()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
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
    
    func colorCategoryLabel() {
        if eventCategory.text == "  Athletics  " {
            eventCategory.backgroundColor = UIColor(red: 0.95, green: 0.44, blue: 0.44, alpha: 1.00)
        }
        else if eventCategory.text == "  Dining  " {
            eventCategory.backgroundColor = UIColor(red: 1.00, green: 0.85, blue: 0.38, alpha: 1.00)
        }
        else {
            eventCategory.backgroundColor =  UIColor(red: 0.43, green: 0.76, blue: 0.89, alpha: 1.00)
        }
    }
    @IBAction func bookmarkPressed(_ sender: Any) {
        link?.handleMarkAsBookmark(cell: self)
    }
    
}

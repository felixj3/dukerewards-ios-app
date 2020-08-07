//
//  RedeemTableViewCell.swift
//  DukeRewards
//
//  Created by Kyra Chan on 6/4/20.
//  Copyright © 2020 Duke University. All rights reserved.
//

import UIKit

//protocol RedeemTableViewCellDelegate: AnyObject {
//  func redeemTableViewCell(_ redeemTableViewCell: RedeemTableViewCell, redeemButtonTappedFor reward: Reward)
//}

class RedeemTableViewCell: UITableViewCell {

    @IBOutlet weak var rewardImage: UIImageView!
    @IBOutlet weak var rewardName: UILabel!
    @IBOutlet weak var rewardTime: UILabel!
    @IBOutlet weak var rewardLocation: UILabel!
    @IBOutlet weak var rewardDescription: UILabel!
    @IBOutlet weak var rewardCategory: UILabel!
    @IBOutlet weak var rewardPoints: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    var link: RedeemViewController?
    
    var reward: Reward?
    // weak var delegate : RedeemTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        rewardPoints.adjustsFontSizeToFitWidth = true
        // Initialization code
        colorCategoryLabel()
//        self.redeemButton.addTarget(self, action: #selector(tapRedeem(_:)), for: .touchUpInside)
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
        if rewardCategory.text == "  Athletics  " {
            rewardCategory.backgroundColor = UIColor(red: 0.95, green: 0.44, blue: 0.44, alpha: 1.00)
        }
        else if rewardCategory.text == "  Dining  " {
            rewardCategory.backgroundColor = UIColor(red: 1.00, green: 0.85, blue: 0.38, alpha: 1.00)
        }
        else {
            rewardCategory.backgroundColor = UIColor(red: 0.43, green: 0.76, blue: 0.89, alpha: 1.00)
        }
    }

    @IBAction func favoritePressed(_ sender: Any) {
        link?.handleMarkAsFavorite(cell: self)
    }
    //    @IBAction func tapRedeem(_ sender: Any) {
//        if let reward = reward, let delegate = delegate {
//            self.delegate?.redeemTableViewCell(self, redeemButtonTappedFor: reward)
//        }
//    }
    
}

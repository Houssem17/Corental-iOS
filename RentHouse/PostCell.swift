//
//  PostCell.swift
//  RentHouse
//
//

import UIKit

class PostCell: UITableViewCell {

    
    @IBOutlet weak var usernameLbl: UILabel!
    
    
    @IBOutlet weak var pictureImg: UIImageView!
    
    
   
    @IBOutlet weak var textLbl: UILabel!
    
    @IBOutlet weak var dateLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // color
              usernameLbl.textColor = colorBrandBlue
              
              // round corners
              pictureImg.layer.cornerRadius = pictureImg.bounds.width / 20
              pictureImg.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

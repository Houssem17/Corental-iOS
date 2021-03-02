//
//  CityCell.swift
//  RentHouse
//
//

import UIKit

class CityCell: UITableViewCell {

  
    @IBOutlet weak var fullnameLbl: UILabel!
    @IBOutlet weak var avaImg: UIImageView!
    
    @IBOutlet weak var usernameLbl: UILabel!
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
               // round corners
               avaImg.layer.cornerRadius = avaImg.bounds.width / 2
               avaImg.clipsToBounds = true
               
               // color
               usernameLbl.textColor = colorBrandBlue
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

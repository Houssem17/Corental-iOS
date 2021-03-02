//
//  EditVc.swift
//  RentHouse
//
//

import UIKit

class EditVc: UIViewController {
let defaults = UserDefaults.standard
    @IBOutlet weak var usernameTxt: UITextField!
    
    @IBOutlet weak var nameTxt: UITextField!
    
    @IBOutlet weak var surnameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    
    @IBOutlet weak var avaImg: UIImageView!
    
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var fullnameLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

      // shortcuts
        let username = self.defaults.object(forKey:"username")
        self.navigationItem.title = username as? String
        let fullname = self.defaults.object(forKey:"fullname")
        print ( 	 fullname )
        self.navigationItem.title = fullname as? String
       // let fullnameArray = ((fullname!) as! String).split {$0 == " "}.map(String.init) // include 'Fistname Lastname' as array of seperated elements
      //  let firstname = fullnameArray[0]
       // let lastname = fullnameArray[1]
        
       
      //  _ = user!["email"] as? String
        let ava = self.defaults.object(forKey: "user_ava")as? String
        
        
        navigationItem.title = "PROFILE"
        usernameTxt.text = defaults.object(forKey: "username") as? String
        nameTxt.text = defaults.object(forKey: "fullname") as? String
        surnameTxt.text = defaults.object(forKey: "surrname") as? String
        emailTxt.text = defaults.object(forKey: "email") as? String
       // fullnameLbl.text = "\(nameTxt.text!) \(surnameTxt.text!)"
      //  nameTxt.text = firstname
       // surnameTxt.text = lastname
        
        
        // get user profile picture
        if ava != "" && ava != nil {
            
         // url path to image
            let imageURL = URL(string: ava!)!
            
            // communicate back user as main queue
            DispatchQueue.main.async(execute: {
                
                // get data from image url
                let imageData = try? Data(contentsOf: imageURL)
                
                // if data is not nill assign it to ava.Img
                if imageData != nil {
                    DispatchQueue.main.async(execute: {
                        self.avaImg.image = UIImage(data: imageData!)
                    })
                }
            })
            
        }
        
            // round corners
                   avaImg.layer.cornerRadius = avaImg.bounds.width / 2
                   avaImg.clipsToBounds = true
                   saveBtn.layer.cornerRadius = saveBtn.bounds.width / 4.5
                   
                   // color
                   saveBtn.backgroundColor = colorBrandBlue
                   
                   // disable button initially
                   saveBtn.isEnabled = false
                   saveBtn.alpha = 0.4
                   
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

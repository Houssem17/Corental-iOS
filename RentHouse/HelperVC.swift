//
//  HelperVC.swift
//  RentHouse
//
//

import UIKit


class HelperVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    

    
    
    
    // allows us to go to another ViewController programmatically
    func instantiateViewController(identifier: String, animated: Bool, by vc: UIViewController, completion: (() -> Void)?) {
        
        // accessing any ViewController from Main.storyboard via ID
        let newViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier)
        
        // presenting accessed ViewController
        vc.present(newViewController, animated: animated, completion: completion)
        
    }
    
}

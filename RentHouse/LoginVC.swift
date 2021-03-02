//
//  LoginVC.swift
//  RentHouse
//
//

import UIKit

class LoginVC: UIViewController {

    
    let defaults = UserDefaults.standard
    @IBOutlet weak var usernameTxt: UITextField!
    
    @IBOutlet weak var passwordTxt: UITextField!
    
    // click login button
  
  
    
    @IBAction func login_click(_ sender: Any) {
    
    // if no text entered
               if usernameTxt.text!.isEmpty || passwordTxt.text!.isEmpty {
                 
                   // red placeholders
                   usernameTxt.attributedPlaceholder = NSAttributedString(string: "username", attributes: [NSAttributedStringKey.foregroundColor:UIColor.red])
                   passwordTxt.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSAttributedStringKey.foregroundColor:UIColor.red])
                   
               // text is entered
        
        
        }else {
                
                // remove keyboard
                self.view.endEditing(true)
                
                // shortcuts
                let username = usernameTxt.text!.lowercased()
                let password = passwordTxt.text!
                
                // send request to mysql db
                // url to access our php file
                let url = URL(string: "http://localhost:8888/RentHouse/login.php")!
                
                // request url
                var request = URLRequest(url: url)
                
                // method to pass data POST - cause it is secured
                request.httpMethod = "POST"
                
                // body gonna be appended to url
                let body = "username=\(username)&password=\(password)"
                
                // append body to our request that gonna be sent
                request.httpBody = body.data(using: .utf8)
                
                // launch session
                URLSession.shared.dataTask(with: request) { data, response, error in
                    
                    // no error
                    if error == nil {
                        
                        do {
                            let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                            
                            guard let parseJSON = json else {
                                print("Error while parsing")
                                return
                            }
                           print(parseJSON)
                            
                            
                            let id = parseJSON["id"] as? String
                            
                            // successfully logged in
                            if id != nil   {
                   let name = parseJSON["username"] as? String
                   let email = parseJSON["email"] as? String
                   let fullname = parseJSON["fullname"] as? String
                   let ava = parseJSON["ava"] as? String
                  self.defaults.set(id, forKey: "user_id")
                  self.defaults.set(name, forKey: "user_name")
                  self.defaults.set(email, forKey: "user_email")
                  self.defaults.set(fullname, forKey: "user_fullname")
                  self.defaults.set(ava, forKey: "user_ava")
                   
                   print(self.defaults.object(forKey: "user_id")as? String)
                                
                                
                    /*    let recovedUserJsonData = UserDefaults.standard.object(forKey: "parseJSON")
                                let recovedUserJson = NSKeyedUnarchiver.unarchiveObject(with: recovedUserJsonData as! Data)
                           UserDefaults.standard.set(parseJSON, forKey: "parseJSON")
                            user = UserDefaults.standard.value(forKey: "parseJSON") as? NSDictionary
                                                  */
                                                       
                               DispatchQueue.main.async {
                                
                                // save user information we received from our host
                                                   
                                
                                          
                                
                                                   
                                          // accessing Helper Class to access its functions
                                          let helper = HelperVC()
                                
                                
                                                  // go to TabBar
                                                  helper.instantiateViewController(identifier: "TabBar", animated: true, by: self, completion: nil)
                                                 
                                
                                }
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                   /*
                                     // save user information we received from our host
                                     UserDefaults.standard.set(parseJSON, forKey: "parseJSON")
                                     user = UserDefaults.standard.value(forKey: "parseJSON") as? NSDictionary
                                                                         // go to tabbar / home page
                                     DispatchQueue.main.async(execute: {
                                         appDelegate.login()
                     
                                 })
                                      
                                //self.performSegue(withIdentifier: "GoToHome", sender: Any?.self)
                                 
                                 // error*/
                                
                               
                                
                                
                                 
                            }
                            
                            else {
                                   
                                                                       // get main queue to communicate back to user
                                                                       DispatchQueue.main.async(execute: {
                                                                           let message =
                                                                               parseJSON["message"] as! String
                                                                           appDelegate.infoView(message: message, color: colorSmoothRed)
                                                                       })
                                                                       return
                                                                       
                                                                  }
                        } catch {
                            
                          print("   Caught an error:\(error)")
                        }
                        
                    } else {
                        
                       print("Error:\(error)")
                        
                    }
                    
                }.resume()
                
            }
         
        }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "GoToHome"){
            let dest = segue.destination as! TabBarVC
            
        }
    }
    
    override func viewDidLoad() {
         super.viewDidLoad()

         // Do any additional setup after loading the view.
     }
     
    
      // white status bar
      override var preferredStatusBarStyle : UIStatusBarStyle {
          return UIStatusBarStyle.lightContent
      }
    

    // touched screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // hide keyboard
        self.view.endEditing(false)
    }
    
}
    
    
    
    
    
    
    
 

  



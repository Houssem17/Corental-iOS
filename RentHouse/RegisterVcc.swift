//
//  RegisterVcc.swift
//  RentHouse
//
//

import UIKit

class RegisterVcc: UIViewController {

    @IBOutlet weak var usernameTxt: UITextField!
    
    @IBOutlet weak var passwordTxt: UITextField!
    
    @IBOutlet weak var emailTxt: UITextField!
    
    @IBOutlet weak var firstnameTxt: UITextField!
    
    @IBOutlet weak var lastnameTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func register_click(_ sender: Any) {
        
        
        
              // if no text
              if usernameTxt.text!.isEmpty || passwordTxt.text!.isEmpty || emailTxt.text!.isEmpty || firstnameTxt.text!.isEmpty || lastnameTxt.text!.isEmpty {
                  
                  //red placeholders
                usernameTxt.attributedPlaceholder = NSAttributedString(string: "username", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
                passwordTxt.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
                emailTxt.attributedPlaceholder = NSAttributedString(string: "email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
                firstnameTxt.attributedPlaceholder = NSAttributedString(string: "name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
                  lastnameTxt.attributedPlaceholder = NSAttributedString(string: "surname", attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
                  
              // if text is entered
              }  else {
                          
                          // remove keyboard
                          self.view.endEditing(true)
                          
                          // url to php file
                          let url = URL(string: "http://localhost:8888/RentHouse/register.php")!
                          
                          // request to this file
                          var request = URLRequest(url: url)
                          
                          // method to pass data to this file (e.g. via POST)
                          request.httpMethod = "POST"
                          
                          // body to be appended to url
                          let body = "username=\(usernameTxt.text!.lowercased())&password=\(passwordTxt.text!)&email=\(emailTxt.text!)&fullname=\(firstnameTxt.text!)%20\(lastnameTxt.text!)"
                          
                          request.httpBody = body.data(using: .utf8)
                          
                          // proceed request
                          URLSession.shared.dataTask(with: request) { data, response, error in
                              
                              if error == nil {
                                  
                                  // get main queue in code process to communicate back to UI
                                  DispatchQueue.main.async(execute: {
                                      
                                      do {
                                          // get json result
                                          let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                                          
                                          // assign json to new var parseJSON in guard/secured way
                                          guard let parseJSON = json else {
                                              print("Error while parsing")
                                              return
                                          }
                                          
                                          // get id from parseJSON dictionary
                                          let id = parseJSON["id"]
                                          
                                          // successfully registered
                                          if id != nil {
                                      
                                        // go to tabbar / home page
                                        DispatchQueue.main.async(execute: {
                                                     
                                                                            // accessing Helper Class to access its functions
                                                                            let helper = HelperVC()
                                                                  
                                                                  
                                                                                    // go to TabBar
                                                                                    helper.instantiateViewController(identifier: "TabBar", animated: true, by: self, completion: nil)
                                        })
                                            

                                                               // saving logged user
                                                               currentUser = parseJSON.mutableCopy() as? NSMutableDictionary
                                                               UserDefaults.standard.set(currentUser, forKey: "currentUser")
                                                               UserDefaults.standard.synchronize()
                                            
                                            
                                          }
                                        else {
                                        /*
                                            // get main queue to communicate back to user
                                            DispatchQueue.main.async(execute: {
                                                let message =
                                                    parseJSON["message"] as! String
                                                appDelegate.infoView(message: message, color: colorSmoothRed)
                                            })
                                       */     return
                                            
                                        }
                                          
                                          
                                      } catch {

                                        print("caught an error: \(error)")
                                          
                                      }
                                      
                                  })
                                  
                              // if unable to proceed request
                              } else {

                               print("error:\(error)")

                              }
                              
                          // launch prepared session
                          }.resume()
                          
                      }
                      
                      
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


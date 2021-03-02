//
//  ResetVC.swift
//  RentHouse
//
//

import UIKit

class ResetVC: UIViewController {

    @IBOutlet weak var emailTxt: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func reset_click(_ sender: Any) {
        
        
        // if not text entered
        if emailTxt.text!.isEmpty {
            
            // red placeholder
            emailTxt.attributedPlaceholder = NSAttributedString(string: "email", attributes: [NSAttributedStringKey.foregroundColor:UIColor.red])
        }else{
            // remove keyboard
                       self.view.endEditing(true)
                       
                       // shortcut ref to text in email TextField
                       let email = emailTxt.text!.lowercased()
                       
                       // send mysql / php / hosting request
                       
                       // url path to php file
                       let url = URL(string: "http://localhost:8888/RentHouse/resetPassword.php")!
                       
                       // request to send to this file
                       var request = URLRequest(url: url)
                       
                       // method of passing inf to this file
                       request.httpMethod = "POST"
                       
                       // body to be appended to url. It passes inf to this file
                       let body = "email=\(email)"
                       request.httpBody = body.data(using: .utf8)
                       
                       // proces reqeust
                       URLSession.shared.dataTask(with: request) { data, response, error in
                         if error == nil {
                                            
                                            // give main queue to UI to communicate back
                                            DispatchQueue.main.async(execute: {
                                                
                                                do {
                                                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                                                    
                                                   
                                                    
                                                    guard let parseJSON = json else {
                                                        print("Error while parsing")
                                                        return
                                                    }
                                                    
                                                    
                                                    
                                               
                                                     
                                                    
                                                    
                                                } catch {

                                                print("Caught an error:\(error)")
                                                }
                                                
                                            })
                                            
                                            
                                        } else {

                                           print("Error:\(error)")
                                        }
                                        
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




//
//  HomeVC.swift
//  RentHouse
//
//

import UIKit

class HomeVC: UIViewController ,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UITableViewDelegate, UITableViewDataSource{
    
       
    
    
    
    let defaults = UserDefaults.standard
    @IBOutlet weak var avaImg: UIImageView!
    
    @IBOutlet weak var usernameLbl: UILabel!
    
    
    @IBOutlet weak var fullnameLbl: UILabel!
    
    
    @IBOutlet weak var emailLbl: UILabel!
    
    
    @IBOutlet weak var editBtn: UIButton!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @objc var houses = [AnyObject]()
    @objc var images = [UIImage]()
       
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        

    // round corners
    avaImg.layer.cornerRadius = avaImg.bounds.width / 20
    avaImg.clipsToBounds = true
        
        
        let name = self.defaults.object(forKey:"user_name")
        self.navigationItem.title = name as! String
        // get user details from user global var
        // shortcuts to store inf
      /*  let username = (user!["username"] as? String)
        let fullname = user!["fullname"] as? String
        let email = user!["email"] as? String
        let ava = user!["ava"] as? String
        */
        // assign values to labels
       usernameLbl.text = defaults.object(forKey: "user_name") as! String
        fullnameLbl.text = defaults.object(forKey: "user_fullname") as! String
        emailLbl.text =  defaults.object(forKey: "user_email") as! String
        let ava = self.defaults.object(forKey: "user_ava")as? String
    
      
  
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
        avaImg.layer.cornerRadius = avaImg.bounds.width / 20
        avaImg.clipsToBounds = true
        
        editBtn.setTitleColor(colorBrandBlue, for: UIControlState())
        
       // houses = [ "Hello", "world" , "how"]
        
    }
    
    
    
    
    @IBAction func edit_click(_ sender: Any) {
   
    // delcare sheet
           let sheet = UIAlertController(title: "Edit profile", message: nil, preferredStyle: .actionSheet)
           
           // cancel button clicked
           let cancelBtn = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
           
           // change picture clicked
           let pictureBtn = UIAlertAction(title: "Change picture", style: .default) { (action:UIAlertAction) in
               self.selectAva()
           }
           
           // update profile clicked
           let editBtn = UIAlertAction(title: "Update profile", style: .default) { (action:UIAlertAction) in
               
               // declare var to store editvc scene from main.stbrd
               let editvc = self.storyboard!.instantiateViewController(withIdentifier: "EditVc") as! EditVc
               self.navigationController?.pushViewController(editvc, animated: true)
               
               // remove title from back button
               let backItem = UIBarButtonItem()
               backItem.title = ""
               self.navigationItem.backBarButtonItem = backItem
               
           }
           
           // add actions to sheet
           sheet.addAction(cancelBtn)
           sheet.addAction(pictureBtn)
           sheet.addAction(editBtn)
           
           // present action sheet
           self.present(sheet, animated: true, completion: nil)
           
       }
       
       // select profile picture
       @objc func selectAva() {
           let picker = UIImagePickerController()
           picker.delegate = self
           picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
           picker.allowsEditing = true
           self.present(picker, animated: true, completion: nil)
       }
    
    // selected image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        avaImg.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        
        
        
        // call func of uploading file to server
        uploadAva()
       
    }
    
    // custom body of HTTP request to upload image file
      @objc func createBodyWithParams(_ parameters: [String: String]?, filePathKey: String?, imageDataKey: Data, boundary: String) -> Data {
          
          let body = NSMutableData();
          
          if parameters != nil {
              for (key, value) in parameters! {
                  body.appendString("--\(boundary)\r\n")
                  body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                  body.appendString("\(value)\r\n")
              }
          }
          
          let filename = "ava.jpg"
          
          let mimetype = "image/jpg"
          
          body.appendString("--\(boundary)\r\n")
          body.appendString("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
          body.appendString("Content-Type: \(mimetype)\r\n\r\n")
          body.append(imageDataKey)
          body.appendString("\r\n")
          
          body.appendString("--\(boundary)--\r\n")
          
          return body as Data
          
      }
    
    
    
    
       // upload image to serve
       @objc func uploadAva() {
        
        // shotcut id
        let id = self.defaults.object(forKey: "user_id") as?  String
        
        // url path to php file
        let url = URL(string: "http://localhost:8888/RentHouse/uploadAva.php")!
        
        // declare request to this file
        var request = URLRequest(url: url)
        
        // declare method of passign inf to this file
        request.httpMethod = "POST"
        
        // param to be sent in body of request
        let param = ["id" : id]
        
        // body
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        // compress image and assign to imageData var
        let imageData = UIImageJPEGRepresentation(avaImg.image!, 0.5)
        
        // if not compressed, return ... do not continue to code
        if imageData == nil {
            return
        }
        
        // ... body
        request.httpBody = createBodyWithParams(param as! [String : String], filePathKey: "file", imageDataKey: imageData!, boundary: boundary)
        
        
        // launc session
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            // get main queue to communicate back to user
            DispatchQueue.main.async(execute: {
                
                if error == nil {
                    
                    do {
                        // json containes $returnArray from php
                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                        
                        // declare new parseJSON to store json
                        guard let parseJSON = json else {
                            print("Error while parsing")
                            return
                        }
                        
                        // get id from $returnArray["id"] - parseJSON["id"]
                        let id = parseJSON["id"]
                        
                        // successfully uploaded
                        if id != nil {
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
                            
                        } else {
                            
                            // get main queue to communicate back to user
                            DispatchQueue.main.async(execute: {
                                let message = parseJSON["message"] as! String
                                appDelegate.infoView(message: message, color: colorSmoothRed)
                            })
                            
                        }
                    
                    // error while jsoning
                    } catch {
                        
                        // get main queue to communicate back to user
                        DispatchQueue.main.async(execute: {
                            let message = error as! String
                            appDelegate.infoView(message: message, color: colorSmoothRed)
                        })

                    }
                    
                // error with php
                } else {

                    // get main queue to communicate back to user
                    DispatchQueue.main.async(execute: {
                        let message = error!.localizedDescription
                        appDelegate.infoView(message: message, color: colorSmoothRed)
                    })

                }
                
                
            })
            
        }.resume()
        
        
    }
    
    
    
    
    @IBAction func logout_click(_ sender: Any) {
        
        
          self.defaults.set("", forKey: "user_id")
          self.defaults.set("", forKey: "user_name")
          self.defaults.set("", forKey: "user_email")
          self.defaults.set("", forKey: "user_fullname")
          self.defaults.set("", forKey: "user_ava")
           print(self.defaults.object(forKey: "user_id"));
          DispatchQueue.main.async (execute: {
              let helper = HelperVC()
              // go to TabBar
              helper.instantiateViewController(identifier: "loginVC", animated: true, by: self, completion: nil)
                      let message = "you logged out with success" as! String
                      
          })
          return
              print(self.defaults.object(forKey: "user_id"));
           
           }
    
    
    
    // TABLEVIEW
       // cell numb
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return houses.count
       }
      
    // cell config
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostCell
        
        // shortcuts
        let house = houses[indexPath.row]
        let image = images[indexPath.row]
        let username = house["username"] as? String
        let text = house["text"] as? String
        let date = house["date"] as! String
        
        cell.usernameLbl.text = username
        cell.textLbl.text = text
        cell.pictureImg.image = image
        
        // converting date string to date
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd-HH:mm:ss"
        let newDate = dateFormater.date(from: date)!
        
        // declare settings
        let from = newDate
        let now = Date()
        let components : NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfMonth]
        let difference = (Calendar.current as NSCalendar).components(components, from: from, to: now, options: [])
        
        // calculate date
        if difference.second! <= 0 {
            cell.dateLbl.text = "now"
        }
        if difference.second! > 0 && difference.minute! == 0 {
            cell.dateLbl.text = "\(String(describing: difference.second))s." // 12s.
        }
        if difference.minute! > 0 && difference.hour! == 0 {
            cell.dateLbl.text = "\(String(describing: difference.minute))m."
        }
        if difference.hour! > 0 && difference.day! == 0 {
            cell.dateLbl.text = "\(String(describing: difference.hour))h."
        }
        if difference.day! > 0 && difference.weekOfMonth! == 0 {
            cell.dateLbl.text = "\(String(describing: difference.day))d."
        }
        if difference.weekOfMonth! > 0 {
            cell.dateLbl.text = "\(String(describing: difference.weekOfMonth))w."
        }
        
        
          
        // get main queue to this block of code to communicate back
        DispatchQueue.main.async {
            
            // if no image on the cell
            if image.size.width == 0 && image.size.height == 0 {
                // move left textLabel if no picture
                cell.textLbl.frame.origin.x = self.view.frame.size.width / 16 // 20
                cell.textLbl.frame.size.width = self.view.frame.size.width - self.view.frame.size.width / 8 // 40
                cell.textLbl.sizeToFit()
            }
        }
        
        return cell
        
    }


    // pre load func
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // call func of laoding posts
        loadPosts()
    }
    
    

               // func of loading posts from server
    @objc  func loadPosts() {
                 
                   // shortcut to id
                   let id = self.defaults.object(forKey: "user_id") as!  String
                   
                   // accessing php file via url path
                   let url = URL(string: "http://localhost:8888/RentHouse/posts.php")!
                   
                   // declare request to proceed php file
                   var request = URLRequest(url: url)
                   
                   // declare method of passing information to php file
                   request.httpMethod = "POST"
                   
                   // pass information to php file
                   let body = "id=\(id)&text=&uuid="
                   request.httpBody = body.data(using: String.Encoding.utf8)
                   
                   // launch session
                   URLSession.shared.dataTask(with: request) { data, response, error in
                       
                       // get main queue to operations inside of this block
                       DispatchQueue.main.async(execute: {
                          
                           // no error of accessing php file
                        if error == nil {
                               
                               do {
                                   // json containes $returnArray from php
                                                          let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                                                          
                                                          // declare new parseJSON to store json
                                                          guard let parseJSON = json else {
                                                              print("Error while parsing")
                                                              return
                                                          }
                                                          
                                
                                   // clean up
                               self.houses.removeAll(keepingCapacity: false)
                                self.images.removeAll(keepingCapacity: false)
                                self.tableView.reloadData()
                            
                                  // declare new posts to store parseJSON
                                   guard let posts = parseJSON["posts"] as? [AnyObject] else {
                                       print("Error while parseJSONing")
                                       return
                                   }
                                   //print(posts)
                                   
                               
                            
                                   // append all posts var's inf to tweets
                                 self.houses = posts
                                    
                                   
                                   // getting images from url paths
                                 for i in 0 ..< self.houses.count {
                                       
                                       // path we are getting from $returnArray that assigned to parseJSON > to posts > tweets
                                       let path = self.houses[i]["path"] as? String
                                       
                                       // if we found path
                                       if !path!.isEmpty {
                                           let url = URL(string: path!)! // convert path str to url
                                           let imageData = try? Data(contentsOf: url) // get data via url and assigned imageData
                                           let image = UIImage(data: imageData!)! // get image via data imageData
                                           self.images.append(image) // append found image to [images] var
                                       } else {
                                           let image = UIImage() // if no path found, create a gab of type uiimage
                                           self.images.append(image) // append gap to uiimage to avoid crash
                                       }
                                       
                                   }
                                    
                                   
                                   // reload tableView to show back information
                                 self.tableView.reloadData()
                                   
                                
                               } catch let error as NSError {
                                let dataSet = String(data: data!, encoding: .utf8)

                                   print("Trying again")
                                   if (dataSet?.isEmpty)!{
                                       print ("ok")
                                   }

                                   
                                   print( "caught an error\(error)");
                               }
                               
                           } else {
                                print("Error:\(error)")
                           }
                           
                       })
                       
                   }.resume()
                   
               }
    
    // DELETE SECTION
    // allow edit cell
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // cell is swiped ...
      func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
          
          // we pressed delete button from swiped cell
          if editingStyle == .delete {
              
              // send delete PHP request
            //  deletePost(indexPath)
          }
          
      }
    
    
      // delete post php request
      @objc func deletePost(_ indexPath : IndexPath) {
          
          // shortcuts
          let house = houses[indexPath.row]
          let uuid = house["uuid"] as! String
          let path = house["path"] as! String
          
          let url = URL(string: "http://localhost:8888/RentHouse/posts.php")! // access php file
          var request = URLRequest(url: url) // declare request to proceed url
          request.httpMethod = "POST" // declare method of passing inf to php
          let body = "uuid=\(uuid)&path=\(path)" // body - here we are passing info
          request.httpBody = body.data(using: String.Encoding.utf8) // supports all lang
          
          // launc php request
          URLSession.shared.dataTask(with: request) { data, response, error in
              
              // get main queue to this block of code to communicate back, in other case it will do all this in background
              DispatchQueue.main.async(execute: {
                  
                  if error == nil {
                      
                      do {
                          
                          // get back from server $returnArray of php file
                          let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                          
                          // secure way to declare new var to store (e.g. json) data
                          guard let parseJSON = json else {
                              print("Error while parsing")
                              return
                          }
                          
                          // we are getting content of $returnArray under value "result" -> $returnArray["result"]
                          let result = parseJSON["result"]
                          // if result exists - deleted successfulyy
                          if result != nil {
                              self.houses.remove(at: indexPath.row) // remove related content from array
                              self.images.remove(at: indexPath.row) // remove related picture
                              self.tableView.deleteRows(at: [indexPath], with: .automatic) // remove table cell
                              self.tableView.reloadData() // reload table to show updates
                          } else {
                              // get main queue to communicate back to user
                              DispatchQueue.main.async(execute: {
                                  let message = parseJSON["message"] as! String
                                  appDelegate.infoView(message: message, color: colorSmoothRed)
                              })
                              return
                          }
                          
                      } catch {
                          // get main queue to communicate back to user
                          DispatchQueue.main.async(execute: {
                              let message = "\(error)"
                              appDelegate.infoView(message: message, color: colorSmoothRed)
                          })
                          return
                      }
                      
                  } else {
                      // get main queue to communicate back to user
                      DispatchQueue.main.async(execute: {
                          let message = error!.localizedDescription
                          appDelegate.infoView(message: message, color: colorSmoothRed)
                      })
                      return
                  }
                  
              })
              
          }.resume()
          
          
      }
               
    }
    
           // remove saved information
      



  

    

// Creating protocol of appending string to var of type data
extension NSMutableData {

    @objc func appendString(_ string : String) {
        
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
        
    }
    
}

    



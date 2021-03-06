//
//  GuestVc.swift
//  RentHouse

import UIKit

class GuestVc: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // variable that stores guest information passed via segue
    @objc var guest = NSDictionary()
    
  @IBOutlet weak var avaImg: UIImageView!
  @IBOutlet weak var usernameLbl: UILabel!
  @IBOutlet weak var fullNameLbl: UILabel!
  @IBOutlet weak var emailLbl: UILabel!
  @IBOutlet weak var editBtn: UIButton!
  @IBOutlet weak var tableView: UITableView!
  
     
      // UI obj related to Posts
  
      @objc var tweets = [AnyObject]()
      @objc var images = [UIImage]()
      
      
      // first load
      override func viewDidLoad() {
          super.viewDidLoad()
          
          // get user details from user global var
          // shortcuts to store inf
          let username = guest["username"] as? String
          let fullname = guest["fullname"] as? String
          let email = guest["email"] as? String
          let ava = guest["ava"] as? String
          
          // assign values to labels
          usernameLbl.text = username
          fullNameLbl.text = fullname
          emailLbl.text = email
          
           print (username)
        print (fullname)
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
          
        self.navigationItem.title = username?.uppercased()
          
      }
      
      
      
      // TABLEVIEW
      // cell numb
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return tweets.count
      }
      
      
      // cell config
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          
          let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostCell
          
          // shortcuts
          let tweet = tweets[indexPath.row]
          let image = images[indexPath.row]
          let username = tweet["username"] as? String
          let text = tweet["text"] as? String
          let date = tweet["date"] as! String
          
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
          
          
          // assigning shortcuts to ui obj
          cell.usernameLbl.text = username
          cell.textLbl.text = text
          cell.pictureImg.image = image
          
          
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
      @objc func loadPosts() {
          
          // shortcut to id
          let id = guest["id"]!
          
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
                          
                          // getting content of $returnArray variable of php file
                          let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                          
                          // clean up
                          self.tweets.removeAll(keepingCapacity: false)
                          self.images.removeAll(keepingCapacity: false)
                          self.tableView.reloadData()
                          
                          // declare new parseJSON to store json
                          guard let parseJSON = json else {
                              print("Error while parsing")
                              return
                          }
                          
                          // declare new posts to store parseJSON
                          guard let posts = parseJSON["posts"] as? [AnyObject] else {
                              print("Error while parseJSONing")
                              return
                          }
                          
                          
                          // append all posts var's inf to tweets
                          self.tweets = posts
                          
                          
                          // getting images from url paths
                          for i in 0 ..< self.tweets.count {
                              
                              // path we are getting from $returnArray that assigned to parseJSON > to posts > tweets
                              let path = self.tweets[i]["path"] as? String
                              
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


//
//  AppDelegate.swift
//  RentHouse
//
//

// colors
let colorSmoothRed = UIColor(red: 255/255, green: 50/255, blue: 75/255, alpha: 1)
let colorLightGreen = UIColor(red: 30/255, green: 244/255, blue: 125/255, alpha: 1)
let colorSmoothGray = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
let colorBrandBlue = UIColor(red: 45 / 255, green: 213 / 255, blue: 255 / 255, alpha: 1)

// sizes
let fontSize12 = UIScreen.main.bounds.width / 31



import UIKit
// global var - to store all logged / registered user infromation

// global var - to store all logged / registered user infromation
var currentUser: NSMutableDictionary?

let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate


var user : NSDictionary?
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
 var window: UIWindow?


    // boolean to check is erroView is currently showing or not
       @objc var infoViewIsShowing = false
       

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // loading current user
        currentUser = UserDefaults.standard.object(forKey: "currentUser") as? NSMutableDictionary
        
      //  print(currentUser)
        
        // checking is the glob variable that stores current user's info is empty or not
        if currentUser?["id"] != nil {
            
            // accessing TabBar controller via Main.storyboard
            let TabBar = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBar")
            
            // assigning TabBar as RootViewController of the project
            window?.rootViewController = TabBar
        }
        
        return true
    }
    

    
   
    // infoView view on top
    @objc func infoView(message:String, color:UIColor) {
        
        // if infoView is not showing ...
        if infoViewIsShowing == false {
            
            // cast as infoView is currently showing
            infoViewIsShowing = true
            
            
            // infoView - red background
            let infoView_Height = self.window!.bounds.height / 14.2
            let infoView_Y = 0 - infoView_Height
      
            let infoView = UIView(frame: CGRect(x: 0, y: infoView_Y, width: self.window!.bounds.width, height: infoView_Height))
            infoView.backgroundColor = color
            self.window!.addSubview(infoView)
            
            
            // infoView - label to show info text
            let infoLabel_Width = infoView.bounds.width
            let infoLabel_Height = infoView.bounds.height + UIApplication.shared.statusBarFrame.height / 2
            
            let infoLabel = UILabel()
            infoLabel.frame.size.width = infoLabel_Width
            infoLabel.frame.size.height = infoLabel_Height
            infoLabel.numberOfLines = 0
            
            infoLabel.text = message
            infoLabel.font = UIFont(name: "HelveticaNeue", size: fontSize12)
            infoLabel.textColor = .white
            infoLabel.textAlignment = .center
            
            infoView.addSubview(infoLabel)
            
            
            // animate info view
            UIView.animate(withDuration: 0.2, animations: {
                
                // move down infoView
                infoView.frame.origin.y = 0
                
                // if animation did finish
                }, completion: { (finished:Bool) in
                    
                    // if it is true
                    if finished {
                        
                        UIView.animate(withDuration: 0.1, delay: 3, options: .curveLinear, animations: {
                        
                            // move up infoView
                            infoView.frame.origin.y = infoView_Y
                        
                        // if finished all animations
                        }, completion: { (finished:Bool) in
                          
                            if finished {
                                infoView.removeFromSuperview()
                                infoLabel.removeFromSuperview()
                                self.infoViewIsShowing = false
                            }
                            
                        })
                        
                    }
                    
            })
            
            
        }
        
    }

    
    // func to pass to home page ro to tabBar
      @objc func login() {
          
          // refer to our Main.storyboard
          let storyboard = UIStoryboard(name: "Main", bundle: nil)
          
          // store our tabBar Object from Main.storyboard in tabBar var
          let taBar = storyboard.instantiateViewController(withIdentifier: "tabBar")
          
          // present tabBar that is storing in tabBar var
          window?.rootViewController = taBar
          
      }
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}


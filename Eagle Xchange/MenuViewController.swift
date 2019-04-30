//
//  MenuViewController.swift
//  Eagle Xchange
//
//  Created by Thomas Ronan on 4/27/19.
//  Copyright © 2019 Thomas Ronan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import GoogleSignIn

class MenuViewController: UIViewController {

    var eventOrg = ""
    var authUI: FUIAuth!
    
    @IBOutlet weak var welcomeLabel: UILabel!
    
    override func viewDidLoad() {
        authUI = FUIAuth.defaultAuthUI()
        authUI?.delegate = self
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        signIn()
        //welcomeLabel.text = "Welcome, user " + (Auth.auth().currentUser?.displayName)! + "!"
        
    }
    
    // Nothing should change unless you add different kinds of authentication.
    func signIn() {
        let providers: [FUIAuthProvider] = [
            FUIGoogleAuth(), FUIEmailAuth()]
        if authUI.auth?.currentUser == nil {
            self.authUI?.providers = providers
            present(authUI.authViewController(), animated: true, completion: nil)
        } else {
            //tableView hidden
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddEventDetail" {
            let destination = segue.destination as! EventDetailTableViewController
            if self.eventOrg == "BC" {
                destination.eventInfo.eventOrg = "BC"
            }
            else {
              destination.eventInfo.eventOrg = "Other"
            }
            destination.addingEvent = true
        }
    }
    
    @IBAction func ticketmasterTapped(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "ShowTicketmasterSearch", sender: nil)
    }
    
    @IBAction func bostonCollegePressed(_ sender: UITapGestureRecognizer) {
        eventOrg = "BC"
        performSegue(withIdentifier: "AddEventDetail", sender: nil)
    }
    @IBAction func otherPressed(_ sender: Any) {
        eventOrg = "Other"
        performSegue(withIdentifier: "AddEventDetail", sender: nil)
    }
    @IBAction func viewEventsPressed(_ sender: UITapGestureRecognizer) {
        print("View Events pressed!")
        performSegue(withIdentifier: "ShowEvents", sender: nil)
        
    }
    
    @IBAction func signOutPressed(_ sender: UIBarButtonItem) {
        do {
            try authUI!.signOut()
            print("^^^ Successfully signed out!")
            signIn()
        } catch {
            print("*** ERROR: Couldn't sign out")
        }
    }
    
}

extension MenuViewController: FUIAuthDelegate {
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        let sourceApplication = options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String?
        if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
            return true
        }
        // other URL handling goes here.
        return false
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        if let user = user {
            // Assumes data will be isplayed in a tableView that was hidden until login was verified so unauthorized users can't see data.
            print("^^^ We signed in with the user \(user.email ?? "unknown e-mail")")
        }
    }
    func authPickerViewController(forAuthUI authUI: FUIAuth) -> FUIAuthPickerViewController {
        
        // Create an instance of the FirebaseAuth login view controller
        let loginViewController = FUIAuthPickerViewController(authUI: authUI)
        
        // Set background color to white
        loginViewController.view.backgroundColor = UIColor.white
        
        // Create a frame for a UIImageView to hold our logo
        let marginInsets: CGFloat = 16 // logo will be 16 points from L and R margins
        let imageHeight: CGFloat = 225 // the height of our logo
        let imageY = self.view.center.y - imageHeight // places bottom of UIImageView in the center of the login screen
        let logoFrame = CGRect(x: self.view.frame.origin.x + marginInsets, y: imageY, width: self.view.frame.width - (marginInsets*2), height: imageHeight)
        
        // Create the UIImageView using the frame created above & add the "logo" image
        let logoImageView = UIImageView(frame: logoFrame)
        logoImageView.image = UIImage(named: "ticketLogo")
        logoImageView.contentMode = .scaleAspectFit // Set imageView to Aspect Fit
        loginViewController.view.addSubview(logoImageView) // Add ImageView to the login controller's main view
        return loginViewController
    }
}

//
//  ViewController.swift
//  Fill My Basket
//
//  Created by Vasanthkumar V on 04/06/17.
//  Copyright © 2017 Vasanthkumar V. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase
import FirebaseAuth
import GoogleSignIn


class ViewController: UIViewController, FBSDKLoginButtonDelegate, GIDSignInUIDelegate {

    @IBOutlet weak var FBLoginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        FBLoginButton = FBSDKLoginButton()
    }
    
    @IBAction func GoogleLogin(_ sender: UIButton) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func FBLogin(_ sender: UIButton) {
        FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile"], from: self) { (result, error) in
            if let err = error {
                print(err.localizedDescription)
                return
            }
            self.getUserDetails()
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("logged out from fb")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if let err = error {
            print(err)
            return
        }
        self.getUserDetails()
    }
    
    func getUserDetails() {
        let accessToken = FBSDKAccessToken.current()
        let credential = FacebookAuthProvider.credential(withAccessToken: accessToken!.tokenString)
        Auth.auth().signIn(with: credential) { (user, err) in
            if err != nil {
                print(err!.localizedDescription)
            }
            print("successfully logged in with the user", user!)
        }
       
        
        FBSDKGraphRequest.init(graphPath: "/me", parameters: ["fields":"id, name, email"]).start { (connection, user, error) in
            if let err = error {
                print(err.localizedDescription)
            }
            print(user!)
        }
    }

}


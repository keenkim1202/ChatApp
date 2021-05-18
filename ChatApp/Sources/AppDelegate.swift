//
//  AppDelegate.swift
//  ChatApp
//
//  Created by KEEN on 2021/04/26.
//

import UIKit
import Firebase
import FBSDKCoreKit
import GoogleSignIn

@main
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

  var window: UIWindow?
  
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    FirebaseApp.configure()
    ApplicationDelegate.shared.application(
        application,
        didFinishLaunchingWithOptions: launchOptions
    )
    
    GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
    GIDSignIn.sharedInstance()?.delegate = self
    
    return true
  }
  
  func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey : Any] = [:]
  ) -> Bool {
    // MARK: Facebook sign in
    ApplicationDelegate.shared.application(
      app,
      open: url,
      sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
      annotation: options[UIApplication.OpenURLOptionsKey.annotation]
    )
    // MARK: Google sign in
    return GIDSignIn.sharedInstance().handle(url)
  }
  
  func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
    // treat error
    guard error == nil else {
      if let error = error {
        print("Failed to sign in with Google: \(error)")
      }
      return
    }
    
    guard let user = user else { return }
    print("Did sign in with Google: \(user)")
    
    // check database if this email is exits.
    guard let email = user.profile.email,
          let firstName = user.profile.givenName,
          let lastName = user.profile.familyName else {
      return
    }
    
    DatabaseManager.shared.userExists(with: email) { exists in
      if !exists {
        // insert to databsae
        DatabaseManager.shared.insertUser(with: User(firstName: firstName,
                                                     lastName: lastName,
                                                     emailAddress: email))
      }
    }
    
    // treat accessToken
    guard let authentication = user.authentication else {
      print("Missing auth object off of google user.")
      return
    }
    let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                   accessToken: authentication.accessToken)
    
    FirebaseAuth.Auth.auth().signIn(with: credential) { authResult, error in
      guard authResult != nil, error == nil else {
        print("Failed to log in with google credential.")
        return
      }
      print("Successfully signed in with Google credential.")
      NotificationCenter.default.post(name: .didLogInNotification, object: nil)
    }
  }
  
  func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
    print("Google user was disconnected.")
  }
  
  func application(
    _ application: UIApplication,
    shouldAllowExtensionPointIdentifier extensionPointIdentifier: UIApplication.ExtensionPointIdentifier) -> Bool {
    if extensionPointIdentifier == UIApplication.ExtensionPointIdentifier.keyboard {
      return false
    }
    return true
  }
  
  // MARK: UISceneSession Lifecycle
  func application(
    _ application: UIApplication,
    configurationForConnecting connectingSceneSession: UISceneSession,
    options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }

  func application(
    _ application: UIApplication,
    didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
  }


}


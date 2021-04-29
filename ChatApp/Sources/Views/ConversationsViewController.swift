//
//  ViewController.swift
//  ChatApp
//
//  Created by KEEN on 2021/04/26.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit

class ConversationsViewController: UIViewController {

  // MARK: View Life-Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    validateAuth()
  }
  private func validateAuth() {
    if FirebaseAuth.Auth.auth().currentUser == nil {
      let vc = LoginViewController()
      let nav =  UINavigationController(rootViewController: vc)
      nav.modalPresentationStyle = .fullScreen
      present(nav, animated: false)
    }
  }
}


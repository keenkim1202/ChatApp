//
//  ViewController.swift
//  ChatApp
//
//  Created by KEEN on 2021/04/26.
//

import UIKit
import FirebaseAuth

class ConversationsViewController: UIViewController {

  // MARK: View Life-Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .red
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


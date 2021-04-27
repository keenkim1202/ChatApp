//
//  ViewController.swift
//  ChatApp
//
//  Created by KEEN on 2021/04/26.
//

import UIKit

class ConversationsViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .red
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    let isLoggedIn = UserDefaults.standard.bool(forKey: "logged_in")
    
    if !isLoggedIn {
      let vc = LoginViewController()
      let nav =  UINavigationController(rootViewController: vc)
      nav.modalPresentationStyle = .fullScreen
      present(nav, animated: false)
    }
  }

}


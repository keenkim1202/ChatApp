//
//  ProfileViewController.swift
//  ChatApp
//
//  Created by KEEN on 2021/04/26.
//

import UIKit
import Firebase
import FBSDKLoginKit

class ProfileViewController: UIViewController {
  // MARK: UI
  @IBOutlet var tableView: UITableView!
  
  // MARK: Properties
  let data = ["로그아웃"]
  
  // MARK: View Life-Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    tableView.delegate = self
    tableView.dataSource = self
  }
}

// MARK: UITableViewDelegate & UITableViewDataSource
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int) -> Int {
    return data.count
  }
  
  func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    cell.textLabel?.text = data[indexPath.row]
    cell.textLabel?.textAlignment = .center
    cell.textLabel?.textColor = .red
    return cell
  }
  
  func tableView(
    _ tableView: UITableView,
    didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    
    let actionSheet = UIAlertController(title: "알림", message: "로그아웃 하시겠습니까?", preferredStyle: .actionSheet)
    actionSheet.addAction(UIAlertAction(title: "로그아웃", style: .destructive, handler: { [weak self] _ in
      guard let strongSelf = self else { return }
      
      // Log out facebook
      FBSDKLoginKit.LoginManager().logOut()
      
      do {
        try FirebaseAuth.Auth.auth().signOut()
        
        let vc = LoginViewController()
        let nav =  UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        strongSelf.present(nav, animated: true)
      }
      catch {
        print("로그아웃 실패.")
      }
    }))
    actionSheet.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
    present(actionSheet, animated: true)
  }
}

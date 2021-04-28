//
//  DatabaseManager.swift
//  ChatApp
//
//  Created by KEEN on 2021/04/27.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager {
  static let shared = DatabaseManager()
  private let database = Database.database().reference()
}

// MARK: Account Management
extension DatabaseManager {
  public func userExists(with email: String, completion: @escaping ((Bool) -> Void)) {
    database.child(email).observeSingleEvent(of: .value) { (snapshot) in
      guard snapshot.value as? String != nil else {
        completion(false)
        return
      }
      completion(true)
    }
  }
  
  /// Insert new user to database
  public func insertUser(with user: User) {
    database.child(user.emailAddress).setValue([
      "first_name": user.firstName,
      "last_name": user.lastName
    ])
  }
}

struct User {
  let firstName: String
  let lastName: String
  let emailAddress: String
//  let profileUrl: String
}

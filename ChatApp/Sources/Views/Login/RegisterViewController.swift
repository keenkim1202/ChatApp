//
//  RegisterViewController.swift
//  ChatApp
//
//  Created by KEEN on 2021/04/26.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {
  // MARK: Properties
  private let scrollView: UIScrollView = {
    let v = UIScrollView()
    v.clipsToBounds = true
    v.backgroundColor = .yellow
    return v
  }()
  
  private let firstNameField: UITextField = {
    let v = UITextField()
    v.autocapitalizationType = .none
    v.autocorrectionType = .no
    v.returnKeyType = .continue
    v.layer.cornerRadius = 12
    v.layer.borderWidth = 1
    v.layer.borderColor = UIColor.lightGray.cgColor
    v.placeholder = "이름"
    v.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
    v.leftViewMode = .always
    v.backgroundColor = .white
    return v
  }()
  
  private let lastNameField: UITextField = {
    let v = UITextField()
    v.autocapitalizationType = .none
    v.autocorrectionType = .no
    v.returnKeyType = .continue
    v.layer.cornerRadius = 12
    v.layer.borderWidth = 1
    v.layer.borderColor = UIColor.lightGray.cgColor
    v.placeholder = "성"
    v.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
    v.leftViewMode = .always
    v.backgroundColor = .white
    return v
  }()
  
  private let emailField: UITextField = {
    let v = UITextField()
    v.autocapitalizationType = .none
    v.autocorrectionType = .no
    v.returnKeyType = .continue
    v.layer.cornerRadius = 12
    v.layer.borderWidth = 1
    v.layer.borderColor = UIColor.lightGray.cgColor
    v.placeholder = "이메일"
    v.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
    v.leftViewMode = .always
    v.backgroundColor = .white
    return v
  }()
  
  private let passwordField: UITextField = {
    let v = UITextField()
    v.autocapitalizationType = .none
    v.autocorrectionType = .no
    v.returnKeyType = .done
    v.layer.cornerRadius = 12
    v.layer.borderWidth = 1
    v.layer.borderColor = UIColor.lightGray.cgColor
    v.placeholder = "비밀번호"
    v.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
    v.leftViewMode = .always
    v.backgroundColor = .white
    v.isSecureTextEntry = true
    return v
  }()
  
  private let imageView: UIImageView = {
    let v = UIImageView()
    v.image = UIImage(systemName: "person.crop.circle.fill")
    v.tintColor = .gray
    v.contentMode = .scaleAspectFit
    v.layer.masksToBounds = true
    v.layer.borderWidth = 2
    v.layer.borderColor = UIColor.systemGreen.cgColor
    return v
  }()
  
  private let imageLabel: UILabel = {
    let v = UILabel()
    v.text = "프로필 추가"
    v.font = .systemFont(ofSize: 12)
    v.sizeToFit()
    return v
  }()
  
  private let registerButton: UIButton = {
    let v = UIButton()
    v.setTitle("가입", for: .normal)
    v.backgroundColor = .systemGreen
    v.layer.cornerRadius = 12
    v.layer.masksToBounds = true
    v.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
    return v
  }()
  
  // MARK: View Life-Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Log In"
    view.backgroundColor = .white
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "가입",
                                                        style: .done,
                                                        target: self,
                                                        action: #selector(didTapRegister))
    
    registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
    emailField.delegate = self
    passwordField.delegate = self
    
    // Add subviews
    view.addSubview(scrollView)
    scrollView.addSubview(imageView)
    scrollView.addSubview(imageLabel)
    scrollView.addSubview(firstNameField)
    scrollView.addSubview(lastNameField)
    scrollView.addSubview(emailField)
    scrollView.addSubview(passwordField)
    scrollView.addSubview(registerButton)
    
    imageView.isUserInteractionEnabled = true
    scrollView.isUserInteractionEnabled = true
    
    let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapChangeProfilePic))
    gesture.numberOfTouchesRequired = 1
    gesture.numberOfTapsRequired = 1
    imageView.addGestureRecognizer(gesture)
  }
  
  @objc private func didTapChangeProfilePic() {
    presentPhotoActionSheet()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    scrollView.frame = view.bounds
    
    let size = view.width / 5
    let centerX = scrollView.center.x
    imageView.frame = CGRect(x: centerX - (size / 2),
                             y: 40,
                             width: size,
                             height: size)
    imageView.layer.cornerRadius = imageView.width / 2
    imageLabel.frame = CGRect(x: centerX - (imageLabel.width / 2),
                              y: imageView.bottom,
                              width: imageLabel.width,
                              height: 30)
    firstNameField.frame = CGRect(x: 30,
                              y: imageLabel.bottom + 15,
                              width: scrollView.width - 60,
                              height: 52)
    lastNameField.frame = CGRect(x: 30,
                              y: firstNameField.bottom + 10,
                              width: scrollView.width - 60,
                              height: 52)
    emailField.frame = CGRect(x: 30,
                              y: lastNameField.bottom + 10,
                              width: scrollView.width - 60,
                              height: 52)
    passwordField.frame = CGRect(x: 30,
                                 y: emailField.bottom + 10,
                                 width: scrollView.width - 60,
                                 height: 52)
    registerButton.frame = CGRect(x: 30,
                               y: passwordField.bottom + 10,
                               width: scrollView.width - 60,
                               height: 52)
  }
  
  @objc private func registerButtonTapped() {
    emailField.resignFirstResponder()
    passwordField.resignFirstResponder()
    firstNameField.resignFirstResponder()
    lastNameField.resignFirstResponder()

    guard
      let firstName = firstNameField.text,
      let lastName = lastNameField.text,
      let email = emailField.text,
      let password = passwordField.text,
      !email.isEmpty, !password.isEmpty,
      !firstName.isEmpty, !lastName.isEmpty,
      password.count >= 6 else {
      alertUserLoginError()
      return
    }
    
    // Firebase Log In
    FirebaseAuth.Auth.auth().createUser(withEmail: email,
                                        password: password) { [weak self](result, error) in
      guard let strongSelf = self else { return }
      guard let result = result, error == nil else {
        print("계정 생성 시 에러가 발생.")
        return
      }
      let user = result.user
      print("생성된 계정: \(user )")
      strongSelf.navigationController?.dismiss(animated: true, completion: nil)
    }
  }
  
  func alertUserLoginError() {
    let alert = UIAlertController(title: "⚠️", message: "모든 정보를 입력해주세요.", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "닫기", style: .cancel, handler: nil))
    present(alert, animated: true)
  }
  
  @objc private func didTapRegister() {
    let vc = RegisterViewController()
    vc.title = "계정 생성"
    navigationController?.pushViewController(vc, animated: true)
  }
}

// MARK: UITextFieldDelegate
extension RegisterViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == emailField {
      passwordField.becomeFirstResponder()
    } else if textField == passwordField {
      registerButtonTapped()
    }
    return true
  }
}

// MARK: UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func presentPhotoActionSheet() {
    let actionSheet = UIAlertController(title: "프로필 편집",
                                        message: "프로필을 추가하시겠습니까?",
                                        preferredStyle: .actionSheet)
    actionSheet.addAction(UIAlertAction(title: "취소",
                                        style: .cancel,
                                        handler: nil))
    actionSheet.addAction(UIAlertAction(title: "카메라",
                                        style: .default,
                                        handler: { [weak self] _ in
                                          self?.presentCamera()
                                        }))
    actionSheet.addAction(UIAlertAction(title: "사진첩",
                                        style: .default,
                                        handler: { [weak self] _ in
                                          self?.presentPhotoPicker()
                                        }))
    present(actionSheet, animated: true)
  }
  
  func presentCamera() {
    let vc = UIImagePickerController()
    vc.sourceType = .camera
    vc.delegate = self
    vc.allowsEditing = true
    present(vc, animated: true)
  }
  
  func presentPhotoPicker() {
    let vc = UIImagePickerController()
    vc.sourceType = .photoLibrary
    vc.delegate = self
    vc.allowsEditing = true
    present(vc, animated: true)
  }
  
  func imagePickerController(
    _ picker: UIImagePickerController,
    didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    picker.dismiss(animated: true, completion: nil)
    guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
      return
    }
    self.imageView.image = selectedImage
  }
  func imagePickerControllerDidCancel(
    _ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
  }
}

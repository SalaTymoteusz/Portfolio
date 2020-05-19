//
//  ViewController.swift
//  EncryptedNotepad_v2.0
//
//  Created by xxx on 24/10/2019.
//  Copyright © 2019 xxx. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import AVFoundation
import CommonCrypto
import LocalAuthentication


class ViewController: UIViewController {
    
    // Outlets
    // UIView of all four password dots
    @IBOutlet weak var keycode1: UIView!
    @IBOutlet weak var keycode2: UIView!
    @IBOutlet weak var keycode3: UIView!
    @IBOutlet weak var keycode4: UIView!
    @IBOutlet weak var infoLabel: UILabel! // infoLabel is label above dots, showing actual informations for user
    @IBOutlet weak var passCodeCollectionView: UICollectionView!
    
    // Variables
    var user = User()
    var codeKeys = PassCodeKeyData()
    var inputKeycode : [String] = [] // array for code
    var editButtonTapped : Bool = false // variable = true when user taped 'Edit' button

    // Constant
    let numberPadCollectionViewCell = "NumberPadCollectionViewCell"
    let textPadCollectionViewCell = "TextPadCollectionViewCell"
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        save()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setCollectionView()
        self.clearInputKeycodeView()
        KeychainWrapper.standard.set("1111", forKey: "code")
        KeychainWrapper.standard.set(true, forKey: "isCode")
        print(user)
        user = Services.getUserData()
        print(user)
        firstSetOfInfoLabel(user: user)
    }
    
    private func setKeyCodeView(keyCode: UIView, backgroundColor: UIColor = UIColor.clear) -> Void {
        keyCode.layer.cornerRadius = 10
        keyCode.layer.borderWidth = 1
        keyCode.layer.borderColor = UIColor.black.cgColor
        keyCode.backgroundColor = backgroundColor
    }
    
    // function set up view of dots
    private func setKeysCodeView() -> Void {
        setKeyCodeView(keyCode: keycode1)
        setKeyCodeView(keyCode: keycode2)
        setKeyCodeView(keyCode: keycode3)
        setKeyCodeView(keyCode: keycode4)
    }
    
    private func setInfoLabel(text: String, textColor: UIColor) -> Void {
        infoLabel.text = text
        infoLabel.textColor = textColor
    }

    private func setCollectionView() -> Void {
        self.passCodeCollectionView.register(UINib(nibName: self.numberPadCollectionViewCell, bundle: nil),  forCellWithReuseIdentifier: self.numberPadCollectionViewCell)
        self.passCodeCollectionView.register(UINib(nibName: self.textPadCollectionViewCell, bundle: nil),  forCellWithReuseIdentifier: self.textPadCollectionViewCell)
        self.passCodeCollectionView.dataSource = self
        self.passCodeCollectionView.delegate = self
    }
    
    private func clearInputKeycodeView() -> Void {
         self.inputKeycode = []
         self.setKeysCodeView()
     }
    
    private func changeButton(status: Int, title: String) -> Void {
        clearInputKeycodeView()
        codeKeys.passCodeKeyData.removeLast()
        codeKeys.passCodeKeyData.append(PassCodeKeyStruct(status: status, title: title, value: ""))
    }
    
    private func firstSetOfInfoLabel(user: User) -> Void {
        // After run, check if the user has blocked the application after too many incorrectly entered codes
        if user.delay != 0 {
            runTimer()
        }else {
            if user.code == true {
                setInfoLabel(text: "Enter code", textColor: UIColor.black)
            } else {
                setInfoLabel(text: "Enter new code", textColor: UIColor.black)
            }
        }
    }
    
    // what is going after enter 1-4 code char
    private func inputKeycodeAction() {
        setKeysCodeView()
        print(user.delay)
        if user.delay == 0 {
            switch inputKeycode.count {
            case 1:
                setKeyCodeView(keyCode: keycode1, backgroundColor: UIColor.lightGray)
            case 2:
                setKeyCodeView(keyCode: keycode1, backgroundColor: UIColor.lightGray)
                setKeyCodeView(keyCode: keycode2, backgroundColor: UIColor.lightGray)
            case 3:
                setKeyCodeView(keyCode: keycode1, backgroundColor: UIColor.lightGray)
                setKeyCodeView(keyCode: keycode2, backgroundColor: UIColor.lightGray)
                setKeyCodeView(keyCode: keycode3, backgroundColor: UIColor.lightGray)
            case 4:
                self.setKeyCodeView(keyCode: self.keycode1, backgroundColor: UIColor.lightGray)
                self.setKeyCodeView(keyCode: self.keycode2, backgroundColor: UIColor.lightGray)
                self.setKeyCodeView(keyCode: self.keycode3, backgroundColor: UIColor.lightGray)
                self.setKeyCodeView(keyCode: self.keycode4, backgroundColor: UIColor.lightGray)
                
                if user.allowToCreateNewCode == true {
                    createCode()
                    break
                }
                
                if editButtonTapped == true && user.allowToCreateNewCode == false {
                    authorization(action: runProcessOfChangingCode)
                }
                
                if editButtonTapped == false && user.allowToCreateNewCode == false {
                    authorization(action: logIn)
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.clearInputKeycodeView()
                }
                
            default:
                print("Error inputKeyCode count")
                clearInputKeycodeView()
            }
        } else {
            print("Access blocked")
            clearInputKeycodeView()
        }
    }
    
    private func save() -> Void {
        print("saving \(user)")
        Services.saveUserData(user: user)
    }
    
    private func runTimer() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.user.delay -= 1
            self.setInfoLabel(text: "Wait: \(self.user.delay) seconds", textColor: UIColor.red)
            
            if self.user.delay < 1 {
                timer.invalidate()
                self.user.delay = 0
                self.setInfoLabel(text: "Enter code", textColor: UIColor.black)
            }
        }
    }
    
    private func logIn() -> Void {
        navigatedToNote()
        print("loading...")
    }
        
    private func runProcessOfChangingCode() -> Void {
        print("start process of changing code")
        setInfoLabel(text: "Enter new code", textColor: UIColor.black)
        user.allowToCreateNewCode = true
    }
    
    private func createCode() -> Void {
        let input = inputKeycode.joined(separator: "")
        user.code = Services.createNewCode(newCode: input)
        clearInputKeycodeView()
        editButtonTapped = false
        user.allowToCreateNewCode = false
        setInfoLabel(text: "Enter code", textColor: UIColor.black)
        print("new code set")
    }
    
    private func navigatedToNote() -> Void{
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let noteVC = (mainStoryboard.instantiateViewController(withIdentifier: "noteView") as? NoteViewController)!
        self.navigationController!.pushViewController(noteVC, animated: true)
    }
    
    private func authorization(action: () -> Void) -> Void {
        let input = inputKeycode.joined(separator: "")
         switch Services.checkPassword(code: input) {
         case true:
            action()
            user.counterOfWrongAnswers = 0
         case false:
            UIDevice.vibrate()
            if user.incrementCounter() == true {
                runTimer()
            }
            print("wrong password, counter: \(user.counterOfWrongAnswers), delay: \(user.delay))")
        }
    }
    
    
    @IBAction func authenticationWithTouchID(_ sender: Any) {
        let context: LAContext = LAContext()
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
            context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Put your finger", reply: {(success, error) in
                if success {
                    DispatchQueue.main.async {
                        self.navigatedToNote()
                    }
                } else {
                    UIDevice.vibrate()
                }})
        } else {
            print("Authentication error")
        }
    }
}


// added a feature that causes device vibration
extension UIDevice {
    static func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
}

extension ViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.codeKeys.passCodeKeyData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = self.codeKeys.passCodeKeyData[indexPath.row]
        if data.status == 0 {
            let numCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.numberPadCollectionViewCell, for: indexPath) as! NumberPadCollectionViewCell
            numCell.setupCell(title: data.title)
            return numCell
        }
        let textCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.textPadCollectionViewCell, for: indexPath) as! TextPadCollectionViewCell
        textCell.setupCell(title: data.title)
        return textCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / 3
        let height = width
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // last pressed key
        let data = self.codeKeys.passCodeKeyData[indexPath.row]
        switch data.status {
        case 0:
            self.inputKeycode.append(data.value)
            self.inputKeycodeAction()
        case 1:
            self.clearInputKeycodeView()
        case 2:
            if user.delay == 0 {
                changeButton(status: 3, title: "Cancle")
                collectionView.reloadData()
            }
            if user.delay == 0 && user.code == true {
                setInfoLabel(text: "Confirm password", textColor: UIColor.black)
                editButtonTapped = true
            }
        case 3:
            editButtonTapped = false
            setInfoLabel(text: "Enter code", textColor: UIColor.black)
            changeButton(status: 2, title: "Edit")
            collectionView.reloadData()
        default:
            print("Error passCodeKeyData status")
        
        }
    }
}

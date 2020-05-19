//
//  NoteViewController.swift
//  EncryptedNotepad_v2.0
//
//  Created by xxx on 24/10/2019.
//  Copyright © 2019 xxx. All rights reserved.
//

import UIKit

class NoteViewController: UIViewController, UITextViewDelegate {
    

    @IBOutlet weak var textView: UITextView!

    @objc func dismissKeyboard() {
      view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        textView.text = Encryptor.decrypt()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if self.isMovingFromParent {
            Encryptor.encrypt(text: textView.text)
        }
    }

    //getting text
    func textViewDidEndEditing(_ textView: UITextView) {
        Encryptor.encrypt(text: textView.text)
    }
    


    
    
    
    
}

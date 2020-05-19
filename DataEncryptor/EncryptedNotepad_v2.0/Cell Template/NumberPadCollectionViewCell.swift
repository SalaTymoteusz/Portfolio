//
//  NumberPadCollectionViewCell.swift
//  EncryptedNotepad_v2.0
//
//  Created by xxx on 24/10/2019.
//  Copyright © 2019 xxx. All rights reserved.
//

import UIKit

class NumberPadCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var keyView: UIView!
    @IBOutlet weak var keyLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()

        self.keyView.layer.cornerRadius = 36
        self.keyView.layer.borderWidth = 2
        self.keyView.layer.borderColor = UIColor.black.cgColor
        self.keyView.layer.backgroundColor = UIColor.white.cgColor
        self.keyLabel.textColor = UIColor.black
    }
    
    func setupCell(title: String) {
        self.keyLabel.text = title
    }
    
}

//
//  CopypastaButton.swift
//  Copypasta MessagesExtension
//
//  Created by Christian Chernock on 1/2/24.
//

import Foundation
import UIKit

class AddNewPastaUIButton: UIButton {
    var delegate: AddNewPastaUIButtonDelegate?
    
    init() {
        // Init
        super.init(frame: .zero)
        
        // Style button
        super.setTitle("+ Add new...", for: .normal)
        super.titleLabel?.font = UIFont(name: "Futura-Bold", size: 20)
        super.setTitleColor(.systemBlue, for: .normal)
        super.contentHorizontalAlignment = .left
        super.layer.borderColor = UIColor.black.cgColor
        super.layer.borderWidth = 1
        super.layer.cornerRadius = 8
        super.backgroundColor = UIColor(red: 0.041, green: 0.375, blue: 0.998, alpha: 0.05)
        
        // Add button action
        super.addTarget(self, action: #selector(addNewButtonPressedAction), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Button actions
    
    @IBAction func addNewButtonPressedAction(_ sender: UIButton) {
        
        let colorAnimation = CABasicAnimation(keyPath: "backgroundColor")
        colorAnimation.fromValue = UIColor(red: 0.041, green: 0.375, blue: 0.998, alpha: 0.25).cgColor
        colorAnimation.duration = 0.25  // animation duration
        sender.layer.add(colorAnimation, forKey: "ColorPulse")
        
        delegate?.showPastaEntryView()
    }
}

protocol AddNewPastaUIButtonDelegate: AnyObject {
    func showPastaEntryView()
}

//
//  CopypastaButton.swift
//  Copypasta MessagesExtension
//
//  Created by Christian Chernock on 1/2/24.
//

import Foundation
import UIKit

class CopypastaUIButton: UIButton {
    var pasta: Pasta?
    var delegate: PastaUIButtonDelegate?
    
    init(_ pasta: Pasta) {
        // Init
        self.pasta = pasta
        super.init(frame: .zero)
        
        // Style button
        super.setTitle(pasta.text, for: .normal)
        super.titleLabel?.font = UIFont(name: "Futura", size: 20)
        super.setTitleColor(.systemBlue, for: .normal)
        super.contentHorizontalAlignment = .left
        super.layer.borderColor = UIColor.black.cgColor
        super.layer.borderWidth = 1
        super.layer.cornerRadius = 8
        
        // Add button actions
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(pastaMessageTappedAction))
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(pastaMessageLongPressAction))
        super.addGestureRecognizer(tapGesture)
        super.addGestureRecognizer(longGesture)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Button actions
    
    @IBAction func pastaMessageTappedAction(_ gesture: UITapGestureRecognizer) {
        
        guard let sender = gesture.view as? CopypastaUIButton else {
            print("Sender is not a button")
            return
        }
        
        let colorAnimation = CABasicAnimation(keyPath: "backgroundColor")
        colorAnimation.fromValue = UIColor.lightGray.cgColor
        colorAnimation.duration = 0.25  // animation duration
        sender.layer.add(colorAnimation, forKey: "ColorPulse")
        
        // Send text
        delegate?.sendPastaText(self.pasta!.text!)
        
        // Update date last used
        self.pasta?.lastUsed = Date()
        PastaDatabase.shared.updateContext()
    }
    
    @IBAction func pastaMessageLongPressAction(_ gesture: UILongPressGestureRecognizer) {
        
        guard let sender = gesture.view as? CopypastaUIButton else {
            print("Sender is not a button")
            return
        }
        // Make button look pressed
        sender.backgroundColor = UIColor.lightGray
        
        // Create new alert
        let alert = UIAlertController(title: "Delete?",
                                      message: "Delete this pasta?",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Delete",
                                       style: .destructive) { _ in
            PastaDatabase.shared.deleteFromContext(pasta: self.pasta!)
            sender.removeFromSuperview()
            sender.backgroundColor = .clear
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel) { _ in
            sender.backgroundColor = .clear
        }
        
        // Add actions and present alerts
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        delegate?.showDeleteAlert(alert)
    }
}

protocol PastaUIButtonDelegate: AnyObject {
    func showDeleteAlert(_ alert: UIAlertController)
    func sendPastaText(_ text: String)
}

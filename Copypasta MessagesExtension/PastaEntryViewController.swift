//
//  PastaEntryForm.swift
//  Copypasta MessagesExtension
//
//  Created by Christian Chernock on 12/31/23.
//

import Foundation
import UIKit

public class PastaEntryViewController: UIViewController {
    static let storyboardIdentifier = "PastaEntryForm"
    var delegate: PastaEntryFormDelegate?
    
    @IBOutlet weak var cancelEntryBttn: UIButton!
    @IBOutlet weak var doneBttn: UIButton!
    
    @IBOutlet weak var pastaPotForm: UITextView!
    @IBOutlet weak var toolbarStackView: UIStackView!
    
    @IBAction func cancelEntryPressed(_ sender: UIButton) {
        closeView()
    }
    
    @IBAction func doneBttnPressed(_ sender: UIButton) {
        self.delegate?.pastaEntered(pastaPotForm.text)
        closeView()
    }
    
    fileprivate func closeView() {
        self.view.removeFromSuperview()
        willMove(toParent: nil)
        removeFromParent()
    }
}

protocol PastaEntryFormDelegate: AnyObject {
    func pastaEntered(_ pasta: String)
}

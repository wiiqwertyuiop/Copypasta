//
//  MessagesViewController.swift
//  Copypasta MessagesExtension
//
//  Created by Christian Chernock on 12/29/23.
//

import UIKit
import Messages
import CoreData

class MessagesViewController: MSMessagesAppViewController {
    
    @IBOutlet weak var viewLayout: UIStackView!
    
    // MARK: - Setup view
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createButtons()
    }
    
    fileprivate func createButtons() {
        // + Add new button
        let button = AddNewPastaUIButton()
        button.delegate = self
        viewLayout.addArrangedSubview(button)
        
        // Add copypastas above the add new button
        for pasta in PastaDatabase.shared.getStoredDataFromCoreData() {
            addNewPastaButtonToLayout(pasta)
        }
    }
    
    fileprivate func addNewPastaButtonToLayout(_ newPasta: Pasta) {
        let button = CopypastaUIButton(newPasta)
        button.delegate = self
        viewLayout.insertArrangedSubview(button, at: viewLayout.arrangedSubviews.count - 1)
    }
}

// MARK: - Delegates

extension MessagesViewController: PastaEntryFormDelegate {
    func pastaEntered(_ pasta: String) {
        addNewPastaButtonToLayout(PastaDatabase.shared.createNewContext(text: pasta))
    }
}

extension MessagesViewController: PastaUIButtonDelegate {
    func sendPastaText(_ text: String) {
        guard let conversation = activeConversation else { fatalError("Expected a conversation") }
        conversation.insertText(text) { error in
            if let error = error {
                print(error)
            }
        }
    }
    
    func showDeleteAlert(_ alert: UIAlertController) {
        present(alert, animated: true)
    }
}

extension MessagesViewController: AddNewPastaUIButtonDelegate {
    func showPastaEntryView() {
        let viewcontroller = self.storyboard?.instantiateViewController(withIdentifier: PastaEntryViewController.storyboardIdentifier) as! PastaEntryViewController
        viewcontroller.delegate = self
        addChild(viewcontroller)
        
        viewcontroller.view.frame = view.bounds
        viewcontroller.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(viewcontroller.view)
        
        viewcontroller.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        viewcontroller.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        viewcontroller.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        viewcontroller.view.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor).isActive = true
        
        viewcontroller.didMove(toParent: self)
    }
}


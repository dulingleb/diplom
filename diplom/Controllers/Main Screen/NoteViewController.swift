//
//  NoteViewController.swift
//  diplom
//
//  Created by Dulin Gleb on 29.1.24..
//

import UIKit

class NoteViewController: UIViewController {
    private let noteTextView: UITextView = {
        let noteTextView = UITextView()
        noteTextView.backgroundColor = .white
        noteTextView.layer.cornerRadius = 12
        noteTextView.font = UIFont.systemFont(ofSize: 17)
        
        return noteTextView
    }()
    
    private let saveButton: UIButton = {
        var saveButtonConfig = UIButton.Configuration.filled()
        saveButtonConfig.cornerStyle = .capsule
        let saveButton = UIButton(configuration: saveButtonConfig)
        saveButton.setTitle("Save", for: .normal)
        saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        return saveButton
    }()
    
    var noteOnChange: ((String?) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Note"
        view.backgroundColor = .secondarySystemBackground
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)

        saveButton.addTarget(self, action: #selector(saveButtonTaped), for: .touchUpInside)

        
        view.addSubview(noteTextView)
        view.addSubview(saveButton)
        
        noteTextView.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            noteTextView.topAnchor.constraint(equalTo: view.topAnchor, constant: 62),
            noteTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            noteTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            noteTextView.heightAnchor.constraint(equalToConstant: 112)
        ])
        
        noteTextView.becomeFirstResponder()
        
        navigationItemSetup()
    }
    
    private func navigationItemSetup() {
        
        // Кнопка закрытия
        let closeButtonContainer = CloseButtonContainer()
        
        closeButtonContainer.closeButton.closeButtonAction = {[weak self] in
            self?.closeTapped()
        }

        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: closeButtonContainer)
    }
    
    public func setText(_ text: String?) {
        self.noteTextView.text = text
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            NSLayoutConstraint.activate([
                saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                saveButton.heightAnchor.constraint(equalToConstant: 50),
                saveButton.widthAnchor.constraint(equalToConstant: 200),
                saveButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -keyboardSize.height - 16)
            ])
        }
    }
    
    @objc func closeTapped() {
        dismiss(animated: true)
    }
    
    @objc func saveButtonTaped() {
        noteOnChange?(self.noteTextView.text)
        dismiss(animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }

}

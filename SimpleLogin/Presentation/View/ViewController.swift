//
//  ViewController.swift
//  SimpleLogin
//
//  Created by Jose Galindo Martinez on 30/09/20.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    // UI
    @IBOutlet weak var usrText: UITextField!
    @IBOutlet weak var pwdText: UITextField!
    @IBOutlet weak var termsSwitch: UISwitch!
    @IBOutlet weak var acceptBtn: UIButton!
    
    // Properties
    private var cancellables = Set<AnyCancellable>()
    private var viewModel = ViewModelImplementation()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        bindButton()
        viewModel.viewDidLoad.send()
    }

    
    @IBAction func usrChaged(_ sender: UITextField) {
        viewModel.userInput.send(sender.text ?? "")
    }
    
    @IBAction func pwdChanged(_ sender: UITextField) {
        print("Text \(sender.text)")
        viewModel.passwdInput.send(sender.text ?? "")
    }
    
    @IBAction func switchChanged(_ sender: Any) {
        viewModel.switchValid.send(self.termsSwitch.isOn)
    }
    
    @IBAction func acceptTapped(_ sender: Any) {
    }
    
}

extension ViewController {
    
    func bindButton() {
        viewModel.isValidOptions.sink { (isOk) in
            let color: UIColor = isOk ? .green : .lightGray
            self.acceptBtn.backgroundColor = color
            self.acceptBtn.isEnabled = isOk
        }.store(in: &cancellables)
    }
    
}

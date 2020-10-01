//
//  ViewModel.swift
//  SimpleLogin
//
//  Created by Jose Galindo Martinez on 30/09/20.
//

import Foundation
import Combine

protocol ViewModel: class {
    
    // inputs
    var viewDidLoad: PassthroughSubject<Void, Never> { get }
    var userInput: PassthroughSubject<String, Never> { get }
    var passwdInput: PassthroughSubject<String, Never> { get }
    var switchValid: PassthroughSubject<Bool, Never> { get }
    
    // Output
    var isValidOptions: CurrentValueSubject<Bool, Never> { get }
}

class ViewModelImplementation: ViewModel {
    // Inputs
    var viewDidLoad = PassthroughSubject<Void, Never>()
    var userInput = PassthroughSubject<String, Never>()
    var passwdInput = PassthroughSubject<String, Never>()
    var switchValid = PassthroughSubject<Bool, Never>()
    
    // Outputs
    var isValidOptions = CurrentValueSubject<Bool, Never>(false)
    
    // private properties
    private var cancelables = Set<AnyCancellable>()
    
    init() {
        bindOnDidLoad()
        bindTextInputs()
    }
    
    private func bindOnDidLoad() {
        viewDidLoad.sink { (_) in
            print("ViewModel did load")
        }.store(in: &cancelables)
    }
    
    private func bindTextInputs() {
        Publishers.CombineLatest3(userInput, passwdInput, switchValid)
            .map { (usrName, usrPwd, acceptTerms) -> (String, String, Bool) in
                return (usrName, usrPwd, acceptTerms)
            }.map { (usrName, usrPwd, terms) -> Bool in
                return (!usrName.isEmpty) &&
                    (!usrPwd.isEmpty) &&
                    usrPwd.count >= 8 && terms
            }.sink { (validC) in
                print("Termine con \(validC)")
                self.isValidOptions.send(validC)
            }.store(in: &cancelables)
    }
}

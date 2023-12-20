//
//  AuthService.swift
//  RickAndMorty
//
//  Created by Lex Sava on 30.11.2023.
//

import Foundation

protocol AuthServiceProtocol {
    func login()
    func logout()
}

class AuthService: AuthServiceProtocol {
    
    func login() {
        
    }
    
    func logout() {
        
    }
}

class StubAuthService: AuthServiceProtocol {
    func login() { }
    func logout() { }
}

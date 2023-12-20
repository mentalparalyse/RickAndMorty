//
//  NavigationController.swift
//  RickAndMorty
//
//  Created by Lex Sava on 30.11.2023.
//

import UIKit

@MainActor
class NavigationController: UINavigationController {
    
    convenience init(isNavigationBarHidden: Bool = true, delegate: NavigationControllerDelegateProxy? = nil) {
        self.init(nibName: nil, bundle: nil)
        
        self.isNavigationBarHidden = isNavigationBarHidden
        self.delegate = delegate
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//
//  TransitionAction.swift
//  RickAndMorty
//
//  Created by Lex Sava on 12.12.2023.
//

import SwiftUI

enum TransitionAction {
    case push(animated: Bool)
    case present(
        animated: Bool = true,
        modalPresentationStyle: UIModalPresentationStyle = .automatic,
        delegate: UIViewControllerTransitioningDelegate? = nil,
        _ completion: (() -> Void)? = nil
    )
}

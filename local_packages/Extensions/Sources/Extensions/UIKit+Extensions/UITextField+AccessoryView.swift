//
//  UITextField+AccessoryView.swift
//
//  Created by SOLVEIT on 16.11.21.
//  Copyright © 2021 SOLVEIT. All rights reserved.

import UIKit

public extension UITextField {
    /// Height of an inputAccessoryView for UIToolbar after call _addDoneAccessoryView_.
    /// Default value is 50 points
    static let inputAccessoryViewHeight: CGFloat = 50
        
    /// Call these method to add UIToolbar to inputAccessoryView
    /// - Parameters:
    ///   - title: action button title
    ///   - action: callback that invokes when button pressed. By default value is nil (call _resignFirstResponder_ when button pressed)
    func addDoneAccessoryView(
        title: String = "Done",
        action: Selector? = nil
    ) {
        let doneAction: Selector = action ?? #selector(resignFirstResponder)
        let toolbar = UIToolbar.makeInputAccessoryToolbar(
            rightActionTitle: title,
            actionTarget: self,
            rightAction: doneAction
        )
        inputAccessoryView = toolbar
        self.reloadInputViews()
    }
}

private extension UIToolbar {
    /// Height of an inputAccessoryView for UIToolbar after call _addDoneAccessoryView_.
    /// Default value is 50 points
    static let inputAccessoryViewHeight: CGFloat = 50
    
    static func makeInputAccessoryToolbar(
        rightActionTitle: String = "Done",
        actionTarget: Any,
        rightAction: Selector
    ) -> UIToolbar {
        let toolbarSize = CGSize(
            width: UIScreen.main.bounds.width,
            height: UITextField.inputAccessoryViewHeight
        )
        let toolbarFrame = CGRect(origin: .zero, size: toolbarSize)
        let doneToolbar = UIToolbar(frame: toolbarFrame)
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )
        
        let done = UIBarButtonItem(
            title: rightActionTitle,
            style: .done,
            target: actionTarget,
            action: rightAction
        )
        
        doneToolbar.items = [flexSpace, done]
        doneToolbar.sizeToFit()
        return doneToolbar
    }
}

public extension UITextView {
    /// Call these method to add UIToolbar to inputAccessoryView
    /// - Parameters:
    ///   - title: action button title
    ///   - action: callback that invokes when button pressed. By default value is nil (call _resignFirstResponder_ when button pressed)
    func addDoneAccessoryView(
        title: String = "Done",
        action: Selector? = nil
    ) {
        let doneAction: Selector = action ?? #selector(resignFirstResponder)
        let toolbar = UIToolbar.makeInputAccessoryToolbar(
            rightActionTitle: title,
            actionTarget: self,
            rightAction: doneAction
        )
        inputAccessoryView = toolbar
    }
}

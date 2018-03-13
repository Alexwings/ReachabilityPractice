//
//  Extensions.swift
//  NetworkReachability
//
//  Created by Xinyuan's on 3/1/18.
//  Copyright © 2018 Xinyuan Wang. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    
    func layout(top: NSLayoutYAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, leading: NSLayoutXAxisAnchor? = nil, trailing: NSLayoutXAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, right:NSLayoutXAxisAnchor? = nil,  height: NSLayoutDimension? = nil, width: NSLayoutDimension? = nil, centerX: NSLayoutXAxisAnchor? = nil, centerY: NSLayoutYAxisAnchor? = nil, constants: [NSLayoutConstraint.LayoutPosition : CGFloat]) {
        self.translatesAutoresizingMaskIntoConstraints = false
        if let top = top {
            let constraint = topAnchor.constraint(equalTo: top)
            constraint.type = .top
            constraint.isActive = true
        }
        
        if let const = constants[.top] {
            self.
        }
        
    }
    
    func constraint(for type: NSLayoutConstraint.LayoutPosition) -> NSLayoutConstraint {
        
    }
    
    private func constraint(for type: NSLayoutConstraint.LayoutPosition, startIndex: Int, endIndex: Int, at index: Int) -> NSLayoutConstraint? {
        
    }
}

extension NSLayoutConstraint {
    
    enum LayoutPosition: String {
        case top = "Top", bottom = "Bottom", leading = "Leading", trailing = "Trailing", left = "Left", right = "Right", height = "Height", width = "Width", centerX = "CenterX", centerY = "CenterY"
    }
    
    var type: LayoutPosition? {
        get {
            guard let id = self.identifier else { return nil }
            return LayoutPosition(rawValue: id)
        }
        set {
            self.identifier = newValue?.rawValue
        }
    }
}

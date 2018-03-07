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
    enum LayoutPosition: String {
        case top = "LayoutPositionTop", bottom = "LayoutPositionBottom", leading = "LayoutPositionLeading", trailing = "LayoutPositionTrailing", left = "LayoutPositionLeft", right = "LayoutPositionRight", height = "LayoutPositionHeight", width = "LayoutPositionWidth", centerX = "LayoutPositionCenterX", centerY = "LayoutPositionCenterY"
    }
    
    func autoLayout (top: NSLayoutAnchor<NSLayoutYAxisAnchor>? = nil, bottom: NSLayoutAnchor<NSLayoutYAxisAnchor>? = nil, leading: NSLayoutAnchor<NSLayoutXAxisAnchor>? = nil, trailing: NSLayoutAnchor<NSLayoutXAxisAnchor>? = nil, left: NSLayoutAnchor<NSLayoutXAxisAnchor>? = nil, right:NSLayoutAnchor<NSLayoutXAxisAnchor>? = nil,  height: NSLayoutAnchor<NSLayoutDimension>? = nil, width: NSLayoutAnchor<NSLayoutDimension>? = nil, constants: [LayoutPosition : CGFloat]) {
        self.translatesAutoresizingMaskIntoConstraints = false
        let _ = setLayout(for: .top, anchor: top, constant: constants[.top])
        let _ = setLayout(for: .bottom, anchor: bottom, constant: constants[.bottom])
        let _ = setLayout(for: .leading, anchor: leading, constant: constants[.leading])
        let _ = setLayout(for: .trailing, anchor: trailing, constant: constants[.trailing])
        let _ = setLayout(for: .left, anchor: left, constant: constants[.left])
        let _ = setLayout(for: .right, anchor: right, constant: constants[.right])
        let _ = setLayout(for: .height, anchor: height, constant: constants[.height])
        let _ = setLayout(for: .width, anchor: width, constant: constants[.width])
    }
    
    func centerLayout(centerX: NSLayoutXAxisAnchor? = nil, centerY: NSLayoutYAxisAnchor? = nil) {
        let _ = setLayout(for: .centerX, anchor: centerX, constant: nil)
        let _ = setLayout(for: .centerY, anchor: centerY, constant: nil)
    }
    
    func setLayout<T>(for pos: LayoutPosition, anchor: NSLayoutAnchor<T>?, constant: CGFloat?) -> NSLayoutConstraint? {
        self.translatesAutoresizingMaskIntoConstraints = false
        var result: NSLayoutConstraint?
        switch pos {
        case .top:
            guard let anchor = anchor as? NSLayoutYAxisAnchor else { break }
            result = self.topAnchor.constraint(equalTo: anchor)
            break
        case .bottom:
            guard let anchor = anchor as? NSLayoutYAxisAnchor else { break }
            result = self.bottomAnchor.constraint(equalTo: anchor)
            break
        case .leading:
            guard let anchor = anchor as? NSLayoutXAxisAnchor else { break }
            result = self.leadingAnchor.constraint(equalTo: anchor)
            break
        case .trailing:
            guard let anchor = anchor as? NSLayoutXAxisAnchor else { break }
            result = self.trailingAnchor.constraint(equalTo: anchor)
            break
        case .left:
            guard let anchor = anchor as? NSLayoutXAxisAnchor else { break }
            result = self.leftAnchor.constraint(equalTo: anchor)
            break
        case .right:
            guard let anchor = anchor as? NSLayoutXAxisAnchor else { break }
            result = self.rightAnchor.constraint(equalTo: anchor)
            break
        case .height:
            guard let anchor = anchor as? NSLayoutDimension else { break }
            result = self.heightAnchor.constraint(equalTo: anchor)
        case .width:
            guard let anchor = anchor as? NSLayoutDimension else { break }
            result = self.widthAnchor.constraint(equalTo: anchor)
            break
        case .centerX:
            guard let anchor = anchor as? NSLayoutXAxisAnchor else { break }
            result = self.centerXAnchor.constraint(equalTo: anchor)
        case .centerY:
            guard let anchor = anchor as? NSLayoutYAxisAnchor else { break }
            result = self.centerYAnchor.constraint(equalTo: anchor)
        }
        result?.identifier = pos.rawValue
        result?.isActive = true
        return result
    }
}

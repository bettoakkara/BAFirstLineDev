//
//  LBIndicator.swift
//  BAExtensions
//
//  Created by Betto Akkara on 04/02/21.
//

import UIKit

class LBIndicator: UIView, IndicatorProtocol {
    open var isAnimating: Bool = false
    open var radius: CGFloat = 18.0
    open var color: UIColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    
    public convenience init(radius: CGFloat = 18.0, color: UIColor = .gray) {
        self.init()
        self.radius = radius
        self.color = color
    }
    
    open func startAnimating() {
        guard !isAnimating else { return }
        isHidden = false
        isAnimating = true
        layer.speed = 1
        setupAnimation(in: self.layer, size: CGSize(width: 2*radius, height: 2*radius))
    }
    
    open func stopAnimating() {
        guard isAnimating else { return }
        isHidden = true
        isAnimating = false
        layer.sublayers?.removeAll()
    }
    
    open func setupAnimation(in layer: CALayer, size: CGSize) {
        fatalError("Need to be implemented")
    }
    
}

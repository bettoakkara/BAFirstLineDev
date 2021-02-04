//
//  GradientView.swift
//  BAExtensions
//
//  Created by Betto Akkara on 04/02/21.
//

import Foundation
import UIKit

@IBDesignable
open class BAGradientView: UIView {
    @IBInspectable var firstColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    @IBInspectable var secondColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    @IBInspectable var isHorizontal: Bool = true {
        didSet {
            updateView()
        }
    }
    func updateView() {
        DispatchQueue.main.async{
            let layer : CAGradientLayer = CAGradientLayer()
            layer.frame.size = self.frame.size
            layer.colors = [self.firstColor, self.secondColor].map{$0.cgColor}
            if (self.isHorizontal) {
                layer.startPoint = CGPoint(x: 0, y: 0.5)
                layer.endPoint = CGPoint (x: 1, y: 0.5)
            } else {
                layer.startPoint = CGPoint(x: 0.5, y: 0)
                layer.endPoint = CGPoint (x: 0.5, y: 1)
            }
            self.layer.insertSublayer(layer, at: 0)
        }
    }
}

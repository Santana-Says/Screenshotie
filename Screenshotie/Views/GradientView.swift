//
//  GradientView.swift
//  Screenshotie
//
//  Created by Jeffrey Santana on 10/20/18.
//  Copyright © 2018 Jefffrey Santana. All rights reserved.
//

import UIKit

@IBDesignable class GradientView: UIView {
	@IBInspectable var gradientColor1: UIColor = UIColor.white {
		didSet{
			self.setGradient()
		}
	}
	
	@IBInspectable var gradientColor2: UIColor = UIColor.white {
		didSet{
			self.setGradient()
		}
	}
	
	@IBInspectable var gradientStartPoint: CGPoint = .zero {
		didSet{
			self.setGradient()
		}
	}
	
	@IBInspectable var gradientEndPoint: CGPoint = CGPoint(x: 0, y: 1) {
		didSet{
			self.setGradient()
		}
	}
	
	@IBInspectable var cornerRadius: CGFloat = 0 {
		didSet {
			self.setNeedsLayout()
		}
	}
	
	override func prepareForInterfaceBuilder() {
		super.prepareForInterfaceBuilder()
		
		setGradient()
	}
	
	private func setGradient()
	{
		let gradientLayer = CAGradientLayer()
		gradientLayer.colors = [self.gradientColor1.cgColor, self.gradientColor2.cgColor]
		gradientLayer.startPoint = self.gradientStartPoint
		gradientLayer.endPoint = self.gradientEndPoint
		gradientLayer.cornerRadius = cornerRadius
		gradientLayer.frame = self.bounds
		if let topLayer = self.layer.sublayers?.first, topLayer is CAGradientLayer
		{
			topLayer.removeFromSuperlayer()
		}
		self.layer.addSublayer(gradientLayer)
//		gradientLayer.insertSublayer(gradientLayer, at: 0)
	}
}

//
//  IconToggleCell.swift
//  Screenshotie
//
//  Created by Jeffrey Santana on 5/6/18.
//  Copyright © 2018 Jefffrey Santana. All rights reserved.
//

import UIKit

protocol IconToggleCellDelegate: class {
	func iconBtnAction(sender: UIButton)
}

class IconToggleCell: UICollectionViewCell {
    
	@IBOutlet weak var iconImg: UIImageView!
	@IBOutlet weak var iconBtn: UIButton!
	
	weak var delegate: IconToggleCellDelegate?
	
	@IBAction func toggleIconAction(_ sender: UIButton) {
		delegate?.iconBtnAction(sender: sender)
	}
	
	func cellConfig(img: UIImage) {
		iconImg.image = img
	}
}

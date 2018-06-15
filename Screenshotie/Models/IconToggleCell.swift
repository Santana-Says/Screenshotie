//
//  IconToggleCell.swift
//  Screenshotie
//
//  Created by Jeffrey Santana on 5/6/18.
//  Copyright © 2018 Jefffrey Santana. All rights reserved.
//

import UIKit

protocol IconToggleCellDelegate: class {
	func iconBtnAction(image: String)
}

class IconToggleCell: UICollectionViewCell {
    
	@IBOutlet weak var iconImgView: UIImageView!
	@IBOutlet weak var iconBtn: UIButton!
	private var imgString = ""
	
	weak var delegate: IconToggleCellDelegate?
	
	@IBAction func toggleIconAction(_ sender: UIButton) {
		delegate?.iconBtnAction(image: imgString)
	}
	
	func cellConfig(img: String) {
		iconImgView.image = UIImage(named: img)
		imgString = img
	}
}

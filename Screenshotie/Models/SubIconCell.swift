//
//  SubIconCell.swift
//  Screenshotie
//
//  Created by Jeffrey Santana on 5/22/18.
//  Copyright © 2018 Jefffrey Santana. All rights reserved.
//

import UIKit

protocol SubIconCellDelegate: class {
	func subIconBtnAction(sender: UIButton)
}

class SubIconCell: UICollectionViewCell {
	
	@IBOutlet weak var subIconBtn: UIButton!
	
	weak var delegate: SubIconCellDelegate?
	
	@IBAction func selectIconAction(_ sender: UIButton) {
		delegate?.subIconBtnAction(sender: sender)
	}
	
	func cellConfig(img: UIImage) {
		subIconBtn.setBackgroundImage(img, for: .normal)
	}

}
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
	
	@IBOutlet weak var subIconImg: UIImageView!
	@IBOutlet weak var subIconBtn: UIButton!
	
	weak var delegate: SubIconCellDelegate?
	
	@IBAction func selectIconAction(_ sender: UIButton) {
		delegate?.subIconBtnAction(sender: sender)
	}
	
	func cellConfig(img: UIImage?, carrier title: String?) {
		//reset cell
		subIconImg.image = nil
		subIconBtn.setTitle("", for: .normal)
		
		if let img = img {
			subIconImg.image = img
		} else if let title = title {
			subIconBtn.setTitle(title, for: .normal)
		}
	}

}

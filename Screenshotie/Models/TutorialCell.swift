//
//  TutorialCell.swift
//  Screenshotie
//
//  Created by Jeffrey Santana on 6/14/18.
//  Copyright © 2018 Jefffrey Santana. All rights reserved.
//

import UIKit

class TutorialCell: UICollectionViewCell {
    
	@IBOutlet weak var tutorialImg: UIImageView!
	@IBOutlet weak var instructionLbl: UILabel!
	
	func configCell(img: UIImage, instruction: String) {
		tutorialImg.image = img
		instructionLbl.text = instruction
	}
}

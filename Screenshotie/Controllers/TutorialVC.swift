//
//  TutorialVC.swift
//  Screenshotie
//
//  Created by Jeffrey Santana on 6/13/18.
//  Copyright © 2018 Jefffrey Santana. All rights reserved.
//

import UIKit

class TutorialVC: UIViewController {

	@IBOutlet weak var pageControl: UIPageControl!
	@IBOutlet weak var collectionview: UICollectionView!
	
	private let images = [#imageLiteral(resourceName: "select"), #imageLiteral(resourceName: "modify"), #imageLiteral(resourceName: "share")]
	private let instructions = ["Start by selecting a screenshot", "Modify any of the status bar icons to suit your needs", "Then send the new screenshot to a friend or save it for later"]
	
	override func viewDidLoad() {
        super.viewDidLoad()

		collectionview.delegate = self
		collectionview.dataSource = self
    }

	@IBAction func tutorialfinishedAction(_ sender: Any) {
		dismiss(animated: true, completion: nil)
	}
}

extension TutorialVC: UICollectionViewDelegate, UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return images.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TutorialCell", for: indexPath) as! TutorialCell
		
		cell.configCell(img: images[indexPath.row], instruction: instructions[indexPath.row])
		cell.frame.size.width = collectionview.frame.width
		return cell
	}
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		pageControl.currentPage = Int(collectionview.contentOffset.x / collectionview.frame.width)
	}
}

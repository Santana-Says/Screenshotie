//
//  BarEditorVC.swift
//  Screenshotie
//
//  Created by Jeffrey Santana on 4/24/18.
//  Copyright © 2018 Jefffrey Santana. All rights reserved.
//

import UIKit

class EditorVC: UIViewController {
	
	//MARK: - IBOutlets
	
	@IBOutlet weak var statusBarView: UIView!
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var airplaneModeImg: UIImageView!
	@IBOutlet weak var signalImg: UIImageView!
	@IBOutlet weak var carrierImg: UIImageView!
	@IBOutlet weak var wifiImg: UIImageView!
	@IBOutlet weak var timeLbl: UILabel!
	@IBOutlet weak var collectionView: UICollectionView!
	@IBOutlet weak var timePicker: UIDatePicker!
	@IBOutlet weak var doNotDisturbImg: UIImageView!
	@IBOutlet weak var alarmImg: UIImageView!
	@IBOutlet weak var screenLockImg: UIImageView!
	@IBOutlet weak var locationImg: UIImageView!
	@IBOutlet weak var bluetoothImg: UIImageView!
	@IBOutlet weak var batteryLbl: UILabel!
	@IBOutlet weak var batteryImg: UIImageView!
	@IBOutlet weak var chargingImg: UIImageView!
	
	@IBOutlet weak var toolBoxBtn: UIButton!
	@IBOutlet weak var toolsView: UIView!
	@IBOutlet weak var shareBtn: UIButton!
	
	private var isOpen = false
	var screenshot: UIImage?
	
	let statusIconImages = ["airplaneMode", "signal 3:4", "carrier AT&T", "wifi full", "doNotDisturb", "screenLock", "location", "alarm", "bluetooth", "charging"]
	
    override func viewDidLoad() {
        super.viewDidLoad()

		imageView.image = screenshot
		timeLbl.text = DateFormatter.localizedString(from: timePicker.date, dateStyle: .none, timeStyle: .short)
		toolsView.alpha = 0
		roundCorners()
		shadowEffect()
		hideNonEssentialIcons()
		collectionViewConfig()
    }
	
	override var prefersStatusBarHidden: Bool {
		return true
	}
	
	//MARK: IBActions
	
	@IBAction func toolBoxBtnAction(_ sender: Any) {
		toggleToolbox()
		
	}
	@IBAction func shareBtnAction(_ sender: Any) {
		toggleToolbox()
		toolBoxBtn.isHidden = true
		
		captureScreenshot()
		if let image = screenshot {
			let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])
			present(vc, animated: true)
		}
		toolBoxBtn.isHidden = false
	}
	
	@IBAction func timePickerChanged(_ sender: UIDatePicker) {
		let dateFormatter = DateFormatter()
		
		dateFormatter.dateStyle = .none
		dateFormatter.timeStyle = .short
		
		let strTime = dateFormatter.string(from: timePicker.date)
		timeLbl.text = strTime
	}
	
	//MARK: Helper Functions
	
	func hideNonEssentialIcons() {
		airplaneModeImg.isHidden = true
		doNotDisturbImg.isHidden = true
		screenLockImg.isHidden = true
		locationImg.isHidden = true
		alarmImg.isHidden = true
		bluetoothImg.isHidden = true
		chargingImg.isHidden = true
	}
	
	private func toggleToolbox() {
		if isOpen {
			isOpen = false
			UIView.animate(withDuration: 0.5, animations: {
				self.toolsView.alpha = 0
			}) { (_) in
				self.toolsView.isHidden = true
			}
		} else {
			isOpen = true
			UIView.animate(withDuration: 0.7) {
				self.toolsView.isHidden = false
				self.toolsView.alpha = 1
			}
		}
	}
	
	private func captureScreenshot() {
		
		let layer = UIApplication.shared.keyWindow!.layer
		let scale = UIScreen.main.scale
		
		// Creates UIImage of same size as view
		UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
		layer.render(in: UIGraphicsGetCurrentContext()!)
		screenshot = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
	}
	
	private func roundCorners() {
		toolsView.layer.cornerRadius = 10
		shareBtn.layer.cornerRadius = toolsView.layer.cornerRadius
		shareBtn.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]	//focus on bottom radius
		toolBoxBtn.layer.cornerRadius = toolBoxBtn.frame.width / 2
	}
	
	private func shadowEffect() {
		toolBoxBtn.layer.shadowColor = UIColor.black.cgColor
		toolBoxBtn.layer.shadowOpacity = 0.5
		toolBoxBtn.layer.shadowOffset = CGSize.zero
		toolBoxBtn.layer.shadowRadius = 5
		
		toolsView.layer.shadowColor = UIColor.black.cgColor
		toolsView.layer.shadowOpacity = 0.5
		toolsView.layer.shadowOffset = CGSize.zero
		toolsView.layer.shadowRadius = 10
	}
	
	//TODO: - turn this into an imageview extension
	func toggleIcon(imgView: UIImageView) {
		if imgView.isHidden {
			imgView.isHidden = false
		} else {
			imgView.isHidden = true
		}
	}
}

extension EditorVC: UICollectionViewDataSource, UICollectionViewDelegate, IconToggleCellDelegate {
	
	func collectionViewConfig() {
		collectionView.delegate = self
		collectionView.dataSource = self
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return statusIconImages.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IconToggleCell", for: indexPath) as! IconToggleCell
		cell.delegate = self
		cell.cellConfig(img: UIImage(named: statusIconImages[indexPath.row])!)
		cell.iconBtn.tag = indexPath.row
		
		cell.layer.cornerRadius = cell.frame.width / 2
		cell.layer.masksToBounds = true
		
		return cell
	}
	
	func iconBtnAction(sender: UIButton) {
		switch sender.tag {
			case 0:
				airplaneModeImg.isHidden = false
				signalImg.isHidden = true
				carrierImg.isHidden = true
				wifiImg.isHidden = true
			case 1:
				airplaneModeImg.isHidden = true
				toggleIcon(imgView: signalImg)
			case 2:
				airplaneModeImg.isHidden = true
				toggleIcon(imgView: carrierImg)
			case 3:
				airplaneModeImg.isHidden = true
				toggleIcon(imgView: wifiImg)
			case 4:
				toggleIcon(imgView: doNotDisturbImg)
			case 5:
				toggleIcon(imgView: screenLockImg)
			case 6:
				toggleIcon(imgView: locationImg)
			case 7:
				toggleIcon(imgView: alarmImg)
			case 8:
				toggleIcon(imgView: bluetoothImg)
			case 9:
				toggleIcon(imgView: chargingImg)
				batteryImg.image = chargingImg.isHidden ? #imageLiteral(resourceName: "battery 3:4") : #imageLiteral(resourceName: "battery charging full")
			default:
				print("Empty icon toggled")
		}
	}
	
	
}

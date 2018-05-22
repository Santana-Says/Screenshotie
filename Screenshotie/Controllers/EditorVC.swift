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
	@IBOutlet weak var subCollectionView: UICollectionView!
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
	@IBOutlet weak var backBtn: UIButton!
	@IBOutlet weak var shareBtn: UIButton!
	
	private var isOpen = false
	var screenshot: UIImage?
	
	private let statusIconImages = ["AirplaneMode", "Signal 4:4", "AT&T", "Wifi 3:3", "DoNotDisturb", "ScreenLock", "Location", "Alarm", "Bluetooth", "Battery 100%", "Charging"]
	private let signalIconImages = [#imageLiteral(resourceName: "Signal 0:4"), #imageLiteral(resourceName: "Signal 1:4"),#imageLiteral(resourceName: "Signal 2:4"),#imageLiteral(resourceName: "Signal 3:4"), #imageLiteral(resourceName: "Signal 4:4")]
	private let carrierIconImages = [#imageLiteral(resourceName: "AT&T")]
	private let wifiIconImages = [#imageLiteral(resourceName: "Wifi 0:3"), #imageLiteral(resourceName: "Wifi 1:3"), #imageLiteral(resourceName: "Wifi 2:3"), #imageLiteral(resourceName: "Wifi 3:3")]
	private let batteryIconImages = [#imageLiteral(resourceName: "Battery 10%"), #imageLiteral(resourceName: "Battery 50%"), #imageLiteral(resourceName: "Battery 100%")]
	private let batterChargingIconImages = [#imageLiteral(resourceName: "Battery Charging 10%"), #imageLiteral(resourceName: "Battery Charging 50%"), #imageLiteral(resourceName: "Battery Charging 100%")]
	private var currentSubIconImages: [UIImage]?
	private var imgViewToEdit: UIImageView?
	
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
	
	@IBAction func backBtnAction(_ sender: Any) {
		navigationController?.popViewController(animated: true)
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
		backBtn.layer.cornerRadius = toolsView.layer.cornerRadius
		shareBtn.layer.cornerRadius = toolsView.layer.cornerRadius
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
	
	func showSubCollectionView(imgView: UIImageView, images: [UIImage]) {
		imgViewToEdit = imgView
		currentSubIconImages = images
		subCollectionView.reloadData()
		subCollectionView.isHidden = false
	}
}

//MARK: - CollectionView Conforming

extension EditorVC: UICollectionViewDataSource, UICollectionViewDelegate {
	
	func collectionViewConfig() {
		collectionView.delegate = self
		subCollectionView.delegate = self
		collectionView.dataSource = self
		subCollectionView.dataSource = self
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if collectionView == self.collectionView {
			return statusIconImages.count
		} else if collectionView == subCollectionView {
			guard let currentSubIconImages = currentSubIconImages else {return 0}
			return currentSubIconImages.count
		}
		return 0
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		if collectionView == self.collectionView {
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IconToggleCell", for: indexPath) as! IconToggleCell
			cell.delegate = self
			cell.cellConfig(img: UIImage(named: statusIconImages[indexPath.row])!)
			cell.iconBtn.tag = indexPath.row
			
			cell.layer.cornerRadius = cell.frame.width / 2
			cell.layer.masksToBounds = true
			
			return cell
		} else if collectionView == subCollectionView {
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubIconCell", for: indexPath) as! SubIconCell
			cell.delegate = self
			cell.cellConfig(img: currentSubIconImages![indexPath.row])
			cell.subIconBtn.tag = indexPath.row
			
			cell.layer.cornerRadius = cell.frame.width / 2
			cell.layer.masksToBounds = true
			
			return cell
		}
		
		return UICollectionViewCell()
	}
}

//MARK: - IconToggleCellDelegate

extension EditorVC: IconToggleCellDelegate {
	func iconBtnAction(sender: UIButton) {
		switch sender.tag {
		case 0:
			airplaneModeImg.isHidden = false
			signalImg.isHidden = true
			carrierImg.isHidden = true
		case 1:
			airplaneModeImg.isHidden = true
			toggleIcon(imgView: signalImg)
			if !signalImg.isHidden {
				showSubCollectionView(imgView: signalImg, images: signalIconImages)
			}
		case 2:
			airplaneModeImg.isHidden = true
			toggleIcon(imgView: carrierImg)
			if !carrierImg.isHidden {
				showSubCollectionView(imgView: carrierImg, images: carrierIconImages)
			}
		case 3:
			toggleIcon(imgView: wifiImg)
			if !wifiImg.isHidden {
				showSubCollectionView(imgView: wifiImg, images: wifiIconImages)
			}
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
		case 10:
			toggleIcon(imgView: chargingImg)
			fallthrough
		case 9:
			showSubCollectionView(imgView: batteryImg, images: chargingImg.isHidden ? batteryIconImages : batterChargingIconImages)
		//TODO: - switch between regular/charging battery icons
		default:
			print("Empty icon toggled")
		}
	}
}

//MARK: - SubIconCellDelegate

extension EditorVC: SubIconCellDelegate {
	func subIconBtnAction(sender: UIButton) {
		guard let imgViewToEdit = imgViewToEdit, let currentSubIconImages = currentSubIconImages else {return}
		
		subCollectionView.isHidden = true
		imgViewToEdit.image = currentSubIconImages[sender.tag]
	}
}




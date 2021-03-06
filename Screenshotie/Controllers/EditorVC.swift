//
//  BarEditorVC.swift
//  Screenshotie
//
//  Created by Jeffrey Santana on 4/24/18.
//  Copyright © 2018 Jefffrey Santana. All rights reserved.
//

import UIKit
import GoogleMobileAds

class EditorVC: UIViewController {
	
	//MARK: - IBOutlets
	
	@IBOutlet weak var statusBarView: UIView!
	@IBOutlet weak var iPhoneXstatusBarView: UIView!
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet var airplaneModeImg: [UIImageView]!
	@IBOutlet var signalImg: [UIImageView]!
	@IBOutlet weak var carrierLbl: UILabel!
	@IBOutlet var wifiImg: [UIImageView]!
	@IBOutlet weak var timeLbl: UILabel!
	@IBOutlet weak var timeLblX: UILabel!
	@IBOutlet weak var collectionView: UICollectionView!
	@IBOutlet weak var subCollectionView: UICollectionView!
	@IBOutlet weak var timePicker: UIDatePicker!
	@IBOutlet weak var doNotDisturbImg: UIImageView!
	@IBOutlet weak var alarmImg: UIImageView!
	@IBOutlet weak var screenLockImg: UIImageView!
	@IBOutlet weak var locationImg: UIImageView!
	@IBOutlet weak var bluetoothImg: UIImageView!
	@IBOutlet weak var batteryLbl: UILabel!
	@IBOutlet var batteryImg: [UIImageView]!
	@IBOutlet weak var chargingImg: UIImageView!
	
	@IBOutlet weak var toolsView: UIView!
	@IBOutlet weak var backShareStack: UIStackView!
	@IBOutlet weak var backShareStackBtmAnchor: NSLayoutConstraint!
	@IBOutlet weak var toolboxBtn: UIButton!
	
	var screenshot: UIImage?
	
	private var iphone: iphoneVersion?
	private var isToolBoxOpen = false
	private let statusIconImages: [iconImages] = [.AirplaneModeIcon, .Signal, .Carrier, .Wifi, .DoNotDisturbIcon, .ScreenLockIcon, .LocationIcon, .AlarmIcon, .BluetoothIcon, .Battery, .ChargingIcon]
	private let statusIconImagesX: [iconImages] = [.AirplaneModeIcon, .Signal, .Wifi, .Battery, .ChargingIcon]
	private var currentSubIconImages = [UIImage]()
	private var imgViewToEdit = UIImageView()
	private var airplaneModeImgviewInUse = UIImageView()
	private var signalImgviewInUse = UIImageView()
	private var wifiImgviewInUse = UIImageView()
	private var batteryImgviewInUse = UIImageView()
	private var batteryChargingImgviewInUse = [UIImage]()
	private var statusIconsInUse = [iconImages]()
	private var interstitial: GADInterstitial!
	private var isCarrierBtnSelected = false
	
    override func viewDidLoad() {
        super.viewDidLoad()

		imageView.image = screenshot
		toolsView.alpha = 0
		backShareStackBtmAnchor.constant = backShareStack.frame.height / 2
		timePicker.setValue(UIColor.white, forKeyPath: "textColor")
		
		detectIphoneVersion()
		configAdMob()
		variationsDependingOnVersion()
		imgViewFromCollection()
		hideNonEssentialIcons()
		setTime()
		collectionViewConfig()
    }
	
	override var prefersStatusBarHidden: Bool {
		return true
	}
	
	//MARK: - IBActions
	
	@IBAction func toolBoxBtnAction(_ sender: Any) {
		toggleToolbox()
		print(collectionView.frame.height)
	}
	
	@IBAction func backBtnAction(_ sender: Any) {
		navigationController?.popViewController(animated: true)
	}
	
	@IBAction func shareBtnAction(_ sender: Any) {
		toggleToolbox()
		toolboxBtn.isHidden = true
		
		captureScreenshot()
		if let image = screenshot {
			let shareMenuVC = UIActivityViewController(activityItems: [image], applicationActivities: [])
			shareMenuVC.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
				if completed {
					if self.interstitial.isReady {
						self.interstitial.present(fromRootViewController: self)
					} else {
						print("Ad wasn't ready")
						self.backBtnAction(self)
					}
				}
			}
			present(shareMenuVC, animated: true)
		}
		toolboxBtn.isHidden = false
	}
	
	@IBAction func timePickerChanged(_ sender: UIDatePicker) {
		setTime()
	}
	
	//MARK: - Helper Functions
	
	private func detectIphoneVersion() {
		let phoneHeight = view.frame.height
		switch phoneHeight {
		case _ where phoneHeight >= iphoneVersion.iphoneX.rawValue:
			iphone = .iphoneX
		case iphoneVersion.iphonePlus.rawValue:
			iphone = .iphonePlus
		case iphoneVersion.iphone678.rawValue:
			iphone = .iphone678
		case _ where phoneHeight <= iphoneVersion.iphoneSE.rawValue:
			iphone = .iphoneSE
		default:
			iphone = nil
		}
	}
	
	func variationsDependingOnVersion() {
		guard let iphone = iphone else { return }
		
		if iphone.isIPhoneX() {
			statusIconsInUse = statusIconImagesX
			statusBarView.isHidden = true
			batteryChargingImgviewInUse = StatusBarImages().batteryChargingIconImagesX
		} else {
			statusIconsInUse = statusIconImages
			iPhoneXstatusBarView.isHidden = true
			batteryChargingImgviewInUse = ToolBoxImages().batteryChargingIconImages
		}
		backShareStack.frame.origin.y = toolsView.frame.maxY - (backShareStack.frame.height / 2)
	}
	
	//WHATS THIS DO?
	private func imgViewFromCollection() {
		guard let iphone = iphone else { return }
		
		airplaneModeImgviewInUse = airplaneModeImg.filter{$0.tag == iphone.tag()}.first!
		signalImgviewInUse = signalImg.filter{$0.tag == iphone.tag()}.first!
		wifiImgviewInUse = wifiImg.filter{$0.tag == iphone.tag()}.first!
		batteryImgviewInUse = batteryImg.filter{$0.tag == iphone.tag()}.first!
	}
	
	private func hideNonEssentialIcons() {
		airplaneModeImgviewInUse.isHidden = true
		doNotDisturbImg.isHidden = true
		screenLockImg.isHidden = true
		locationImg.isHidden = true
		alarmImg.isHidden = true
		bluetoothImg.isHidden = true
		batteryLbl.isHidden = true
		chargingImg.isHidden = true
		subCollectionView.isHidden = true
	}
	
	private func toggleToolbox() {
		if isToolBoxOpen {
			isToolBoxOpen = false
			UIView.animate(withDuration: 0.5, animations: {
				self.toolsView.alpha = 0
			}) { (_) in
				self.toolsView.isHidden = true
			}
		} else {
			isToolBoxOpen = true
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
	
	private func toggleIcon(imgView: UIImageView) {
		guard let iphone = iphone else { return }
		subCollectionView.isHidden = true
		isCarrierBtnSelected = false
		
		if imgView.isHidden {
			imgView.isHidden = false
			if imgView == airplaneModeImgviewInUse {
				signalImgviewInUse.isHidden = true
				if iphone.isIPhoneX() {
					wifiImgviewInUse.isHidden = true
				} else {
					carrierLbl.isHidden = true
				}
			}
		} else {
			imgView.isHidden = true
			if imgView == airplaneModeImgviewInUse {
				signalImgviewInUse.isHidden = false
				if iphone.isIPhoneX() {
					wifiImgviewInUse.isHidden = false
				} else {
					carrierLbl.isHidden = false
				}
			}
		}
	}
	
	private func setTime() {
		guard let iphone = iphone else { return }
		
		if iphone.isIPhoneX() {
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "h:mm"
			timeLblX.text = dateFormatter.string(from: timePicker.date)
		} else {
			timeLbl.text = DateFormatter.localizedString(from: timePicker.date, dateStyle: .none, timeStyle: .short)
		}
	}
	
	private func showSubCollectionView(imgView: UIImageView?, images: [UIImage]?) {
		let maxAvailableSpacing = 100
		let evenSubIconLayout = subCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
		
		if let imgView = imgView, let images = images {
			imgViewToEdit = imgView
			currentSubIconImages = images
			evenSubIconLayout.minimumInteritemSpacing = CGFloat(maxAvailableSpacing / (currentSubIconImages.count))
		} else if isCarrierBtnSelected {
			evenSubIconLayout.minimumInteritemSpacing = CGFloat(maxAvailableSpacing / (StatusBarImages().serviceProviders.count))
		}
		
		subCollectionView.collectionViewLayout = evenSubIconLayout
		subCollectionView.reloadData()
		subCollectionView.isHidden = false
	}
	
	private func configAdMob() {
		let request = GADRequest()
		
		interstitial = GADInterstitial(adUnitID: GAD().INTERSTITIAL_AD_ID)
		interstitial.delegate = self
		interstitial.load(request)
	}
}

//MARK: - CollectionView Conforming

extension EditorVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
	
	func collectionViewConfig() {
		collectionView.delegate = self
		subCollectionView.delegate = self
		collectionView.dataSource = self
		subCollectionView.dataSource = self
	}

	private func getPortionOfView(divideBy portion: CGFloat) -> CGFloat {
		return toolsView.frame.size.width / portion
	}
	
	private func setCollectionViewHeight(collectionView: UICollectionView, cellHeight: CGFloat) {
		let rowSpace: CGFloat = 15
		let cellsPerRow: CGFloat = 3
		let surroundingInsets: CGFloat = 20
		let numberOfRows: CGFloat = ceil(CGFloat(statusIconsInUse.count) / cellsPerRow)
		let sumOfSpaces = (rowSpace * (numberOfRows - 1)) + (surroundingInsets * 2)
		
		collectionView.frame.size.height = (cellHeight * numberOfRows) + sumOfSpaces
		view.layoutIfNeeded()
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		let topBtmInset: CGFloat = 20
		let ninthOfView = getPortionOfView(divideBy: 10)
		return UIEdgeInsets(top: topBtmInset, left: ninthOfView, bottom: topBtmInset, right: ninthOfView)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		let seventhOfView = getPortionOfView(divideBy: 7)
		return seventhOfView
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if collectionView == self.collectionView {
			return statusIconsInUse.count
		} else if collectionView == subCollectionView {
			return isCarrierBtnSelected ? StatusBarImages().serviceProviders.count : currentSubIconImages.count
		}
		return 0
	}
	
	#warning("Figure out dynamic collectionView height")
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		
		var cellSpace: CGFloat = 0
		var cellsPerRow: CGFloat = 0
		let sideInset: CGFloat = getPortionOfView(divideBy: 10)
		var sumOfSpaces: CGFloat = 0
		var cellWidth: CGFloat = 0
		
		if collectionView == self.collectionView {
			cellSpace = getPortionOfView(divideBy: 7)
			cellsPerRow = 3
			sumOfSpaces = (cellSpace * cellsPerRow) + (sideInset * 2)
			cellWidth = (collectionView.layer.frame.width - sumOfSpaces) / cellsPerRow
			setCollectionViewHeight(collectionView: collectionView, cellHeight: cellWidth)
			
			return CGSize(width: cellWidth, height: cellWidth)
		} else if collectionView == subCollectionView {
			cellSpace = 5
			cellsPerRow = CGFloat(currentSubIconImages.count)
			sumOfSpaces = cellSpace * cellsPerRow
			cellWidth = (collectionView.layer.frame.width - sumOfSpaces) / cellsPerRow
			setCollectionViewHeight(collectionView: collectionView, cellHeight: cellWidth)
			
			return CGSize(width: cellWidth, height: cellWidth)
		}
		
		return CGSize()
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		if collectionView == self.collectionView {
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IconToggleCell", for: indexPath) as! IconToggleCell
			
			cell.delegate = self
			cell.cellConfig(img: statusIconsInUse[indexPath.row].rawValue)
			cell.iconBtn.tag = indexPath.row
			
			return cell
		} else if collectionView == subCollectionView {
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubIconCell", for: indexPath) as! SubIconCell
			cell.delegate = self
			
			if isCarrierBtnSelected {
				cell.cellConfig(img: nil, carrier: StatusBarImages().serviceProviders[indexPath.row])
			} else {
				cell.cellConfig(img: currentSubIconImages[indexPath.row], carrier: nil)
			}
			
			cell.subIconBtn.tag = indexPath.row
			
			return cell
		}
		
		return UICollectionViewCell()
	}
}

//MARK: - IconToggleCellDelegate

extension EditorVC: IconToggleCellDelegate {
	private func cancelAirplaneMode() {
		airplaneModeImgviewInUse.isHidden = true
		signalImgviewInUse.isHidden = false
		carrierLbl.isHidden = false
		wifiImgviewInUse.isHidden = false
		subCollectionView.isHidden = true
		isCarrierBtnSelected = false
	}
	
	func iconBtnAction(image: String) {
		
		switch UIImage(named: image) {
		case #imageLiteral(resourceName: "AirplaneMode"):
			toggleIcon(imgView: airplaneModeImgviewInUse)
		case #imageLiteral(resourceName: "Signal 4:4"):
			cancelAirplaneMode()
			showSubCollectionView(imgView: signalImgviewInUse, images: ToolBoxImages().signalIconImages)
		case #imageLiteral(resourceName: "AT&T"):
			cancelAirplaneMode()
			isCarrierBtnSelected = true
			showSubCollectionView(imgView: nil, images: nil)
		case #imageLiteral(resourceName: "Wifi 3:3"):
			cancelAirplaneMode()
			showSubCollectionView(imgView: wifiImgviewInUse, images: ToolBoxImages().wifiIconImages)
		case #imageLiteral(resourceName: "DoNotDisturb"):
			toggleIcon(imgView: doNotDisturbImg)
		case #imageLiteral(resourceName: "ScreenLock"):
			toggleIcon(imgView: screenLockImg)
		case #imageLiteral(resourceName: "Location"):
			toggleIcon(imgView: locationImg)
		case #imageLiteral(resourceName: "Alarm"):
			toggleIcon(imgView: alarmImg)
		case #imageLiteral(resourceName: "Bluetooth"):
			toggleIcon(imgView: bluetoothImg)
		case #imageLiteral(resourceName: "Charging"):
			toggleIcon(imgView: chargingImg)
			fallthrough
		case #imageLiteral(resourceName: "Battery 100%"):
			showSubCollectionView(imgView: batteryImgviewInUse, images: chargingImg.isHidden ? ToolBoxImages().batteryIconImages : batteryChargingImgviewInUse)
		default:
			print("Empty icon toggled")
		}
	}
}

//MARK: - SubIconCellDelegate

extension EditorVC: SubIconCellDelegate {
	func subIconBtnAction(sender: UIButton) {
		subCollectionView.isHidden = true
		
		if isCarrierBtnSelected {
			carrierLbl.text = StatusBarImages().serviceProviders[sender.tag]
			isCarrierBtnSelected = false
		} else {
			imgViewToEdit.image = currentSubIconImages[sender.tag]
		}
	}
}

//MARK: - GADDelegate

extension EditorVC: GADInterstitialDelegate {
	/// Tells the delegate an ad request succeeded.
	func interstitialDidReceiveAd(_ ad: GADInterstitial) {
		print("interstitialDidReceiveAd")
	}
	
	/// Tells the delegate an ad request failed.
	func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
		print("interstitial:didFailToReceiveAdWithError: \(error.localizedDescription)")
	}
	
	/// Tells the delegate that an interstitial will be presented.
	func interstitialWillPresentScreen(_ ad: GADInterstitial) {
		print("interstitialWillPresentScreen")
	}
	
	/// Tells the delegate the interstitial is to be animated off the screen.
	func interstitialWillDismissScreen(_ ad: GADInterstitial) {
		print("interstitialWillDismissScreen")
		backBtnAction(self)
	}
	
	/// Tells the delegate the interstitial had been animated off the screen.
	func interstitialDidDismissScreen(_ ad: GADInterstitial) {
		print("interstitialDidDismissScreen")
	}
	
	/// Tells the delegate that a user click will open another app
	/// (such as the App Store), backgrounding the current app.
	func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
		print("interstitialWillLeaveApplication")
	}
}



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
	@IBOutlet weak var carrierImg: UIImageView!
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
	@IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
	
	@IBOutlet weak var ToolBoxBtnView: UIView!
	@IBOutlet weak var toolsView: UIView!
	@IBOutlet weak var backBtn: UIButton!
	@IBOutlet weak var shareBtn: UIButton!
	
	private enum iphoneVersion: CGFloat {
		//based off of root view height
		case iphoneX = 812
		case iphonePlus = 736
		case iphone678 = 667
		case iphoneSE = 568
		
		func isIPhoneX() -> Bool { return self == .iphoneX ? true : false }
		func tag() -> Int { return self == .iphoneX ? 1 : 0 }
	}
	
	private enum iconImages: String {
		case AirplaneMode
		case Signal = "Signal 4:4"
		case Carrier = "AT&T"
		case Wifi = "Wifi 3:3"
		case DoNotDisturb
		case ScreenLock
		case Location
		case Alarm
		case Bluetooth
		case Battery = "Battery 100%"
		case Charging
//		case getImage(named: String)
//
//		var image: UIImage {
//			switch self {
//			case .getImage(let imgName):
//				guard let img = UIImage(named: imgName) else { return UIImage() }
//				return img
//			}
//		}
	}
	
	var screenshot: UIImage?
	
	private let IPHONEX_COLLECTIONVIEW_SIZE: CGFloat = 110
	private var iphone: iphoneVersion?
	private var isToolBoxOpen = false
//	private let statusIconImages = ["AirplaneMode", "Signal 4:4", "AT&T", "Wifi 3:3", "DoNotDisturb", "ScreenLock", "Location", "Alarm", "Bluetooth", "Battery 100%", "Charging"]
//	private let statusIconImagesX = ["AirplaneMode", "Signal 4:4", "Wifi 3:3", "Battery 100%", "Charging"]
	private let statusIconImages: [iconImages] = [.AirplaneMode, .Signal, .Carrier, .Wifi, .DoNotDisturb, .ScreenLock, .Location, .Alarm, .Bluetooth, .Battery, .Charging]
	private let statusIconImagesX: [iconImages] = [.AirplaneMode, .Signal, .Wifi, .Battery, .Charging]
	private let signalIconImages = [#imageLiteral(resourceName: "Signal 1:4"), #imageLiteral(resourceName: "Signal 2:4"), #imageLiteral(resourceName: "Signal 3:4"), #imageLiteral(resourceName: "Signal 4:4")]
	private let carrierIconImages = [#imageLiteral(resourceName: "AT&T")]
	private let wifiIconImages = [#imageLiteral(resourceName: "Wifi 1:3"), #imageLiteral(resourceName: "Wifi 2:3"), #imageLiteral(resourceName: "Wifi 3:3")]
	private let batteryIconImages = [#imageLiteral(resourceName: "Battery 10%"), #imageLiteral(resourceName: "Battery 50%"), #imageLiteral(resourceName: "Battery 100%")]
	private let batteryChargingIconImages = [#imageLiteral(resourceName: "Battery Charging 10%"), #imageLiteral(resourceName: "Battery Charging 50%"), #imageLiteral(resourceName: "Battery Charging 100%")]
	private let batteryChargingIconImagesX = [#imageLiteral(resourceName: "Battery X Charging 10%"), #imageLiteral(resourceName: "Battery X Charging 50%"), #imageLiteral(resourceName: "Battery X Charging 100%")]
	private var currentSubIconImages = [UIImage]()
	private var imgViewToEdit = UIImageView()
	private var airplaneModeImgviewInUse = UIImageView()
	private var signalImgviewInUse = UIImageView()
	private var wifiImgviewInUse = UIImageView()
	private var batteryImgviewInUse = UIImageView()
	private var batteryChargingImgviewInUse = [UIImage]()
	private var statusIconsInUse = [iconImages]()
	private var interstitial: GADInterstitial!
	
    override func viewDidLoad() {
        super.viewDidLoad()

		imageView.image = screenshot
		toolsView.alpha = 0
		
		detectIphoneVersion()
		configAdMob()
		variationsDependingOnVersion()
		imgViewFromCollection()
		hideNonEssentialIcons()
		setTime()
		roundCorners()
		shadowEffect()
		collectionViewConfig()
    }
	
	override var prefersStatusBarHidden: Bool {
		return true
	}
	
	//MARK: - IBActions
	
	@IBAction func toolBoxBtnAction(_ sender: Any) {
		toggleToolbox()
	}
	
	@IBAction func backBtnAction(_ sender: Any) {
		navigationController?.popViewController(animated: true)
	}
	
	@IBAction func shareBtnAction(_ sender: Any) {
		toggleToolbox()
		ToolBoxBtnView.isHidden = true
		
		captureScreenshot()
		if let image = screenshot {
			let shareMenuVC = UIActivityViewController(activityItems: [image], applicationActivities: [])
			shareMenuVC.completionWithItemsHandler = {(activityType: UIActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
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
		ToolBoxBtnView.isHidden = false
	}
	
	@IBAction func timePickerChanged(_ sender: UIDatePicker) {
		setTime()
	}
	
	//MARK: - Helper Functions
	
	private func detectIphoneVersion() {
		switch view.frame.height {
		case iphoneVersion.iphoneX.rawValue:
			iphone = .iphoneX
		case iphoneVersion.iphonePlus.rawValue:
			iphone = .iphonePlus
		case iphoneVersion.iphone678.rawValue:
			iphone = .iphone678
		case iphoneVersion.iphoneSE.rawValue:
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
			collectionViewHeight.constant = IPHONEX_COLLECTIONVIEW_SIZE
			batteryChargingImgviewInUse = batteryChargingIconImagesX
		} else {
			statusIconsInUse = statusIconImages
			iPhoneXstatusBarView.isHidden = true
			batteryChargingImgviewInUse = batteryChargingIconImages
		}
	}
	
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
	
	private func roundCorners() {
		toolsView.layer.cornerRadius = 10
		backBtn.layer.cornerRadius = toolsView.layer.cornerRadius
		shareBtn.layer.cornerRadius = toolsView.layer.cornerRadius
		ToolBoxBtnView.layer.cornerRadius = ToolBoxBtnView.frame.width / 2
	}
	
	private func shadowEffect() {
		ToolBoxBtnView.layer.shadowColor = UIColor.black.cgColor
		ToolBoxBtnView.layer.shadowOpacity = 0.5
		ToolBoxBtnView.layer.shadowOffset = CGSize.zero
		ToolBoxBtnView.layer.shadowRadius = 5
		
		toolsView.layer.shadowColor = UIColor.black.cgColor
		toolsView.layer.shadowOpacity = 0.5
		toolsView.layer.shadowOffset = CGSize.zero
		toolsView.layer.shadowRadius = 10
	}
	
	private func toggleIcon(imgView: UIImageView) {
		guard let iphone = iphone else { return }
		
		if imgView.isHidden {
			imgView.isHidden = false
			if imgView == airplaneModeImgviewInUse {
				signalImgviewInUse.isHidden = true
				if iphone.isIPhoneX() {
					wifiImgviewInUse.isHidden = true
				} else {
					carrierImg.isHidden = true
				}
			}
		} else {
			imgView.isHidden = true
			if imgView == airplaneModeImgviewInUse {
				signalImgviewInUse.isHidden = false
				if iphone.isIPhoneX() {
					wifiImgviewInUse.isHidden = false
				} else {
					carrierImg.isHidden = false
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
	
	private func showSubCollectionView(imgView: UIImageView, images: [UIImage]) {
		imgViewToEdit = imgView
		currentSubIconImages = images
		
		let maxAvailableSpacing = 100
		let evenSubIconLayout = subCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
		evenSubIconLayout.minimumInteritemSpacing = CGFloat(maxAvailableSpacing / (currentSubIconImages.count))
		
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

extension EditorVC: UICollectionViewDataSource, UICollectionViewDelegate {
	
	func collectionViewConfig() {
		collectionView.delegate = self
		subCollectionView.delegate = self
		collectionView.dataSource = self
		subCollectionView.dataSource = self
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if collectionView == self.collectionView {
			return statusIconsInUse.count
		} else if collectionView == subCollectionView {
			return currentSubIconImages.count
		}
		return 0
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		if collectionView == self.collectionView {
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IconToggleCell", for: indexPath) as! IconToggleCell
			
			cell.delegate = self
			cell.cellConfig(img: statusIconsInUse[indexPath.row].rawValue)
			cell.iconBtn.tag = indexPath.row
			
			cell.layer.cornerRadius = cell.frame.width / 2
			cell.layer.masksToBounds = true
			
			return cell
		} else if collectionView == subCollectionView {
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubIconCell", for: indexPath) as! SubIconCell
			cell.delegate = self
			cell.cellConfig(img: currentSubIconImages[indexPath.row])
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
	private func cancelAirplaneMode() {
		airplaneModeImgviewInUse.isHidden = true
		signalImgviewInUse.isHidden = false
		carrierImg.isHidden = false
		wifiImgviewInUse.isHidden = false
	}
	
	func iconBtnAction(image: String) {
		
		switch UIImage(named: image) {
		case #imageLiteral(resourceName: "AirplaneMode"):
			toggleIcon(imgView: airplaneModeImgviewInUse)
		case #imageLiteral(resourceName: "Signal 4:4"):
			cancelAirplaneMode()
			showSubCollectionView(imgView: signalImgviewInUse, images: signalIconImages)
		case #imageLiteral(resourceName: "AT&T"):
			cancelAirplaneMode()
			showSubCollectionView(imgView: carrierImg, images: carrierIconImages)
		case #imageLiteral(resourceName: "Wifi 3:3"):
			cancelAirplaneMode()
			showSubCollectionView(imgView: wifiImgviewInUse, images: wifiIconImages)
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
			showSubCollectionView(imgView: batteryImgviewInUse, images: chargingImg.isHidden ? batteryIconImages : batteryChargingImgviewInUse)
		default:
			print("Empty icon toggled")
		}
	}
}

//MARK: - SubIconCellDelegate

extension EditorVC: SubIconCellDelegate {
	func subIconBtnAction(sender: UIButton) {
		subCollectionView.isHidden = true
		imgViewToEdit.image = currentSubIconImages[sender.tag]
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



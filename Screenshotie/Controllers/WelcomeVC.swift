//
//  WelcomeVC.swift
//  Screenshotie
//
//  Created by Jeffrey Santana on 4/24/18.
//  Copyright © 2018 Jefffrey Santana. All rights reserved.
//

import UIKit
import Photos
import GoogleMobileAds

class WelcomeVC: UIViewController {
	
	//MARK: - IBOutlets

	@IBOutlet weak var bannerView: GADBannerView!
	let photoController = UIImagePickerController()
	var screenshot: UIImage?
	
	override func viewDidLoad() {
        super.viewDidLoad()
		checkPermission()
		configAdMob()
		
		if !launchedBefore {
			showTutorial()
			UserDefaults.standard.set(true, forKey: "launchedBefore")
		}
    }
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let vc = segue.destination as? EditorVC {
			vc.screenshot = screenshot
		}
	}
	
	//Mark: - IBActions
    
	@IBAction func PhotosBtnPressed(_ sender: Any) {
		photoLibrary()
	}
	
	//MARK: - Helper Funcs
	
	private func configAdMob() {
		let request = GADRequest()
//		request.testDevices = GAD().TESTERS
		
		bannerView.adUnitID = GAD().BANNER_AD_ID
		bannerView.rootViewController = self
		bannerView.delegate = self
		bannerView.load(request)
	}
	
	func showTutorial() {
		if let vc = storyboard?.instantiateViewController(withIdentifier: "TutorialVC") {
			present(vc, animated: true, completion: nil)
		}
	}
}

extension WelcomeVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	func checkPermission() {
		let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
		switch photoAuthorizationStatus {
		case .authorized:
			print("Access is granted by user")
		case .notDetermined:
			PHPhotoLibrary.requestAuthorization({ (newStatus) in
				print("status is \(newStatus)")
				if newStatus ==  PHAuthorizationStatus.authorized {
					print("success")
				}
			})
			print("It is not determined until now")
		case .restricted:
			print("User do not have access to photo album.")
		case .denied:
			print("User has denied the permission.")
		}
	}
	
	func photoLibrary() {
		if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
			photoController.delegate = self
			photoController.sourceType = .savedPhotosAlbum
			present(photoController, animated: true, completion: nil)
		}
	}
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		dismiss(animated: true, completion: nil)
	}
	
	@objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

		if let photo = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
			screenshot = photo
			performSegue(withIdentifier: "EditorVCSegue", sender: self)
		} else {
			print("Something went wrong")
		}
		dismiss(animated: true, completion: nil)
	}
}
extension WelcomeVC: GADBannerViewDelegate {
	/// Tells the delegate an ad request loaded an ad.
	func adViewDidReceiveAd(_ bannerView: GADBannerView) {
		print("adViewDidReceiveAd")
	}
	
	/// Tells the delegate an ad request failed.
	func adView(_ bannerView: GADBannerView,
				didFailToReceiveAdWithError error: GADRequestError) {
		print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
	}
	
	/// Tells the delegate that a full-screen view will be presented in response
	/// to the user clicking on an ad.
	func adViewWillPresentScreen(_ bannerView: GADBannerView) {
		print("adViewWillPresentScreen")
	}
	
	/// Tells the delegate that the full-screen view will be dismissed.
	func adViewWillDismissScreen(_ bannerView: GADBannerView) {
		print("adViewWillDismissScreen")
	}
	
	/// Tells the delegate that the full-screen view has been dismissed.
	func adViewDidDismissScreen(_ bannerView: GADBannerView) {
		print("adViewDidDismissScreen")
	}
	
	/// Tells the delegate that a user click will open another app (such as
	/// the App Store), backgrounding the current app.
	func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
		print("adViewWillLeaveApplication")
	}
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}

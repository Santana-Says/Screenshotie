//
//  PhotoLibraryHandler.swift
//  Screenshotie
//
//  Created by Jeffrey Santana on 4/28/18.
//  Copyright © 2018 Jefffrey Santana. All rights reserved.
//

import UIKit
import Photos


class PhotoLibraryHandler: NSObject {
	static let shared = PhotoLibraryHandler()
	private var currentVC: UIViewController?
	
	var imageSelected: UIImage?
	
	func authorizationStatus(vc: UIViewController) {
		currentVC = vc
		
		let status = PHPhotoLibrary.authorizationStatus()
		switch status {
		case .authorized:
			photoLibrary()
		case .denied:
			print("Permission denied")
			addAlertForSettings()
		case .notDetermined:
			print("Permission not determined")
			PHPhotoLibrary.requestAuthorization { (status) in
				if status == PHAuthorizationStatus.authorized {
					print("Access given")
					self.photoLibrary()
				} else {
					print("Manually restricted")
					self.addAlertForSettings()
				}
			}
		case .restricted:
			print("Permission restricted")
			addAlertForSettings()
		}
	}
	
	func addAlertForSettings() {
		let alertController = UIAlertController(title: "Open Settings", message: nil, preferredStyle: .alert)
		let settingsAction = UIAlertAction(title: "Settings", style: .destructive) { (_) in
			guard let settingsURL = NSURL(string: UIApplication.openSettingsURLString) else { return }
			UIApplication.shared.open(settingsURL as URL, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
		}
		let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
		
		alertController.addAction(settingsAction)
		alertController.addAction(cancelAction)
		currentVC?.present(alertController, animated: true, completion: nil)
		
		
	}
	
	func photoLibrary() {
		if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
			let photoController = UIImagePickerController()
			photoController.delegate = self
			photoController.sourceType = .photoLibrary
			currentVC?.present(photoController, animated: true, completion: nil)
		}
	}
	
}

extension PhotoLibraryHandler: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		currentVC?.dismiss(animated: true, completion: nil)
	}
	
	@objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

		if let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
			imageSelected = image
		} else {
			print("Something went wrong")
		}
		currentVC?.dismiss(animated: true, completion: nil)
	}
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}

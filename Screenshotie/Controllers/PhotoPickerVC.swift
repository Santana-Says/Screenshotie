//
//  ViewController.swift
//  Screenshotie
//
//  Created by Jeffrey Santana on 4/24/18.
//  Copyright © 2018 Jefffrey Santana. All rights reserved.
//

import UIKit
import Photos

class PhotoPickerVC: UIViewController {

	@IBOutlet weak var collectionView: UICollectionView!
	
	var imagePicked: ((UIImage) -> Void)?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		photoLibrary()
		authorizationStatus()
	}

}

extension PhotoPickerVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	func authorizationStatus() {
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
	
	func photoLibrary() {
		if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
			let photoController = UIImagePickerController()
			photoController.delegate = self
			photoController.sourceType = .photoLibrary
			present(photoController, animated: true, completion: nil)
		}
	}
	
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		dismiss(animated: true, completion: nil)
	}
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
			imagePicked?(image)
		} else {
			print("Something went wrong")
		}
		dismiss(animated: true, completion: nil)
	}
	
	func addAlertForSettings() {
		let alertController = UIAlertController(title: "Open Settings", message: nil, preferredStyle: .alert)
		let settingsAction = UIAlertAction(title: "Settings", style: .destructive) { (_) in
			guard let settingsURL = NSURL(string: UIApplicationOpenSettingsURLString) else { return }
			UIApplication.shared.open(settingsURL as URL, options: [:], completionHandler: nil)
		}
		let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
		
		alertController.addAction(settingsAction)
		alertController.addAction(cancelAction)
		present(alertController, animated: true, completion: nil)
		
		
	}
}


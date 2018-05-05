//
//  WelcomeVC.swift
//  Screenshotie
//
//  Created by Jeffrey Santana on 4/24/18.
//  Copyright © 2018 Jefffrey Santana. All rights reserved.
//

import UIKit
import Photos

class WelcomeVC: UIViewController {

	let photoController = UIImagePickerController()
	var screenshot: UIImage?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		checkPermission()
    }
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let vc = segue.destination as? EditorVC {
			vc.screenshot = screenshot
		}
	}
    
	@IBAction func PhotosBtnPressed(_ sender: Any) {
		photoLibrary()
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
	
	@objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		if let photo = info[UIImagePickerControllerOriginalImage] as? UIImage {
			screenshot = photo
			performSegue(withIdentifier: "WelcomeVCtoBarEditorVC", sender: self)
		} else {
			print("Something went wrong")
		}
		dismiss(animated: true, completion: nil)
	}
}

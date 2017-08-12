//
//  ViewController.swift
//  Card2Contact
//
//  Created by Griffin Solimini on 8/8/17.
//  Copyright © 2017 Griffin Solimini. All rights reserved.
//

import UIKit
import AVFoundation
import ContactsUI

class ViewController: UIViewController, AVCapturePhotoCaptureDelegate, CNContactViewControllerDelegate {

    var cameraOutput = AVCapturePhotoOutput()
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let session = setupSession() {
            if session.canAddOutput(cameraOutput) {
                session.addOutput(cameraOutput)
            }
            
            session.startRunning()
        }
        
        previewImageView.isHidden = true
        
        navigationController!.setNavigationBarHidden(true, animated: false)
    }
    
    func setupSession() -> AVCaptureSession? {
        let session = AVCaptureSession()
        
        if session.canSetSessionPreset(AVCaptureSessionPresetHigh) {
            session.sessionPreset = AVCaptureSessionPresetHigh
        }
        
        guard let discoverySession = AVCaptureDeviceDiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaTypeVideo, position: .back) else {
            return nil
        }
        
        let captureDevice = discoverySession.devices[0]
        do {
            session.addInput(try AVCaptureDeviceInput(device: captureDevice))
        } catch {
            return nil
        }
        
        if let previewLayer = AVCaptureVideoPreviewLayer(session: session) {
            containerView.layer.addSublayer(previewLayer)
            previewLayer.frame = containerView.layer.frame
        } else {
            return nil
            
        }
        
        do {
            try captureDevice.lockForConfiguration()
            captureDevice.focusMode = .continuousAutoFocus
            captureDevice.unlockForConfiguration()
        } catch {
            print("tuffcup 2.0")
        }
        
        return session
    }
    
    @IBAction func cameraButtonPressed(_ sender: Any) {
        takePhoto()
        cameraButton.isEnabled = false
        activityIndicator.startAnimating()
    }
    
    func takePhoto() {
        let settings = AVCapturePhotoSettings()
        let previewPixelType = settings.availablePreviewPhotoPixelFormatTypes.first!
        let previewFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewPixelType,
                             kCVPixelBufferWidthKey as String: 160,
                             kCVPixelBufferHeightKey as String: 160]
        settings.previewPhotoFormat = previewFormat
        cameraOutput.capturePhoto(with: settings, delegate: self)
    }
    
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
        if let error = error {
            print(error.localizedDescription)
        }
        
        if let sampleBuffer = photoSampleBuffer, let previewBuffer = previewPhotoSampleBuffer, let dataImage = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: sampleBuffer, previewPhotoSampleBuffer: previewBuffer) {
            
            if let image = UIImage(data: dataImage) {
                
                previewImageView.image = image
                previewImageView.isHidden = false
                
                if let data = UIImageJPEGRepresentation(image, 1.0) {
                    callAPI(image: data)
                }
            }
        }
    }
    
    func callAPI(image: Data) {
        APIHandler().callAPI(image: image, completion: { (data, response, error) -> Void in
            if let HTTPResponse = response as? HTTPURLResponse {
                let statusCode = HTTPResponse.statusCode
                
                if statusCode == 200 {
                    guard let data = data else {
                        return
                    }
                    
                    do {
                        guard let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary else {
                            return
                        }
                        
                        if let responses = json["responses"] as? NSArray {
                            for response in responses {
                                if let response = response as? NSDictionary {
                                    if let fta = response["fullTextAnnotation"] as? NSDictionary, let text = fta["text"] as? String {
                                        
                                        let newContact = ContactHandler().makeContact(rawText: text)
                                        DispatchQueue.main.async {
                                            self.addContact(contact: newContact) 
                                            
                                            self.cameraButton.isEnabled = true
                                            self.previewImageView.image = nil
                                            self.previewImageView.isHidden = true
                                            self.activityIndicator.stopAnimating()
                                        }
                                    }
                                }
                            }
                        }
                        
                    } catch {
                        print("error")
                    }
                }
            }
        })
    }
    
    func addContact(contact : CNMutableContact) {
        if #available(iOS 9.0, *) {
            let store = CNContactStore()
            let controller = CustomContactViewController(forUnknownContact : contact)
            controller.contactStore = store
            controller.delegate = self
            
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func contactViewLeft() {
        print("hi")
    }
}

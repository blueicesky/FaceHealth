//
//  cameraVC.swift
//  FaceHealth
//
//  Created by Tianchen Wang on 2017-12-02.
//  Copyright © 2017 Tianchen Wang. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire
import Firebase
import FirebaseDatabase
import ResearchKit

class cameraVC: UIViewController,AVCapturePhotoCaptureDelegate, ORKTaskViewControllerDelegate {
    var ref: DatabaseReference!
    @IBOutlet weak var previewLayer: UIView!
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var capturePhotoOutput: AVCapturePhotoOutput?
    var hi_h: ORKBooleanQuestionResult?
    var hi_s: ORKBooleanQuestionResult?
    @IBAction func dismissVC(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
        let result_arr = taskViewController.result
        var headaches = result_arr.results![1] as! ORKStepResult
        var smile = result_arr.results![2] as! ORKStepResult
        hi_h = headaches.results![0] as! ORKBooleanQuestionResult
        hi_s = smile.results![0] as! ORKBooleanQuestionResult
        
        taskViewController.dismiss(animated: true) {
            self.callThis()
        }
    }
    
    func callThis(){
        if Bool(hi_h!.booleanAnswer!) && Bool(hi_s!.booleanAnswer!){
            let alertController = UIAlertController(title: "Serious Stroke Risk!", message: "Please go to the hospital immediately!!!", preferredStyle: .alert)
            
            // Create OK button
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                alertController.dismiss(animated: true, completion: {
                    self.dismiss(animated: true, completion: nil)
                })
            }
            alertController.addAction(OKAction)
            
            // Create Cancel button
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in
                print("Cancel button tapped");
                alertController.dismiss(animated: true, completion: {
                    self.dismiss(animated: true, completion: nil)
                })
            }
            alertController.addAction(cancelAction)
            
            // Present Dialog message
            self.present(alertController, animated: true, completion:nil)
        }else if Bool(hi_h!.booleanAnswer!) || Bool(hi_s!.booleanAnswer!){
            let alertController = UIAlertController(title: "You are at risk of having a stroke", message: "We recommend you to consult a clinic or a family doctor.", preferredStyle: .alert)
            
            // Create OK button
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                alertController.dismiss(animated: true, completion: {
                    self.dismiss(animated: true, completion: nil)
                })
            }
            alertController.addAction(OKAction)
            
            // Create Cancel button
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in
                print("Cancel button tapped");
                alertController.dismiss(animated: true, completion: {
                    self.dismiss(animated: true, completion: nil)
                })
            }
            alertController.addAction(cancelAction)
            
            // Present Dialog message
            self.present(alertController, animated: true, completion:nil)
        }
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func convertImageToBW(image:UIImage) -> UIImage {
        
        let filter = CIFilter(name: "CIPhotoEffectMono")
        
        // convert UIImage to CIImage and set as input
        
        let ciInput = CIImage(image: image)
        filter?.setValue(ciInput, forKey: "inputImage")
        
        // get output CIImage, render as CGImage first to retain proper UIImage scale
        
        let ciOutput = filter?.outputImage
        let ciContext = CIContext()
        let cgImage = ciContext.createCGImage(ciOutput!, from: (ciOutput?.extent)!)
        
        return UIImage(cgImage: cgImage!)
    }
    
    func cropToBounds(image: UIImage, width: Double, height: Double) -> UIImage {
        
        let contextImage: UIImage = UIImage(cgImage: image.cgImage!)//(CGImage: image.CGImage!)
        
        let contextSize: CGSize = contextImage.size
        
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgwidth: CGFloat = CGFloat(width)
        var cgheight: CGFloat = CGFloat(height)
        
        // See what size is longer and create the center off of that
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            cgwidth = contextSize.height
            cgheight = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            cgwidth = contextSize.width
            cgheight = contextSize.width
        }
        
        let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)//(posX, posY, cgwidth, cgheight)
        
        // Create bitmap image from context using the rect
        let imageRef: CGImage = (contextImage.cgImage?.cropping(to: rect))!
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)//(CGImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
        
        return image
    }
    
    @IBAction func takePhoto(_ sender: Any) {
        // Make sure capturePhotoOutput is valid
        guard let capturePhotoOutput = self.capturePhotoOutput else { return }
        // Get an instance of AVCapturePhotoSettings class
        let photoSettings = AVCapturePhotoSettings()
        // Set photo settings for our need
        photoSettings.isAutoStillImageStabilizationEnabled = true
        photoSettings.isHighResolutionPhotoEnabled = true
        photoSettings.flashMode = .auto
        // Call capturePhoto method by passing our photo settings and a
        // delegate implementing AVCapturePhotoCaptureDelegate
        capturePhotoOutput.capturePhoto(with: photoSettings, delegate: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        let captureDevice = AVCaptureDevice.default(AVCaptureDevice.DeviceType.builtInWideAngleCamera, for: AVMediaType.video, position: AVCaptureDevice.Position.front)
       
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            captureSession = AVCaptureSession()
            captureSession?.addInput(input)
            
            // Get an instance of ACCapturePhotoOutput class
            capturePhotoOutput = AVCapturePhotoOutput()
            capturePhotoOutput?.isHighResolutionCaptureEnabled = true
            // Set the output on the capture session
            captureSession?.addOutput(capturePhotoOutput!)
            
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            previewLayer.layer.addSublayer(videoPreviewLayer!)
            captureSession?.startRunning()
        } catch {
            print(error)
        }
        
    }
    
    func photoOutput(_ captureOutput: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?,
                     previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?,
                     resolvedSettings: AVCaptureResolvedPhotoSettings,
                     bracketSettings: AVCaptureBracketedStillImageSettings?,
                     error: Error?) {
        // Make sure we get some photo sample buffer
        guard error == nil,
            let photoSampleBuffer = photoSampleBuffer else {
                print("Error capturing photo: \(String(describing: error))")
                return
        }
        
        // Convert photo same buffer to a jpeg image data by using AVCapturePhotoOutput
        guard let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer) else {
            return
        }
        var stroke_in = false
        // Initialise an UIImage with our image data
        let capturedImage = UIImage.init(data: imageData , scale: 1.0)
        let dbRef = self.ref.childByAutoId()
        if let helloImage = capturedImage {
            var placeholder = cropToBounds(image: helloImage, width: Double(helloImage.size.width), height: Double(helloImage.size.width))
            var photoImage = resizeImage(image: placeholder,newWidth: 96)
            let datazzz = UIImageJPEGRepresentation(photoImage, 1.0)
            let base64EnCodedStr2:String = datazzz!.base64EncodedString()
            photoImage = convertImageToBW(image: photoImage)
            let data = UIImageJPEGRepresentation(photoImage, 1.0)
            let base64EnCodedStr:String = data!.base64EncodedString()
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM dd yyyy HH:mm"
            let result = formatter.string(from: date)
            UIImageWriteToSavedPhotosAlbum(photoImage, nil, nil, nil)
            Alamofire.request("http://35.199.10.134/", method: .get, parameters: ["photo":base64EnCodedStr]).responseJSON{response in
                print("-----")
                if response.result.isSuccess{
                    if let res = response.value as? Dictionary<String,Int>{
                        print(res)
                        if res["result"] == 0{
                            dbRef.child("Health").setValue("Healthy")
                        }else{
                            dbRef.child("Health").setValue("Unhealthy")
                        }
                        
                        if res["stroke_risk"] == 1{
                            stroke_in = true
                            if stroke_in{
                                let taskViewController = ORKTaskViewController(task: SurveyTask, taskRun: nil)
                                taskViewController.delegate = self
                                self.present(taskViewController, animated: true, completion: nil)
                            }
                            dbRef.child("Stroke").setValue(1)
                        }else{
                            self.performSegue(withIdentifier: "toHistoryC", sender: self)
                            dbRef.child("Stroke").setValue(0)
                        }
                    }
                }else{
                    print("Not Successful")
                }
            }
            dbRef.child("Date").setValue(result)
            dbRef.child("Image").setValue(base64EnCodedStr2)
            
            // Save our captured image to photos album
            //UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
    }

}



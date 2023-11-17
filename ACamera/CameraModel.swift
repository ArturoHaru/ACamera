//
//  CameraModel.swift
//  ACamera
//
//  Created by Arturo Cecora on 16/11/23.
//

import Foundation
import AVFoundation
import SwiftUI

class CameraModel: NSObject,ObservableObject,AVCapturePhotoCaptureDelegate{
    
    @Published var isTaken = false
    
    @Published var session = AVCaptureSession()
    
    @Published var alert = false
    
    // since were going to read pic data....
    @Published var output = AVCapturePhotoOutput()
    
    // preview....
    @Published var preview : AVCaptureVideoPreviewLayer!
    
    @Published var image = UIImage()
    
    @Published var flashEnabled = false
    @Published var frontCameraEnabled = true
    
    @Published var input: AVCaptureDeviceInput?
    @State var devicePosition = AVCaptureDevice.Position.back
    @State var deviceType = AVCaptureDevice.DeviceType.builtInDualWideCamera
    
    func Check(){
        
        // first checking camerahas got permission...
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setUp()
            return
            // Setting Up Session
        case .notDetermined:
            // retusting for permission....
            AVCaptureDevice.requestAccess(for: .video) { (status) in
                
                if status{
                    self.setUp()
                }
            }
        case .denied:
            self.alert.toggle()
            return
            
        default:
            return
        }
    }
    
    func turnCamera(){
        frontCameraEnabled.toggle()
        self.session.stopRunning()
        session.beginConfiguration()
        session.removeInput(input!)
        self.session.commitConfiguration()
        self.setUp()
        
        
    }
    
    func setUp(){
        
        // setting up camera...
        
        do{
            
            // setting configs...
            self.session.beginConfiguration()
            
            // change for your own...
            
            let device = AVCaptureDevice.default(frontCameraEnabled ? .builtInWideAngleCamera : .builtInDualWideCamera, for: .video, position: frontCameraEnabled ? .front : .back)
            print(frontCameraEnabled)
            print(frontCameraEnabled ? AVCaptureDevice.DeviceType.builtInWideAngleCamera : AVCaptureDevice.DeviceType.builtInDualWideCamera)
            print(frontCameraEnabled ? AVCaptureDevice.Position.front.rawValue : AVCaptureDevice.Position.back.rawValue)
            input = try AVCaptureDeviceInput(device: device!)
            
            // checking and adding to session...
            
            if self.session.canAddInput(input!){
                self.session.addInput(input!)
            }
            
            // same for output....
            
            if self.session.canAddOutput(self.output){
                self.session.addOutput(self.output)
            }
            
            session.sessionPreset = .photo
            
            self.session.commitConfiguration()
            
            DispatchQueue.global(qos: .background).async {
                self.session.startRunning()
                
            }
        }
        catch{
            print(error.localizedDescription)
        }
    }
    
    // take and retake functions...
    
    func takePic(){
        
        self.output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
        //self.session.stopRunning()
        self.reTake()
        
        DispatchQueue.global().async {
            
            
            DispatchQueue.main.async {
                
                withAnimation{self.isTaken.toggle()}
            }
        }
    }
    
    func reTake(){
        
        DispatchQueue.global(qos: .background).async {
            self.session.startRunning()
            
            DispatchQueue.main.async {
                withAnimation{self.isTaken.toggle()}
            }
            
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        print("reached")
        
        if error != nil{
            print(error!)
            return
        }
        
        guard let imageData = photo.fileDataRepresentation() else{return}
        print("image taken")

        guard let uiImage = UIImage(data: imageData) else {return}
        
        
        self.image = uiImage
        
    
        UIImageWriteToSavedPhotosAlbum(self.image, nil, nil, nil)
        print("image saved")
    }
}

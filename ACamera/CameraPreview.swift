//
//  CameraPreview.swift
//  ACamera
//
//  Created by Arturo Cecora on 16/11/23.
//

import Foundation
import AVFoundation
import SwiftUI


struct CameraPreview: UIViewRepresentable{
    
    var attributes = CameraAttributes()
    
    @ObservedObject var camera : CameraModel
    
    func makeUIView(context: Context) -> some UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: attributes.width, height: attributes.height))
        
        camera.preview = AVCaptureVideoPreviewLayer(session: camera.session)
        camera.preview.frame = view.frame
        
        camera.preview.videoGravity = .resizeAspectFill
        view.layer.addSublayer(camera.preview)
        
        DispatchQueue.global(qos: .background).async{
            camera.session.startRunning()
            
        }
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}

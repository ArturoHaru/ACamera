//
//  ContentView.swift
//  ACamera
//
//  Created by Arturo Cecora on 16/11/23.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var camera = CameraModel()
    
    @State var attributes = CameraAttributes()
    @State var flashicon = "bolt.circle"
    
    
    
    var body: some View {
        ZStack{
            Color.black
                .ignoresSafeArea()
            VStack{
                HStack{
                    Button(action: {
                        camera.flashEnabled.toggle()
                        flashicon = !camera.flashEnabled ? "bolt.circle" : "bolt.slash.circle"
                    }, label: {
                        Image(systemName: flashicon)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25)
                            .foregroundStyle(.white)
                            .padding()
                    })
                    .accessibilityLabel("Flash")
                    .accessibilityHint(camera.flashEnabled ? "Flash is enabled" : "Flash is disabled")
                    Spacer()
                }
                CameraPreview(camera: camera)
                VStack{
                    
                    HStack {
                        
                        ScrollView(.horizontal, showsIndicators: false){
                            HStack{
                                ForEach(attributes.labels, id: \.self) {
                                    Text($0)
                                        .foregroundStyle(.white)
                                        .containerRelativeFrame(.horizontal, count: 1, spacing: 4)
                                }
                            }
                            .scrollTargetLayout()
                        }
                        .scrollClipDisabled()
                        .contentMargins(2,for: .scrollContent)
                        .scrollTargetBehavior(.viewAligned)
                        .frame(width: 100, height: 20)
                        .contentShape(Rectangle())
                    }
                    
                    HStack{
                        Rectangle()
                            .fill(.secondary)
                            .frame(width: 50,height: 50)
                        Spacer()
                        Button(action: {
                            camera.takePic()
                            camera.reTake()}, label: {
                                ZStack{
                                    Circle()
                                        .fill(.white)
                                        .frame(width: 60, height: 60)
                                    Circle()
                                        .stroke(Color.white, lineWidth: 4)
                                        .frame(width: 70, height: 70)
                                }
                            })
                        .accessibilityLabel("Take Picture")
                        
                        Spacer()
                        Button(action: {
                            camera.turnCamera()
                        }, label: {
                            ZStack{
                                Circle()
                                    .fill(Color(red: 44/255, green: 44/255, blue: 46/255))
                                    .frame(width: 50,height: 50)
                                
                                Image(systemName: "arrow.triangle.2.circlepath")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 35,height: 35)
                                    .foregroundStyle(.white)
                            }
                        })
                        .accessibilityLabel("Switch Camera")
                        .accessibilityHint(camera.frontCameraEnabled ? "Front Camera Enabled" : "Back Camera Enabled")
                    }
                    .padding()
                    .padding(.bottom, 20)
                }
            }
        }.onAppear(){
            camera.Check()

        }
    }
}

#Preview {
    ContentView()
}

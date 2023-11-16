//
//  ContentView.swift
//  ACamera
//
//  Created by Arturo Cecora on 16/11/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack{
            Color.black
                .ignoresSafeArea()
            VStack{
                Spacer()
                HStack{
                    Rectangle()
                        .fill(.secondary)
                        .frame(width: 50,height: 50)
                    Spacer()
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        ZStack{
                            
                            Circle()
                                .fill(.white)
                                .frame(width: 70, height: 70)
                            Circle()
                                .stroke(Color.white, lineWidth: 4)
                                .frame(width: 80, height: 80)
                            
                        }
                        
                    })
                    Spacer()
                    ZStack{
                        Circle()
                            .fill(.secondary)
                            .frame(width: 50,height: 50)
                        Image(systemName: "arrow.triangle.2.circlepath")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 35,height: 35)
                            .foregroundStyle(.white)
                        
                    }
                    
                }
                .padding()
            }
        }
    }
}

#Preview {
    ContentView()
}

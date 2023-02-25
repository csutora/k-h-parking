//
//  MapView.swift
//  K&H Parking
//
//  Created by Török Péter on 2023. 02. 25..
//

//unfortunately we didn't have time to implement an actual map system:(

import Foundation
import SwiftUI

struct MapGuideView: View {
    var body: some View {
        GeometryReader { geometry in
            Image("parkolo1")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: geometry.size.width * 0.9)
                .position(x: geometry.frame(in: .local).midX, y: geometry.frame(in: .local).midY)
        }
    }
}

struct MapTakenView: View {
    @State private var inputText: String = ""
    @State private var isImageVisible = false
    
    var body: some View {
        VStack {
            Text("")
            Text("Írd be a rendszámát annak, \n        aki beállt a helyedre")
                .font(.system(size: 18, weight: .bold))
            Text("")
            TextField("", text: $inputText)
                .padding()
                .frame(width: 200, height: 50)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray, lineWidth: 1)
                )
            
            Button(action: {
                isImageVisible = true
            }) {
                Text("Keress meg")
            }
            .padding()
            
            if isImageVisible && !inputText.isEmpty {
                GeometryReader { geometry in
                    Image("parkolo2")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.width * 0.9)
                        .position(x: geometry.frame(in: .local).midX, y: geometry.frame(in: .local).midY)
                }
            }
            
            Spacer()
        }
    }
}

                

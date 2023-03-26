//
//  playgroundView.swift
//  LonelyscapeAR
//
//  Created by Vinchen Amigo on 25/03/23.
//

import SwiftUI

struct playgroundView: View {
    
    @State public var userInput = ""
    
    var body: some View {
        ZStack {
            Color("#1e1e1e")
                .edgesIgnoringSafeArea(.all)
                .opacity(0.5)
            
            VStack(alignment: .leading) {
                Button("back") {
                }
                .buttonStyle(CustomButtonStyle())
                
                TextField("Enter a keyword", text: $userInput)
                
                Button(action:{}, label:{
                    HStack{
                        Spacer()
                        Text("Test")
                        Spacer()
                    }
                })
                .buttonStyle(CustomButtonStyle())
            }
        }
    }
}

struct playgroundView_Previews: PreviewProvider {
    static var previews: some View {
        playgroundView()
    }
}

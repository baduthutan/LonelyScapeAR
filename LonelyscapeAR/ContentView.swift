//
//  ContentView.swift
//  LonelyscapeAR
//
//  Created by Vinchen Amigo on 21/03/23.
//

import AVKit
import SwiftUI
import RealityKit
import ARKit

struct ContentView : View {
    var body: some View {
        MainMenu()
    }
}
struct GameplayView : View {
    @State var audioPlayer: AVAudioPlayer!
    @State public var clickComputer:Bool = false
    @State public var clickSafe:Bool = false
    @State public var clickBox:Bool = false
    @State public var doorOpens:Bool = false
    @State public var userInput = ""
    @State public var pinCorrect = false
    @State private var outOfPlayzone:Bool = false
    @State private var arView:ARView = ARView(frame: .zero)
    @State private var scene:Experience.Scene = try! Experience.loadScene()
    @State private var keyAppear:Bool = false
    @State private var openSafe:Bool = false
    @State private var playBacksound:Bool = false
    @State private var keyObtain:Bool = false
    @State private var binaryString = ""
    @State private var statusString = ""
    
    
    var body: some View {
        NavigationView{
            ZStack{
                ARViewContainer(clickComputer: $clickComputer, clickSafe: $clickSafe, clickBox: $clickBox, arView: $arView,scene: $scene, keyObtain: $keyObtain,  outOfPlayzone: $outOfPlayzone, doorOpens: $doorOpens).edgesIgnoringSafeArea(.all)
                    .onAppear {
                                let sound = Bundle.main.path(forResource: "song", ofType: "mp3")
                                self.audioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
                                audioPlayer.numberOfLoops = -1
                                self.audioPlayer.play()
                            }

                
                if clickComputer{
                    ZStack {
                        Image("bg")
                            .resizable()
                            .edgesIgnoringSafeArea(.all)
                            .opacity(0.5)
                        
                        VStack(alignment: .leading) {
                            Button("back") {
                                clickComputer.toggle()
                                statusString = ""
                                userInput = ""
                            }
                            .buttonStyle(CustomButtonStyle())
                            
                            Spacer()
                            
                            TextField("Enter a keyword", text: $userInput)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.bottom, 10)
        
                            Button(
                            action: {
                                if userInput.lowercased() == "tes" {
                                    statusString = "Access granted, clue: 1110100"
                                } else {
                                    statusString = "The keyword does not match."
                                }
                            },label: {
                                HStack{
                                    Spacer()
                                    Text("Enter Password")
                                    Spacer()
                                }
                            })
                            .buttonStyle(CustomSmallButtonStyle())
                            
                            Text(statusString)
                        
                            Spacer()
                        }
                        .padding()
                    }
                }
                if clickSafe{
                    ZStack {
                        Image("bg")
                            .resizable()
                            .edgesIgnoringSafeArea(.all)
                            .opacity(0.5)
                        
                        VStack(alignment: .leading) {
                            Button("back") {
                                clickSafe.toggle()
                                binaryString = ""
                                statusString = ""
                            }
                            .buttonStyle(CustomButtonStyle())
                            Spacer()
                            
                            HStack {
                                Spacer()
                                
                                Button("to left") {
                                    binaryString += "0"
                                }
                                .buttonStyle(CustomButtonStyle())
                                Button("to right") {
                                    binaryString += "1"
                                }
                                .buttonStyle(CustomButtonStyle())
                                Spacer()
                            }
                            .padding(.bottom, 10)
                            Button(
                            action: {
                                if binaryString == "1110100" {
                                    openSafe = true
                                    scene.notifications.openSafe.post()
                                    statusString = "The combination mathces!"
                                } else {
                                    statusString = "The combination does not match."
                                    binaryString = ""
                                }
                            },label: {
                                HStack{
                                    Spacer()
                                    Text("Check Combination")
                                    Spacer()
                                }
                            })
                            .buttonStyle(CustomSmallButtonStyle())
                            
                            
                            Text(statusString)
                            
                            Spacer()
                        }
                        .padding()
                    }
                }
                if clickBox{
                    ZStack {
                        Image("bg")
                            .resizable()
                            .edgesIgnoringSafeArea(.all)
                            .opacity(0.5)
                        
                        VStack(alignment: .leading) {
                            Button("back") {
                                clickBox.toggle()
                                statusString = ""
                                userInput = ""
                            }
                            .buttonStyle(CustomButtonStyle())
                            
                            Spacer()
                            
                            TextField("Enter PIN number", text: $userInput)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.numberPad)
                                .padding(.bottom, 10)
                            
                            Button(
                            action: {
                                if userInput == "56709" {
                                    statusString = "The PIN matches!"
                                    pinCorrect.toggle()
                                    keyAppear = true
                                    scene.notifications.keyAppear.post()
                                } else {
                                    statusString = "The PIN does not match."
                                    }
                            }, label: {
                                HStack{
                                    Spacer()
                                    Text("Check PIN")
                                    Spacer()
                                }
                            })
                            .buttonStyle(CustomSmallButtonStyle())
                            
                            Text(statusString)
                            
                            Spacer()
                        }
                        .padding()
                    }
                }
                if outOfPlayzone && !doorOpens{
                    ZStack {
                        Image("danger")
                            .resizable()
                            .edgesIgnoringSafeArea(.all)
                            .opacity(0.5)
                        
                        Text("Please go back to playzone!")
                    }
                }
                if doorOpens{
                    ZStack {
                        Image("success")
                            .resizable()
                            .edgesIgnoringSafeArea(.all)
                            .opacity(0.5)
                        
                        VStack{
                            Text("You escaped!")
                            NavigationLink(destination: MainMenu()){
                                HStack{
                                    Spacer()
                                    Text("Back to main menu")
                                    Spacer()
                                }
                                .padding(10)
                                .background(Color.white)
                                .cornerRadius(16)
                                .foregroundColor(Color.black)
                                .frame(width: 280, height: 70)
                            }
                            .simultaneousGesture(TapGesture().onEnded{
                                self.audioPlayer.pause()
                            })
                        }
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        
    }
}

struct ARViewContainer: UIViewRepresentable {

    @Binding var clickComputer:Bool
    @Binding var clickSafe:Bool
    @Binding var clickBox:Bool
    @Binding var arView:ARView
    @Binding var scene:Experience.Scene
    @Binding var keyObtain:Bool
    @Binding var outOfPlayzone:Bool
    @Binding var doorOpens:Bool
    
    func makeUIView(context: Context) -> ARView {
        let coachingOverlay = ARCoachingOverlayView()
        coachingOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        coachingOverlay.session = arView.session
        coachingOverlay.goal = .horizontalPlane
        arView.addSubview(coachingOverlay)
        
        scene.actions.tappedComputer.onAction = handleTapOnComputer(_:)
        scene.actions.tappedSafe.onAction = handleTapOnSafe(_:)
        scene.actions.outedOfPlayzone.onAction = handleOutOfPlayzone(_:)
        scene.actions.intoPlayzone.onAction = handleIntoPlayzone(_:)
        scene.actions.tappedBox.onAction = handleTapOnBox(_:)
        scene.actions.openDoor.onAction = handleOpenDoor(_:)
        arView.scene.anchors.append(scene)
    
        return arView
    }
    
    func pressKeyObtain(_ entity: Entity?) {
        keyObtain = true
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
    func handleTapOnComputer(_ entity: Entity?) {
        clickComputer = true
    }
    
    func handleTapOnSafe(_ entity: Entity?) {
        clickSafe = true
    }
    
    func handleTapOnBox(_ entity: Entity?) {
        clickBox = true
    }
    
    func handleOutOfPlayzone(_ entity: Entity?) {
        outOfPlayzone = true
    }
    
    func handleIntoPlayzone(_ entity: Entity?) {
        outOfPlayzone = false
    }
    func handleOpenDoor(_ entity: Entity?) {
        doorOpens = true
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif

struct MainMenu : View {
    var body: some View {
        NavigationView{
            ZStack{
                Image("bg")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                VStack{
                    Image("LONELYSCAPE")
                        .resizable()
                        .frame(width: 280, height: 30)
                    NavigationLink(destination: GameplayView()){
                        HStack{
                            Spacer()
                            Text("Play Game")
                            Spacer()
                        }
                        .padding(10)
                        .background(Color.white)
                        .cornerRadius(16)
                        .foregroundColor(Color.black)
                        .frame(width: 280, height: 70)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}


struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .background(configuration.isPressed ? Color.white : Color.black)
            .cornerRadius(16)
            .foregroundColor(configuration.isPressed ? Color.black : Color.white)
            .scaleEffect(configuration.isPressed ? 1.1 : 1)
            .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct CustomSmallButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(5)
            .background(configuration.isPressed ? Color.black : Color.white)
            .cornerRadius(5)
            .foregroundColor(configuration.isPressed ? Color.white : Color.black)
            .scaleEffect(configuration.isPressed ? 1.1 : 1)
            .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
    }
}

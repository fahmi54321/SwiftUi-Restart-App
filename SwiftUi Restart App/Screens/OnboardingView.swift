//
//  OnboardingView.swift
//  SwiftUi Restart App
//
//  Created by Fahmi Aziz on 15/08/23.
//

import SwiftUI

struct OnboardingView: View {
    
    // MARK: PROPERTY
    @AppStorage("onboarding") var isOnboardingViewActive: Bool = true
    
    @State private var buttonWidth: Double = UIScreen.main.bounds.width - 80;
    @State private var buttonOffset: CGFloat = 0
    @State private var isAnimation: Bool = false
    @State private var imageOffset: CGSize = CGSize(width: 0, height: 0)
    @State private var indicatorOpacity: Double = 1.0
    @State private var textTitle: String = "Share."
    
    let hapticFeedback = UINotificationFeedbackGenerator()
    
    // MARK: BODY
    
    var body: some View {
        ZStack {
            Color("ColorBlue")
                .ignoresSafeArea(.all,edges: .all)
            
            VStack(spacing: 20.0){
                // MARK: - HEADER
                
                Spacer()
                VStack(spacing: 0){
                    Text(textTitle)
                        .font(.system(size: 60.0))
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .transition(.opacity)
                        .id(textTitle)
                    
                    Text("""
                It's not how much we give but
                how much love we put into giving
                """)
                    .font(.title3)
                    .fontWeight(.light)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal,10.0)
                }// HEADER
                .opacity(isAnimation ? 1 : 0)
                .offset(y: isAnimation ? 0 : -40)
                .animation(.easeOut(duration: 1), value: isAnimation)
                
                // MARK: - CENTER
                
                ZStack{
                    CircleGroupView(ShapeColor: .white, ShapeOpacity: 0.2)
                        .offset(x: imageOffset.width * -1)
                        .blur(radius: abs(imageOffset.width / 5))
                        .animation(.easeOut(duration: 1), value: imageOffset)
                    
                    Image("character-1")
                        .resizable()
                        .scaledToFit()
                        .opacity(isAnimation ? 1 : 0)
                        .animation(.easeOut(duration: 0.5), value: isAnimation)
                        .offset(x: imageOffset.width * 1.2, y: 0)
                        .rotationEffect(.degrees(Double(imageOffset.width / 20)))
                        .gesture(
                            DragGesture()
                                .onChanged{ gesture in
                                    if(abs(imageOffset.width) <= 150){
                                        imageOffset = gesture.translation
                                        
                                        withAnimation(.linear(duration: 0.25)){
                                            indicatorOpacity = 0
                                            textTitle = "Give."
                                        }
                                    }
                                }
                                .onEnded{_ in
                                    imageOffset = .zero
                                    
                                    withAnimation(.linear(duration: 0.25)){
                                        indicatorOpacity = 1
                                        textTitle = "Share."
                                    }
                                }
                        ) // GESTURE
                        .animation(.easeOut(duration: 1), value: imageOffset)
                }// CENTER
                .overlay(
                    Image(systemName: "arrow.left.and.right.circle")
                        .font(.system(size: 44.0,weight: .ultraLight))
                        .foregroundColor(.white)
                        .offset(y: 20)
                        .opacity(isAnimation ? 1 : 0)
                        .animation(.easeOut(duration: 1).delay(2), value: isAnimation)
                        .opacity(indicatorOpacity)
                    ,alignment: .bottom
                )
                Spacer()
                
                // MARK: - FOOTER
                
                ZStack{
                    // PARTS OF THE CUSTOM BUTTON
                    
                    // 1. BACKGROUND (STATIC)
                    
                    Capsule()
                        .fill(Color.white.opacity(0.2))
                    
                    Capsule()
                        .fill(Color.white.opacity(0.2)).padding()
                    
                    // 2. CALL-TO-ACTION (STATIC)
                    
                    Text("Get Started")
                        .font(.system(.title3,design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .offset(x: 20.0)
                    
                    // 3. CAPSULE (DYNAMIC WIDTH)
                    
                    HStack{
                        Capsule()
                            .fill(Color("ColorRed"))
                            .frame(width: buttonOffset + 80)
                        Spacer()
                    }
                    // 4. CIRCLE (DRAGGABLE)
                    HStack {
                        ZStack{
                            Circle()
                                .fill(Color("ColorRed"))
                            Circle()
                                .fill(.black.opacity(0.15))
                                .padding(8)
                            Image(systemName: "chevron.right.2")
                                .font(.system(size: 24.0,weight: .bold))
                        }
                        .foregroundColor(.white)
                        .frame(width: 80.0,height: 80.0,alignment: .center)
                        .offset(x: buttonOffset)
                        .gesture(
                            DragGesture()
                                .onChanged{ gesture in
                                    
                                    if(gesture.translation.width > 0 && buttonOffset <= buttonWidth - 80){
                                        buttonOffset = gesture.translation.width
                                    }
                                    
                                }
                                .onEnded{_ in
                                    withAnimation(.easeIn(duration: 0.4)){
                                        hapticFeedback.notificationOccurred(.success)
                                        playSound(sound: "chimeup", type: "mp3")
                                        if(buttonOffset > buttonWidth / 2){
                                            buttonOffset = buttonWidth - 80
                                            isOnboardingViewActive = false
                                        }else{
                                            hapticFeedback.notificationOccurred(.warning)
                                            buttonOffset = 0
                                        }
                                    }
                                }
                        )// GESTURE
                        
                        Spacer()
                    }// HSTACK
                    
                    
                }// FOOTER
                .frame(width: buttonWidth,height: 80.0,alignment: .center)
                .padding()
                .opacity(isAnimation ? 1 : 0)
                .offset(y: isAnimation ? 0 : 40)
                .animation(.easeOut(duration: 1), value: isAnimation)
                
            } // VSTACK
        }// ZSATCK
        .onAppear {
            isAnimation = true
        }
        .preferredColorScheme(.dark)
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}

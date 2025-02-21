import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var opacity = 0.0
    
    var body: some View {
        if isActive {
            ContentView() // Transition to your main app screen
        } else {
            VStack {
                Image("startup") // Replace with your app's logo
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(25)
                    .frame(width: 150, height: 150)
                    .foregroundColor(.blue)
                    .opacity(opacity)
                    .onAppear {
                        withAnimation(.easeIn(duration: 1.5)) {
                            opacity = 1.0
                        }
                    }
                
                Text("DJTX AI V1") // Replace with your app name
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .opacity(opacity)
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    withAnimation {
                        isActive = true // Transition to the main view
                    }
                }
            }
        }
    }
}

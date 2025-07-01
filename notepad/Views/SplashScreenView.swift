import SwiftUI

struct SplashScreenView: View {
    @State private var logoScale: CGFloat = 0.5
    @State private var logoOpacity: Double = 0.0
    @State private var logoRotation: Double = 0.0
    @State private var textOpacity: Double = 0.0
    @State private var showPulse: Bool = false

    var body: some View {
        ZStack {
            // Background dengan gradient
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.cyan.opacity(0.2)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Spacer()
                
                // Logo dengan animasi
                ZStack {
                    // Efek pulse di background
                    Circle()
                        .fill(Color.cyan.opacity(0.3))
                        .frame(width: showPulse ? 200 : 140, height: showPulse ? 200 : 140)
                        .opacity(showPulse ? 0.0 : 0.8)
                        .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: false), value: showPulse)
                    
                    // Teks logo utama dengan animasi menarik
                    Text("Notepad")
                        .font(.system(size: 48, weight: .heavy, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color.cyan, Color.blue, Color.purple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .scaleEffect(logoScale)
                        .opacity(logoOpacity)
                        .rotationEffect(.degrees(logoRotation))
                        .shadow(color: Color.cyan.opacity(0.4), radius: 10, x: 0, y: 8)
                }
                
                Spacer()
            }
        }
        .onAppear {
            startAnimations()
        }
    }
    
    private func startAnimations() {
        // Animasi logo masuk dengan bounce
        withAnimation(.spring(response: 0.8, dampingFraction: 0.6, blendDuration: 0)) {
            logoScale = 1.0
            logoOpacity = 1.0
        }
        
        // Animasi rotasi ringan
        withAnimation(.easeInOut(duration: 0.5).delay(0.3)) {
            logoRotation = 360.0
        }
        
        // Animasi teks muncul
        withAnimation(.easeIn(duration: 0.8).delay(0.6)) {
            textOpacity = 1.0
        }
        
        // Mulai efek pulse
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            showPulse = true
        }
    }
}

#Preview {
    SplashScreenView()
}

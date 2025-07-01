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
                    
                    // Logo utama - logo notepad asli
                    Image("logo-notepad")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .scaleEffect(logoScale)
                        .opacity(logoOpacity)
                        .rotationEffect(.degrees(logoRotation))
                }
                
                // Teks aplikasi
                VStack(spacing: 8) {
                    Text("Notepad")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .opacity(textOpacity)
                    
                    Text("Catatan Harian Anda")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .opacity(textOpacity)
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

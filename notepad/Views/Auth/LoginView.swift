import SwiftUI

struct LoginView: View {
    @Binding var isLoggedIn: Bool
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isSecure: Bool = true
    @State private var showAlert: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            // Logo/teks aplikasi di atas
            Text("Notepad")
                .font(.system(size: 40, weight: .heavy, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color.cyan, Color.blue, Color.purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: Color.cyan.opacity(0.3), radius: 8, x: 0, y: 6)
                .padding(.bottom, 10)
            
            // Username field
            TextField("Username or Email", text: $username)
                .autocapitalization(.none)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.secondarySystemBackground))
                        .shadow(color: Color.cyan.opacity(0.08), radius: 4, x: 0, y: 2)
                )
                .padding(.horizontal)
            
            // Password field
            HStack {
                if isSecure {
                    SecureField("Password", text: $password)
                } else {
                    TextField("Password", text: $password)
                }
                Button(action: { isSecure.toggle() }) {
                    Image(systemName: isSecure ? "eye.slash" : "eye")
                        .foregroundColor(.cyan)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.secondarySystemBackground))
                    .shadow(color: Color.blue.opacity(0.08), radius: 4, x: 0, y: 2)
            )
            .padding(.horizontal)
            
            // Login button
            Button(action: {
                showAlert = true
            }) {
                Text("Login")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        LinearGradient(
                            colors: [Color.cyan, Color.blue],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .shadow(color: Color.cyan.opacity(0.2), radius: 6, x: 0, y: 4)
            }
            .padding(.horizontal)
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Login Berhasil"),
                    message: Text("Selamat datang, \(username)!"),
                    dismissButton: .default(Text("OK")) {
                        isLoggedIn = true
                    }
                )
            }
            
            Spacer()
        }
        .padding()
        .background(
            LinearGradient(
                colors: [Color.white, Color.cyan.opacity(0.08), Color.blue.opacity(0.05)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
    }
}

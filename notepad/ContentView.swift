//
//  ContentView.swift
//  notepad
//
//  Created by Syahrial Danu on 30/06/25.
//

import SwiftUI

struct ContentView: View {
    @State private var isLoggedIn: Bool = false
    @State private var showSplash: Bool = true
    
    var body: some View {
        if showSplash {
            SplashScreenView()
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation { showSplash = false }
                    }
                }
        } else if !isLoggedIn {
            LoginView(isLoggedIn: $isLoggedIn)
        } else {
            HomeTabView()
        }
    }
}

#Preview {
    ContentView()
}

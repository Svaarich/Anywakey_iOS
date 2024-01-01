//
//  InfoView.swift
//  LANWakeUp-IOS
//
//  Created by Svarychevskyi Danylo on 09.12.2023.
//

import SwiftUI

struct AppInfoView: View {
    
    var body: some View {
        VStack {
            Text("Some Info")
                .frame(height: 200)
                .frame(maxWidth: .infinity)
                .background(.gray.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding(.bottom)
            gitHubButton
            Text("Text text text text text\ntext text text text text")
                .padding(.top)
            Spacer()
            Text("Version number: 1.0")
                .foregroundStyle(.secondary)
                .font(.caption)
        }
        .navigationTitle("App Information")
        .navigationBarTitleDisplayMode(.large)
        .padding(.horizontal)
        .padding(.top)
    }
    
    private var gitHubButton: some View {
        Link(destination: DrawingConstants.gitHubURL!) {
            HStack {
                Image(systemName: "text.word.spacing")
                Text("GitHub".uppercased())
                
            }
            .foregroundStyle(.black)
            .fontWeight(.semibold)
            .padding()
            .padding(.horizontal, 8)
            .frame(maxWidth: .infinity)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(color: .black.opacity(0.15), radius: 10, y: 10)
        }
    }
    
    private struct DrawingConstants {
        static let gitHubURL = URL(string: "https://github.com/Svaarich")
    }
}

#Preview {
    AppInfoView()
}

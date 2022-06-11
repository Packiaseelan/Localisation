//
//  ContentView.swift
//  HexLocalisationExample
//
//  Created by Packiaseelan S on 11/06/22.
//

import SwiftUI

struct ContentView: View {
    
    @AppStorage("selectedLanguageId") var selectedLanguageId: String?
    @AppStorage("selectedLanguage") var selectedLanguage: String?
    
    @EnvironmentObject var localisation: Localisation
    
    @State var selectedLang: String?
    
    @State var showSupportLanguage: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Hello, world!")
                .padding()
            
            HStack {
                Text("Selected Language: ")
                    .font(.headline)
                Spacer()
                if let lang = selectedLang ?? "None" {
                    Text(lang)
                        .font(.title)
                        .foregroundColor(selectedLanguage == nil ? .red : .green)
                        .onTapGesture {
                            showSupportLanguage.toggle()
                        }
                }
            }
            
            HStack {
                Text("App Name:")
                    .font(.headline)
                Spacer()
                Text(localisation.getString(for: "app_name"))
                    .font(.title)
            }
            
            Text(localisation.getString(for: "app_description"))
                .font(.headline)
                .foregroundColor(.secondary)
                .padding(.vertical)
            
            Text(localisation.getString(for: "question"))
                .font(.headline)
            
            Text(localisation.getString(for: "answer"))
                .font(.body)
                .foregroundColor(.secondary)
        
            Spacer()
        }
        .padding(.horizontal)
        .onAppear {
            if selectedLanguage == nil {
                showSupportLanguage.toggle()
            }
            selectedLang = selectedLanguage
        }
        .fullScreenCover(isPresented: $showSupportLanguage, onDismiss: onDismissSheet) {
            SelectLanguageView()
        }
        .navigationBarHidden(true)
    }
    
    func onDismissSheet() {
        selectedLang = selectedLanguage
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

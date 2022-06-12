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
            
            language
            appName
            desription
            question
            answer
            
            Spacer()
        }
        .padding(.horizontal)
        .onAppear(perform: onAppear)
        .fullScreenCover(
            isPresented: $showSupportLanguage,
            onDismiss: onDismissSheet,
            content: content
        )
        .navigationBarHidden(true)
    }
    
    func onAppear() {
        if selectedLanguage == nil {
            showSupportLanguage.toggle()
        }
        selectedLang = selectedLanguage
    }
    
    func content() -> some View {
        SelectLanguageView()
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

extension ContentView {
    private var language: some View {
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
    }
    
    private var appName: some View {
        HStack {
            Text("App Name:")
                .font(.headline)
            Spacer()
            Text(localisation.getString(for: "app_name"))
                .font(.title)
        }
    }
    
    private var desription: some View {
        Text(localisation.getString(for: "app_description"))
            .font(.headline)
            .foregroundColor(.secondary)
            .padding(.vertical)
    }
    
    private var question: some View {
        Text(localisation.getString(for: "question"))
            .font(.headline)
    }
    
    private var answer: some View {
        Text(localisation.getString(for: "answer"))
            .font(.body)
            .foregroundColor(.secondary)
    }
}

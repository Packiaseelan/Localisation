//
//  SelectLanguageView.swift
//  HexLocalisationExample
//
//  Created by Packiaseelan S on 11/06/22.
//

import SwiftUI
import HexLocalisation

class SelectLanguageViewModel: ObservableObject {
    
    let localisation = Localisation.shared
    
    @Published var supportedLanguages: [SupportedLang] = []
    
    init() {
        supportedLanguages = localisation.getSupportedlanguages()
    }
    
    func selectLang(languageId: String) {
        localisation.selectLanguage(languageId: languageId)
    }
}

struct SelectLanguageView: View {
    
    @StateObject var vm = SelectLanguageViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    @State var selected: SupportedLang?
    
    var body: some View {
        VStack {
            header
            List {
                ForEach(vm.supportedLanguages) { lang in
//                    HStack {
//                        VStack(alignment: .leading) {
//                            Text(lang.language)
//                                .font(.headline)
//                            Text(lang.displayContent)
//                                .font(.title)
//                                .foregroundColor(.red)
//                        }
//                        Spacer()
//                        Image(systemName: selected?.languageId == lang.languageId ? "circle.fill" : "circle")
//                            .foregroundColor(selected?.languageId == lang.languageId ? .green: .gray)
//                    }
                    LanguageRowView(lang: lang, isSelected: selected?.languageId == lang.languageId)
                    .onTapGesture {
                        selected = lang
                    }
                }
            }
            Spacer()
            
            Button("Continue") {
                if let selected = selected {
                    vm.selectLang(languageId: selected.languageId)
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .frame(maxWidth: .infinity)
            .buttonStyle(BorderedProminentButtonStyle())

        }
    }
}

struct SelectLanguageView_Previews: PreviewProvider {
    static var previews: some View {
        SelectLanguageView()
    }
}

extension SelectLanguageView {
    private var header: some View {
        HStack {
            Text("Select Language")
            Spacer()
            Image(systemName: "xmark")
                .foregroundColor(.red)
                .onTapGesture {
                    presentationMode.wrappedValue.dismiss()
                }
        }
        .font(.title)
        .padding()
    }
}


struct LanguageRowView: View {
    
    let lang: SupportedLang
    let isSelected: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(lang.language)
                    .font(.headline)
                Text(lang.displayContent)
                    .font(.title)
                    .foregroundColor(.red)
            }
            Spacer()
            Image(systemName: isSelected ? "circle.fill" : "circle")
                .foregroundColor(isSelected ? .green: .gray)
        }
    }
}

//
//  SelectLanguageView.swift
//  HexLocalisationExample
//
//  Created by Packiaseelan S on 11/06/22.
//

import SwiftUI
import HexLocalisation

struct SelectLanguageView: View {
    
    @StateObject var vm = SelectLanguageViewModel()
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("selectedLanguageId") var selectedLanguageId: String?
    
    @State var selectedId: String?
    
    var body: some View {
        VStack {
            header
            List {
                ForEach(vm.supportedLanguages) { lang in
                    LanguageRowView(
                        lang: lang,
                        isSelected: selectedId == lang.languageId
                    )
                    .listRowSeparator(.hidden)
                    .onTapGesture {
                        selectedId = lang.languageId
                    }
                }
            }
            .listStyle(PlainListStyle())
            button
        }
        .onAppear(perform: onAppear)
    }
    
    func onAppear() {
        if let langId = selectedLanguageId {
            selectedId = langId
        }
    }
    
    func onClose() {
        presentationMode.wrappedValue.dismiss()
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
                .font(.title)
            Spacer()
            Image(systemName: "xmark")
                .font(.title3)
                .foregroundColor(.red)
                .onTapGesture(perform: onClose)
        }
        .padding()
    }
    
    private var button: some View {
        Button {
            if let id = selectedId {
                vm.selectLang(languageId: id)
                presentationMode.wrappedValue.dismiss()
            }
        } label: {
            Text("Continue")
                .frame(width: UIScreen.main.bounds.width - 50, height: 55)
        }
        .background(Color.blue)
        .foregroundColor(Color.white)
        .cornerRadius(5)
        .padding(.horizontal)
    }
}

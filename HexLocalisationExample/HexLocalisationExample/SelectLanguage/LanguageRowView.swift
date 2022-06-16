//
//  LanguageRowView.swift
//  HexLocalisationExample
//
//  Created by Packiaseelan S on 12/06/22.
//

import SwiftUI
import HexLocalisation

struct LanguageRowView: View {
    
    let lang: SupportedLanguage
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
            Image(systemName: isSelected ? "checkmark.circle" : "circle")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(isSelected ? .green: .gray)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(backgroundView)
    }
}


struct LanguageRowView_Previews: PreviewProvider {
    static let lang = SupportedLanguage(languageId: "1", language: "English", displayContent: "Welcome", iconPath: "")
    static var previews: some View {
        
        Group {
            LanguageRowView(lang: lang, isSelected: false)
                .previewLayout(.sizeThatFits)
            
            LanguageRowView(lang: lang, isSelected: true)
                .previewLayout(.sizeThatFits)
        }
    }
}

extension LanguageRowView {
    private var backgroundView: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(
                .blue
                    .opacity(isSelected ? 0.1 : 0.01)
            )
    }
}

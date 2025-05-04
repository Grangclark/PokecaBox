//
//  CardEditView.swift
//  PokecaBox
//
//  Created by 長橋和敏 on 2025/03/28.
//

import SwiftUI

struct CardEditView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var card: Card
    
    var body: some View {
        Form {
            // 画像があれば表示する
            if let imagePath = card.imagePath,
               let uiImage = UIImage(contentsOfFile: imagePath) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .cornerRadius(8)
            }
            
            // 既存のフォーム要素（例）
            TextField("カード名", text: Binding($card.name, ""))
            TextField("カード番号", text: Binding($card.cardNumber, ""))
            TextField("イラストレーター", text: Binding($card.illustrator, ""))
            // 他のフィールドも同様に設定
            
            Button("変更を保存") {
                saveEdit()
            }
        }
        .navigationTitle("カード編集")
    }
    
    private func saveEdit() {
        do {
            try viewContext.save()
            dismiss()
        } catch {
            print("更新エラー: \(error.localizedDescription)")
        }
    }
}

// Optional Stringを安全にBindingするヘルパー
extension Binding where Value == String {
    init(_ source: Binding<String?>, _ defaultValue: String) {
        self.init(
            get: { source.wrappedValue ?? defaultValue },
            set: { source.wrappedValue = $0 }
        )
    }
}

/*
struct CardEditView_Previews: PreviewProvider {
    static var previews: some View {
        CardEditView()
    }
}
 */

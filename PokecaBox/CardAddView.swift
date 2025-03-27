//
//  CardAddView.swift
//  PokecaBox
//
//  Created by 長橋和敏 on 2025/03/23.
//

import SwiftUI

struct CardAddView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var cardNumber = ""
    @State private var series = ""
    @State private var expansion = ""
    @State private var rarity = ""
    @State private var type = ""
    @State private var hp = ""
    @State private var ability = ""
    @State private var attacks = ""
    @State private var descriptionText = ""
    @State private var illustrator = ""
    @State private var quantity = "1"
    
    var body: some View {
        NavigationStack {
            Form {
                Section("カード基本情報") {
                    TextField("カード名", text: $name)
                    TextField("カード番号", text: $cardNumber)
                    TextField("シリーズ名", text: $series)
                    TextField("拡張パック名", text: $expansion)
                    TextField("レア度", text: $rarity)
                    TextField("ポケモンタイプ", text: $type)
                    TextField("HP", text: $hp).keyboardType(.numberPad)
                }
                
                Section("カード詳細情報") {
                    TextField("特性（任意）", text: $ability)
                    TextField("ワザ名・ダメージ等", text: $attacks)
                    TextField("カード説明（任意）", text: $descriptionText)
                    TextField("イラストレーター", text: $illustrator)
                        .autocapitalization(.none) // ←これを追加
                    TextField("所持枚数", text: $quantity).keyboardType(.numberPad)
                }
                
                Button("カード登録") {
                    addCard()
                }
            }
            .navigationTitle("カード登録")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("キャンセル") { dismiss() }
                }
            }
        }
    }
    
    private func addCard() {
        let newCard = Card(context: viewContext)
        newCard.name = name
        newCard.cardNumber = cardNumber
        newCard.series = series
        newCard.expansion = expansion
        newCard.rarity = rarity
        newCard.type = type
        newCard.hp = Int16(hp) ?? 0
        newCard.ability = ability.isEmpty ? nil : ability
        newCard.attacks = attacks
        newCard.descriptionText = descriptionText.isEmpty ? nil : descriptionText
        newCard.illustrator = illustrator
        newCard.quantity = Int16(quantity) ?? 1
        newCard.createdAt = Date()
        
        do {
            try viewContext.save()
            dismiss()
        } catch {
            print("保存エラー: \(error.localizedDescription)")
        }
    }
}

struct CardAddView_Previews: PreviewProvider {
    static var previews: some View {
        CardAddView()
    }
}

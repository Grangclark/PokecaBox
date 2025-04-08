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

    // カテゴリーを追加
    @State private var category = "ポケモン"
    let categories = ["ポケモン", "トレーナーズ", "エネルギー"]

    @State private var rarity = ""
    
    // createdAt はシステム側で自動的に記録される

    @State private var quantity = 0
    @State private var type = ""
    @State private var hp = 0
    @State private var ability = ""
    @State private var descriptionText = ""
    @State private var imagePath = ""
    @State private var illustrator = ""
    
    // add column
    @State private var evolutionStage = ""
    @State private var evolutionDescription = ""
    @State private var specialDescription = ""
    @State private var nationalDexDescription = ""
    @State private var attackName1 = ""
    @State private var attackEnergy1 = ""
    @State private var attackDamege1 = ""
    @State private var attackName2 = ""
    @State private var attackEnergy2 = ""
    @State private var attackDamege2 = ""
    @State private var weaknessType = ""
    @State private var weaknessAmount = ""
    @State private var resistanceType = ""
    @State private var resistanceAmount = ""
    @State private var retreatCost = ""
    @State private var expansionMark = ""
    @State private var regulationMark = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section("カードカテゴリー") {
                    Picker("カテゴリー", selection: $category) {
                        ForEach(categories, id: \.self) { cat in
                            Text(cat)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
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
                }
                
                Section("共通情報") {
                    TextField("イラストレーター", text: $illustrator)
                        .autocapitalization(.none) // ←これを追加
                    TextField("所持枚数", text: $quantity).keyboardType(.numberPad)
                }
                
                // カテゴリーによって表示を切り替える
                if category == "ポケモン" {
                    Section("ポケモン専用情報") {
                        TextField("進化マーク（任意）", text: $evolutionStage)
                        TextField("進化説明文（任意）", text: $evolutionDescription)
                        TextField("ワザ名・エネルギー・ダメージ①", text: $attack1)
                        TextField("ワザ名・エネルギー・ダメージ②（任意）", text: $attack2)
                        TextField("弱点（任意）", text: $weakness)
                        TextField("抵抗力（任意）", text: $resistance)
                        TextField("にげる（任意）", text: $retreatCost)
                        TextField("全国図鑑説明文（任意）", text: $nationalDexDescription)
                    }
                } else if category == "トレーナーズ" {
                    Section("トレーナーズ専用情報") {
                        TextField("特殊説明文（任意）", text: $specialDescription)
                    }
                } else if category == "エネルギー" {
                    Section("エネルギー専用情報") {
                        // エネルギー特有の入力フィールド（あれば）
                    }
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

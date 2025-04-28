//
//  PokecaAddView.swift
//  PokecaBox
//
//  Created by 長橋和敏 on 2025/04/10.
//

import SwiftUI
import PhotosUI

struct PokecaAddView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
        
    @State private var name = ""
    @State private var cardNumber = ""
    @State private var series = ""
    @State private var expansion = ""

    // カテゴリーを追加
    @State private var category = "ポケモン"
    let categories = ["ポケモン", "特別なカード", "トレーナーズ", "エネルギー"]

    @State private var rarity = ""
    
    // createdAt はシステム側で自動的に記録される

    @State private var quantity: String = ""
    @State private var type = ""
    @State private var hp: String = ""
    @State private var ability = ""
    @State private var descriptionText = ""
    @State private var imagePath = ""
    @State private var illustrator = ""
    
    // add column
    @State private var evolutionStage = ""
    @State private var evolutionDescription = ""
    @State private var specialDescription = ""
    @State private var nationalDexDescription = ""
    @State private var weaknessType = ""
    @State private var weaknessAmount = ""
    @State private var resistanceType = ""

    @State private var expansionMark = ""
    @State private var regulationMark = ""
    @State private var trainersCategory = ""
    @State private var trainersEffect = ""
    @State private var basicEnergytypes = ""
    
    @State private var resistanceAmount = ""
    @State private var retreatCost = ""
    
    @State private var attackName1 = ""
    @State private var attackEnergy1 = ""
    @State private var attackDamage1 = ""
    @State private var attackName2 = ""
    @State private var attackEnergy2 = ""
    @State private var attackDamage2 = ""
    
    // カード画像の保存・表示機能
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var selectedUIImage: UIImage?

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
                    TextField("エキスパンションマーク", text: $expansionMark).autocapitalization(.none)
                    TextField("レギュレーションマーク", text: $regulationMark)
                    TextField("カード説明文", text: $descriptionText)
                }
                
                Section("共通情報") {
                    TextField("イラストレーター", text: $illustrator).autocapitalization(.none) // ←先頭小文字はこれを追加
                    TextField("所持枚数", text: $quantity).keyboardType(.numberPad)
                }
                
                // カテゴリーによって表示を切り替える
                if category == "ポケモン" || category == "特別なカード" {
                    Section("ポケモン専用情報") {
                        TextField("ポケモンタイプ", text: $type)
                        TextField("HP", text: $hp)
                        TextField("特性", text: $ability)
                        TextField("進化マーク（任意）", text: $evolutionStage)
                        TextField("進化説明文（任意）", text: $evolutionDescription)
                        TextField("特殊説明文（任意）", text: $specialDescription)
                        TextField("全国図鑑説明文（任意）", text: $nationalDexDescription)
                        TextField("弱点の種類（任意）", text: $weaknessType)
                        TextField("弱点の倍数（任意）", text: $weaknessAmount)
                        // 以下のカラムはどうしても実行できない
                        // Xcodeの不可解なバグで、1つのSectionにまとめるとエラーになるため
                        // 「ポケモン専用情報」と「ポケモン補足情報」を分割している
                        // 将来的に再検討予定（2025年04月10日時点）
                        // TextField("抵抗エネルギーの枚数（任意）", text: $resistanceAmount)
                        // TextField("にげる（任意）", text: $retreatCost)
                        // TextField("ワザ名１", text: $attackName1)
                        // TextField("必要エネルギー１", text: $attackEnergy1)
                        // TextField("ダメージ１", text: $attackDamage1)
                        // TextField("ワザ名２", text: $attackName2)
                        // TextField("必要エネルギー２", text: $attackEnergy2)
                        // TextField("ダメージ２", text: $attackDamage2)
                    }
                }
                
                if category == "ポケモン" || category == "特別なカード" {
                    Section("ポケモン補足情報") {
                        TextField("抵抗エネルギーのタイプ（任意）", text: $resistanceType)
                        TextField("抵抗エネルギーの枚数（任意）", text: $resistanceAmount)
                        TextField("にげる（任意）", text: $retreatCost)
                        TextField("ワザ名１", text: $attackName1)
                        TextField("必要エネルギー１", text: $attackEnergy1)
                        TextField("ダメージ１", text: $attackDamage1)
                        TextField("ワザ名２", text: $attackName2)
                        TextField("必要エネルギー２", text: $attackEnergy2)
                        TextField("ダメージ２", text: $attackDamage2)
                    }
                }
                
                if category == "トレーナーズ" {
                    Section("トレーナーズ専用情報") {
                        TextField("トレーナーズカテゴリー", text: $trainersCategory)
                        TextField("トレーナーズ効果", text: $trainersEffect)
                    }
                }
                
                if category == "エネルギー" {
                    Section("エネルギー専用情報") {
                        // エネルギー特有の入力フィールド（あれば）
                        TextField("基本エネルギータイプ", text: $basicEnergytypes)
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
        
        // View内に追加
        PhotosPicker(selection: $selectedPhoto, matching: .images, photoLibrary: .shared()) {
            HStack {
                Image(systemName: "photo")
                Text("カード画像を選択")
            }
            .onChange(of: selectedPhoto) { newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        selectedUIImage = uiImage
                    }
                }
            }
        }
        
        // 選択した画像のプレビュー表示（任意）
        if let selectedUIImage {
            Image(uiImage: selectedUIImage)
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 200)
        }
    }
    
    // UIImageをDocumentsフォルダに保存し、ファイルパスを返す
    private func saveImageToDocuments(uiImage: UIImage) -> String? {
        guard let imageData = uiImage.jpegData(compressionQuality: 0.8) else { return nil
        }
        
        let fileName = UUID().uuidString + ".jpg"
        let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask) [0]
            .appendingPathComponent(fileName)
        
        do {
            try imageData.write(to: fileURL)
            return fileURL.path
        } catch {
            print("画像保存エラー: \(error.localizedDescription)")
            return nil
        }
    }
    
    private func addCard() {
        let newCard = Card(context: viewContext)
        newCard.name = name
        newCard.cardNumber = cardNumber
        newCard.series = series
        newCard.expansion = expansion
        newCard.rarity = rarity
        newCard.quantity = Int16(quantity) ?? 0
        newCard.type = type.isEmpty ? nil : type
        newCard.hp = Int16(hp) ?? 0
        newCard.ability = ability.isEmpty ? nil : ability
        newCard.descriptionText = descriptionText.isEmpty ? nil : descriptionText
        newCard.illustrator = illustrator.isEmpty ? nil : illustrator
        newCard.evolutionStage = evolutionStage.isEmpty ? nil : evolutionStage
        newCard.evolutionDescription = evolutionDescription.isEmpty ? nil : evolutionDescription
        newCard.specialDescription = specialDescription.isEmpty ? nil : specialDescription
        newCard.nationalDexDescription = nationalDexDescription.isEmpty ? nil : nationalDexDescription
        newCard.attackName1 = attackName1.isEmpty ? nil : attackName1
        newCard.attackEnergy1 = attackEnergy1.isEmpty ? nil : attackEnergy1
        newCard.attackDamage1 = attackDamage1.isEmpty ? nil : attackDamage1
        newCard.attackName2 = attackName2.isEmpty ? nil : attackName2
        newCard.attackEnergy2 = attackEnergy2.isEmpty ? nil : attackEnergy2
        newCard.attackDamage2 = attackDamage2.isEmpty ? nil : attackDamage2
        newCard.weaknessType = weaknessType.isEmpty ? nil : weaknessType
        newCard.weaknessAmount = weaknessAmount.isEmpty ? nil : weaknessAmount
        newCard.resistanceType = resistanceType.isEmpty ? nil : resistanceType
        newCard.resistanceAmount = resistanceAmount.isEmpty ? nil : resistanceAmount
        newCard.retreatCost = retreatCost.isEmpty ? nil : retreatCost
        newCard.expansionMark = expansionMark.isEmpty ? nil : expansionMark
        newCard.regulationMark = regulationMark.isEmpty ? nil : regulationMark
        newCard.trainersCategory = trainersCategory.isEmpty ? nil : trainersCategory
        newCard.trainersEffect = trainersEffect.isEmpty ? nil : trainersEffect
        newCard.basicEnergytypes = basicEnergytypes.isEmpty ? nil : basicEnergytypes
        
        newCard.createdAt = Date()
        
        // ★画像のパス保存処理を追加
        if let selectedUIImage, let savedPath = saveImageToDocuments(uiImage: selectedUIImage) {
            newCard.imagePath = savedPath
        }
        
        do {
            try viewContext.save()
            dismiss()
        } catch {
            print("保存エラー: \(error.localizedDescription)")
        }
    }
}

struct PokecaAddView_Previews: PreviewProvider {
    static var previews: some View {
        PokecaAddView()
    }
}

//
//  CardListView.swift
//  PokecaBox
//
//  Created by 長橋和敏 on 2025/03/26.
//

import SwiftUI
import CoreData

struct CardListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Card.createdAt, ascending: false)],
        animation: .default)
    private var cards: FetchedResults<Card>
    
    @State private var showAddView = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(cards) { card in
                    // 一覧から編集画面への遷移（CardListView.swift内）
                    NavigationLink(destination: CardEditView(card: card)) {
                        VStack(alignment: .leading) {
                            if let imagePath = card.imagePath,
                               let uiImage = UIImage(contentsOfFile: imagePath) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 150)
                                    .cornerRadius(8)
                            }
                            Text(card.name ?? "カード名なし").font(.headline)
                            Text("カード番号: \(card.cardNumber ?? "-") | 所持枚数: \(card.quantity)")
                                .font(.subheadline)
                            Text("illus. \(card.illustrator ?? "-")").font(.caption)
                        }
                    }
                }
                .onDelete(perform: deleteCards)
            }
            .navigationTitle("PokecaBox")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showAddView = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddView) {
                PokecaAddView()
                    .environment(\.managedObjectContext, viewContext)
            }
        }
    }
    
    private func deleteCards(offsets: IndexSet) {
        offsets.map { cards[$0] }.forEach(viewContext.delete)
        do {
            try viewContext.save()
        } catch {
            print("削除エラー: \(error.localizedDescription)")
        }
    }
}


struct CardListView_Previews: PreviewProvider {
    static var previews: some View {
        CardListView()
    }
}

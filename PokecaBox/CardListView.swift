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
                    VStack(alignment: .leading) {
                        Text(card.name ?? "カード名なし").font(.headline)
                        Text("カード番号: \(card.cardNumber ?? "-") | 所持枚数: \(card.quantity)")
                            .font(.subheadline)
                        Text("illus. \(card.illustrator ?? "-")").font(.caption)
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
                CardAddView()
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

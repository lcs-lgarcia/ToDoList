//
//  ListItemsView.swift
//  ToDoList
//
//  Created by Lucas García on 11/4/23.
//

import SwiftUI

@Environment(\.blackbirdDatabase) var db: Blackbird.Database?


@BlackbirdLiveModels({ db in try await TodoItem.read(from: db, sqlWhere: "description LIKE ?"," %\(searchText)%")
}) var todoItems

struct ListItemsView: View {
    var body: some View {
        List{
            ForEach(todoItems.results){
                currentItem in
                Label(title: {
                    Text(currentItem.description)
                }, icon: {
                    if currentItem.completed == true {
                        Image(systemName: "checkmark.circle")
                    } else {
                        Image(systemName: "circle")
                    }
                })
                
                .onTapGesture {
                    Task{
                        try await db!.transaction { core in try core.query("UPDATE TodoItem SET completed = (?) WHERE id = (?)", !currentItem.completed, currentItem.id)
                            
                        }
                    }
                }
                
            }
            .onDelete(perform: removeRows)
        }
    }
    
    func removeRows(at offsets: IndexSet) {
        
        Task{
            try await db!.transaction{ core in
                
                var idList = ""
                for offset in offsets {
                    idList += "\(todoItems.results[offset].id),"
                }
                print(idList)
                idList.removeLast()
                print(idList)
                
                try core.query("DELETE FROM TodoItem WHERE id IN (?)", idList)
            }
        }
    }
    
}

struct ListItemsView_Previews: PreviewProvider {
    static var previews: some View {
        ListItemsView()
    }
}

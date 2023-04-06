import Blackbird
import SwiftUI

struct ListView: View {
    
    @Environment(\.blackbirdDatabase) var db: Blackbird.Database?
    
    @BlackbirdLiveModels({ db in try await TodoItem.read(from: db)
    }) var todoItems
    @State var newItemDescription: String = ""
    
    var body: some View {
      
        NavigationView{
            VStack{
                HStack{
                    
                    TextField("Enter a to-do item", text:$newItemDescription )
                    
                    Button(action: {
                        Task {
                            try await db!.transaction { core in
                                try core.query("INSERT INTO TodoItem (description) VALUES (?)", newItemDescription)
                            }
                            newItemDescription = ""
                        }
                    }, label:{
                        Text("ADD")
                            .font(.caption)
                    })
                    
                }
                .padding(20)
                
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
                }
            }
            .navigationTitle("To do")
        }
        
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}


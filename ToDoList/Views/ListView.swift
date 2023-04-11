import Blackbird
import SwiftUI

struct ListView: View {
    
    @Environment(\.blackbirdDatabase) var db: Blackbird.Database?
    
    
    @State var newItemDescription: String = ""
    
    @State var searchText = ""
    
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
                
                
                .searchable(text: $searchtext)
                
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


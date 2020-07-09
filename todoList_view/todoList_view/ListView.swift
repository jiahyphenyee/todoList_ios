//
//  ListView.swift
//  todoList_view
//
//  Created by Koe Jia-Yee on 9/7/20.
//  Copyright © 2020 Koe Jia-Yee. All rights reserved.
//

import SwiftUI

struct ListView: View {
    
    @State var edit = true
    var body: some View {
        ZStack {
            
            VStack {
                
                VStack (spacing: 5)  {
                    
                    HStack {
                        Text("ToDo").font(.largeTitle).fontWeight(.heavy)
                        
                        Spacer()
                        
                        Button(action: {
                            
                        }) {
                            
                            Text(self.edit ? "Done" : "Edit")
                            
                        }.padding([.leading, .trailing], 15)
                        .padding(.top, 10)
                    }
                    
                    Button (action:{
                        
                    }) {
                        Image(systemName: "plus").resizable().frame(width: 25, height: 25).padding()
                    }.padding(.bottom, -25)
                    .offset(y: 25)
                    .clipShape(Circle())
                }
                
            }
            
            Spacer()
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}

//
//  TaskAddView.swift
//  WhatsPlan
//
//  Created by 이경민 on 2022/05/18.
//

import SwiftUI

struct TaskAddView: View {
    //MARK: - PROPERTIES
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var isShowing:Bool
    
    //MARK: - VIEW PROPERTIES
    @State var input:String = ""
    
    //MARK: - FUNCTIONS
    private var isButtonDisable:Bool{
        return input.isEmpty
    }
    
    private func addItem(completions:@escaping(Bool)->Void){
        withAnimation {
            let newItem = Plan(context: viewContext)
            newItem.id = UUID()
            newItem.done = false
            newItem.name = input
            newItem.time = Date()
            print(newItem)
            do{
                try viewContext.save()
                completions(true)
            } catch {
                completions(false)
//                let nsError = error as NSError
//                print(error.localizedDescription)
//                fatalError("Unresolved error \(nsError) \(nsError.userInfo)")
            }
            

        }
    }
    var body: some View {
        VStack{
            Spacer()
            
            VStack{
                TextField("", text: $input)
                    .placeHolder(when: input.isEmpty, placeholder: {
                        Text("할일을 입력하세요.")
                            .foregroundColor(.gray)
                    })
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.black)
                    .padding()
                    .background(lightGray)
                    .cornerRadius(10)
                
                Button {
                    addItem { isSuccess in
                        if isSuccess{
                            input = ""
                            hideKeyboard()
                            isShowing = false
                        }
                    }
                } label: {
                    Spacer()
                    Text("추가하기")
                        .fontWeight(.bold)
                    Spacer()
                }
                .disabled(isButtonDisable)
                .padding()
                .font(.headline)
                .foregroundColor(isButtonDisable ? lightGray:myGray)
                .background(isButtonDisable ? myGray:myPink)
                .cornerRadius(10)
            }
            .padding(.horizontal)
            .padding(.vertical)
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(16)
            
            Spacer()
        }
        .padding()
    }
}

struct TaskAddView_Previews: PreviewProvider {
    static var previews: some View {
        TaskAddView(isShowing: .constant(true))
            .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}

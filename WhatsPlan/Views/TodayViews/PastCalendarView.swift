//
//  PastCalendarView.swift
//  WhatsPlan
//
//  Created by 이경민 on 2022/05/18.
//

import SwiftUI

struct PastCalendarView: View {
    //MARK: - PROPERTIES
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Plan.time, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Plan>
    
    //MARK: - VIEW PROPERTIES
    @State var selectedDate = Date()
    
    //MARK: - FUNCTIONS
    var body: some View {
        VStack(spacing:0){
            HeaderView(userSelectedTab: .past, isShowAddView: .constant(false), listEditMode: .constant(false))
            
            ScrollView(.vertical, showsIndicators: false) {
                DatePicker("", selection: $selectedDate,displayedComponents: .date)
                    .environment(\.locale, Locale(identifier: "ko_KR"))
                    .datePickerStyle(.graphical)
                    .padding(.horizontal,10)
                    .background(Color.secondary)
                    .cornerRadius(15)
                    .padding(.horizontal,20)
                
                let items = items.filter{DateToString($0.time) == DateToString(selectedDate)}
                HStack{
                    RoundedRectangle(cornerRadius: 3)
                        .frame(width:10)
                    Text("\(items.filter{$0.done == true}.count)/\(items.count)")
                        .font(.system(.title, design: .rounded))
                        .foregroundColor(.accentColor)
                    Spacer()
                }
                .padding([.top,.horizontal])
                
                ForEach(items.filter{DateToString($0.time) == DateToString(selectedDate)},id:\.self) { item in
                    HStack{

                        VStack(alignment:.leading){
                            Text(item.name ?? "")
                        }

                        Spacer()
                        
                        Image(systemName: item.done ? "checkmark.circle.fill":"circle")
                    }
                    .foregroundColor(.accentColor)
                    .padding(.horizontal,20)
                    .padding(.vertical,5)
                }
            }
            
            Spacer()
        }
        .background(Color.black)

    }
}

struct PastCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        PastCalendarView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

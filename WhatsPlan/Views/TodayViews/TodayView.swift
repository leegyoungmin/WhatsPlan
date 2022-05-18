//
//  TodayView.swift
//  WhatsPlan
//
//  Created by 이경민 on 2022/05/17.
//

import SwiftUI
import CoreData

struct TodayView: View {
    
    //MARK: - PROPERTIES
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Plan.time, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Plan>
    
    //MARK: - VIEW PROPERTIES
    @State var isShowAddPage:Bool = false
    @State var isEditing = false
    
    //MARK: - FUNCTIONS
    private func deleItems(offsets:IndexSet){
        withAnimation {
            offsets.map{ items[$0] }.forEach(viewContext.delete)
            do{
                try viewContext.save()
            } catch {
                let nsError = error as NSError?
                fatalError("Unresolved error \(nsError) \(nsError?.userInfo)")
            }
        }
    }
    //MARK: - INIT
    var body: some View {
        ZStack{
            VStack{
                HeaderView(userSelectedTab: .today,isShowAddView: $isShowAddPage,listEditMode: $isEditing)
                
                if items.isEmpty{
                    VStack{
                        Spacer()
                        Text("오늘 할일을 작성해주세요.")
                            .foregroundColor(.accentColor)
                            .font(.system(.title, design: .rounded))
                            .fontWeight(.bold)
                        
                        Spacer()
                    }
                    .foregroundColor(.white)
                }else{
                    List{
                        ForEach(items.filter{DateToString($0.time) == DateToString(Date())}) { item in
                            TodayCellView(item: item)
                                .padding(.vertical,10)
                                .padding(.horizontal)
                        }
                        .onDelete { indexSet in
                            deleItems(offsets: indexSet)
                        }
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        .listRowBackground(Color.black)
                        .listStyle(.plain)
                    }
                    .listStyle(.plain)
                    .background(Color.black.edgesIgnoringSafeArea(.all))
                    .environment(\.editMode, .constant(isEditing ? .active:.inactive))
                    .onAppear {
                        UITableView.appearance().separatorStyle = .none
                    }
                }
            }
            
            if isShowAddPage{
                lightGray.edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        isShowAddPage = false
                    }
                TaskAddView(isShowing: $isShowAddPage)
            }
        }
    }
}

struct TodayView_previews:PreviewProvider{
    static var previews: some View{
        TodayView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

//
//  CountDownView.swift
//  dteproof
//
//  Created by 陳昱豪 on 2020/5/28.
//  Copyright © 2020 Chen_Yu_Hao. All rights reserved.
//

import SwiftUI
import CoreData
struct NewTitleView:View {
    @Binding var date:Date
    @Binding var title:String
    @Binding var shownew:Bool
    var body: some View{
        VStack{
            TextField("title", text: $title).padding().border(Color.gray)
            DatePicker("", selection: $date, displayedComponents: .date)
            Button(action: {
                self.shownew=false
            }) {
                Text("完成")
            }
        }
    }
}
struct DaysRow:View {
    var title:String
    var date:Date
    var pass:Int{
        date.daysBetweenDate(toDate: Date())
    }
    var body: some View{
        HStack{
            Text(title)
            Spacer()
            if pass>0{
                Text("過了")
                Text("\(pass,specifier: "%10d")").frame(width:100)
                Text("天")
            }
            else{
                Text("還差")
                Text("\(pass*(-1),specifier: "%10d")").frame(width:100)
                Text("天")

            }
            
        }
    }
}
struct CountDownView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: CountDowns.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \CountDowns.date, ascending: false)])var fetchedItems: FetchedResults<CountDowns>
    @State var newtitle = ""
    @State var shownew=false
    @State var date=Date()

    var body: some View {
        List{
            ForEach(fetchedItems, id: \.self) { (item:CountDowns) in
                DaysRow(title: item.title!,date:item.date!)
            }.onDelete(perform: removeItems)
            HStack {
                Text("新增日子")
                Button(action: {
                    self.shownew=true
                    
                }) {
                   Image(systemName: "plus")
                        .imageScale(.large)
                }
            }

        }.sheet(isPresented: $shownew,onDismiss: {
            self.saveTask()
        }) {
            NewTitleView(date: self.$date, title: self.$newtitle,shownew: self.$shownew)
        }.navigationBarTitle("倒數日", displayMode: .inline)
            .navigationBarItems(trailing: EditButton())
        
    }
    func saveTask() {
        guard self.newtitle != "" else {
            return
        }
        let newCountDowns = CountDowns(context: self.managedObjectContext)
        newCountDowns.title = self.newtitle
        newCountDowns.date = self.date
        do {
            try self.managedObjectContext.save()
        } catch {
            print(error.localizedDescription)
        }
        self.newtitle = ""
    }
    func removeItems(at offsets: IndexSet) {
       for index in offsets {
            let item = fetchedItems[index]
            managedObjectContext.delete(item)
        }
        do {
            try managedObjectContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }

}

struct CountDownView_Previews: PreviewProvider {
    
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        return CountDownView().environment(\.managedObjectContext, context)
    }
}

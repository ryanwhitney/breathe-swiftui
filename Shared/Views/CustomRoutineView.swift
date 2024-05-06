//
//  CustomRoutineView.swift
//  breathe-swiftui
//

import SwiftUI

extension View {
    func hasScrollEnabled(_ value: Bool) -> some View {
        self.onAppear {
            UITableView.appearance().isScrollEnabled = value
        }
    }
}



struct Instruction : Identifiable {
    var id: UUID
    var name : String
    var count: Double
    var localMax: Double = 15
    init(name: String, count: Double ) {
        self.id = UUID()
        self.name = name
        self.count = count
    }
}


struct CustomRoutineView: View {
    
    @Environment(\.managedObjectContext) var viewContext
    
    
    @State var routine : [Instruction] = [
        Instruction(name: "Inhale", count: 5),
        Instruction(name: "Pause", count: 5),
        Instruction(name: "Exhale", count: 5),
        Instruction(name: "Pause", count: 5),
        Instruction(name: "Repeat", count: 10)
        
    ]
    
    @State var showActionSheet = false
    
    @State var routineName: String = ""
    @State var routineShorthand: String = ""
    @State var routineDesc: String = ""
    @State var repeatCount: String = ""
    @State var interpretedShorthand: String = ""
    @Binding var isShowingCustomRoutineSheet: Bool
    @State var celsius = 50
    @State var routineAsArray: [(String, Int)] = [("Inhale", 3)]
    
    @State var routineTotalTime: String?
    @State var secondOrTimes: String = ""
    
    let colorOptions = [Color.blue, Color.purple, Color.orange, Color.indigo, Color.mint]
    
    
    var body: some View {
        ZStack{
            BackgroundView()
                .ignoresSafeArea()
            VStack{
                HStack{
                    Text("New Routine")
                        .font(.title)
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .padding()
                    Spacer()
                    Button {
                        isShowingCustomRoutineSheet = false
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 44, height: 44)
                            .padding()
                    }
                }.padding(.bottom,-20)
                VStack{
                    ScrollViewReader { scrollViewProxy in
                        List{
                            Section {
                                TextField("Routine Name", text: $routineName)
                                TextField("Description", text: $routineDesc)
                                    .textInputAutocapitalization(.never)
                            }
                            
                            Section(
                                header:
                                    EditButton().frame(
                                        maxWidth: .infinity,
                                        alignment: .trailing
                                    )
                                    .padding(.bottom, 5)
                                
                            ){
                                ForEach($routine, id: \.self.id) { step in
                                    VStack {
                                        HStack {
                                            Text("\(step.name.wrappedValue)")
                                                .font(.subheadline)
                                            Spacer()
                                            let theCount = Int(step.count.wrappedValue.rounded(.toNearestOrEven))
                                            if step.name.wrappedValue != "Repeat"{
                                                if step.count.wrappedValue > 1{
                                                    Text("\(theCount) seconds").font(.subheadline)
                                                } else{
                                                    Text("\(theCount) second").font(.subheadline)
                                                }
                                            } else{
                                                if step.count.wrappedValue > 1{
                                                    Text("\(theCount) times").font(.subheadline)
                                                } else{
                                                    Text("\(theCount) time").font(.subheadline)
                                                }
                                            }
                                        }
                                        .padding(-10)
                                        .padding(.bottom, 10)
                                        Slider(
                                            value: step.count,
                                            in: 1 ... step.localMax.wrappedValue,
                                            step: 1, onEditingChanged: { changed in
                                                // increase max value if slider matches previous max
                                                if step.count.wrappedValue == step.localMax.wrappedValue{
                                                    step.localMax.wrappedValue += 30.0
                                                }
                                                calculateTime()
                                            }
                                        )
                                        .padding(-10)
                                    }
                                    .padding(15)
                                }
                                .onDelete(perform: onDelete)
                                .onMove(perform: onMove)
                                .transition(.opacity)
                            }
                        }.onAppear(){
                            calculateTime()
                        }
                        .onChange(of: routine.count){
                            withAnimation{
                                calculateTime()
                                // scroll to the last added item
                                scrollViewProxy.scrollTo(routine[(routine.count - 1)].id)
                            }
                        } // List end
                    }
                }
                VStack{
                    Text("Routine Length:")
                    Text("\(routineTotalTime ?? "")")
                }
                HStack{
                    Button {
                        showActionSheet = true
                    } label: {
                        Label("Add Step", systemImage: "plus")
                            .font(.headline)
                            .padding(.vertical,10)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.leading, 20)
                    .tint(.purple)
                    Button {
                        addItem()
                        isShowingCustomRoutineSheet = false
                    } label: {
                        Text("Save Routine")
                            .font(.headline)
                            .padding(.vertical,10)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.trailing, 20)
                    
                }
            }
            .actionSheet(isPresented: $showActionSheet) {
                ActionSheet(title: Text("Add a step"),
                            buttons: [
                                .cancel(),
                                .default(
                                    Text("Inhale"),
                                    action: addInhaleStep
                                ),
                                .default(
                                    Text("Pause"),
                                    action: addPauseStep
                                ),
                                .default(
                                    Text("Exhale"),
                                    action: addExhaleStep
                                ),
                                .default(
                                    Text("Repeat"),
                                    action: addRepeatStep
                                )
                            ]
                )
            }
        }
    }
    
    func calculateTime(){
        let tempRoutine = buildRoutineString()
        let expanded = expandRoutineShorthand(
            selectedRoutineInstruction:tempRoutine
        )
        routineTotalTime = expandedRoutineToTime(routine: expanded)
    }
    
    func addInhaleStep(){
        withAnimation{
            let instruction = Instruction(name: "Inhale", count: 5)
            routine.append(instruction)
        }
    }
    
    func addPauseStep(){
        withAnimation{
            let instruction = Instruction(name: "Pause", count: 5)
            routine.append(instruction)
        }
    }
    
    func addExhaleStep(){
        let instruction = Instruction(name: "Exhale", count: 5)
        withAnimation{
            
            routine.insert(instruction, at: routine.endIndex)
        }
    }
    
    func addRepeatStep(){
        let instruction = Instruction(name: "Repeat", count: 5)
        withAnimation(.spring()){
            routine.append(instruction)
        }
    }
    
    private func buildRoutineString() -> String{
        var routineAsString = ""
        for (index, item) in routine.enumerated() {
            switch item.name{
            case "Inhale":
                routineAsString.append("i:\(Int(item.count))")
                
            case "Exhale":
                routineAsString.append("e:\(Int(item.count))")
                
            case "Pause":
                routineAsString.append("p:\(Int(item.count))")
                
            case "Repeat":
                routineAsString.append("r:\(Int(item.count))")
                
            default:
                routineAsString.append("")
            }
            if index < (routine.count - 1){
                routineAsString.append(",")
            }
        }
        return routineAsString
    }
    
    private func addItem() {
        withAnimation {
            let newRoutine = Routine(context: viewContext)
            var routineAsString = ""
            for (index, item) in routine.enumerated() {
                switch item.name{
                case "Inhale":
                    routineAsString.append("i:\(Int(item.count))")
                    
                case "Exhale":
                    routineAsString.append("e:\(Int(item.count))")
                    
                case "Pause":
                    routineAsString.append("p:\(Int(item.count))")
                    
                case "Repeat":
                    routineAsString.append("r:\(Int(item.count))")
                    
                default:
                    routineAsString.append("")
                }
                if index < (routine.count - 1){
                    routineAsString.append(",")
                }
            }
            
            newRoutine.name = routineName
            newRoutine.desc = routineDesc
            newRoutine.instruction = routineAsString
            newRoutine.dateCreated = Date()
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                print("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func onDelete(offsets: IndexSet) {
        routine.remove(atOffsets: offsets)
    }
    
    private func onMove(source: IndexSet, destination: Int) {
        routine.move(fromOffsets: source, toOffset: destination)
    }
    
    
    func doNothing(){
        showActionSheet = false
    }
    
}


struct CustomRoutineView_Previews: PreviewProvider {
    static var previews: some View {
        CustomRoutineView(isShowingCustomRoutineSheet: .constant(true))
    }
}

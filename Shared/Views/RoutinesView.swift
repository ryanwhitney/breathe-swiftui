//
//  ContentView.swift
//  Shared
//

import SwiftUI
import CoreData

struct RoutinesView: View {
    
    class Theme {
        static func navigationBarColors(background : UIColor?,
                                        titleColor : UIColor? = nil, tintColor : UIColor? = nil ){
            
            let navigationAppearance = UINavigationBarAppearance()
            navigationAppearance.configureWithOpaqueBackground()
            navigationAppearance.backgroundColor =  UIColor(Color("gradientTopColor"))
            navigationAppearance.shadowImage = UIImage()
            navigationAppearance.shadowColor = .clear
            navigationAppearance.titleTextAttributes = [.foregroundColor: titleColor ?? .black]
            navigationAppearance.largeTitleTextAttributes = [.foregroundColor: titleColor ?? .black]
            UINavigationBar.appearance().standardAppearance = navigationAppearance
            UINavigationBar.appearance().compactAppearance = navigationAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = navigationAppearance
            UINavigationBar.appearance().tintColor = tintColor ?? titleColor ?? .black
        }
    }
    
    init(){
        
        UITableView.appearance().backgroundColor = .clear
        Theme.navigationBarColors(background: UIColor(Color("gradientTopColor")), titleColor: .white)
    }
    
    @GestureState private var dragOffset: CGFloat = -100
    
    @State var isShowingCustomRoutineSheet = false
    @State var isActive = false
    @Environment(\.managedObjectContext) var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Routine.dateCreated, ascending: false)],
        animation: .default)
    
    var routines: FetchedResults<Routine>
    var sampleRoutine: String = "i:1,p:2,e:3,p:1,r:244,i:5,p:6,e:7,p:8,r:334,i:9,p:10,e:11"
    let colorOptions = [Color.blue, Color.purple, Color.orange, Color.indigo, Color.mint]
    
    var body: some View {
        NavigationView {
            ZStack{
                BackgroundView().ignoresSafeArea()
                VStack{
                    ScrollView{
                        VStack(spacing: 20){
                            ForEach(routines) { routine in
                                NavigationLink {
                                    RoutineDetailView(
                                        selectedRoutineName: routine.name ?? "default value",
                                        selectedRoutineDescription: routine.desc ?? "default value",
                                        selectedRoutineInstruction: routine.instruction ?? sampleRoutine)
                                } label: {
                                    SwipeableCard(
                                        routine: routine,
                                        routineTitle: routine.name ?? "default value",
                                        routineDescription: routine.desc ?? "default value",
                                        routineTintColor: colorOptions.randomElement()!)
                                }.buttonStyle(CardNavigationLinkStyle())
                            }
                        }.padding(.top, 20)
                    }
                    .toolbar {
                        ToolbarItem {
                            Button {
                                isShowingCustomRoutineSheet.toggle()
                            } label: {
                                
                                Label("Add Item", systemImage: "plus")
                            }
                        }
                    }
                }
                .navigationTitle("Breath Routines")
                .navigationBarTitleDisplayMode(.large)
                .navigationViewStyle(.stack)
            }
            .foregroundColor(.white)
            .onAppear(perform: preloadItems)
            .sheet(
                isPresented: $isShowingCustomRoutineSheet,
                content: { CustomRoutineView(isShowingCustomRoutineSheet: $isShowingCustomRoutineSheet)
                    
                }
            )
        }
    }
    
    
    private func preloadItems() {
        // If app is a new install, preload four routines
        let hasLaunchedKey = "HasLaunched"
        let defaults = UserDefaults.standard
        let hasLaunched = defaults.bool(forKey: hasLaunchedKey)
        if !hasLaunched {
            withAnimation {
                let newRoutine = Routine(context: viewContext)
                for i in 0...3 {
                    switch i {
                    case 3:
                        newRoutine.name = "Calm Breathing"
                        newRoutine.instruction = "i:4,p:2,e:4,p:2,r:30"
                        newRoutine.dateCreated = Date()
                        newRoutine.desc = "a sixty second breath routine to start your day"
                    case 2:
                        let newRoutine = Routine(context: viewContext)
                        newRoutine.name = "5-5-5"
                        newRoutine.instruction = "i:5,p:5,e:5,p:5,r:30"
                        newRoutine.dateCreated = Date()
                        newRoutine.desc = "a box breathing routine for relaxation"
                    case 1:
                        let newRoutine = Routine(context: viewContext)
                        newRoutine.name = "Relaxing Breath"
                        newRoutine.instruction = "i:4,p:7,e:8,r:20"
                        newRoutine.dateCreated = Date()
                        newRoutine.desc = "a 4-7-8 breathing technique for sleep and relaxation"
                    case 0:
                        let newRoutine = Routine(context: viewContext)
                        newRoutine.name = "Wim Hof Breathing: Beginners"
                        newRoutine.instruction = "i:2,e:2,r:29,i:5,p:30,r:0,i:2,e:2,r:29,i:5,p:60,r:0,i:2,e:2,r:29,i:5,p:90"
                        newRoutine.dateCreated = Date()
                        newRoutine.desc = "thirty quick breaths followed by increasingly long holds"
                    default:
                        break
                    }
                }
                do {
                    try viewContext.save()
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nsError = error as NSError
                    print("Unresolved error \(nsError), \(nsError.userInfo)")
                }
            }
            defaults.set(true, forKey: hasLaunchedKey)
        }
    }
    
}

struct CardNavigationLinkStyle: ButtonStyle {
    public func makeBody(configuration: CardNavigationLinkStyle.Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.8 : 1).animation(.easeOut, value: configuration.isPressed)
            .scaleEffect(configuration.isPressed ? 0.98 : 1).animation(.easeOut, value: configuration.isPressed)
    }
}


struct RoutinesView_Previews: PreviewProvider {
    static var previews: some View {
        RoutinesView().preferredColorScheme(.dark).environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}

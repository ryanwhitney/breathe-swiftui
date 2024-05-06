//
//  RoutineDetailView.swift
//  breathe-swiftui
//

import SwiftUI

extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}

struct RoutineDetailView: View {
    
    @State private var growingInner = false
    @State private var growingCenter = false
    @State private var growingOuter = false
    @State private var paused = true
    @State private var currentStepCount = 1
    
    @State var showCountdown = false
    @State var routineIsPlaying = false
    
    @State var timeRemaining = 0
    @State var totalTimeRemaining = 0
    
    @State var currentStepNumber = 0
    @State var currentStepInstruction = ""
    @State var currentStepInstructionReadable = ""
    
    @State var timerOpacity = 0
    
    //    @Binding var currentStepString: String?
    //    @Binding var currentStepCount: String?
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var selectedRoutineName: String?
    var selectedRoutineDescription: String?
    var selectedRoutineInstruction:  String?
    
    var combinedShorthandRoutineArray2: [(String, Int)] = []
    var expandedRoutine2: [(String, Int)] = []
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    
    var body: some View {
        ZStack{
            BackgroundView()
                .ignoresSafeArea()
            VStack(spacing:20){
                Text(selectedRoutineName!)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                    .multilineTextAlignment(.center)
                    .onAppear{
                        decodeShorthandRoutine(selectedRoutineInstruction: selectedRoutineInstruction!)
                        //                        interpretShorthandRoutine()
                    }
                Text(selectedRoutineDescription!)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .fontWeight(.regular)
                    .multilineTextAlignment(.center)
                    .padding(.top, -10)
                //                Text(String(selectedRoutineInstruction))
                //                    .font(.title2)
                //                    .onAppear {
                //                        let _ = buildRoutine(instructions:selectedRoutineInstruction)
                //                    }
                //                Text(selectedRoutineInstruction)
                VStack{
                    if showCountdown{
                        Text(currentStepInstructionReadable)
                            .font(.title3)
                        //                            .opacity( timeRemaining == 0 ? 0.0 : 1.0)
                        //                            .onChange(of: timeRemaining) { (on) in
                        //
                            .frame(width: 300)
                            .frame(height: 10)
                            .transition(.opacity)
                        Text("\(totalTimeRemaining)")
                        Text("\(timeRemaining + 1)")
                            .font(.title2)
                            .transition(.opacity)
                            .onReceive(timer) { _ in
                                if routineIsPlaying == true {
                                    if timeRemaining > 0 {
                                        timeRemaining -= 1
                                        totalTimeRemaining -= 1
                                    }else{
                                        runRoutine()
                                        if totalTimeRemaining > 0 {
                                            totalTimeRemaining -= 1
                                        }
                                    }
                                }
                            }
                            .padding(.bottom, 40)
                    }
                }
                .frame(width: 320, height: 80, alignment: .center)
                .opacity(routineIsPlaying ? 1 : 0)
                .animation(
                    .easeInOut(duration: Double(0.2)),
                    value: routineIsPlaying
                )
                ZStack{
                    Circle()
                    //                        .scale(CGFloat(1.15))
                        .fill(.blue)
                        .frame(width: 250, height: 250)
                        .shadow(color: Color(.sRGBLinear, white: 0, opacity: growingOuter ? 0.1: 0.23), radius: 20, x: 0, y: 0)
                        .opacity(0.25)
                    Circle()
                        .fill(Color("outerOrange"))
                        .frame(width: growingOuter ? 250 : 120, height: growingOuter ? 250 : 120)
                        .shadow(color: Color(.sRGBLinear, white: 0, opacity: growingOuter ? 0.1: 0.23), radius: 20, x: 0, y: 0)
                        .opacity(growingOuter ? 0.5: 0.9)
                        .animation(
                            .easeInOut(duration: Double(currentStepCount)),
                            value: growingOuter
                        )
                    Circle()
                        .fill(Color("centerOrange"))
                        .frame(width: growingOuter ? 240 : 80, height: growingOuter ? 240 : 80)
                        .shadow(color: Color(.sRGBLinear, white: 0, opacity: growingOuter ? 0.1: 0.33), radius: 20, x: 0, y: 0)
                        .opacity(growingCenter ? 0.5: 0.4)
                        .animation(
                            .easeInOut(duration: Double(currentStepCount)),
                            value: growingCenter
                        )
                    Circle()
                        .fill(Color("innerOrange"))
                        .frame(width: growingOuter ? 230 : 50, height: growingOuter ? 230 : 50)
                        .shadow(color: Color(.sRGBLinear, white: 0, opacity: growingOuter ? 0.1: 0.33), radius: 20, x: 0, y: 0)
                        .opacity(growingInner ? 0.5: 0.5)
                        .animation(
                            .easeInOut(duration: Double(currentStepCount)),
                            value: growingInner
                        )
                    
                }.frame(width: 320, height: 200)
                Spacer()
                
                
                Button {
                    routineIsPlaying.toggle()
                    runRoutine()
                } label: {
                    if !routineIsPlaying {
                        Text("Start Routine")
                    } else{
                        Text("Pause")
                    }
                }.buttonStyle(.borderedProminent)
                Spacer()
            }
            
            Spacer()
                .toolbar{
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            routineIsPlaying = false
                            self.presentationMode.wrappedValue.dismiss()
                        } label: {
                            Label("Back", systemImage: "chevron.backward")
                                .foregroundColor(.white)
                        }
                    }
                }
        }
        .navigationBarTitleDisplayMode((.inline))
        .navigationBarBackButtonHidden(false)
        //        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
    
    
    func simpleSuccess() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    func updateCurrentStepInstruction(instruction: String){
        switch instruction {
        case "i", "I":
            currentStepInstructionReadable = "Inhale"
        case "p", "P":
            currentStepInstructionReadable = "Pause"
        case "e", "E":
            currentStepInstructionReadable = "Exhale"
        default:
            break
        }
    }
    
    var expandedRoutineContainer = RoutineTupleClass()
    
    func decodeShorthandRoutine(selectedRoutineInstruction: String){
        expandedRoutineContainer.item = expandRoutineShorthand(selectedRoutineInstruction: selectedRoutineInstruction)
        
        for (index, _) in expandedRoutineContainer.item.enumerated(){
            totalTimeRemaining += expandedRoutineContainer.item[index].1
        }
    }
    
    func runRoutine(){
        
        //        print(expandedRoutineContainer.item)
        showCountdown = true
        if routineIsPlaying{
            if currentStepNumber < expandedRoutineContainer.item.count{
                
                let currentStep = expandedRoutineContainer.item[currentStepNumber]
                
                currentStepInstruction = currentStep.0 // [->"exhale"<-,5]
                currentStepCount = currentStep.1 // ["exhale",->5<-]
                
                switch currentStepInstruction {
                case "i":
                    (growingInner, growingCenter, growingOuter) = (true, true, true)
                    paused = false
                    print("let's inhale")
                    simpleSuccess()
                    timeRemaining = (currentStepCount - 1)
                    updateCurrentStepInstruction(instruction: currentStepInstruction)
                    currentStepNumber += 1
                case "e":
                    (growingInner, growingCenter, growingOuter) = (false, false, false)
                    paused = false
                    print("let's exhale")
                    simpleSuccess()
                    timeRemaining = (currentStepCount - 1)
                    updateCurrentStepInstruction(instruction: currentStepInstruction)
                    currentStepNumber += 1
                case "p":
                    paused = true
                    simpleSuccess()
                    print("let's pause now")
                    timeRemaining = (currentStepCount - 1)
                    updateCurrentStepInstruction(instruction: currentStepInstruction)
                    currentStepNumber += 1
                default:
                    break
                }
                
            }
        }
    }
    
    
    struct RoutineDetailView_Previews: PreviewProvider {
        
        @Environment(\.managedObjectContext) var viewContext
        
        @FetchRequest(
            sortDescriptors: [NSSortDescriptor(keyPath: \Routine.dateCreated, ascending: true)],
            animation: .default)
        
        var routines: FetchedResults<Routine>
        
        
        static var previews: some View {
            RoutineDetailView(
                selectedRoutineName: "Calm Breathing",
                selectedRoutineDescription: "box breathing routine for relaxation",
                selectedRoutineInstruction:  "i:1,p:2,e:3,p:4,r:3,i:5,p:6,e:7,p:8,r:4,i:9,p:10,e:11")
        }
    }
}

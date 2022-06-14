//
//  infoWidget.swift
//  infoWidget
//
//  Created by Hans Capapey sierra on 8/6/22.


import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

//-----------

struct infoWidgetEntryView : View {
    var entry: Provider.Entry
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Registro.time, ascending: true)],
        animation: .default)
    private var registers: FetchedResults<Registro>
    
    let nutrients = ["Error", "Proteïnes", "Fibra", "Hidrats de carboni", "Caloríes", "Calci", "Ferro", "Lípids"]

    var body: some View {
        let nutrientSelected : String = nutrients [entry.configuration.Nutrient.rawValue]
        
        let registersForType = registers.filter{ register in
            return register.type! == nutrientSelected
        }
        
        let registersFiltered = registersForType.filter{ register in
            return Calendar.current.component(.day, from: register.time!) == Calendar.current.component(.day, from: Date())
        }
        
        let registersCalculatedString = String(format: "%.2f", calculateTotalOfDay(registros: registersFiltered))

        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(red: 0.413, green: 0.797, blue: 0.377), Color(red: 0.463, green: 0.847, blue: 0.427)]), startPoint: .bottom, endPoint: .top)
            
            VStack {
                HStack {
                    Image(systemName: "staroflife.fill")
                        .foregroundColor(.white)
                        .padding([.top, .leading])
                        .font(.title3)
                    
                    Spacer()
                }
                HStack {
                    Text(nutrientSelected)
                        .font(.body.bold())
                        .foregroundColor(.white)
                        .padding(.leading)
                    Spacer()
                }
                HStack {
                    Text(registersCalculatedString)
                        .font(.title.bold())
                    .foregroundColor(.white)
                    .padding(.leading)
                    Spacer()
                }
                HStack {
                    Text("de 5 g")
                        .font(.title3.bold())
                        .padding(.leading)
                    .foregroundColor(.white)
                    Spacer()
                }
                Spacer()
            }
            
            
        }
        
    }
    func calculateTotalOfDay(registros : [Registro]) -> Float{
        var total : Float = 0
        for registro in registros{
            total += registro.quantity
        }
        return total
    }
}

//-----------

@main
struct infoWidget: Widget {
    let persistenceController = PersistenceController.shared

    let kind: String = "infoWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            infoWidgetEntryView(entry: entry)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        } 
        .configurationDisplayName("Nutrient")
        .description("Mostra el consum diari d'un nutrient.")
        .supportedFamilies([.systemSmall])
    }
}

struct infoWidget_Previews: PreviewProvider {
    static var previews: some View {
        infoWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

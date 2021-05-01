//
//  StatDisplayWidget.swift
//  StatDisplayWidget
//
//  Created by jerry on 4/27/21.
//

import WidgetKit
import SwiftUI
import Intents
import Firebase

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> DataEntry {
        DataEntry(date: Date(), dataType: "temperature", data: "", configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (DataEntry) -> ()) {
        let db = Firestore.firestore()
        let user = Auth.auth().currentUser
        if user != nil {
            let dataCollection = db.collection("ESP32data").document(user!.uid).collection("sensorData")
            dataCollection.order(by: "timestamp", descending: true).limit(to: 1).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    if querySnapshot!.count > 0 {
                        let document = querySnapshot!.documents.first
                        let entry = DataEntry(date: Date(), dataType: "temperature", data: String(describing: document!.data()["temperature"]), configuration: configuration)
                        completion(entry)
                    }
                }
            }
        } else {
            let entry = DataEntry(date: Date(), dataType: "null", data: "null", configuration: configuration)
            completion(entry)
            print("No user signed in on device")
        }
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let nextUpdateDate = Calendar.current.date(byAdding: .minute, value: 30, to: Date())!
        let db = Firestore.firestore()
        let user = Auth.auth().currentUser
        if user != nil {
            let dataCollection = db.collection("ESP32data").document(user!.uid).collection("sensorData")
            dataCollection.order(by: "timestamp", descending: true).limit(to: 1).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    if querySnapshot!.count > 0 {
                        let document = querySnapshot!.documents.first
                        let entry = DataEntry(date: Date(), dataType: "temperature", data: String(describing: document!.data()["temperature"]), configuration: configuration)
                        let timeline = Timeline(
                                    entries:[entry],
                                    policy: .after(nextUpdateDate)
                                )
                        completion(timeline)
                    }
                }
            }
        } else {
            let entry = DataEntry(date: Date(), dataType: "null", data: "null", configuration: configuration)
            let timeline = Timeline(
                        entries:[entry],
                        policy: .after(nextUpdateDate)
                    )
            completion(timeline)
            print("No user signed in on device")
        }
    }
}

struct DataEntry: TimelineEntry {
    var date: Date
    
    let dataType: String
    let data: String
    let configuration: ConfigurationIntent
}

struct StatDisplayWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        Text("\(entry.dataType): \(entry.data)")
    }
}

@main
struct StatDisplayWidget: Widget {
    let kind: String = "StatDisplayWidget"

    init() {
        FirebaseApp.configure()
    }
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            StatDisplayWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct StatDisplayWidget_Previews: PreviewProvider {
    static var previews: some View {
        StatDisplayWidgetEntryView(entry: DataEntry(date: Date(), dataType: "temperature", data: "1", configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

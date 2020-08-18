//
//  BeaverWidgets.swift
//  BeaverWidgets
//
//  Created by Joel Clark on 8/16/20.
//  Copyright © 2020 MyCo. All rights reserved.
//

import WidgetKit
import SwiftUI
import CoreData
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

struct BeaverWidgetsEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            LinearGradient(gradient: buildGradient(color: .accentGreen), startPoint: .top, endPoint: .bottom)
            
            Image(systemName: "checkmark")
                .resizable()
                .frame(maxWidth: 50, maxHeight: 50)
                .scaledToFit()
                .foregroundColor(Color("accentWhite"))
        }
        
    }
}

struct BeaverWidgets_Previews: PreviewProvider {
    static var previews: some View {
        BeaverWidgetsEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

//
//  StringExtension.swift
//  RickAndMorty
//
//  Created by Lex Sava on 10/8/18.
//  Copyright © 2018 Lex Sava. All rights reserved.
//

import Foundation


/*
 @discussion This function looks kinda crappy
 but solves some issues with date created witch i need
 @parameters String formated date, from Character Model
 @return String in format aka "10 months ago"
 */
func timeAgoSinceDate(_ dateString: String) -> String {
  let dateFmt = DateFormatter()
  dateFmt.locale = Locale(identifier: "en_US_POSIX")
  dateFmt.timeZone = TimeZone.autoupdatingCurrent
  dateFmt.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSZ"
  
  guard let date = dateFmt.date(from: dateString) else {
    fatalError("Something went wrong with date")
  }
  let calendar = Calendar.current
  let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day,
                                            .weekOfYear, .month,
                                            .year, .second]
  let now = Date()
  let earliest = now < date ? now : date
  let latest = (earliest == now) ? date : now
  let components = calendar.dateComponents(unitFlags, from: earliest,
                                           to: latest)
  if (components.month! >= 1) {
    return "\(components.month!) months ago"
  }
  return ""
}

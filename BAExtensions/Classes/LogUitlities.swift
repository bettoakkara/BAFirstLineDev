//
//  LogUitlities.swift
//  BAExtensions
//
//  Created by Betto Akkara on 03/02/21.
//

import Foundation

enum LogEvent: String {
   case e = "[‼️]" // error
   case i = "[ℹ️]" // info
   case d = "[💬]" // debug
   case v = "[🔬]" // verbose
   case w = "[⚠️]" // warning
   case s = "[🔥]" // severe
}
/**
 # e => "[‼️]"  error, Logger.e()
 # i => "[ℹ️]"  info, Logger.i()
 # d => "[💬]"  debug, Logger.d()
 # v => "[🔬]"  verbose, Logger.v()
 # w => "[⚠️]"  warning, Logger.w()
 # s => "[🔥]"  severe, Logger.s()
 #
 # Print_json : to print Dictionary in Json format

 */
open class BALogger {
   // 1. The date formatter
   static var dateFormat = "yyyy-MM-dd hh:mm:ssSSS" // Use your own
   static var dateFormatter: DateFormatter {
      let formatter = DateFormatter()
      formatter.dateFormat = dateFormat
      formatter.locale = Locale.current
      formatter.timeZone = TimeZone.current
      return formatter
    }

    private class func sourceFileName(filePath: String) -> String {
       let components = filePath.components(separatedBy: "/")
       return components.isEmpty ? "" : components.last!
    }

    // 1. Error
    open class func e( _ object: Any,// 1
        filename: String = #file, // 2
            line: Int = #line, // 3
          column: Int = #column, // 4
        funcName: String = #function) {
              Print("\(Date().toString()) \(LogEvent.e.rawValue)[\(sourceFileName(filePath: filename))]:\(line) \(column) \(funcName) -> \(object)")
      }

    // 2. Debug
    open class func d( _ object: Any,// 1
        filename: String = #file, // 2
            line: Int = #line, // 3
          column: Int = #column, // 4
        funcName: String = #function) {
              Print("\(Date().toString()) \(LogEvent.d.rawValue)[\(sourceFileName(filePath: filename))]:\(line) \(column) \(funcName) -> \(object)")
      }

    // 3. Info
    open class func i( _ object: Any,// 1
        filename: String = #file, // 2
            line: Int = #line, // 3
          column: Int = #column, // 4
        funcName: String = #function) {
              Print("\(Date().toString()) \(LogEvent.i.rawValue)[\(sourceFileName(filePath: filename))]:\(line) \(column) \(funcName) -> \(object)")
      }

    // 4. Verbose
    open class func v( _ object: Any,// 1
        filename: String = #file, // 2
            line: Int = #line, // 3
          column: Int = #column, // 4
        funcName: String = #function) {
              Print("\(Date().toString()) \(LogEvent.v.rawValue)[\(sourceFileName(filePath: filename))]:\(line) \(column) \(funcName) -> \(object)")
      }

    // 5. Warning
    open class func w( _ object: Any,// 1
        filename: String = #file, // 2
            line: Int = #line, // 3
          column: Int = #column, // 4
        funcName: String = #function) {
              Print("\(Date().toString()) \(LogEvent.w.rawValue)[\(sourceFileName(filePath: filename))]:\(line) \(column) \(funcName) -> \(object)")
      }

    // 6. Severe
    open class func s( _ object: Any,// 1
        filename: String = #file, // 2
            line: Int = #line, // 3
          column: Int = #column, // 4
        funcName: String = #function) {
              Print("\(Date().toString()) \(LogEvent.s.rawValue)[\(sourceFileName(filePath: filename))]:\(line) \(column) \(funcName) -> \(object)")
      }

    public static func Print_json(_ object: Any) {
        // Only allowing in DEBUG mode
        #if DEBUG
        if let theJSONData = try? JSONSerialization.data(
            withJSONObject: object,
            options: [.prettyPrinted]) {
            let theJSONText = String(data: theJSONData,
                                     encoding: .ascii)
            Swift.print(theJSONText!)
        }
        #endif
    }

}
// 2. The Date to String extension
extension Date {
   func toString() -> String {
      return BALogger.dateFormatter.string(from: self as Date)
   }
}

fileprivate func Print(_ object: Any) {
  // Only allowing in DEBUG mode
  #if DEBUG
      Swift.print(object)
  #endif
}


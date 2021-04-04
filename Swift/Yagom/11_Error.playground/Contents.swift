import UIKit

// 11. 오류 처리

enum DateParseError: Error {
  case overSizeString
  case underSizeString
  case incorrectFormat(part: String)
  case incorrectData(part: String)
}

// overSizeString: 입력된 데이터의 길이가 필요한 크기보다 큽니다.
// underSizeString: 입력된 데이터의 길이가 필요한 크기보다 부족합니다.
// incorrectFormat: 입력된 데이터의 형식이 맞지 않습니다.
// incorrectData: 입력된 데이터의 값이 올바르지 않습니다.


// 11.1.2 오류 던지기

struct Date {
  var year: Int
  var month: Int
  var date: Int
}

func parseDate(param: NSString) throws -> Date {
  // 입력된 문자열의 길이가 10이 아닐 경우 분석이 불가능하므로 오류
  guard param.length == 10 else {
    if param.length > 10 {
      throw DateParseError.overSizeString
    } else {
      throw DateParseError.underSizeString
    }
  }
  
  // 반환할 객체 타입 선언
  var dateResult = Date(year: 0, month: 0, date: 0)
  
  // 연도 정보 분석
  if let year = Int(param.substring(with: NSRange(location: 0, length: 4))) {
    dateResult.year = year
  } else {
    // 연도 분석 실패
    throw DateParseError.incorrectFormat(part: "year")
  }
  
  // 월 정보 분석
  if let month = Int(param.substring(with: NSRange(location: 5, length: 2))) {
    // 월에 대한 값은 1 ~ 12까지만 가능하므로 그 이외의 범위는 잘못된 값으로 처리한다.
    guard month > 0 && month < 13 else {
      throw DateParseError.incorrectData(part: "month")
    }
    dateResult.month = month
  } else {
    // 월 분석 실패
    throw DateParseError.incorrectFormat(part: "month")
  }
  
  // 일 정보 분석
  if let date = Int(param.substring(with: NSRange(location: 8, length: 2))) {
    // 일에 대한 값은 1 ~ 31까지만 가능하므로 그 이외의 범위는 잘못된 값으로 처리한다.
    guard date > 0 && date < 32 else {
      throw DateParseError.incorrectData(part: "date")
    }
    dateResult.date = date
  } else {
    // 일 분석 실패
    throw DateParseError.incorrectFormat(part: "date")
  }
  
  return dateResult
}

// 호출, 변수나 상수에 할당
let date = try parseDate(param: "2020-02-28")


// 11.1.3 오류 객체 잡아내기

func getPartsDate(date: NSString, type: String) {
  do {
    let date = try parseDate(param: date)
    
    switch type {
    case "year":
      print("\(date.year)년입니다.")
    case "month":
      print("\(date.month)월입니다.")
    case "date":
      print("\(date.date)일입니다.")
    default:
      print("입력값에 해당하는 날짜정보가 없습니다.")
    }
  } catch DateParseError.overSizeString {
    print("입력된 문자열이 너무 깁니다. 줄여주세요")
  } catch DateParseError.underSizeString {
    print("입력된 문자열이 불충분합니다. 늘려주세요")
  } catch DateParseError.incorrectFormat(let part) {
    print("입력값의 \(part)해당하는 형식이 잘못되었습니다.")
  } catch DateParseError.incorrectData(let part) {
    print("입력값의 \(part)해당하는 값이 잘못사용되었습니다. 확인해주세요.")
  } catch {
    print("알 수 없는 오류가 발생하였습니다.")
  }
}

getPartsDate(date: "2015-12-31", type: "year")
getPartsDate(date: "2015-12-31", type: "month")
getPartsDate(date: "2015-13-31", type: "month")
getPartsDate(date: "2015-12-40", type: "date")
getPartsDate(date: "2015-13-40", type: "date")
getPartsDate(date: "2015-12-4x", type: "date")
getPartsDate(date: "2015-12-40x", type: "date")
getPartsDate(date: "2015-12-4", type: "date")

let date2 = try! parseDate(param: "2020-02-28")
print("\(date2)")

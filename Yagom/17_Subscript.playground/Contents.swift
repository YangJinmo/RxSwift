import UIKit

// 17 서브스크립트

// 17.1

extension Int {
  subscript(index: Int) -> Int {
    get {
      // 적절한 스크립트 결괏값 반환
      return 0
    }
    set {
      // 적절한 설정자 역할 수행
    }
  }
}

// 17.2

/*
struct Student {
  var name: String
  var number: Int
}

class School {
  var number: Int = 0
  var students: [Student] = [Student]()
  
  func addStudent(name: String) {
    let student: Student = Student(name: name, number: self.number)
    self.students.append(student)
    self.number += 1
  }
  
  func addStudents(names: String...) {
    for name in names {
      self.addStudent(name: name)
    }
  }
  
  subscript(index: Int) -> Student? {
    if index < self.number {
      return self.students[index]
    }
    return nil
  }
}

let highSchool: School = School()
highSchool.addStudents(
  names: "개굴", "무마니", "찜쓰", "스리니", "헤이즐", "정석준", "이현호"
)

let aStudent: Student? = highSchool[1]
print("\(aStudent?.number) \(aStudent?.name)")
// Optional(1) Optional("무마니")

let aStudent7: Student? = highSchool[7]
print("\(aStudent7?.number) \(aStudent7?.name)")
// nil nil
*/


// 17.3

struct Student {
  var name: String
  var number: Int
}

class School {
  var number: Int = 0
  var students: [Student] = [Student]()
  
  func addStudent(name: String) {
    let student: Student = Student(name: name, number: self.number)
    self.students.append(student)
    self.number += 1
  }
  
  func addStudents(names: String...) {
    for name in names {
      self.addStudent(name: name)
    }
  }
  
  // 첫번째 서브스크립트
  subscript(index: Int) -> Student? {
    get {
      if index < self.number {
        return self.students[index]
      }
      return nil
    }
    set {
      guard var newStudent: Student = newValue else {
        return
      }
      
      var number: Int = index
      
      if index > self.number {
        number = self.number
        self.number += 1
      }
      
      newStudent.number = number
      self.students[number] = newStudent
    }
  }
  
  // 두번째 서브스크립트
  subscript(name: String) -> Int? {
    get {
      return self.students.filter { $0.name == name }.first?.number
    }
    set {
      guard var number: Int = newValue else {
        return
      }
      
      if number > self.number {
        number = self.number
        self.number += 1
      }
      
      let newStudent: Student = Student(name: name, number: number)
      self.students[number] = newStudent
    }
  }
  
  // 세번째 서브스크립트
  subscript(name: String, number: Int) -> Student? {
    return self.students.filter { $0.name == name && $0.number == number }.first
  }
}

let highSchool: School = School()
highSchool.addStudents(
  names: "개굴", "무마니", "찜쓰", "스리니", "헤이즐", "정석준", "이현호"
)

print(highSchool["이현호"])
print(highSchool["정석"])

highSchool[0] = Student(name: "개구리", number: 0)
highSchool["비비"] = 1

print(highSchool.students.map { $0.name })

print(highSchool["개굴"])
print(highSchool["비비"])
print(highSchool["헤이즐", 4])
print(highSchool["스리니", 4])

/*
 Optional(6)
 nil
 ["개구리", "비비", "찜쓰", "스리니", "헤이즐", "정석준", "이현호"]
 nil
 Optional(1)
 Optional(__lldb_expr_45.Student(name: "헤이즐", number: 4))
 nil
 */


// 17.4 타입 서브스크립트

enum School2: Int {
  case elementary = 1, middle, high, university
  
  static subscript(level: Int) -> School2? {
    return Self(rawValue: level)
    // return School2(rawValue: level)과 같은 표현
  }
}

let school: School2? = School2[2]
print(school)
// Optional(__lldb_expr_47.School2.middle)


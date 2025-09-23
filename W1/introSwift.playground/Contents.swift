import Cocoa

// Intro swift

var greeting = "Hello, playground"
print(greeting)

let requiredTaskCount = 2
var tasks = ["Feed the dog", "take out the trash"]

tasks.append("Do laundry")

print(tasks)
tasks.remove(at: 2)

print(tasks)

func completeTasks(tasks: [String], requiredTaskCount: Int) -> Bool {
    for task in tasks {
        print("I completedL \(task)")
    }
    
    if tasks.count == requiredTaskCount {
        return true
    } else {
        return false
    }
}

completeTasks(tasks: tasks, requiredTaskCount: 2)

let isComplete = completeTasks(tasks: tasks, requiredTaskCount: 2)
print("My tasks are complete \(isComplete)")

// Function and function call
func sayMyName() {
    print("Hello, World!")
}
sayMyName()

// Closure and closure call: you take input and output
let sayMyNumber: () -> Void = {
    print("123")
}
sayMyNumber()

let storedFunctionAsClosure = sayMyName

storedFunctionAsClosure()

//
func filterEven(numbers: [Int]) -> [Int] {
    var outputArray: [Int] = []
    for number in numbers {
        if (number % 2 == 0) {
            outputArray.append(number)
        }
    }
    return outputArray
}

print(filterEven(numbers: [1, 2, 3, 4, 5]))

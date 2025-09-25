import UIKit

/*
This function prints the hypotenuse based on the side 1 and 2.
*/
func findHypotenuse(side1: Double, side2: Double) -> Double {
    let sidesSquared = (side1 * side1 + side2 * side2)
    return sqrt(sidesSquared)
}

let hypotenuse = findHypotenuse(side1: 8.0, side2: 6.0)
print("Hypotenuse is: \(hypotenuse)")

/*
This function adds two integers and returns the result.
*/
func add(num1: Int, num2: Int) -> Int {
    return num1 + num2
}

var result = add(num1: 100, num2: 50)
print("Result after the addition is: \(result)")

/*
This function takes a name and prints hello with the name.
*/
func greet(name: String) {
    print("Hello, \(name)!" )
}

greet(name: "John Doe")

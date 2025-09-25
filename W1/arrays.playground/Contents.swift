import UIKit

// Create a new array to contain String values
var groceryList: [String] = []

// Add an item
groceryList.append("Apples") // [Apples]

// Append another array
groceryList += ["Bananas", "Oranges"] // [Apples, Bananas, Oranges]

// Access and modify a value
groceryList[1] = "Pineapples" // [Apples, Pineapples, Oranges]

// Print the number of items in the list
print(groceryList.count) // 3

// Print the valid indices
print(groceryList.indices) // [0, 1, 2], which is <3

// Remove an item
groceryList.remove(at: 1) // [Apples, Pineapples, Oranges] -> [Apples, Oranges]
print(groceryList)

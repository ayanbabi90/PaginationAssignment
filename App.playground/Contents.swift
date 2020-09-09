import UIKit

var str = "Hello, playground"

let dic = ["keyA": "valueA", "keyB": "valueB"]
let param = dic.map { $0.0 + "=" + $0.1 }.joined(separator: "&")
print(param)

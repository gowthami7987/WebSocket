//
//  ViewController.swift
//  demoproject
//
//  Created by gowthamichintha on 22/04/21.
//

import UIKit
import Starscream
import Alamofire
struct Response: Codable { // or Decodable
  let hash: String
    let add : String
    let amount : Double
}
public protocol Queue {
  associatedtype Element
  mutating func enqueue(_ element: Element) -> Bool
  mutating func dequeue() -> Element?
  var isEmpty: Bool { get }
  var peek: Element? { get }
}

class ViewController: UIViewController, WebSocketDelegate {
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var Date: UILabel!
    @IBOutlet weak var clear: UIButton!
  //var queue = OperationQueue()
   
 
    struct Queue<T> {
      private var elements: [T] = []

      mutating func enqueue(_ value: T) {
        elements.append(value)
      }

      mutating func dequeue() -> T? {
        guard !elements.isEmpty else {
          return nil
        }
        return elements.removeFirst()
      }

      var head: T? {
        return elements.first
      }

      var tail: T? {
        return elements.last
      }
    }

    func didReceive(event: WebSocketEvent, client: WebSocket) {
        
        switch event {
        case .connected(let headers):
            //isConnected = true
            print("hvnbvnb",event)
            status.text = "websocket is connected"
            print("websocket is connected: \(headers)")
            let response = headers as NSDictionary
            //example if there is an id
            print("response",response)
            print(response.object(forKey: "Date") as Any)
            Date.text = response.object(forKey: "Date") as Any as! String
            print(response.object(forKey: "Hash") as Any)
        case .disconnected(let reason, let code):
           // isConnected = false
            status.text = "disconnected"
            status.text = "websocket is disconnected"
            print("websocket is disconnected: \(reason) with code: \(code)")
        case .text(let string):
            print("Received text: \(string)")
        case .binary(let data):
            print("Received data: \(data.count)")
        case .ping(_):
            break
        case .pong(_):
            break
        case .viabilityChanged(_):
            break
        case .reconnectSuggested(_):
            break
        case .cancelled: break
            //isConnected = false
        case .error(let error): break
           // isConnected = false
           // handleError(error)
        }
    }
  
    var socket: WebSocket!
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "wss://ws.blockchain.info/inv")
        var request = URLRequest(url: url!)
          let websocket = WebSocket(request: request)
        request.timeoutInterval = 5
        socket = WebSocket(request: request)
        socket.delegate = self
        socket.connect()
        if let url = URL(string: "https://www.blockchain.com/btc/unconfirmed-transactions?format=json") {
                   URLSession.shared.dataTask(with: url) { data, response, error in
                      if let data = data {
                          do {
                            print("data",data)
                            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String: Any]
                            // Access specific key with value of type String
                            let str = json["hash"] as! String
                            let response1 = json as NSDictionary
                            //example if there is an id
                            print("response1`1",response1)
                            print(response1.object(forKey: "hash") as Any)
                            print(response1.object(forKey: "add") as Any)
                            print("xzm,zm,nc,c,mzn",str)
                            
                          } catch let error {
                             print(error)
                          }
                       }
                 
                   }.resume()
                }
        if let url = URL(string: "https://blockchain.info/unconfirmed-transactions?format=json") {
            do {
                let contents = try String(contentsOf: url)
                print("bh",contents)
              
               // queue.addOperation(Response(hash: "Task1", add: "task", amount: 100000))
                      // queue.addOperation
               // print(queue)
                
               // let response = contents as NSDictionary
            } catch {
                // contents could not be loaded
            }
        } else {
            // the URL was bad!
        }
        
    }
}

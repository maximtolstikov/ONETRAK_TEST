import Foundation

protocol Networking {
  typealias CompletionHandler = (Data?, Swift.Error?) -> Void
  
  func request(from: Endpoint, completion: @escaping CompletionHandler)
}

/// Модуль работы с сетью
struct HTTPNetworking: Networking {
  
  func request(from: Endpoint, completion: @escaping CompletionHandler) {
    guard let url = URL(string: from.path) else { return }
    let request = createRequest(from: url)
    let task = createDataTask(from: request, completion: completion)
    task.resume()
  }
  
  private func createRequest(from url: URL) -> URLRequest {
    var request = URLRequest(url: url)
    request.cachePolicy = .reloadIgnoringCacheData
    return request
  }
  
  private func createDataTask(from request: URLRequest,
                              completion: @escaping CompletionHandler) -> URLSessionDataTask {
    return URLSession.shared.dataTask(with: request, completionHandler: { (data, _, error) in
      completion(data, error)
    })
  }
}

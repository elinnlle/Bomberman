//
//  WebSocketClient.swift
//  Bomberman
//

import Foundation

@MainActor
final class WebSocketClient: NSObject {
    private var webSocketTask: URLSessionWebSocketTask?
    private var urlSession: URLSession?
    private var reconnectAttempts = 0
    private let maxReconnectAttempts = 3
    
    var onMessage: ((ServerMessage) -> Void)?
    var onError: ((Error) -> Void)?
    var onConnected: (() -> Void)?
    var onDisconnected: (() -> Void)?
    
    private let serverURL: URL
    
    init(serverURL: URL) {
        self.serverURL = serverURL
        super.init()
    }
    
    func connect() {
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        urlSession = URLSession(configuration: config, delegate: self, delegateQueue: nil)
        
        webSocketTask = urlSession?.webSocketTask(with: serverURL)
        webSocketTask?.resume()
        
        receiveMessage()
    }
    
    func disconnect() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        webSocketTask = nil
        urlSession?.invalidateAndCancel()
        urlSession = nil
        reconnectAttempts = 0
    }
    
    func send(_ message: ClientMessage) {
        guard let webSocketTask = webSocketTask else { return }
        
        let jsonObject: [String: Any]
        switch message {
        case .join(let name, let role):
            jsonObject = ["type": "join", "name": name, "role": role]
        case .ready:
            jsonObject = ["type": "ready"]
        case .move(let dx, let dy):
            jsonObject = ["type": "move", "dx": dx, "dy": dy]
        case .placeBomb:
            jsonObject = ["type": "place_bomb"]
        }
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject),
              let jsonString = String(data: jsonData, encoding: .utf8) else {
            onError?(NSError(domain: "WebSocketClient", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to encode message"]))
            return
        }
        
        let wsMessage = URLSessionWebSocketTask.Message.string(jsonString)
        
        webSocketTask.send(wsMessage) { [weak self] error in
            if let error = error {
                Task { @MainActor in
                    self?.onError?(error)
                }
            }
        }
    }
    
    private func receiveMessage() {
        webSocketTask?.receive { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let message):
                Task { @MainActor [weak self] in
                    guard let self = self else { return }
                    switch message {
                    case .string(let text):
                        self.handleMessage(text)
                    case .data(let data):
                        if let text = String(data: data, encoding: .utf8) {
                            self.handleMessage(text)
                        }
                    @unknown default:
                        break
                    }
                    
                    // Продолжаем слушать сообщения
                    self.receiveMessage()
                }
                
            case .failure(let error):
                Task { @MainActor [weak self] in
                    guard let self = self else { return }
                    self.onError?(error)
                    self.onDisconnected?()
                }
            }
        }
    }
    
    private func handleMessage(_ text: String) {
        guard let data = text.data(using: .utf8),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let type = json["type"] as? String else {
            return
        }
        
        switch type {
        case "assign_id":
            if let payload = json["payload"] as? String {
                onMessage?(.assignId(payload))
            }
            
        case "game_state":
            if let payload = json["payload"] as? [String: Any],
               let gameState = GameState(from: payload) {
                onMessage?(.gameState(gameState))
            }
            
        default:
            break
        }
    }
}

extension WebSocketClient: URLSessionWebSocketDelegate {
    nonisolated func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        Task { @MainActor in
            reconnectAttempts = 0
            onConnected?()
        }
    }
    
    nonisolated func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        Task { @MainActor [weak self] in
            guard let self = self else { return }
            // Если есть причина закрытия, считаем это ошибкой
            if let reasonData = reason,
               let reasonString = String(data: reasonData, encoding: .utf8),
               !reasonString.isEmpty {
                onError?(NSError(domain: "WebSocketClient", code: -1, userInfo: [NSLocalizedDescriptionKey: reasonString]))
            }
            onDisconnected?()
        }
    }
}

// MARK: - Message Types

enum ServerMessage {
    case assignId(String)
    case gameState(GameState)
}

enum ClientMessage {
    case join(name: String, role: String)
    case ready
    case move(dx: Int, dy: Int)
    case placeBomb
}


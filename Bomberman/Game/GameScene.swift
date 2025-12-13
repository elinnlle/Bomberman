//
//  GameScene.swift
//  Bomberman
//

import SpriteKit

final class GameScene: SKScene {
    
    // MARK: - Constants
    
    private var tileSize: CGFloat = 32
    
    // Цвета
    private let wallColor = SKColor(red: 0.545, green: 0.553, blue: 0.569, alpha: 1.0)
    private let wallShadowColor = SKColor(red: 0.333, green: 0.341, blue: 0.357, alpha: 1.0)
    private let brickColor = SKColor(red: 0.710, green: 0.337, blue: 0.220, alpha: 1.0)
    private let brickMortarColor = SKColor(red: 0.831, green: 0.506, blue: 0.400, alpha: 1.0)
    private let floorColor1 = SKColor(red: 0.157, green: 0.157, blue: 0.157, alpha: 1.0)
    private let floorColor2 = SKColor(red: 0.196, green: 0.196, blue: 0.196, alpha: 1.0)
    private let myPlayerColor = SKColor(red: 0.196, green: 0.588, blue: 1.0, alpha: 1.0)
    private let otherPlayerColor = SKColor(red: 1.0, green: 0.549, blue: 0.0, alpha: 1.0)
    private let bombColor = SKColor(red: 0.078, green: 0.078, blue: 0.078, alpha: 1.0)
    private let fuseColor = SKColor.yellow
    private let explosionColors: [SKColor] = [
        SKColor(red: 1.0, green: 0.420, blue: 0.0, alpha: 1.0),
        SKColor(red: 1.0, green: 0.647, blue: 0.0, alpha: 1.0),
        SKColor(red: 1.0, green: 0.816, blue: 0.0, alpha: 1.0)
    ]
    
    // MARK: - Layers
    
    private let floorLayer = SKNode()
    private let wallLayer = SKNode()
    private let bombLayer = SKNode()
    private let explosionLayer = SKNode()
    private let playerLayer = SKNode()
    
    // MARK: - State
    
    private var currentGameState: GameState?
    private var myPlayerId: String?
    private var mapInitialized = false
    
    // Кеш для переиспользования
    private var bombNodes: [String: SKNode] = [:]
    private var playerNodes: [String: SKNode] = [:]
    
    // Смещение для центрирования карты
    private var mapOffsetX: CGFloat = 0
    private var mapOffsetY: CGFloat = 0
    
    // MARK: - Setup
    
    override func didMove(to view: SKView) {
        backgroundColor = floorColor1
        
        addChild(floorLayer)
        addChild(wallLayer)
        addChild(bombLayer)
        addChild(explosionLayer)
        addChild(playerLayer)
    }
    
    // MARK: - Public Methods
    
    func update(with gameState: GameState, myPlayerId: String?) {
        self.currentGameState = gameState
        self.myPlayerId = myPlayerId
        
        let oldTileSize = tileSize
        calculateTileSize(for: gameState.map)
        
        // Перерисовываем пол если размер изменился или это первый раз
        if !mapInitialized || oldTileSize != tileSize {
            setupFloor(gameState.map)
            mapInitialized = true
        }
        
        updateWalls(gameState.map)
        updateBombs(gameState.bombs)
        updateExplosions(gameState.explosions)
        updatePlayers(gameState.players)
    }
    
    // MARK: - Tile Size
    
    private func calculateTileSize(for map: GameMap) {
        guard let view = view else { return }
        
        let viewWidth = view.bounds.width
        let viewHeight = view.bounds.height
        
        let tileWidth = viewWidth / CGFloat(map.width)
        let tileHeight = viewHeight / CGFloat(map.height)
        
        tileSize = min(tileWidth, tileHeight)
        
        // Центрируем карту на экране
        let mapWidth = CGFloat(map.width) * tileSize
        let mapHeight = CGFloat(map.height) * tileSize
        
        mapOffsetX = (viewWidth - mapWidth) / 2
        mapOffsetY = (viewHeight - mapHeight) / 2
    }
    
    // MARK: - Floor
    
    private func setupFloor(_ map: GameMap) {
        floorLayer.removeAllChildren()
        
        for y in 0..<map.height {
            for x in 0..<map.width {
                let color = (x + y) % 2 == 0 ? floorColor1 : floorColor2
                let tile = SKSpriteNode(color: color, size: CGSize(width: tileSize + 1, height: tileSize + 1))
                tile.position = tilePosition(x: x, y: y, mapHeight: map.height)
                tile.zPosition = 0
                floorLayer.addChild(tile)
            }
        }
    }
    
    // MARK: - Walls
    
    private func updateWalls(_ map: GameMap) {
        wallLayer.removeAllChildren()
        
        for y in 0..<map.height {
            for x in 0..<map.width {
                guard let tile = map.tile(at: x, y: y) else { continue }
                
                let position = tilePosition(x: x, y: y, mapHeight: map.height)
                
                switch tile {
                case .wall:
                    let wallNode = createWallNode()
                    wallNode.position = position
                    wallLayer.addChild(wallNode)
                    
                case .brick:
                    let brickNode = createBrickNode()
                    brickNode.position = position
                    wallLayer.addChild(brickNode)
                    
                default:
                    break
                }
            }
        }
    }
    
    private func createWallNode() -> SKNode {
        let container = SKNode()
        
        // Тень
        let shadow = SKSpriteNode(color: wallShadowColor, size: CGSize(width: tileSize, height: tileSize))
        shadow.zPosition = 1
        container.addChild(shadow)
        
        // Основная стена
        let wall = SKSpriteNode(color: wallColor, size: CGSize(width: tileSize - 4, height: tileSize - 4))
        wall.zPosition = 2
        container.addChild(wall)
        
        return container
    }
    
    private func createBrickNode() -> SKNode {
        let container = SKNode()
        
        // Основа кирпича
        let brick = SKSpriteNode(color: brickColor, size: CGSize(width: tileSize, height: tileSize))
        brick.zPosition = 1
        container.addChild(brick)
        
        // Горизонтальная линия
        let hLine = SKSpriteNode(color: brickMortarColor, size: CGSize(width: tileSize, height: 2))
        hLine.zPosition = 2
        container.addChild(hLine)
        
        // Вертикальные линии
        let vLine1 = SKSpriteNode(color: brickMortarColor, size: CGSize(width: 2, height: tileSize / 2))
        vLine1.position = CGPoint(x: 0, y: tileSize / 4)
        vLine1.zPosition = 2
        container.addChild(vLine1)
        
        let vLine2 = SKSpriteNode(color: brickMortarColor, size: CGSize(width: 2, height: tileSize / 2))
        vLine2.position = CGPoint(x: 0, y: -tileSize / 4)
        vLine2.zPosition = 2
        container.addChild(vLine2)
        
        return container
    }
    
    // MARK: - Bombs
    
    private func updateBombs(_ bombs: [BombPosition]) {
        guard let map = currentGameState?.map else { return }
        
        let currentBombIds = Set(bombs.map { "\($0.x)_\($0.y)" })
        
        // Удаляем старые бомбы
        for (id, node) in bombNodes {
            if !currentBombIds.contains(id) {
                node.removeFromParent()
                bombNodes.removeValue(forKey: id)
            }
        }
        
        // Добавляем новые
        for bomb in bombs {
            let bombId = "\(bomb.x)_\(bomb.y)"
            
            if bombNodes[bombId] == nil {
                let bombNode = createBombNode()
                bombNode.position = tilePosition(x: bomb.x, y: bomb.y, mapHeight: map.height)
                bombLayer.addChild(bombNode)
                bombNodes[bombId] = bombNode
            }
        }
    }
    
    private func createBombNode() -> SKNode {
        let container = SKNode()
        container.zPosition = 10
        
        // Тело бомбы
        let body = SKShapeNode(circleOfRadius: tileSize / 2 - 4)
        body.fillColor = bombColor
        body.strokeColor = .clear
        body.zPosition = 1
        container.addChild(body)
        
        // Быстрая пульсация
        let pulseUp = SKAction.scale(to: 1.1, duration: 0.2)
        let pulseDown = SKAction.scale(to: 1.0, duration: 0.2)
        let pulse = SKAction.sequence([pulseUp, pulseDown])
        body.run(SKAction.repeatForever(pulse))
        
        // Фитиль
        let fuse = SKSpriteNode(color: fuseColor, size: CGSize(width: 4, height: 8))
        fuse.position = CGPoint(x: 0, y: tileSize / 2 - 6)
        fuse.zPosition = 2
        container.addChild(fuse)
        
        // Мигание фитиля
        let fadeOut = SKAction.fadeAlpha(to: 0.3, duration: 0.15)
        let fadeIn = SKAction.fadeAlpha(to: 1.0, duration: 0.15)
        let blink = SKAction.sequence([fadeOut, fadeIn])
        fuse.run(SKAction.repeatForever(blink))
        
        return container
    }
    
    // MARK: - Explosions
    
    private func updateExplosions(_ explosions: [ExplosionPosition]) {
        guard let map = currentGameState?.map else { return }
        
        let currentIds = Set(explosions.map { "\($0.x)_\($0.y)" })
        
        // Удаляем старые
        for child in explosionLayer.children {
            if let name = child.name, !currentIds.contains(name) {
                child.removeFromParent()
            }
        }
        
        // Добавляем новые
        for explosion in explosions {
            let id = "\(explosion.x)_\(explosion.y)"
            
            if explosionLayer.childNode(withName: id) == nil {
                let explosionNode = createExplosionNode()
                explosionNode.position = tilePosition(x: explosion.x, y: explosion.y, mapHeight: map.height)
                explosionNode.name = id
                explosionLayer.addChild(explosionNode)
            }
        }
    }
    
    private func createExplosionNode() -> SKNode {
        let container = SKNode()
        container.zPosition = 15
        
        // Центральный взрыв
        let center = SKShapeNode(circleOfRadius: tileSize / 2)
        center.fillColor = explosionColors.randomElement() ?? .orange
        center.strokeColor = .clear
        center.alpha = 0.9
        container.addChild(center)
        
        // Внутренний яркий круг
        let inner = SKShapeNode(circleOfRadius: tileSize / 4)
        inner.fillColor = .white
        inner.strokeColor = .clear
        inner.alpha = 0.7
        inner.zPosition = 1
        container.addChild(inner)
        
        return container
    }
    
    // MARK: - Players
    
    private func updatePlayers(_ players: [PlayerPosition]) {
        guard let map = currentGameState?.map else { return }
        
        let alivePlayers = players.filter { $0.alive }
        let aliveIds = Set(alivePlayers.map { $0.id })
        
        // Удаляем мёртвых
        for (id, node) in playerNodes {
            if !aliveIds.contains(id) {
                node.removeFromParent()
                playerNodes.removeValue(forKey: id)
            }
        }
        
        // Обновляем позиции
        for player in alivePlayers {
            let targetPosition = tilePosition(x: player.x, y: player.y, mapHeight: map.height)
            
            if let existingNode = playerNodes[player.id] {
                existingNode.position = targetPosition
            } else {
                let isMe = player.id == myPlayerId
                let node = createPlayerNode(isMe: isMe, name: player.name)
                node.position = targetPosition
                playerLayer.addChild(node)
                playerNodes[player.id] = node
            }
        }
    }
    
    private func createPlayerNode(isMe: Bool, name: String) -> SKNode {
        let container = SKNode()
        container.zPosition = 25
        
        let color = isMe ? myPlayerColor : otherPlayerColor
        let headColor = isMe ? SKColor(red: 0.588, green: 0.784, blue: 1.0, alpha: 1.0)
                             : SKColor(red: 1.0, green: 0.784, blue: 0.588, alpha: 1.0)
        
        // Тело
        let body = SKShapeNode(rectOf: CGSize(width: tileSize - 10, height: tileSize - 20), cornerRadius: 5)
        body.fillColor = color
        body.strokeColor = .clear
        body.position = CGPoint(x: 0, y: -5)
        container.addChild(body)
        
        // Голова
        let head = SKShapeNode(circleOfRadius: tileSize * 0.3)
        head.fillColor = headColor
        head.strokeColor = .clear
        head.position = CGPoint(x: 0, y: tileSize * 0.2)
        head.zPosition = 1
        container.addChild(head)
        
        // Имя
        let nameLabel = SKLabelNode(text: name)
        nameLabel.fontName = "HelveticaNeue-Bold"
        nameLabel.fontSize = tileSize * 0.35
        nameLabel.fontColor = .white
        nameLabel.position = CGPoint(x: 0, y: tileSize / 2 + 5)
        nameLabel.zPosition = 2
        nameLabel.horizontalAlignmentMode = .center
        container.addChild(nameLabel)
        
        // Тень для имени
        let shadow = SKLabelNode(text: name)
        shadow.fontName = "HelveticaNeue-Bold"
        shadow.fontSize = tileSize * 0.35
        shadow.fontColor = .black
        shadow.position = CGPoint(x: 1, y: tileSize / 2 + 4)
        shadow.zPosition = 1
        shadow.horizontalAlignmentMode = .center
        container.addChild(shadow)
        
        return container
    }
    
    // MARK: - Helpers
    
    private func tilePosition(x: Int, y: Int, mapHeight: Int) -> CGPoint {
        let flippedY = mapHeight - 1 - y
        return CGPoint(
            x: CGFloat(x) * tileSize + tileSize / 2 + mapOffsetX,
            y: CGFloat(flippedY) * tileSize + tileSize / 2 + mapOffsetY
        )
    }
}

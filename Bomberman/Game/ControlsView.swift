//
//  ControlsView.swift
//  Bomberman
//

import SwiftUI

struct ControlsView: View {
    @EnvironmentObject var gameClient: GameClient
    
    var body: some View {
        HStack(spacing: 40) {
            dPad
            Spacer()
            bombButton
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 20)
    }
    
    private var dPad: some View {
        VStack(spacing: 4) {
            DirectionButton(direction: .up) {
                gameClient.movePlayer(dx: 0, dy: -1)
            }
            
            HStack(spacing: 4) {
                DirectionButton(direction: .left) {
                    gameClient.movePlayer(dx: -1, dy: 0)
                }
                
                Color.clear
                    .frame(width: 56, height: 56)
                
                DirectionButton(direction: .right) {
                    gameClient.movePlayer(dx: 1, dy: 0)
                }
            }
            
            DirectionButton(direction: .down) {
                gameClient.movePlayer(dx: 0, dy: 1)
            }
        }
    }
    
    private var bombButton: some View {
        Button {
            gameClient.placeBomb()
        } label: {
            ZStack {
                Circle()
                    .fill(Color.redAccent)
                    .frame(width: 80, height: 80)
                
                Circle()
                    .fill(Color.redAccent.opacity(0.7))
                    .frame(width: 70, height: 70)
                
                Text("💣")
                    .font(.system(size: 36))
            }
        }
        .buttonStyle(BombButtonStyle())
    }
}

struct DirectionButton: View {
    enum Direction {
        case up, down, left, right
        
        var systemImage: String {
            switch self {
            case .up: return "chevron.up"
            case .down: return "chevron.down"
            case .left: return "chevron.left"
            case .right: return "chevron.right"
            }
        }
    }
    
    let direction: Direction
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.grayApp)
                    .frame(width: 56, height: 56)
                
                Image(systemName: direction.systemImage)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.mainTextColor)
            }
        }
        .buttonStyle(DirectionButtonStyle())
    }
}

struct DirectionButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .opacity(configuration.isPressed ? 0.7 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct BombButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.85 : 1.0)
            .animation(.spring(response: 0.2, dampingFraction: 0.5), value: configuration.isPressed)
    }
}


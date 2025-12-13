#!/bin/bash

# Скрипт для создания ветки и pull request с изменениями WebSocket

set -e

cd "/Users/ovaam/Desktop/3 курс/Bomberman"

# Проверяем, инициализирован ли git репозиторий
if [ ! -d .git ]; then
    echo "Инициализируем git репозиторий..."
    git init
    git branch -M main
fi

# Создаем новую ветку
echo "Создаем ветку feature/websocket-integration..."
git checkout -b feature/websocket-integration 2>/dev/null || git checkout feature/websocket-integration

# Добавляем все изменения
echo "Добавляем изменения..."
git add Bomberman/Networking/WebSocketClient.swift
git add Bomberman/Networking/GameClient.swift
git add Bomberman/Models/GameModels.swift
git add Bomberman/UI/Lobby/Views/LobbyActionsView.swift
git add Bomberman/UI/Lobby/LobbyView.swift
git add Bomberman/Info.plist
git add WEBSOCKET_SETUP.md
git add ЗАПУСК_СЕРВЕРА.md

# Проверяем статус
echo ""
echo "Статус изменений:"
git status --short

# Создаем коммит
echo ""
echo "Создаем коммит..."
git commit -m "feat: Реализовано реальное WebSocket подключение

- Добавлен WebSocketClient для подключения к серверу
- Интегрирован WebSocket в GameClient
- Добавлены модели данных для игрового состояния (GameState, GameMap, BombPosition, ExplosionPosition, PlayerPosition)
- Реализована обработка сообщений от сервера (assign_id, game_state)
- Реализована отправка команд на сервер (join, ready, move, place_bomb)
- Добавлены настройки в Info.plist для разрешения HTTP подключений
- Удалена демо-кнопка из лобби
- Исправлены ошибки компиляции (MainActor, CloseCode)
- Добавлена документация по настройке WebSocket"

echo ""
echo "✅ Коммит создан!"
echo ""
echo "Следующие шаги:"
echo "1. Если у вас есть remote репозиторий, выполните:"
echo "   git push -u origin feature/websocket-integration"
echo ""
echo "2. Затем создайте Pull Request через веб-интерфейс GitHub/GitLab"
echo "   или используйте GitHub CLI:"
echo "   gh pr create --title 'feat: WebSocket интеграция' --body 'Реализовано реальное сетевое подключение через WebSocket'"


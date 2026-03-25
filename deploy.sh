#!/bin/bash

# Скрипт развертывания на сервере

echo "🚀 Начинаю развертывание..."

# Проверка наличия .env файла
if [ ! -f .env ]; then
    echo "❌ Файл .env не найден. Создайте его из .env.example"
    exit 1
fi

# Загрузка переменных окружения
source .env

# Остановка существующих контейнеров
echo "🛑 Остановка контейнеров..."
docker compose -f docker-compose.prod.yml down

# Pull последних изменений из git
echo "📥 Загрузка изменений из git..."
git pull origin main

# Сборка и запуск контейнеров
echo "🔨 Сборка образов..."
docker compose -f docker-compose.prod.yml build

echo "🚀 Запуск контейнеров..."
docker compose -f docker-compose.prod.yml up -d

# Ожидание запуска
echo "⏳ Ожидание запуска приложений..."
sleep 10

# Проверка статуса
echo "✅ Проверка статуса..."
docker compose -f docker-compose.prod.yml ps

# Сбор статических файлов (на всякий случай)
echo "📦 Сбор статических файлов..."
docker compose -f docker-compose.prod.yml exec web python manage.py collectstatic --noinput

# Применение миграций
echo "🗄️ Применение миграций..."
docker compose -f docker-compose.prod.yml exec web python manage.py migrate

echo "🎉 Развертывание завершено!"
echo "🌐 Сайт доступен по адресу: https://$ALLOWED_HOSTS"

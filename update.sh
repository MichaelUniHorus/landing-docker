#!/bin/bash

# Скрипт обновления сайта

echo "🔄 Обновление сайта..."

# Загрузка переменных окружения
if [ -f .env ]; then
    source .env
else
    echo "❌ Файл .env не найден"
    exit 1
fi

# Backup базы данных
echo "💾 Создание бэкапа БД..."
docker compose -f docker-compose.prod.yml exec web cp /app/db.sqlite3 /app/db.sqlite3.backup

# Загрузка изменений
echo "📥 Загрузка изменений из git..."
git pull origin main

# Перезапуск контейнеров
echo "🔄 Перезапуск контейнеров..."
docker compose -f docker-compose.prod.yml restart

# Ожидание запуска
echo "⏳ Ожидание запуска..."
sleep 5

# Применение миграций
echo "🗄️ Применение миграций..."
docker compose -f docker-compose.prod.yml exec web python manage.py migrate

# Сбор статических файлов
echo "📦 Сбор статических файлов..."
docker compose -f docker-compose.prod.yml exec web python manage.py collectstatic --noinput

echo "✅ Обновление завершено!"
echo "🌐 Сайт доступен по адресу: https://$ALLOWED_HOSTS"

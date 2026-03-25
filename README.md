# UniHorus Landing Page

Современный сайт-визитка на Django для Python/Django разработчика.

## Разработка

### Запуск локально
```bash
# Создание виртуального окружения
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate

# Установка зависимостей
pip install -r requirements.txt

# Миграции
python manage.py migrate

# Запуск сервера
python manage.py runserver
```

## Production развертывание

### Docker
```bash
# Сборка и запуск
docker-compose up --build

# В фоне
docker-compose up -d --build

# Остановка
docker-compose down
```

### Переменные окружения
- `DEBUG` - режим отладки (False для production)
- `SECRET_KEY` - секретный ключ Django
- `ALLOWED_HOSTS` - разрешенные хосты через запятую

### Структура
- `main/` - основное приложение
- `landing_project/` - настройки проекта
- `templates/` - HTML шаблоны
- `static/` - статические файлы

### Технологии
- Python 3.11
- Django 5.1.15
- Bootstrap 5
- Gunicorn
- Nginx
- Docker

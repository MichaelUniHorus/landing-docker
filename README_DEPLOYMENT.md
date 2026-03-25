# Развертывание на сервере

## Подготовка сервера

### 1. Установка Docker
```bash
# Ubuntu/Debian
sudo apt update
sudo apt install docker.io docker-compose-plugin git

# CentOS/RHEL
sudo yum install docker docker-compose-plugin git

# Запуск Docker
sudo systemctl start docker
sudo systemctl enable docker

# Добавить пользователя в группу docker
sudo usermod -aG docker $USER
```

### 2. Клонирование проекта
```bash
git clone <ваш-repo-url> landing
cd landing
```

### 3. Настройка переменных окружения
```bash
# Скопировать шаблон
cp .env.example .env

# Редактировать .env
nano .env
```

**Важно изменить в .env:**
- `SECRET_KEY` - сгенерировать новый ключ
- `ALLOWED_HOSTS` - ваш домен

### 4. Первоначальное развертывание
```bash
# Сделать скрипты исполняемыми
chmod +x deploy.sh update.sh

# Запустить развертывание
./deploy.sh
```

### 5. Настройка SSL сертификата
```bash
# Запустить certbot для получения сертификата
docker compose -f docker-compose.prod.yml up certbot

# После получения сертификата перезапустить nginx
docker compose -f docker-compose.prod.yml restart nginx
```

## Обновление сайта

### Простое обновление
```bash
./update.sh
```

### Ручное обновление
```bash
git pull
docker compose -f docker-compose.prod.yml restart
```

### Полное пересборка
```bash
./deploy.sh
```

## Мониторинг

### Проверка статуса
```bash
docker compose -f docker-compose.prod.yml ps
```

### Просмотр логов
```bash
# Все логи
docker compose -f docker-compose.prod.yml logs

# Логи конкретного сервиса
docker compose -f docker-compose.prod.yml logs web
docker compose -f docker-compose.prod.yml logs nginx
```

### Перезапуск сервисов
```bash
# Все сервисы
docker compose -f docker-compose.prod.yml restart

# Конкретный сервис
docker compose -f docker-compose.prod.yml restart web
```

## Структура файлов

- `docker-compose.prod.yml` - production конфигурация
- `nginx.prod.conf` - Nginx с SSL
- `.env` - переменные окружения
- `deploy.sh` - скрипт развертывания
- `update.sh` - скрипт обновления
- `certbot/` - директория для SSL сертификатов

## Важные замечания

1. **Домен**: Убедитесь что DNS A-запись указывает на IP сервера
2. **Порт 80/443**: Должны быть открыты в файрволе
3. **SECRET_KEY**: Обязательно смените в production
4. **Бэкапы**: Регулярно делайте бэкапы БД и файлов
5. **Обновления**: Следите за обновлениями Docker и образов

## Автоматизация

### Cron для автоматических обновлений
```bash
# Добавить в crontab
crontab -e

# Обновление каждый день в 3:00
0 3 * * * /path/to/landing/update.sh >> /var/log/landing-update.log 2>&1
```

### Systemd service
```bash
# Создать сервис
sudo nano /etc/systemd/system/landing.service
```

Содержимое файла:
```ini
[Unit]
Description=Landing Site
Requires=docker.service
After=docker.service

[Service]
Type=oneshot
RemainAfterExit=yes
WorkingDirectory=/path/to/landing
ExecStart=/usr/bin/docker compose -f docker-compose.prod.yml up -d
ExecStop=/usr/bin/docker compose -f docker-compose.prod.yml down
TimeoutStartSec=0

[Install]
WantedBy=multi-user.target
```

```bash
# Включить сервис
sudo systemctl enable landing.service
sudo systemctl start landing.service
```

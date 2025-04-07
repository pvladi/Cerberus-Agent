FROM debian:12

RUN apt-get update && apt-get install -y \
    curl gnupg php php-cli php-fpm php-yaml php-xml php-mbstring nginx \
    nodejs npm \
    && apt-get clean

WORKDIR /app
COPY agent/ /app/agent/
COPY php/ /var/www/html/
COPY config/ /config/
COPY telegraf/ /telegraf/

RUN echo "server { listen 80; root /var/www/html; index index.php; location ~ \.php$ { include snippets/fastcgi-php.conf; fastcgi_pass unix:/run/php/php-fpm.sock; } }" > /etc/nginx/sites-enabled/default

CMD service php7.4-fpm start && nginx -g 'daemon off;'

FROM nginx:1.25-alpine

COPY ./nginx.conf /etc/nginx/conf.d/appka.conf
COPY ./ssl /etc/nginx/ssl

CMD ["nginx", "-g", "daemon off;"]

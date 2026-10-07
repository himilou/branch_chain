FROM nginx:alpine

COPY index.html permits.html /usr/share/nginx/html/
COPY assets/ /usr/share/nginx/html/assets/

EXPOSE 80

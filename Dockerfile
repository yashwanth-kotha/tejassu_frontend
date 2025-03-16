#nginx version
FROM nginx:alpine
COPY index.html /usr/share/nginx/html
#Exposing 80 port
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

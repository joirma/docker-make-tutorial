FROM docker.io/httpd:latest
COPY ./public-html/ /usr/local/apache2/htdocs/

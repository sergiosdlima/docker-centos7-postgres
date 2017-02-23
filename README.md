# Docker CentOS 7 Postgres

Imagem docker CentOS 7 que vem instalado:
* PostgreSQL 9.6

## Criar a imagem

  docker build -t NOME-DA-IMAGEM .

## Criar um container a partir da imagem

  docker run -d -p 5432:5432 NOME-DA-IMAGEM

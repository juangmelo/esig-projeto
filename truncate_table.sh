#!/bin/bash

# Configurações do Banco de Dados
CONTAINER_NAME="postgres"       # Nome ou ID do container Docker
DBNAME="postgres"               # Nome do banco de dados
USERNAME="postgres"             # Nome do usuário do PostgreSQL

# Função para truncar a tabela
truncate_table() {
    echo "Esvaziando a tabela 'animais' no banco de dados '${DBNAME}'..."
    
    # Comando para truncar a tabela
    docker exec -i "${CONTAINER_NAME}" psql -U "${USERNAME}" -d "${DBNAME}" -c \
        "TRUNCATE TABLE animais;"
    
    if [ $? -eq 0 ]; then
        echo "Tabela 'animais' esvaziada com sucesso."
    else
        echo "Falha ao esvaziar a tabela 'animais'."
    fi
}

# Executar a função
truncate_table

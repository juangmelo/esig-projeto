#!/bin/bash

# Definição de variáveis
CONTAINER_NAME="postgres"  # Nome ou ID do container Docker com o PostgreSQL
USERNAME="postgres"        # Nome do usuário do PostgreSQL
DBNAME="postgres"           # Nome do banco de dados a ser exportado
BACKUP_DIR="${HOME}/esig-projeto"  # Diretório onde o backup será salvo
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")  # Timestamp para o nome do arquivo
BACKUP_FILE="${BACKUP_DIR}/${DBNAME}_backup_${TIMESTAMP}.sql"  # Nome do arquivo de backup

# Criação do diretório de backup se não existir
mkdir -p "${BACKUP_DIR}"

# Verificação da existência do banco de dados
echo "Verificando bancos de dados no container..."
docker exec -it "${CONTAINER_NAME}" psql -U "${USERNAME}" -c '\l'

# Medir o tempo de execução do dump
START_TIME=$(date +%s)

# Comando para criar o dump do banco de dados dentro do container
echo "Iniciando backup do banco de dados '${DBNAME}'..."
docker exec -i "${CONTAINER_NAME}" pg_dump -U "${USERNAME}" -d "${DBNAME}" > "${BACKUP_FILE}"
END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))

# Verificação do sucesso do comando e mensagem final
if [ $? -eq 0 ]; then
    echo "Backup do banco de dados '${DBNAME}' foi criado em '${BACKUP_FILE}'"
    echo "Tempo necessário para o dump: ${DURATION} segundos"
else
    echo "Falha ao criar o backup do banco de dados '${DBNAME}'"
fi

# Exibir informações básicas do banco de dados
echo "Exibindo informações básicas do banco de dados..."
docker exec -i "${CONTAINER_NAME}" psql -U "${USERNAME}" -d "${DBNAME}" -c "SELECT version();"
docker exec -i "${CONTAINER_NAME}" psql -U "${USERNAME}" -d "${DBNAME}" -c "SELECT now();"

# Exibir status da conexão do PostgreSQL
echo "Status da conexão do PostgreSQL:"
docker exec -i "${CONTAINER_NAME}" psql -U "${USERNAME}" -d "${DBNAME}" -c "SELECT pg_is_in_recovery();"

echo "Script concluído."

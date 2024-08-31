#!/bin/bash

# Definição de variáveis
CONTAINER_NAME="postgres"  # Nome ou ID do container Docker com o PostgreSQL
USERNAME="postgres"        # Nome do usuário do PostgreSQL
DBNAME="postgres"          # Nome do banco de dados a ser restaurado
BACKUP_DIR="${HOME}/esig-projeto"  # Diretório onde o backup está salvo
BACKUP_PATTERN="${DBNAME}_backup_*.sql"  # Padrão de nome do arquivo de backup

# Verificação dos arquivos de backup
echo "Verificando arquivos de backup em '${BACKUP_DIR}'..."
LATEST_BACKUP_FILE=$(find "${BACKUP_DIR}" -maxdepth 1 -type f -name "${BACKUP_PATTERN}" -print0 | xargs -0 ls -t | head -n 1)

if [ -z "${LATEST_BACKUP_FILE}" ]; then
    echo "Nenhum arquivo de backup encontrado que corresponda ao padrão '${BACKUP_PATTERN}' em '${BACKUP_DIR}'."
    exit 1
fi

# Exibir o nome do arquivo de backup encontrado
echo "Arquivo de backup encontrado: ${LATEST_BACKUP_FILE}"

# Verificação da existência do banco de dados
echo "Verificando bancos de dados no container..."
docker exec -it "${CONTAINER_NAME}" psql -U "${USERNAME}" -c '\l'

# Medir o tempo de execução da restauração
START_TIME=$(date +%s)

# Comando para restaurar o banco de dados dentro do container
echo "Iniciando restauração do banco de dados '${DBNAME}' a partir do arquivo '${LATEST_BACKUP_FILE}'..."
cat "${LATEST_BACKUP_FILE}" | docker exec -i "${CONTAINER_NAME}" psql -U "${USERNAME}" -d "${DBNAME}"

END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))

# Verificação do sucesso do comando e mensagem final
if [ $? -eq 0 ]; then
    echo "Banco de dados '${DBNAME}' foi restaurado com sucesso a partir de '${LATEST_BACKUP_FILE}'."
    echo "Tempo necessário para a restauração: ${DURATION} segundos"
else
    echo "Falha ao restaurar o banco de dados '${DBNAME}' a partir de '${LATEST_BACKUP_FILE}'."
fi

# Exibir informações básicas do banco de dados
echo "Exibindo informações básicas do banco de dados..."
docker exec -i "${CONTAINER_NAME}" psql -U "${USERNAME}" -d "${DBNAME}" -c "SELECT version();"
docker exec -i "${CONTAINER_NAME}" psql -U "${USERNAME}" -d "${DBNAME}" -c "SELECT now();"

# Exibir status da conexão do PostgreSQL
echo "Status da conexão do PostgreSQL:"
docker exec -i "${CONTAINER_NAME}" psql -U "${USERNAME}" -d "${DBNAME}" -c "SELECT pg_is_in_recovery();"

echo "Script concluído."

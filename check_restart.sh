#!/bin/bash

# Definição dos nomes dos containers
TOMCAT_CONTAINER="tomcat"
JBOSS_CONTAINER="jboss"

# Função para calcular a diferença de tempo em segundos
calculate_time_diff() {
    local last_time=$1
    local current_time=$(date +%s)
    echo $((current_time - last_time))
}

# Função para verificar o status e reiniciar o container se necessário
check_and_restart_container() {
    local container_name=$1

    # Verificar se o container está rodando
    if [ "$(docker ps --filter "name=${container_name}" --format '{{.Names}}')" == "${container_name}" ]; then
        echo "${container_name} está rodando."
        # Obter o tempo de atividade do contêiner
        start_time=$(docker inspect -f '{{.State.StartedAt}}' "${container_name}")
        uptime_seconds=$(calculate_time_diff $(date -d "$start_time" +%s))
        echo "Tempo de atividade: ${uptime_seconds} segundos"
    else
        # Se o container não está rodando, obter o tempo de parada
        stopped_time=$(docker inspect -f '{{.State.FinishedAt}}' "${container_name}")
        
        # Converter o tempo de parada para segundos desde Epoch
        stopped_time_seconds=$(date -d "$stopped_time" +%s)
        
        # Calcular a diferença de tempo entre agora e quando o container parou
        time_diff=$(calculate_time_diff $stopped_time_seconds)

        if [ "$time_diff" -gt 60 ]; then
            echo "${container_name} está parado há mais de 1 minuto. Reiniciando..."
            docker start "${container_name}"
        else
            echo "${container_name} está parado, mas por menos de 1 minuto. Não será reiniciado."
        fi
    fi
}

# Verificar e reiniciar Tomcat
check_and_restart_container "${TOMCAT_CONTAINER}"

# Verificar e reiniciar JBoss
check_and_restart_container "${JBOSS_CONTAINER}"

echo "Script concluído."

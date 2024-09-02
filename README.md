# esig-projeto

# Projeto de Backup e Monitoramento de Banco de Dados PostgreSQL

Este projeto tem como objetivo fornecer um conjunto de scripts que permitem realizar o dump e o restore de um banco de dados PostgreSQL, além de verificar o status das instâncias do JBoss e Tomcat em um ambiente de teste. Todos os scripts foram desenvolvidos utilizando Docker, o que facilita a configuração e a execução em diferentes ambientes.

## Funcionalidades

- **Dump do Banco de Dados**: Gera um backup do banco de dados PostgreSQL.
- **Restore do Banco de Dados**: Restaura o banco de dados a partir do backup.
- **Verificação de Instâncias**: Monitora as instâncias do JBoss e Tomcat, verificando se estão rodando e reiniciando-as se necessário.

## Pré-requisitos

- **Docker**: Certifique-se de ter o Docker mais recente instalado. Para instalar o Docker no Ubuntu, execute os seguintes comandos:

```bash
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc 

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```
- Para instalar o Docker em outros sistemas operacionais, consulte o guia oficial de instalação no site do Docker.

- Para garantir que você possa executar comandos do Docker sem precisar usar sudo, adicione seu usuário ao grupo docker com o comando abaixo:
  
```bash
sudo usermod -aG docker $(whoami)
```
- Após executar esse comando, você precisará fazer logout e login novamente para que as alterações tenham efeito.

## Criando um Volume para Persistência de Dados

Para garantir que os dados do banco de dados PostgreSQL sejam mantidos mesmo após a remoção do contêiner, você pode criar um volume chamado `pgdata`. Execute o seguinte comando para criar o volume:

```bash
docker volume create pgdata
```
Após criar o volume, você pode usá-lo ao iniciar um contêiner PostgreSQL. Execute o seguinte comando, com o nome do seu conteiner e sua senha de preferência:

```bash
docker run --name postgres -e POSTGRES_PASSWORD=senha -d -v pgdata:/var/lib/postgresql/data postgres
```

## Acessando o Contêiner PostgreSQL

Após iniciar o contêiner, você pode acessá-lo usando o seguinte comando:

```bash
docker exec -it postgres /bin/bash
```
Isso abrirá um terminal interativo dentro do contêiner. A partir daí, você pode usar o psql, o cliente de linha de comando do PostgreSQL, para interagir com o banco de dados:

```bash
psql -U postgres
```
## Script para Criar e Popular a Tabela 'animais'

O arquivo `create_table.sql`, disponível no repositório, contém um script SQL que realiza a criação e a inserção de dados em uma tabela chamada `animais`. 

### Estrutura da Tabela

Ao conectar-se ao banco de dados, use o seguinte script para criar sua tabela:

```sql
CREATE TABLE animais (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    especie VARCHAR(50) NOT NULL,
    idade INT,
    peso DECIMAL(5, 2),
    habitat VARCHAR(100),
    data_de_entrada DATE DEFAULT CURRENT_DATE
);
```
Após a criação da tabela, o seguinte script insere diversos registros na tabela animais:

```sql
INSERT INTO animais (nome, especie, idade, peso, habitat) VALUES
('Simba', 'Leão', 5, 190.50, 'Savanas da África'),
('Nemo', 'Peixe-palhaço', 2, 0.15, 'Oceano Pacífico'),
('Kaa', 'Cobra', 4, 15.30, 'Floresta Amazônica'),
('Dumbo', 'Elefante', 10, 540.00, 'África'),
('Bambi', 'Cervo', 3, 80.20, 'Florestas da Europa'),
('Baloo', 'Urso', 7, 450.75, 'Montanhas da Índia'),
('Zazu', 'Calau', 2, 0.55, 'Savanas da África'),
('Manny', 'Mamute', 25, 600.00, 'Era do Gelo'),
('Timon', 'Suricato', 3, 0.75, 'Savanas da África'),
('Pumba', 'Javali', 4, 120.00, 'Savanas da África');
```

## Script para Realizar o Dump do Banco de Dados

O arquivo `backup_table.sh`, contém um script que realiza o dump do banco de dados PostgreSQL. 

### Funcionamento do Script

1. **Definição de Variáveis**: O script começa definindo variáveis importantes:
   - `CONTAINER_NAME`: Nome ou ID do contêiner Docker que executa o PostgreSQL.
   - `USERNAME`: Nome do usuário do PostgreSQL.
   - `DBNAME`: Nome do banco de dados que será exportado.
   - `BACKUP_DIR`: Diretório onde o backup será salvo.
   - `BACKUP_FILE`: Nome do arquivo de backup gerado, com um timestamp para evitar sobreposição.

2. **Verificação da Existência do Banco de Dados**: O script verifica os bancos de dados existentes no contêiner.

3. **Criação do Dump**: O comando `pg_dump` é executado para criar o dump do banco de dados. O tempo decorrido da operação é cronometrado em segundos.

4. **Informações Básicas do Banco de Dados**: Após a criação do dump, o script exibe algumas informações básicas do banco de dados, como a versão do PostgreSQL e o status da conexão.

### Executando o Script

Para executar o script de dump:

1. **No terminal, certifique-se de que o script `backup_table.sh` esteja disponível no seu diretório atual**.

2. **Digite o seguinte comando para permissão de execução**:
  ```bash
  chmod +x backup_table.sh
```

3. **Execute o script diretamente do seu terminal**:
   ```bash
   ./backup_table.sh
   ```
### Verificando arquivo de backup

Após a execução do script, verifique o diretório onde você escolheu para o backup.

## Script para Esvaziar o Banco de Dados

Com a finalidade de fazermos a restauração a partir do arquivo dump, iremos esvaziar o banco de dados com este intuito. O arquivo `truncate_table.sh`, esvazia a tabela `animais` do banco de dados PostgreSQL.

### Funcionamento do Script

1. **Configuração das Variáveis**: O script começa definindo as seguintes variáveis
   - `CONTAINER_NAME`: Nome ou ID do contêiner Docker que executa o PostgreSQL.
   - `DBNAME`: Nome do banco de dados que contém a tabela a ser esvaziada.
   - `USERNAME`: Nome do usuário do PostgreSQL.

2. **Função para Truncar a Tabela**: A função `truncate_table` executa o comando SQL para esvaziar a tabela `animais`. O script verifica se o comando foi executado com sucesso e exibe uma mensagem correspondente.

### Executando o Script

Para executar o script de truncar a tabela a partir do seu host, siga os passos abaixo:

1. **No terminal, certifique-se de que o script `truncate_table.sh` esteja disponível no seu diretório atual**.

2. **Digite o seguinte comando para permissão de execução**:
  ```bash
   chmod +x truncate_table.sh
```

3. **Execute o script diretamente do seu terminal**:
   ```bash
   ./truncate_table.sh
   ```
## Script para Restaurar o Banco de Dados

O arquivo `restore_banco.sh`, contém um script Bash que restaura o banco de dados PostgreSQL a partir de um arquivo de backup.

### Funcionamento do Script

1. **Definição de Variáveis**: O script começa definindo as seguintes variáveis:
   - `CONTAINER_NAME`: Nome ou ID do contêiner Docker que executa o PostgreSQL.
   - `USERNAME`: Nome do usuário do PostgreSQL.
   - `DBNAME`: Nome do banco de dados a ser restaurado.
   - `BACKUP_DIR`: Diretório onde o backup está salvo.
   - `BACKUP_PATTERN`: Padrão de nome do arquivo de backup para busca.

2. **Verificação dos Arquivos de Backup**: O script verifica se existem arquivos de backup no diretório especificado. Se não encontrar, exibe uma mensagem de erro e encerra a execução.

3. **Restauração do Banco de Dados**: O script utiliza o comando `psql` para restaurar o banco de dados a partir do arquivo de backup mais recente encontrado. O tempo necessário para essa operação é medido.

4. **Informações Básicas do Banco de Dados**: Após a restauração, o script exibe informações básicas do banco de dados, como a versão do PostgreSQL e o status da conexão.

### Executando o Script

Para executar o script de restauração a partir do seu host, siga os passos abaixo:

1. **No terminal, certifique-se de que o script `restore_table.sh` esteja disponível no seu diretório atual**.

2. **Digite o seguinte comando para permissão de execução**:
   ```bash
   chmod +x restore_table.sh
   ```

3. **Execute o script diretamente do seu terminal**:
   ```bash
   ./restore_table.sh
   ```

## Criando Contêineres para Tomcat e JBoss

Iremos criar contêineres para o Tomcat e o JBoss utilizando o Docker e assim.

### 1. Criando um Contêiner para Tomcat

Para criar um contêiner para o Tomcat, execute o seguinte comando:

```bash
docker run -d --name tomcat -p 8080:8080 tomcat:latest
```

- -d: Executa o contêiner em segundo plano (detached mode).
- --name tomcat: Nomeia o contêiner como "tomcat".
- -p 8080:8080: Mapeia a porta 8080 do contêiner para a porta 8080 do host.
- tomcat:latest: Usa a imagem mais recente do Tomcat.
- Após executar o comando, você pode acessar o Tomcat no seu navegador em "http://localhost:8080".

### 2. Criando um Contêiner para JBoss

```bash
docker run -d --name jboss -p 8081:8080 -p 9991:9990 jboss/wildfly:latest
```

- -d: Executa o contêiner em segundo plano (detached mode).
- --name jboss: Nomeia o contêiner como "jboss".
- -p 8081:8080: Mapeia a porta 8080 do contêiner para a porta 8081 do host.
- -p 9991:9990: Mapeia a porta 9990 do contêiner para a porta 9991 do host, que é usada para o console de administração do JBoss.
- Após executar o comando, você pode acessar o JBoss no seu navegador em http://localhost:8081 e o console de administração em http://localhost:9991.

## Verificando Instâncias JBoss e Tomcat

A partir do script `check_restart.sh`, ele verifica se os contêineres do Tomcat e JBoss estão em execução. Se um contêiner estiver parado por mais de um minuto, ele será reiniciado.

### Executando o Script

Para executar o script, siga os passos abaixo:

1. **No terminal, certifique-se de que o script `check_restart.sh` esteja disponível no seu diretório atual**.

2. **Digite o seguinte comando para permissão de execução**:
   ```bash
   chmod +x check_restart.sh
   ```

3. **Execute o script diretamente do seu terminal**:
   ```bash
   ./check_restart.sh
   ```

### Como funciona
- Verifica se cada contêiner está em execução e obtém o tempo de atividade.
- Se um contêiner não estiver em execução, verifica há quanto tempo ele está parado.
- Reinicia o contêiner se ele estiver parado por mais de 60 segundos.

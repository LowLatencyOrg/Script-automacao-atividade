echo "Verificando a existência do Node"
		if command -v node >/dev/null 2>&1; then
			node -v
			echo "Node.js ja esta instalado!"
		else
			echo "Node.js nao esta instalado na EC2."
			echo "A aplicacao usara a imagem oficial do Node no Docker."
		fi

		cd "$HOME/low-latency"

		echo "Baixando os arquivos da API"
		if [ -d "Site-Grupo10" ]; then

        echo "O repositorio da API ja existe!"

   		else

       		git clone "https://github.com/LowLatencyOrg/Site-Grupo10.git"

    	fi
		
		cd Site-Grupo10
		echo "Criando dockerfile do site"
cat << 'DOCKERFILE_EOF' > Dockerfile
FROM node:20-alpine
WORKDIR /app
COPY . .
RUN npm install
EXPOSE 3333
CMD ["npm", "start"]
DOCKERFILE_EOF

		echo "Dockerfile criado com sucesso!"

		echo "Deseja iniciar a API? [s/n]"
		read input
		if [ "$input" == "s" ]; then
		
			echo "Construindo a imagem Docker"
			sudo docker build -t low-latency-imagem .

			echo "Iniciando o container"
			sudo docker run -d --name low-latency-api -p 3333:3333 low-latency-imagem

		if [ $? -eq 0 ]; then
                echo "Container da aplicacao iniciado!"
                echo "Teste usando http://IP-PUBLICO-DA-EC2:3333"
            else
                echo "Erro ao iniciar o container da aplicacao"
            fi

        else
            echo "Inicializacao da API cancelada"
        fi

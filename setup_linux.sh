#!/usr/bin/env bash
echo "==========================================="
echo "   Instalando dependências do RAG-FAQ Web"
echo "==========================================="

# Verifica Python
if ! command -v python3 &> /dev/null; then
    echo "ERRO: Python3 não encontrado. Instale Python 3.10+."
    exit 1
fi

# Atualiza e instala pip/venv
echo "Atualizando apt e instalando python3-pip/venv (pode pedir senha)..."
sudo apt update -y
sudo apt install -y python3-pip python3-venv

# Atualiza pip e instala requirements
echo "Instalando dependências do requirements.txt..."
pip install --upgrade pip
pip install -r requirements.txt
if [ $? -ne 0 ]; then
    echo "ERRO: Falha ao instalar dependências do requirements.txt."
    exit 1
fi

echo
echo "==========================================="
echo "  Instalando pacote rag_faq..."
echo "==========================================="

# Caminhos possíveis para o arquivo .tar ou .tar.gz dentro da pasta rag_faq-0.1.0
TAR_PATH="rag_faq-0.1.0/rag_faq.tar"
TAR_GZ_PATH="rag_faq-0.1.0/rag_faq.tar.gz" # Ajustado para incluir o diretório

# Verifica qual existe e instala
if [ -f "$TAR_GZ_PATH" ]; then
    echo "Encontrado: $TAR_GZ_PATH"
    pip install "$TAR_GZ_PATH"
elif [ -f "$TAR_PATH" ]; then
    echo "Encontrado: $TAR_PATH"
    pip install "$TAR_PATH"
else
    echo "ERRO: Nenhum arquivo .tar ou .tar.gz encontrado dentro de rag_faq-0.1.0!"
    echo "Certifique-se de que '$TAR_PATH' ou '$TAR_GZ_PATH' existe."
    exit 1
fi

# Verifica se a instalação do pip foi bem-sucedida
if [ $? -ne 0 ]; then
    echo "ERRO: Falha ao instalar o pacote rag_faq."
    exit 1
fi

echo
echo "Instalação concluída!"
echo "Recomendação: Crie e ative um ambiente virtual antes de rodar a aplicação."
echo "Exemplo:"
echo "    python3 -m venv .venv"
echo "    source .venv/bin/activate"
echo
echo "Para iniciar o app (com ambiente virtual ativo, se usado):"
echo "    python app.py"
echo "    (O navegador deve abrir automaticamente em http://localhost:8000)"
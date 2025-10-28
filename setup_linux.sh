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

# Instala o pacote rag_faq diretamente do arquivo .tar.gz
echo "Instalando pacote rag_faq a partir do arquivo .tar.gz..."
ARCHIVE_NAME="rag_faq.tar.gz" # <<< Certifique-se que o nome do seu arquivo é este

if [ -f "$ARCHIVE_NAME" ]; then
    pip install "$ARCHIVE_NAME"
    if [ $? -ne 0 ]; then
        echo "ERRO: Falha ao instalar $ARCHIVE_NAME com pip."
        exit 1
    fi
else
    echo "ERRO: Arquivo '$ARCHIVE_NAME' não encontrado na raiz!"
    echo "Certifique-se de ter criado o .tar.gz com o código corrigido."
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
echo "    (E acesse http://localhost:8000 no navegador)"
@echo off
echo ===========================================
echo   Instalando dependencias do RAG-FAQ Web
echo ===========================================

REM Verifica se Python está instalado
python --version >nul 2>&1
if errorlevel 1 (
    echo ERRO: Python nao encontrado. Instale Python 3.10+ e adicione ao PATH.
    pause
    exit /b
)

echo Atualizando pip e instalando dependencias do requirements.txt...
pip install --upgrade pip
pip install -r requirements.txt
if errorlevel 1 (
    echo ERRO: Falha ao instalar dependencias do requirements.txt.
    pause
    exit /b
)

echo.
echo Instalando pacote rag_faq a partir do arquivo .tar.gz...
set ARCHIVE_NAME=rag_faq.tar.gz REM <<< Certifique-se que o nome do seu arquivo e este

if exist "%ARCHIVE_NAME%" (
    pip install "%ARCHIVE_NAME%"
    if errorlevel 1 (
        echo ERRO: Falha ao instalar %ARCHIVE_NAME% com pip.
        pause
        exit /b
    )
) else (
    echo ERRO: Arquivo '%ARCHIVE_NAME%' nao encontrado na raiz!
    echo Certifique-se de ter criado o .tar.gz com o codigo corrigido.
    pause
    exit /b
)

echo.
echo Instalacao concluida!
echo.
echo Recomendacao: Crie e ative um ambiente virtual antes de rodar a aplicacao.
echo Exemplo (no PowerShell ou CMD):
echo     python -m venv .venv
echo     .\.venv\Scripts\activate
echo.
echo Para iniciar o app (com ambiente virtual ativo, se usado):
echo     python app.py
echo     (E acesse http://localhost:8000 no navegador)
pause
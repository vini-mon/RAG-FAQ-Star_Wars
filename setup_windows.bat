@echo off
echo ===========================================
echo    Instalando dependencias do RAG-FAQ Web
echo ===========================================

:: Verifica Python... (mantém igual)
where python >nul 2>nul
if %errorlevel% neq 0 (
    echo ERRO: Python nao encontrado. Instale Python 3.10 ou superior.
    exit /b 1
)

:: Instala requirements... (mantém igual)
echo.
echo Atualizando pip e instalando dependencias...
python -m pip install --upgrade pip
python -m pip install -r requirements.txt
if %errorlevel% neq 0 (
    echo ERRO: Falha ao instalar dependencias do requirements.txt.
    exit /b 1
)

echo.
echo ===========================================
echo   Instalando pacote local rag_faq em modo editavel...
echo ===========================================

set RAG_FAQ_SOURCE_DIR=rag_faq-0.1.0

if exist "%RAG_FAQ_SOURCE_DIR%\" (
    cd "%RAG_FAQ_SOURCE_DIR%"
    if exist "setup.py" (
        echo Instalando em modo editavel a partir de %CD% ...
        python -m pip install -e . 
        if %errorlevel% neq 0 (
            echo ERRO: Falha ao instalar rag_faq com 'pip install -e .'.
            cd ..
            pause
            exit /b 1
        )
        cd ..
    ) else (
        echo ERRO: setup.py nao encontrado dentro de %RAG_FAQ_SOURCE_DIR%!
        cd ..
        pause
        exit /b 1
    )
) else (
    echo ERRO: Diretorio '%RAG_FAQ_SOURCE_DIR%' nao encontrado na raiz!
    pause
    exit /b 1
)

echo.
echo Instalacao concluida!
echo.
echo Instalacao concluida!
echo.
echo Recomendacao: Crie e ative um ambiente virtual antes de rodar a aplicacao.
echo Exemplo:
echo     python -m venv .venv
echo     .venv\Scripts\activate
echo.
echo Para iniciar o app (com ambiente virtual ativo, se usado):
echo     python app.py
echo     (E acesse http://localhost:8000 no navegador)
pause

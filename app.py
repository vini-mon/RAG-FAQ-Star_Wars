import eel
import subprocess
import sys

import os
os.environ["PYTHONIOENCODING"] = "utf-8"

import io
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
sys.stdin = io.TextIOWrapper(sys.stdin.buffer, encoding='utf-8')



# Inicializa o Eel, apontando para a pasta 'web' onde seu frontend está
eel.init('web')

@eel.expose  # Expõe esta função para o JavaScript
def processar_pergunta(question):
    """
    Recebe uma pergunta do frontend, processa com o RAG
    e retorna a resposta.
    """
    print(f"Recebida pergunta: {question}")
    
    # O nome do seu projeto RAG (o mesmo do notebook)
    project_name = "pbl_3-star_wars" 
    
    # O comando que você usou no notebook
    command = [
        "rag-faq",            # O comando principal
        "--mode", "query",    # Queremos fazer uma pergunta
        "--project", project_name
    ]

    try:
        # Usamos subprocess.run para executar o comando
        # 1. 'input=question' envia a pergunta para o 'stdin' do comando
        # 2. 'capture_output=True' pega o que o comando imprimiria
        # 3. 'text=True' trata tudo como texto (string)
        # 4. 'encoding='utf-8'' garante a codificação correta
        # 5. 'timeout=60' (Opcional) mata o processo se demorar mais de 60s
        
        # Nota: Isso assume que o comando 'rag-faq --mode query' foi
        # programado para ler UMA pergunta do input e sair.
        # Se ele entrar em loop, precisaremos de uma abordagem mais complexa.
        
        # Como estamos no WSL, precisamos garantir que o shell encontre o comando
        # 'rag-faq' que foi instalado pelo 'pip install -e .'
        # A forma mais segura é chamar o python -m
        
        # Ajuste no comando para ser mais robusto
        command = [
            sys.executable,  # O caminho para o 'python' que está rodando este script
            "-m", "rag_faq.main", # Chama o 'main' do pacote como um módulo
            "--mode", "query",
            "--project", project_name
        ]

        result = subprocess.run(
            command,
            input=question + "\nquit\n", # Envia a pergunta E um comando 'quit'
            capture_output=True,
            text=True,
            encoding='utf-8',
            errors="replace",
            timeout=240
        )
        
        if result.returncode != 0:
            error_message = f"Erro no subprocesso RAG:\nSTDERR:\n{result.stderr}\nSTDOUT:\n{result.stdout}"
            print(error_message, file=sys.stderr) # Imprime erro no terminal do app.py
            return error_message # Retorna erro detalhado

        
        # Pega stdout (deve ser a resposta limpa)
        answer = result.stdout.strip() 

        # Pega stderr (deve conter os DEBUGs)
        debug_info = result.stderr.strip()

        print(f"--- DEBUG Info (stderr) ---:\n{debug_info}\n--------------------------") # Imprime DEBUGs no terminal
        print(f"--- Resposta Recebida (stdout) ---:\n{answer}\n-----------------------------") # Imprime resposta limpa no terminal

        return answer # Retorna APENAS a resposta limpa

    except Exception as e:
        print(f"Falha ao executar o subprocesso: {e}")
        return f"Ocorreu um erro no servidor Python: {str(e)}"

# Inicia a aplicação Eel
print("Iniciando servidor Eel em http://localhost:8000/index.html")
try:
    eel.start('index.html', size=(800, 800), port=8000)
except (SystemExit, KeyboardInterrupt):
    print("Encerrando servidor.")
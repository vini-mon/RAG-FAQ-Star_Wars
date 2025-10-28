// main.js

// Espera o conteúdo da página carregar
window.addEventListener('DOMContentLoaded', () => {

    // Pega os elementos da página
    const askButton = document.getElementById('ask-button');
    const questionInput = document.getElementById('question-input');
    const resultsLog = document.getElementById('results-log');

    // Adiciona um "ouvinte" de clique no botão
    askButton.addEventListener('click', ask_question);

    // Função principal que é chamada ao clicar no botão
    async function ask_question() {
        
        const question = questionInput.value;

        // Não faz nada se a pergunta estiver vazia
        if (!question.trim()) {
            return;
        }

        // 1. Desabilita o botão e mostra "processando"
        askButton.disabled = true;
        resultsLog.style.color = 'var(--text-muted)'; // Cor cinza
        resultsLog.innerText = 'Consultando os holocrons... 🚀';

        try {
            // 2. Chama a função Python 'processar_pergunta' exposta pelo Eel
            //    e espera a resposta (o 'await')
            console.log(`Enviando pergunta para o Python: ${question}`);
            const answer = await eel.processar_pergunta(question)();
            console.log(`Resposta recebida do Python: ${answer}`);

            // 3. Mostra a resposta na tela
            resultsLog.style.color = 'var(--text-color)'; // Cor branca
            resultsLog.innerText = answer;

        } catch (error) {
            // 4. Mostra uma mensagem de erro se algo der errado
            console.error('Erro ao chamar o Python:', error);
            resultsLog.style.color = 'var(--danger-color)'; // Cor vermelha
            resultsLog.innerText = `Ocorreu um erro ao contatar o backend Python: ${error.errorText || 'Erro desconhecido'}`;
        
        } finally {
            // 5. Reabilita o botão, não importa se deu certo ou errado
            askButton.disabled = false;
        }
    }
});
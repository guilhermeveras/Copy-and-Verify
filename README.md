# 📁 Script de Cópia de arquivos com recursividade e Verificação de Integridade com PowerShell

Pequeno Script que fiz para resolver um problema de cópia de arquivos de maneira recursiva em um diretório, colocando todos em um único destino, inclui uma verificação de integridade via hash SHA256, estimativa de tempo e tratamento de conflitos de nomes e erros. 

Ideal para backups de fotos, videos e musicas de diferentes lugares para um mesmo local.
(Testei com mais de 260gb, ~13k arquivos de fotos e videos no Onedrive copiando os mesmos para um HD Externo)

---

## ✅ Funcionalidades

- 🔄 Cópia recursiva de todos os arquivos da pasta de origem
- 📁 Todos os arquivos são colocados em uma única pasta de destino
- 🛑 Evita sobrescrever arquivos duplicados com renome automático (`_1`, `_2`, ...)
- 🔒 Verificação de integridade com hash SHA256
- ❌ Remove automaticamente arquivos copiados incorretamente
- ⏱️ Exibe progresso com tempo decorrido e estimativa de tempo restante
- 🧾 Gera um resumo detalhado com contagem de erros e arquivos verificados
- 🧠 Feedback contínuo e mensagens coloridas no terminal

---

## 🖥️ Requisitos

- Windows 10 ou superior
- PowerShell 5.0+
- Permissão de leitura e escrita nas pastas envolvidas

---

## 🚀 Como usar

### 1. Baixe o script

Clone este repositório ou copie o arquivo `.ps1` manualmente.

```powershell
git clone https://github.com/guilhermeveras/Copy-and-Verify.git
cd Copy-and-Verify 
```

### 2. Edite os caminhos no início do script

Abra copy_and_verify.ps1 em um editor e ajuste:

```powershell
$sourcePath = "D:\Caminho\Para\Origem"
$destinationPath = "D:\Caminho\Para\Destino"
```

### 3. Execute o script via PowerShell
Se necessário, libere a execução de scripts na sessão atual:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned
```

Então rode:

```powershell
.\copy_and_verify.ps1
```

---

## 📦 Exemplo de saída

```text
Iniciando copia de 1200 arquivos...

[1/1200] Copiado: imagem1.jpg | Tempo: 00:00:03 | Estimado restante: 00:01:25
[2/1200] Copiado: video.mp4   | Tempo: 00:00:08 | Estimado restante: 00:01:30
...

Resumo Final:
Arquivos copiados: 1200
Arquivos verificados com sucesso: 1198
Arquivos com erro: 2
Tempo total gasto: 00:02:34
```

---

## ⚠️ Observações

Apenas cópia: o script não apaga nada na origem

Arquivos com verificação de hash inválida são deletados do destino

Conflitos de nome são resolvidos automaticamente com sufixos numerados

Estimativa de tempo se baseia na média por arquivo

---

## 💡 Ideias 

Você pode mudar o algoritmo de verificação modificando a função:

```powershell
Get-FileHash -Algorithm SHA256
```

Substitua por SHA1, MD5, etc., conforme necessário.

Para transformar em um utilitário com entrada de parâmetros:

Use o bloco param() no início do script para aceitar caminhos via CLI.

---

## 🤝 Contribua

Achou útil? Tem sugestões ou melhorias?

Contribuições são bem-vindas via pull request ou issue!

Me chama para um cafezinho!

---

## 📄 Licença

Este projeto está licenciado sob os termos da Licença MIT.
Veja o arquivo LICENSE para mais detalhes.

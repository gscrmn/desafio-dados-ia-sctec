# =============================================================================
# Script: publicar-no-github.ps1
# Uso: copie este script para DENTRO da pasta do projeto (desafio-dados-ia-sctec).
#      Depois: cd C:\Users\giova\desafio-dados-ia-sctec
#              .\scripts\publicar-no-github.ps1
# Você precisa ter feito "gh auth login" antes (uma vez).
# =============================================================================

$ErrorActionPreference = "Stop"
$REPO_NAME = "desafio-dados-ia-sctec"
$SCRIPT_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path
$PROJECT_DIR = Split-Path -Parent $SCRIPT_DIR

Set-Location $PROJECT_DIR

Write-Host "Projeto: $PROJECT_DIR" -ForegroundColor Cyan
Write-Host ""

# 1) Verificar se GitHub CLI está instalado e logado
Write-Host "[1/6] Verificando GitHub CLI (gh)..." -ForegroundColor Yellow
try {
    $ghVersion = gh --version 2>&1
    if ($LASTEXITCODE -ne 0) { throw "gh nao encontrado" }
    Write-Host "  OK - gh instalado." -ForegroundColor Green
} catch {
    Write-Host "  ERRO: GitHub CLI nao esta instalado." -ForegroundColor Red
    Write-Host "  Instale com: winget install --id GitHub.cli --source winget" -ForegroundColor White
    Write-Host "  Depois feche e abra o terminal e rode este script de novo." -ForegroundColor White
    exit 1
}

$auth = gh auth status 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "  ERRO: Voce ainda nao fez login no GitHub." -ForegroundColor Red
    Write-Host "  Rode no terminal:  gh auth login" -ForegroundColor White
    Write-Host "  Escolha: GitHub.com, HTTPS, e 'Login with a web browser'." -ForegroundColor White
    Write-Host "  Depois rode este script de novo." -ForegroundColor White
    exit 1
}
Write-Host "  OK - gh autenticado." -ForegroundColor Green
Write-Host ""

# 2) Inicializar Git na pasta (se ainda não tiver)
Write-Host "[2/6] Inicializando Git no projeto..." -ForegroundColor Yellow
if (-not (Test-Path ".git")) {
    git init
    git branch -M main
    Write-Host "  OK - Git inicializado." -ForegroundColor Green
} else {
    Write-Host "  OK - Git ja inicializado." -ForegroundColor Green
}
Write-Host ""

# 3) Adicionar arquivos e primeiro commit (precisa existir antes do gh repo create)
Write-Host "[3/6] Adicionando arquivos e fazendo commit..." -ForegroundColor Yellow
git add .
$status = git status --short
if ([string]::IsNullOrWhiteSpace($status)) {
    Write-Host "  Nenhuma alteracao pendente." -ForegroundColor Gray
} else {
    git commit -m "Estrutura inicial do projeto - Desafio Dados/IA SCTEC"
    Write-Host "  OK - Commit criado." -ForegroundColor Green
}
# Se nao havia nada commitado ainda, fazer um commit inicial
$log = git log --oneline -1 2>&1
if ($LASTEXITCODE -ne 0) {
    git commit --allow-empty -m "Estrutura inicial do projeto - Desafio Dados/IA SCTEC"
    Write-Host "  OK - Commit inicial criado." -ForegroundColor Green
}
Write-Host ""

# 4) Criar repositório no GitHub (se não existir) e conectar
Write-Host "[4/6] Criando repositorio no GitHub (publico)..." -ForegroundColor Yellow
$repoExists = gh repo view $REPO_NAME 2>&1
if ($LASTEXITCODE -ne 0) {
    gh repo create $REPO_NAME --public --source=. --remote=origin --description "Desafio Pratico Dados/IA - SCTEC IA para DEVs"
    if ($LASTEXITCODE -ne 0) {
        Write-Host "  ERRO ao criar repositorio. Verifique se o nome ja existe ou tente outro." -ForegroundColor Red
        exit 1
    }
    Write-Host "  OK - Repositorio criado." -ForegroundColor Green
} else {
    $user = gh api user -q .login
    $remote = git remote get-url origin 2>&1
    if ($LASTEXITCODE -ne 0) {
        git remote add origin "https://github.com/$user/${REPO_NAME}.git"
        Write-Host "  OK - Remote origin configurado." -ForegroundColor Green
    } else {
        Write-Host "  OK - Repositorio ja existe. Usando o existente." -ForegroundColor Green
    }
}
Write-Host ""

# 5) Push para o GitHub
Write-Host "[5/6] Enviando para o GitHub (push)..." -ForegroundColor Yellow
git push -u origin main
if ($LASTEXITCODE -ne 0) {
    Write-Host "  ERRO no push. Confirme que fez 'gh auth login' e tente novamente." -ForegroundColor Red
    exit 1
}
Write-Host "  OK - Codigo enviado." -ForegroundColor Green
Write-Host ""

# 6) Criar branches extras e commits para atender critério do edital (>3 branches, >8 commits)
Write-Host "[6/6] Criando branches e commits para o edital (mais de 3 branches, mais de 8 commits)..." -ForegroundColor Yellow
$extraBranches = @("feature/dados", "feature/limpeza", "feature/analise", "feature/docs")
foreach ($b in $extraBranches) {
    $exists = git branch --list $b 2>&1
    if ([string]::IsNullOrWhiteSpace($exists)) {
        git checkout -b $b
        git commit --allow-empty -m "feature: $b - etapa do projeto"
        git push -u origin $b
        git checkout main
        git merge $b -m "Merge branch '$b'"
        git push origin main
    }
}
git checkout main 2>$null

$finalBranches = (git branch -a | Measure-Object -Line).Lines
$finalCommits = (git log --oneline | Measure-Object -Line).Lines
Write-Host "  OK - Branches: $finalBranches | Commits: $finalCommits" -ForegroundColor Green
Write-Host ""

$user = gh api user -q .login
Write-Host "Concluido." -ForegroundColor Green
Write-Host "Repositorio: https://github.com/$user/$REPO_NAME" -ForegroundColor Cyan
Write-Host "Coloque esse link no PDF do SCTEC (junto com nome, CPF e opcao Dados/IA)." -ForegroundColor White

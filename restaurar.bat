@echo off
REM === CONFIGURAÇÕES ===
set "REPO_URL=https://github.com/azraelitoo/ollama-llama3.git"
set "PASTA_LOCAL=C:\Users\leo\Desktop\ollama-llama3"
set "PASTA_TEMP=C:\tmp\backup_github"
set "DATA_TARGET=1 day ago"
set "BRANCH=main"

REM === LIMPA PASTA TEMPORÁRIA ===
echo [INFO] Limpando pasta temporária...
rmdir /s /q "%PASTA_TEMP%" 2>nul
mkdir "%PASTA_TEMP%"

REM === CLONA O REPOSITÓRIO ===
echo [INFO] Clonando o repositório...
git clone "%REPO_URL%" "%PASTA_TEMP%"
if errorlevel 1 (
    echo [ERRO] Falha ao clonar repositório.
    pause
    exit /b
)

cd /d "%PASTA_TEMP%"

REM === OBTÉM O COMMIT DE ONTEM ===
for /f %%i in ('git rev-list -n 1 --before="%DATA_TARGET%" %BRANCH%') do set COMMIT=%%i

if "%COMMIT%"=="" (
    echo [ERRO] Nenhum commit encontrado para a

@echo off
REM push-to-github-and-netlify.bat
REM Script para enviar automaticamente o projeto GameLux_2 para o GitHub e criar/deploy no Netlify

REM === Configuração ===
set REPO_URL=https://github.com/Mrgirao/GameLux_2.git
set SITE_NAME=gamelux-2

REM === Início do script ===
echo Iniciando publicação para %REPO_URL%

REM Inicializar repositório git
IF NOT EXIST .git (
    git init
)

REM Garantir branch principal como main
git branch -M main

REM Adicionar remote (ignorar erro se já existir)
git remote remove origin >nul 2>&1
git remote add origin %REPO_URL%

REM Adicionar ficheiros e commit
git add .
git commit -m "primeira versão GameLux pronta para Netlify"

REM Fazer push
git push -u origin main

echo ============================
echo Projeto enviado para %REPO_URL%
echo ============================

REM === Netlify Deploy ===
echo Fazendo build e deploy no Netlify...
npm install
npm run build

REM Criar site no Netlify se não existir
netlify sites:list | findstr /C:"%SITE_NAME%" >nul
IF %ERRORLEVEL% NEQ 0 (
    echo Site %SITE_NAME% nao encontrado. Criando novo...
    netlify sites:create --name %SITE_NAME%
)

REM Deploy usando CLI do Netlify (precisa estar instalada e autenticada)
netlify deploy --prod --dir=dist --site %SITE_NAME%

echo ============================
echo Deploy concluído! Verifica no Netlify o site %SITE_NAME%
echo ============================
pause

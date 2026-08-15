cd /opt/k8s-manifests

# Inicializa o Git no diretório atual (cria a pasta oculta .git)
git init

# Verifica o status para garantir que o Git reconheceu a pasta
git status

# Adiciona o link remoto do GitHub
git remote add origin https://github.com/fablicio/k8s-manifests-lab.git

# Prepara os arquivos, faz o commit e envia
git add .
git commit -m "chore: initial manifests structure"
git branch -M main
git push -u origin main
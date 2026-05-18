# dotfiles

> Configuração completa do meu ambiente de desenvolvimento WSL — do zero ao produtivo com um único comando.

---

## Por que este repositório existe

Toda vez que formatava o PC ou precisava configurar uma nova máquina, perdia horas (às vezes dias) reinstalando ferramentas, reconfigurando o terminal, recriando aliases e ajustando plugins. Sem falar nos detalhes pequenos que só lembramos quando fazem falta.

Este repositório resolve isso: é um snapshot versionado de todo o meu ambiente de desenvolvimento. Clonar e rodar `bash install.sh` é suficiente para ter tudo funcionando exatamente como antes.

Versionar as configurações no Git traz um benefício extra: qualquer mudança no `.zshrc` ou no Zellij fica registrada com histórico, mensagem e data — fácil de entender por que algo foi alterado ou reverter se necessário.

---

## O que está incluído

| Ferramenta | Função | Config |
|---|---|---|
| **Zsh + Oh My Zsh** | Shell principal com plugins | `zsh/.zshrc` |
| **Spaceship Prompt** | Tema do terminal com info de git e ambiente | via oh-my-zsh |
| **Zellij** | Multiplexer de terminal (divisão de telas) | `zellij/config.kdl` |
| **Miniforge** | Gerenciador de ambientes Python (conda + mamba) | via install.sh |
| **NVM** | Gerenciador de versões Node.js | via install.sh |
| **Git** | Configurações, aliases e cores | `git/.gitconfig` |
| **new-project** | Script para criar novos projetos com layout Zellij | `bin/new-project` |

---

## Estrutura do repositório

```
dotfiles/
├── install.sh              # Script principal — instala tudo e cria os symlinks
│
├── bin/
│   └── new-project         # Script para criação de novos projetos
│                           # (requer o repo dev-templates)
│
├── zsh/
│   └── .zshrc              # Plugins, aliases, funções,
│                           # integração com conda/mamba, nvm e vagrant
│
├── zellij/
│   └── config.kdl          # Keybindings, comportamento de sessões e plugins
│
└── git/
    └── .gitconfig          # Aliases, cores, editor, comportamento de pull/push
```

---

## Como funciona

### Symlinks em vez de cópia

O `install.sh` não copia os arquivos — ele cria **symlinks** (atalhos simbólicos):

```
~/.zshrc                    → ~/dotfiles/zsh/.zshrc
~/.config/zellij/config.kdl → ~/dotfiles/zellij/config.kdl
~/.gitconfig                → ~/dotfiles/git/.gitconfig
~/bin/*                     → ~/dotfiles/bin/*
```

**Por que isso importa:** qualquer edição no `~/.zshrc` está automaticamente editando o arquivo dentro do repo. Basta um `git commit` para versionar a mudança. Não há sincronização manual.

Se já existir um arquivo no destino, o script faz backup automático com extensão `.bak` antes de criar o symlink.

### O script `install.sh` passo a passo

1. Atualiza o `apt` e instala pacotes base (`zsh`, `git`, `curl`, `build-essential`, etc.)
2. Instala o **Oh My Zsh**
3. Instala o tema **Spaceship** e os plugins `zsh-autosuggestions` e `zsh-syntax-highlighting`
4. Instala o **Zellij** (versão mais recente via API do GitHub)
5. Instala o **Miniforge** (conda + mamba)
6. Instala o **NVM**
7. Cria todos os symlinks
8. Define o Zsh como shell padrão

---

## Instalação

**Pré-requisitos:** WSL 2 com Ubuntu 22.04+, git instalado, internet.

```bash
# 1. Clone o repositório
git clone https://github.com/SEU_USUARIO/dotfiles.git ~/dotfiles

# 2. Execute o instalador
cd ~/dotfiles && bash install.sh

# 3. Reinicie o shell
exec zsh
```

**Após instalar:**

```bash
# Coloque seu nome e email
vim ~/dotfiles/git/.gitconfig

# Clone os templates de projeto (opcional, mas recomendado)
git clone https://github.com/SEU_USUARIO/dev-templates.git ~/dev-templates
```

---

## Referência de aliases

### Navegação

| Alias | Comando |
|---|---|
| `proj` | `cd ~/projects` |
| `linuxlab` | `cd /mnt/c/vagrant-labs/701-702` |
| `dotfiles` | `cd ~/dotfiles` |
| `..` / `...` | `cd ..` / `cd ../..` |
| `ll` | `ls -lah --color=auto` |
| `reload` | `source ~/.zshrc` |

### Git

| Alias | Comando |
|---|---|
| `gs` | `git status` |
| `gl` | `git log --oneline --graph --decorate` |
| `gd` | `git diff` |
| `gco` | `git checkout` |
| `gcb` | `git checkout -b` |
| `gpl` / `gp` | `git pull` / `git push` |

### Conda / Python

| Alias/Função | O que faz |
|---|---|
| `ca nome` | `conda activate nome` |
| `cda` | `conda deactivate` |
| `cenv` | Lista todos os ambientes |
| `mkenv nome` | Cria ambiente conda Python 3.11 e ativa |

### Zellij

| Alias | O que faz |
|---|---|
| `zj` | Abre o Zellij |
| `zja` | Reconecta à sessão existente |
| `zjl` | Lista sessões ativas |

### Funções

| Função | Uso | O que faz |
|---|---|---|
| `mkcd` | `mkcd minha-pasta` | Cria a pasta e entra nela |
| `gcl` | `gcl https://repo.git` | `git clone` + `cd` na pasta |
| `myip` | `myip` | Mostra o IP do WSL |

---

## Fluxo de atualização

Como tudo são symlinks, editar e versionar é direto:

```bash
vim ~/.zshrc          # edita ~/dotfiles/zsh/.zshrc diretamente

cd ~/dotfiles
git add .
git commit -m "feat: adiciona alias para docker"
git push
```

---

## Roadmap

- [ ] Script `update.sh` para atualizar todas as ferramentas
- [ ] Configuração do Windows Terminal via PowerShell (fonte, cores)
- [ ] Suporte a macOS (brew no lugar do apt)
- [ ] Perfis separados (trabalho / pessoal)

---

## Relacionado

**[dev-templates](https://github.com/SEU_USUARIO/dev-templates)** — Templates de projeto usados pelo `new-project`

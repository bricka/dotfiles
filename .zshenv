export DENO_INSTALL="/home/abrick/.deno"
export PATH=~/bin:$DENO_INSTALL/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
[ -s "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

if [ -e ~/.workenv.zsh ]; then
    source ~/.workenv.zsh
fi

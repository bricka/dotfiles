export DENO_INSTALL="/home/abrick/.deno"
export PATH=~/bin:$DENO_INSTALL/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
which fnm &> /dev/null && eval $(fnm env)
[ -s "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

if [ -e ~/.workenv.zsh ]; then
    source ~/.workenv.zsh
fi

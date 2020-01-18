# Aliases related to git:

alias a='git gui' # This alias has been defined in zsh git plugin.
alias amsp="\
    git submodule update --remote --recursive \
    && git add --all \
    && git commit -m 'Update submodules' \
    && git push \
"

# Aliases related to latex:

alias tl="\
    python3 \
    /usr/local/texlive/2019/texmf-dist/scripts/texliveonfly/texliveonfly.py \
    --compiler=lualatex \
"
alias tp="\
    python3 \
    /usr/local/texlive/2019/texmf-dist/scripts/texliveonfly/texliveonfly.py \
    --compiler=pdflatex \
"
alias tx="python3 \
    /usr/local/texlive/2019/texmf-dist/scripts/texliveonfly/texliveonfly.py \
    --compiler=xelatex \
"

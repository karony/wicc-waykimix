# Managed by Chef on packer-5a26f3f3-4b65-3c91-579b-7cc9c3fb2e7f.c.eco-emissary-99515.internal! :heart_eyes_cat:
export PATH="$PATH:/opt/pyenv/bin"
export PYENV_ROOT="/opt/pyenv"
export PYTHON_CONFIGURE_OPTS="--enable-unicode=ucs4 --with-wide-unicode --enable-shared --enable-ipv6 --enable-loadable-sqlite-extensions --with-computed-gotos"
export PYTHON_CFLAGS="-g -fstack-protector --param=ssp-buffer-size=4 -Wformat -Werror=format-security"
eval "$(pyenv init -)"

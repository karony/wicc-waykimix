# Managed by Chef on packer-5a26f3f3-4b65-3c91-579b-7cc9c3fb2e7f.c.eco-emissary-99515.internal :heart:
if [[ -z "${PS1}" ]] ; then
  export PS1='$ '
fi

[[ -s /etc/profile ]] && source /etc/profile
[[ -s "${HOME}/.bashrc" ]] && source "${HOME}/.bashrc"

if [[ -d "${HOME}/.bash_profile.d" ]]; then
  for f in "${HOME}/.bash_profile.d/"*.bash; do
    if [[ -s "${f}" ]]; then
      source "${f}"
    fi
  done
fi

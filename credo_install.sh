#!/bin/bash
set -euo pipefail

REQ_FILE="/credo_env/requirements.txt"

echo "[setup] preparing /credo_env"
mkdir -p /credo_env
cd /credo_env

if [[ ! -f "$REQ_FILE" ]]; then
  echo "[error] requirements.txt non trovato in /credo_env"
  exit 1
fi

run_cmd() {
  echo "[credo] $*"
  "$@"
}

echo "[install] parsing requirements.txt"
# Formato atteso per ogni riga:
#   pip <package[==ver,...]>
#   cran <package>
#   bioc <package>           # Bioconductor
#   github <url|owner/repo@ref>
#   apt <pkg>                # opzionale
# Commenti con '#', righe vuote ignorate.

while IFS= read -r raw || [[ -n "${raw:-}" ]]; do
  # rimuovi commenti inline e trim
  line="${raw%%#*}"
  line="$(echo "$line" | sed 's/^[[:space:]]*//; s/[[:space:]]*$//')"
  [[ -z "$line" ]] && continue

  # backend = prima parola; arg = resto
  backend="$(echo "$line" | awk '{print $1}')"
  arg="$(echo "$line" | cut -d' ' -f2- )"

  # normalizza backend in minuscolo
  backend="$(echo "$backend" | tr '[:upper:]' '[:lower:]')"

  case "$backend" in
    pip)
      if [[ -z "$arg" ]]; then
        echo "[warn] riga pip senza argomento, salto: '$raw'"
        continue
      fi
      run_cmd credo pip $arg
      ;;
    cran)
      if [[ -z "$arg" ]]; then
        echo "[warn] riga cran senza argomento, salto: '$raw'"
        continue
      fi
      run_cmd credo cran $arg
      ;;
    bioc|bioconductor)
      if [[ -z "$arg" ]]; then
        echo "[warn] riga bioc senza argomento, salto: '$raw'"
        continue
      fi
      run_cmd credo bioc $arg
      ;;
    github)
      if [[ -z "$arg" ]]; then
        echo "[warn] riga github senza argomento, salto: '$raw'"
        continue
      fi
      # accetta sia URL completi sia owner/repo[@ref]
      run_cmd credo github "$arg"
      ;;
    apt|apt-get)
      if [[ -z "$arg" ]]; then
        echo "[warn] riga apt senza argomento, salto: '$raw'"
        continue
      fi
      # opzionale: pacchetti di sistema tramite CREDO (se supportato)
      run_cmd credo apt $arg
      ;;
    *)
      echo "[warn] backend non riconosciuto '$backend' nella riga: '$raw' — salto"
      ;;
  esac
done < "$REQ_FILE"

echo "[save] salvo lo stato dell’environment"
credo save
echo "[done] installazione completata"

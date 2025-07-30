SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ "$MSYSTEM" == "MINGW64" ]]; then
  theme_path="$SCRIPT_DIR/../oh-my-posh/themes/paulpe_rr.omp.json"
  eval "$(oh-my-posh init bash --config "$theme_path")"
fi

#!/usr/bin/env bash

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ "$MSYSTEM" == "MINGW64" ]]; then
  theme_path="$script_dir/../oh-my-posh/themes/paulpe_rr.omp.json"
  eval "$(oh-my-posh init bash --config "$theme_path")"
  PROMPT_COMMAND="${PROMPT_COMMAND};printf '\033[?25h'"
fi

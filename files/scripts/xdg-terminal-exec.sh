#!/usr/bin/env bash
set -euo pipefail

curl -sSL https://raw.githubusercontent.com/Vladimir-csp/xdg-terminal-exec/master/xdg-terminal-exec -o /usr/bin/xdg-terminal-exec
chmod +x /usr/bin/xdg-terminal-exec

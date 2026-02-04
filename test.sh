docker build -t mlc-action /Users/dionysislorentzos/Development/github/github-action-markdown-link-check

docker run --rm --name mlc-action -v "/Users/dionysislorentzos/Development/Projects/OWASP/mastg:/workspace" -w /workspace -e "GITHUB_ENV=/tmp/github_env" -e "GITHUB_OUTPUT=/tmp/github_output" mlc-action "yes" "yes" "/workspace/.github/workflows/config/url-checker-config.json" "." "-1" "no" "master" ".md" "" 2>&1 | tee /tmp/mlc-owasp-docker-output.txt

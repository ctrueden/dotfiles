test "$DEBUG" && echo "[dotfiles] Loading plugin 'ai'..."

# WARNING: While allowing all paths and tools broadly makes
# the assistants more autonomous, it also removes some of the
# safety and security guardrails in place. Use with caution.
alias cop='copilot --banner --allow-all-paths --allow-all-tools'
alias claude='claude --dangerously-skip-permissions'

if command -v aider >/dev/null 2>&1
then
  aid() {
    : << 'DOC'
Prompt user to choose a local Ollama model, then launch Aider with it.
DOC
    model=$1
    test "$model" || {
      models=$(ollama ls | cut -f1 -d' ' | grep -v '^NAME$')
      height=$(echo "$models" | wc -l | sed 's; ;;g')
      model=$({
        echo "SELECT MODEL:"
        echo "$models" | cut -f1 -d' '
      } | fzf -1 --height=$((height+3)) --header-lines=1 --layout=reverse-list)
    }
    test -z "$model" ||
      time aider --no-show-model-warnings --model ollama_chat/"$model"
  }
fi

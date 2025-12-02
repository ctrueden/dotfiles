test "$DEBUG" && echo "[dotfiles] Loading plugin 'ollama'..."

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

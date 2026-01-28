test "$DEBUG" && echo "[dotfiles] Loading plugin 'ai'..."

available() { command -v "$@" >/dev/null 2>&1; }
install_tool() {
  available "$1" || {
    echo "--> Installing $1..."
    npm install -g "$2";
  }
}

# Install AI coding assistant TUIs.
if available npm
then
  install_tool  copilot   @github/copilot
  #install_tool  claude    @anthropic-ai/claude-code
  install_tool  codex     @openai/codex
  install_tool  gemini    @google/gemini-cli
  #install_tool grok      @vibe-kit/grok-cli
  install_tool  crush     @charmland/crush
  install_tool  opencode  opencode-ai
  install_tool  kilocode  @kilocode/cli
  #install_tool nanocoder @nanocollective/nanocoder

  # WARNING: While allowing all paths and tools broadly makes
  # the assistants more autonomous, it also removes some of the
  # safety and security guardrails in place. Use with caution.
  alias cop='copilot --banner --allow-all-paths --allow-all-tools'
  alias claude='claude --dangerously-skip-permissions'
fi

if available aider
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

# WARNING: While allowing all paths and tools broadly makes
# the assistants more autonomous, it also removes some of the
# safety and security guardrails in place. Use with caution.
alias cop='copilot --banner --allow-all-paths --allow-all-tools'
alias claude='claude --dangerously-skip-permissions'

alias haiku='claude --model haiku'
alias sonnet='claude --model sonnet'
alias opus='claude --model opus'

alias q='qcode'
alias qlarge='q --tier large'
alias qmed='q --tier medium'
alias qsmall='q --tier small'
alias qsmart='q --tier smart'
alias qbal='q --tier balanced'
alias qfast='q --tier fast'
alias qflash='q --tier flash-large'
alias qflash64='q --tier flash-medium'

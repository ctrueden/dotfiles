# --== zsh command shortcuts ==--

# --== history ==--

# macOS zsh's `history` builtin ignores HISTTIMEFORMAT.
# Use -t for a custom strftime format (ISO8601 sortable: YYYY-MM-DD HH:MM:SS).
alias histime='history -t "%F %T"'

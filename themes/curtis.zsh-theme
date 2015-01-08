# Some ideas stolen from af-magic.zsh-theme
# Repo: https://github.com/andyfleming/oh-my-zsh
# Direct Link: https://github.com/andyfleming/oh-my-zsh/blob/master/themes/af-magic.zsh-theme

#if [ $UID -eq 0 ]; then NCOLOR="red"; else NCOLOR="green"; fi
#local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"

# colors
eval color_comment='$FG[237]' # dark gray
eval color_userhost='$fg_bold[green]'
eval color_path='$fg_bold[blue]'
eval color_prompt='$FG[214]' # orange
eval color_prompt2='$fg_no_bold[red]'
eval color_gitinfo='$fg_bold[yellow]'
eval color_virtualenv='$fg_bold[white]'
eval color_vimode='$fg_no_bold[white]'
eval color_exitcode='$fg_no_bold[red]'
eval color_timestamp='$fg_no_bold[yellow]'

# primary prompt
PROMPT='\
%{$color_comment%}:%{$reset_color%} \
%{$color_userhost%}%n@%m%{$reset_color%} \
%{$color_path%}%~%{$reset_color%}\
$(git_prompt_info) \
%{$color_prompt%}%(!.#.»)%{$reset_color%}
'

# secondary prompt
PROMPT2='%{$color_prompt2%}\ %{$reset_color%}'
#RPS1='${return_code}'

# right prompt
setopt interactivecomments
RPROMPT='\
%{$color_comment%}#%{$reset_color%} \
%{$color_vimode%}${${KEYMAP/vicmd/C}/(main|viins)/I}%{$reset_color%} \
%{$color_exitcode%}%?%{$reset_color%} \
%{$color_timestamp%}{%D{%Y-%m-%d} %*}%{$reset_color%}'

# virtualenv
if type "virtualenv_prompt_info" > /dev/null
then
	RPROMPT="%{$color_virtualenv%}$(virtualenv_prompt_info)%{$reset_color%} $RPROMPT"
fi

# git settings
ZSH_THEME_GIT_PROMPT_PREFIX="%{$color_gitinfo%} ("
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_DIRTY="*"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$color_gitinfo%})%{$reset_color%}"

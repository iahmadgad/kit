PS_Time=" 🕒 \[\033[0;33m\]\t\n"
PS_0="\[\e]0;\u@\h: \w\a\]\[\033[01;97m\]╭─ < Ahmad \[\033[0;97min \[\033[01;32m\]\w\n"
PS_1="\[\033[01;97m\]╰─ \[\033[01;97m\]>\[\033[00m\] "

SCM_THEME_PROMPT_PREFIX="\[\033[0;97m  ${normal?}"
SCM_THEME_PROMPT_SUFFIX=""
SCM_THEME_PROMPT_DIRTY=" ${red?}✗"
SCM_THEME_PROMPT_CLEAN=" ${bold_green?}✓"

# prompt command
make_prompt()
{
    PS1=$PS_0
    PS1+="\[\033[01;97m├─"
    PS1+="\[\033[0m$(scm_prompt_info)"
    PS1+=$PS_Time
    PS1+=$PS_1
}

PROMPT_COMMAND=make_prompt

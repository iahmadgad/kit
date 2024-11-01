PS_Time="\[\033[01;97m🕒 \[\033[0;33m\]\t\[\033[0m\n"
PS_0="\[\e]0;\u@\h: \w\a\]\[\033[01;97m\]⌠\[\033[01;38;5;48m\]\u@\h\[\033[0;97m\] in \[\033[01;38;5;48m\]\w\n"
PS_1="\[\033[01;97m\]⌡\[\033[01;38;2;23;147;209m\]Λ\[\033[00m\] "

# prompt command
make_prompt()
{
    PS1=$PS_0
    PS1+="\[\033[01;97m│"
    if git rev-parse --is-inside-work-tree > /dev/null 2>&1
    then
        PS1+="\$(git branch 2>/dev/null | grep -e '\* ' | sed 's/^..\(.*\)/\\033[0;97m \\033[38;5;45m\1/') "
    fi
    PS1+=$PS_Time
    PS1+=$PS_1
}

setps1()
{
    PS_1="\[\033[01;97m\]⌡\[\033[[38;5;4m\]$1\[\033[00m\] "
}


PROMPT_COMMAND=make_prompt

PROMPT_DIRTRIM=2

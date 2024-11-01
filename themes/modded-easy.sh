# shellcheck shell=bash
# shellcheck disable=SC2034 # Expected behavior for themes.

SCM_THEME_PROMPT_PREFIX=""
SCM_THEME_PROMPT_SUFFIX=" "
SCM_THEME_PROMPT_DIRTY=" ${red?}✗"
SCM_THEME_PROMPT_CLEAN=" ${bold_green?}✓"

function prompt_command() {
	local scm_prompt_info
	if [ "${USER:-${LOGNAME?}}" = root ]; then
		cursor_color="${bold_red?}"
		user_color="\033[38;5;196m"
	else
		cursor_color="${bold_green?}"
		user_color="${cyan?}"
	fi
	scm_prompt_info="$(scm_prompt_info)"
	PS1="\[\e]0;\u@\h: \w\a\]${user_color}\u@\h ${bold_black?}\w\n${reset_color?}${scm_prompt_info}${cursor_color}λ ${normal?}"
}

safe_append_prompt_command prompt_command

source ~/.local/state/zoxide.nu
$env.config.show_banner = false

def lean_prompt [] {
    $"(ansi blue)% (ansi reset)"
}

def lean_prompt_right [] {
    # Get last command execution time (convert from ms to readable format)
    let elapsed_raw = ($env.CMD_DURATION_MS | default 0 | into int)
    let elapsed = if $elapsed_raw < 1000 {
        ""
    } else {
        let seconds = ($elapsed_raw / 1000) | into int
        if $seconds < 60 {
            $"($seconds)s"
        } else {
            let minutes = ($seconds / 60) | into int
            let remaining_seconds = ($seconds mod 60)
            if $remaining_seconds == 0 {
                $"($minutes)m"
            } else {
                $"($minutes)m ($remaining_seconds)s"
            }
        }
    }

    # Get full directory path, replacing home with ~
    let pwd = (pwd | path expand | str replace $nu.home-path "~")

    # Get Git branch (or empty if not in a repo)
    let git_branch = git rev-parse --abbrev-ref HEAD | complete | get stdout | str trim | default ""

    # Check for uncommitted changes (Git status)
    let git_status = if ($git_branch != "") {
        let dirty = (do -i { git status --porcelain } | complete | get stdout | str trim)
        if ($dirty != "") { "+" } else { "" }
    } else { "" }

    # Define ANSI colors
    let color_reset = (ansi reset)
    let color_blue = (ansi blue)
    let color_git = (ansi black_dimmed)  # Light grey for Git status

    # Construct directory + Git status formatting
    let dir_git = if $git_branch == "" {
        $"($color_blue)($pwd)($color_reset)"
    } else {
        $"($color_blue)($pwd) ($color_git)($git_branch)($git_status)($color_reset)"
    }

    # Construct the final right-aligned prompt
    if $elapsed == "" {
        $dir_git
    } else {
        $"($color_git)($elapsed) ($dir_git)"
    }
}

# Set the prompt commands
$env.PROMPT_COMMAND = { lean_prompt }
$env.PROMPT_COMMAND_RIGHT = { lean_prompt_right }
$env.PROMPT_INDICATOR = ""

$env.config = ($env.config | upsert keybindings [
    { name: "open_command_editor", mode: ["emacs"], modifier: "control", keycode: char_x, event: { send: openeditor } }
])

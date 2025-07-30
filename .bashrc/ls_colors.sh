# Color configuration for `ls --color`
LS_COLORS=""

# --- Base file types ---
# di = directory (bold blue)
LS_COLORS="$LS_COLORS:di=1;34"
# fi = regular file (light gray)
LS_COLORS="$LS_COLORS:fi=0;37"
# ln = symbolic link (cyan)
LS_COLORS="$LS_COLORS:ln=36"
# or = broken symlink (red)
LS_COLORS="$LS_COLORS:or=31"
# ex = executable (bold green)
LS_COLORS="$LS_COLORS:ex=1;32"

# --- Special devices ---
# bd = block device (bold yellow)
LS_COLORS="$LS_COLORS:bd=1;33"
# cd = character device (bold yellow)
LS_COLORS="$LS_COLORS:cd=1;33"
# so = socket (magenta)
LS_COLORS="$LS_COLORS:so=35"
# pi = named pipe (yellow)
LS_COLORS="$LS_COLORS:pi=33"
# mi = missing file (no color)
LS_COLORS="$LS_COLORS:mi=0"

# --- Archives (red) ---
LS_COLORS="$LS_COLORS:*.tar=1;31:*.tgz=1;31:*.zip=1;31:*.gz=1;31:*.bz2=1;31:*.xz=1;31:*.deb=1;31:*.rpm=1;31"

# --- Images (magenta) ---
LS_COLORS="$LS_COLORS:*.jpg=1;35:*.jpeg=1;35:*.png=1;35:*.gif=1;35"

# --- Videos (cyan) ---
LS_COLORS="$LS_COLORS:*.mp4=1;36:*.mkv=1;36:*.avi=1;36"

# --- Audio (yellow) ---
LS_COLORS="$LS_COLORS:*.mp3=1;33:*.wav=1;33:*.flac=1;33"

# --- Code files ---
LS_COLORS="$LS_COLORS:*.sh=1;32:*.js=1;33:*.ts=1;33:*.json=0;36:*.md=1;37"

export LS_COLORS

alias ls='ls --color=auto'
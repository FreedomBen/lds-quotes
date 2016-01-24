#!/bin/bash

UNINSTALLED_QUOTES_FILE='lds-quotes-file.txt'
INSTALLED_QUOTES_FILE="${HOME}/.lds-quotes-file"

PRE_LINE_CHECK="Added by lds quotes"
POST_LINE_CHECK="Done by lds quotes"

die ()
{
    echo "[Error]: $1"
    exit 1
}

runningRedHat()
{
    uname -r | grep "el" > /dev/null
}

runningFedora ()
{
    if $(which lsb_release >/dev/null 2>&1); then
        lsb_release -d | grep --color=auto "Fedora" > /dev/null
    else
        uname -r | grep --color=auto "fc" > /dev/null
    fi
}

runningUbuntu ()
{
    if $(which lsb_release >/dev/null 2>&1); then
        lsb_release -d | grep --color=auto "Ubuntu" > /dev/null
    else
        uname -a | grep --color=auto "Ubuntu" > /dev/null
    fi
}

runningArch ()
{
    if $(which lsb_release >/dev/null 2>&1); then
        lsb_release -d | grep --color=auto "Arch" > /dev/null
    else
        uname -a | grep --color=auto "ARCH" > /dev/null
    fi
}

runningMint ()
{
    if $(which lsb_release >/dev/null 2>&1); then
        lsb_release -d | grep --color=auto "Mint" > /dev/null
    else
        uname -a | grep --color=auto "Ubuntu" > /dev/null
    fi
}

runningOSX()
{
    uname -a | grep "Darwin" > /dev/null
}

check_brew ()
{
    $(which brew >/dev/null 2>&1) || die "Homebrew is required"
}

install_cowsay ()
{
    if ! $(which cowsay >/dev/null 2>&1); then
        if runningArch; then
            sudo pacman -S --needed --noconfirm cowsay
        elif runningUbuntu || runningMint; then
            sudo apt-get install cowsay
        elif runningFedora || runningRedHat; then
            sudo dnf install cowsay
        elif runningOSX; then
            check_brew
            brew install cowsay
        fi
    fi
}

install_shuf ()
{
    if ! $(which shuf >/dev/null 2>&1); then
        if runningArch; then
            sudo pacman -S --needed --noconfirm shuf
        elif runningUbuntu || runningMint; then
            sudo apt-get install shuf
        elif runningFedora || runningRedHat; then
            sudo dnf install shuf
        fi
    fi
}

install_quotes_files ()
{
    [ -f "$UNINSTALLED_QUOTES_FILE" ] || die "Cannot find the lds quotes files ($UNINSTALLED_QUOTES_FILE)"

    cp "$UNINSTALLED_QUOTES_FILE" "$INSTALLED_QUOTES_FILE"
}

in_bashrc ()
{
    while read line; do
      if [[ $line =~ $PRE_LINE_CHECK ]]; then
        return 0
      fi
    done < $HOME/.bashrc
    return 1
}

append_to_bashrc ()
{
    if ! in_bashrc; then
        cat << "__EOF__" >> $HOME/.bashrc

# Added by lds quotes
LDS_QUOTES_FILE="$HOME/.lds-quotes-file"

lds-quote ()
{
    if [ -f "$LDS_QUOTES_FILE" ] && $(which cowsay >/dev/null 2>&1) && $(which shuf >/dev/null 2>&1); then
        cat "$LDS_QUOTES_FILE" | shuf -n1 | cowsay
    elif [ -f "$LDS_QUOTES_FILE" ] && $(which shuf >/dev/null 2>&1); then
        cat "$LDS_QUOTES_FILE" | shuf -n1
    fi
}
lds-quote
# Done by lds quotes
__EOF__
    fi
}

clean_bashrc ()
{
    sed -i -e "/$PRE_LINE_CHECK/,/$POST_LINE_CHECK/d" ~/.bashrc
}

if [ -n "$1" ] && [[ "$1" =~ [-u] ]]; then
    echo "Uninstalling LDS Quotes"
    [ -f "$INSTALLED_QUOTES_FILE" ] && rm "$INSTALLED_QUOTES_FILE"
    clean_bashrc
    echo "Done.  LDS Quotes is now uninstalled"
else
    echo "Installing LDS Quotes"
    echo "Installing cowsay if necessary"
    install_cowsay || echo "Cowsay is unavailable so the quotes will be printed without it"
    echo "Installing shuf if necessary"
    install_shuf || {
        echo "Could not install shuf.  We gotta have that"
    }
    echo "Installing quotes files"
    install_quotes_files
    echo "Adding stuff to bottom of bashrc"
    append_to_bashrc
    echo "Done.  LDS Quotes is now uninstalled"
fi

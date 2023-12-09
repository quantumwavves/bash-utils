#!/bin/bash
#Utilities for bash v.0.1

#-----------------------------#
#Regular colors
white='\033[0m'
red='\033[0;31m'
green='\e[0;32m'
cyan='\033[0;96m'
orange='\e[0;33m'
blue='\e[0;34m'
purple='\e[0;35m'

#Bold colors

bred='\033[1;31m'
bgreen='\e[1;32m'
bcyan='\033[1;96m'
borange='\e[1;33m'
bblue='\e[1;34m'
bpurple='\e[1;35m'

#-----------------------------#
get_os()
{
  get_dist=`lsb_release -d | cut -f 2- | awk '{print $1}'`
  case "$get_dist" in
    Arch)
      package_helper="pacman"
    ;;
    Debian)
      package_helper="apt"
    ;;
    Fedora)
      package_helper="dnf"
    ;;
  esac
}

gen_key_ssh()
{
  echo -e "${red}[+] Do you want to configure the name and email for git? (y/n)${white}"
  echo -e "${orange}[*] Yes only for new installation of git${white}"
  read -p "[?] Your option: " cfg_git_flag
  if [[ $cfg_git_flag = "y" ]]; then
    read -p "[?] Enter your name: " name 
    read -p "[?] Enter your email: " email
    echo -e "[-] Set name in global config for git..."
    git config --global user.name $name
    echo -e "${green}[-] Done.${white}"
    echo "[-] Set email in global config for git..."
    git config --global user.email $email
    echo -e "${green}[-] Done.${white}"
  fi 
  echo -e "${red}[+] Do you want set name to ssh key? (y/n)${white}"
  echo -e "${orange}[-] Default name for key is id_rsa${white}}"
  read -p "[?] Your option: " ssh_name_flag
  if [[ $ssh_name_flag = "y" ]]; then
    read -p "[?] Choose the name for ssh key: " key_name
    read -p "[*] Set email for key: " key_email
    echo -e "${cyan}[+] Generate ssh key...${white}"
    ssh-keygen -t rsa -b 4096 -C $key_email -f $HOME/.ssh/$key_name
    echo -e "[-] Adding SSH-Key to ssh-agent"
    eval $(ssh-agent -s)
    ssh-add $HOME/.ssh/$key_name
    echo -e "${red}Don't forget to add the id_rsa.pub to https://github.com/settings/keys${white}"
    echo -e "${cyan}"
    cat ~/.ssh/$key_name.pub
    echo -e "${white}"
  else
    read -p "[*] Set email for key: " key_email
    echo -e "${cyan}[+] Generate ssh key...${white}"
    ssh-keygen -t rsa -b 4096 -C $key_email -f $HOME/.ssh/id_rsa
    echo -e "[-] Adding SSH-Key to ssh-agent"
    eval $(ssh-agent -s)
    ssh-add $HOME/.ssh/id_rsa
    echo -e "${red}Don't forget to add the id_rsa.pub to https://github.com/settings/keys${white}"
    echo -e "${cyan}"
    cat ~/.ssh/id_rsa.pub
    echo -e "${white}"
  fi
 }

optimize_images()
{
  if [[ -a /usr/bin/mogrify ]]; then
    echo -e "${green}[*] Select directory of images, example (/home/user/images)${white}"
    read -p "[?] Write path of directory with images: " image_path
    echo -e "${orange}[-] Convert png,jpg,jpeg files to webp${white}"
    echo $image_path
    find $image_path -type f -regex ".*\.\(jpg\|jpeg\|png\)" -exec mogrify -format webp {}  \; -print
    echo -e "${red}[!] Do you want remove original files? (y/n)${white}"
    read -p "[?] Your option: " rm_files
    if [[ $rm_files = "y" ]]; then
      find $image_path -type f -regex ".*\.\(jpg\|jpeg\|png\)" -exec rm {}  \; -print 
    else
      echo -e "${green}[-] Preserving the original files${white}"
    fi 
  else
    sudo pacman -S imagemagick --noconfirm  
  fi

}

menu(){
  echo -e "+---------------------------------------------------------------------------------+"
  echo -e "|                                                                                 |"
  echo -e "|    ${cyan}██████${blue}╗${cyan}  █████${blue}╗${cyan} ███████${blue}╗${cyan}██${blue}╗${cyan}  ██${blue}╗${cyan}    ██${blue}╗${cyan}   ██${blue}╗${cyan}████████${blue}╗${cyan}██${blue}╗${cyan}██${blue}╗${cyan}     ███████${blue}╗${cyan}${white}    |"
  echo -e "|    ${cyan}██${blue}╔══${cyan}██${blue}╗${cyan}██${blue}╔══${cyan}██${blue}╗${cyan}██${blue}╔════╝${cyan}██${blue}║${cyan}  ██${blue}║${cyan}    ██${blue}║${cyan}   ██${blue}║╚══${cyan}██${blue}╔══╝${cyan}██${blue}║${cyan}██${blue}║${cyan}     ██${blue}╔════╝${white}    |"
  echo -e "|    ${cyan}██████${blue}╔╝${cyan}███████${blue}║${cyan}███████${blue}╗${cyan}███████${blue}║${cyan}    ██${blue}║${cyan}   ██${blue}║${cyan}   ██${blue}║${cyan}   ██${blue}║${cyan}██${blue}║${cyan}     ███████${blue}╗${white}    |"
  echo -e "|    ${cyan}██${blue}╔══${cyan}██${blue}╗${cyan}██${blue}╔══${cyan}██${blue}║╚════${cyan}██${blue}║${cyan}██${blue}╔══${cyan}██${blue}║${blue}    ${cyan}██${blue}║${cyan}   ██${blue}║   ${cyan}██${blue}║${cyan}   ██${blue}║${cyan}██${blue}║     ╚════${cyan}██${blue}║${white}    |"
  echo -e "|    ${cyan}██████${blue}╔╝${cyan}██${blue}║${cyan}  ██${blue}║${cyan}███████${blue}║${cyan}██${blue}║${cyan}  ██${blue}║    ╚${cyan}██████${blue}╔╝${cyan}   ██${blue}║${cyan}   ██${blue}║${cyan}███████${blue}╗${cyan}███████${blue}║${white}    |"
  echo -e "|    ${blue}╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝     ╚═════╝    ╚═╝   ╚═╝╚══════╝╚══════╝${white}    |"
  echo -e "|           Docs: ${cyan}https://quantumwavves.github.io/projects/bash-utils${white}             |"
  echo -e "+---------------------------------------------------------------------------------+"
  echo
  echo -e "${white}                        Welcome to bash utils (=^.^=).              ${white}"
  echo -e "${bcyan}                             By QuantumWavves                        ${white}"
  echo
  echo
  echo -e "System: ${bgreen}$get_dist Linux${white}"
  echo -e "${red}[0]${white} Exit"
  echo -e "$cyan[1]$white Generate ssh key"
  echo -e "$cyan[2]$white Optimize images" 
  echo 
  read -p "[?] Enter value: " option
  
  case "$option" in
    1) gen_key_ssh
    ;;
    2) optimize_images
    ;;
    0)
      return 0
    ;;
  esac
}

get_os
menu

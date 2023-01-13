# cs-tools

This repository contains various configuration files, shell scripts, shortcuts, and little tools that help me do various things. I clone this repo to all of my machines, and add the appropriate directories to my path to access all the tools easily.

### Table of Contents
`configs`:
  * `bashrc` & `zshrc`: My shell configuration files.
  * `vimrc`: My Vim configuration file, copied to every machine.

`scripts-*`:
  * `einstein`: A shortcut to SSH into my desktop
  * `gitacp`: A shortcut to add, commit, and push a given file and commit message with `git`.
  * `new_c`: A shortcut to create a new, .c file with the standard include statements and open it in Vim.
  * `uclinux`: A shortcut to SSH into the UChicago CS Linux server.
  * `grade`: A script formerly used for moving student files and adding tests for homework grading.

`tools`:
  * `Makefile`: Makefile shortcut to build `bytes` and `ishow` utility binaries.
  * `bytes.c`: Source code for utility that displays a file byte by byte.
  * `ishow.c`: Source code for utility that displays a given number in multiple integer formats.
  * Boot files: Scripts to edit EFI variables to allow for a convenient terminal/desktop shortcut to reboot from Linux to Windows or Windows to Linux on my desktop (using rEFInd as a boot manager to dualboot Windows 10 and Ubuntu).
    * The boot-to-{OS} scripts are taken from https://gist.github.com/Darkhogg/82a651f40f835196df3b1bd1362f5b8c and https://gist.github.com/meatcar/907d07918b4e184405e62a39bb295f99. These were essentially ready to use, although I created small shortcut wrappers for each (boot to Windows and boot to Ubuntu).

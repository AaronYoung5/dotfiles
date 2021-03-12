# Dotfiles

My personal dotfiles. I've created a simple and configurable system I can use across different computers and different platforms. In creating these dotfiles, my strategy was to not rely on too many packages, but still have a really intuitive and visual appealing interface.

_A dotfile is simply a file that is preceded by a ".". Ex: `.zshrc`. On Unix based systems, dotfiles are "hidden" and are not typically seen via file explorers or simple `ls` commands. In addtion, dotfiles commonly carry configurations for the command line._

## Philosophy

The philosophy used herein imploys three general ideas:

1. A single dotfile should have a single purpose
2. Configurations specific to a computer should not conflict with other systems
3. Separation of different working environments is encouraged

Furthermore, `zsh` is the used shell. As I began to learn the command line and how to configure my shell environment, I was on a Mac. The default shell, beginning in early 2019, is `zsh`. The only other shell I've used extensively is `bash`, and I found it is not as configurable as `zsh`. 

To faciliate plugin management and provide a better user experience, [oh-my-zsh](https://ohmyz.sh/) and [zgen](https://github.com/tarjoilija/zgen) are used.

## General structure

In this repository, there are four types of files:

1. `zsh` configuration files
2. `vim` configuration files
3. `tmux` configuration files
4. dotfile setup/helper files

### Zsh configuration files

The `zsh` configuration files discussed in this section are the files prefixed with `.zsh...`. Ex: `.zshrc` and `.zsh_functions.user`.

To configure `zsh` as I please, as item 1 of my philosophy outlines, each file as one purpose. There are four general categories to my `zsh` files:

1. `rc`
	- Holds prompt level configurations; kind of the "leader"
	- Ex: oh-my-zsh/zgen setup, plugin install, sourcing all other files below
2. `_aliases`
	- Holds aliases
3. `_exports`
	- Holds any exports needed when the prompt loads
4. `_functions`
	- Additional helper functions I may want

### Vim configuration files

As off early February, 2021, I use [`vim`](https://www.vim.org/) as my main editor. I've experimented with different configurations. These include all files beginning with `.vimrc`.

### Tmux configuration files

I like to use [`tmux`](https://github.com/tmux/tmux/wiki) almost always when using the command line. It allows me to separate different working environments (see philosophy #3) and maintain multiple active shells without multiple terminal windows or tabs. Configurations are helpd in all files beginning with `.tmux.conf`.

### Dotfile setup/helper files

These files are include the keyword `exclude`. These files help setup or tear down my dotfiles on new computers. Currently, there are five different setup/helper files:

1. `bootstrap.exclude.sh`
	- The main setup file that links all dotfiles on a new system (see [installation](#installation))
2. `bootstrap.user.exclude.sh`
	- The setup file the links files for a new pseudouser (see [psuedouser](#psuedousers))
3. `reset.eclude.sh`
	- **Use with caution**, deletes all `zsh` related files
	- Saves backups of all dotfiles in a directory named `backups`
4. `setup_pseudouser.exclude.sh`
	- Creates a new pseudouser (see [pseudouser](#pseudousers))
5. `update.exclude.sh`
	- An automated script called in `.zshrc` (unless `DISABLE_AUTO_UPDATE` is set to 'true')
	- Checks at some fixed rate whether my dotfiles in this repo have been updated, (updates if necessary)

## General concepts

Conceptually, my `zsh` configuration dotfiles are organized into three groups:

1. No suffix
	- General configurations common across _all_ computers
2. `.local`
	- Local configurations that are system wide
	- Anything that is specific to the current computer and not to other ones (See philosophy #2)
3. `.user`
	- Pseudouser specific configurations
	- Only read when a pseudouser is active

### Pseudousers

For the purpose of following philosophy #3, I tried to implement a way to separate different work environments in a clean and efficient manner. By "different work environments", I mean separate activities I'm involved in; for example, `School`, `Work`, `Personal` may be different pseudousers. These pseudousers share the system and share global configurations, but are separate from each other. In a way, each pseudouser doesn't know about any other pseudouser, with it's own `USER_HOME` directory. Furthermore, each pseudouser lives inside a `tmux` session. By this, I mean that to activate/enter a pseudouser, an alias will be created that enters a `tmux` session named similar to the pseudouser and changes the directory to be insider `USER_HOME`.

Each psuedouser has a `USER_HOME` directory that holds it's personal dotfiles and any files specific to that pseudouser. The `setup_pseudouser.exclude.sh` script will create a pseudouser with a specified `USER_HOME` directory and add some local aliases to quickly enter a pseudouser. There is also a function in `zsh_functions` named `create-psuedo-user` that can be called with the name and alias for the psuedouser and will automatically call the setup script.

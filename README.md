# How to setup this script for your Mac.

This script assumes that you're using the zsh in your Terminal and that you have Homebrew, npm, VS Code, & Docker installed on your system.  If these items are not yet installed, see "Install Necessary Apps" below.  This script will attempt to update Homebrew and npm prior to building your project, as well as open VS Code and Docker, so if you don't already have all of these programs installed it will give you errors.

## How to make this work:

1. Place the script in your home folder.
- This is makes the assumption that when you open Terminal, that's where you are.  That being said, if your Terminal opens elsewhere, or you like navigating to your projects folder first, put this script where you'll most likely be when you want to use it.
2. Open the script in either TextEdit or VS Code.
3. Change the path to the directory where you keep all of your projects on lines 11, 12, & 18.
4. Save and quit.

### Make it run.

Each time you want to run the script, ensure that you're in your home folder and enter the following into your Terminal:

```bash
./fullstack.zsh
```
After it updates Homebrew and npm, it will ask you what you want your project to be called.  Type in whatever name you want to give it and press return.

### Install Necessary Apps

In order for everything to work, there are some things that need to be installed first.  I recommend following this list in order below.

- Install Command Line Tools for Xcode
```bash
sudo xcode-select --install
```
- Install [Homebrew](https://brew.sh)
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
- Install npm:
```bash
npm install -g npm@11.2.0
```
- Install [VSCode](https://code.visualstudio.com/download)
- Install [Docker](https://www.docker.com)

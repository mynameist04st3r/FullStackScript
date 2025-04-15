# How to setup this script for your Mac.

This script assumes that you're using the zsh in your Terminal and that you have Homebrew, npm, VS Code, & Docker installed on your system.  If these items are not yet installed, see <span style="color:green">"Install Necessary Apps"</span> below.  This script will attempt to update Homebrew and npm prior to building your project, as well as open VS Code and Docker.  So, if you don't already have all of these programs installed, it will give you errors.

## <span style="color:yellow">How to make this work:</span>

1. Place the script in your home folder.
  - This is making the assumption that when you open Terminal, you are in your home folder.  That being said, if your Terminal opens elsewhere, or you like navigating to your projects folder first, put this script where you'll most likely be when you want to use it.
  - Another option would be to right click (control+click) on the file and select "Get Info".  Once the info window opens, click on the pull down menu under "Open with:", click "Other…" at the bottom of the list, click on "Recommended Applications" and change it to "All Applications".  Then scroll down to "Utilities" in the Applications folder.  Then in the Utilities folder, scroll down to Terminal, select it and click "Add".  Then you can drag the script to your dock and just click on it to start the script and create a new full stack app.
2. Open the script in either TextEdit, VS Code, or Xcode.
3. Change the path to the directory where you keep all of your projects on lines <u>**13**</u>, <u>**14**</u>, & <u>**24**</u>.
4. Save and quit.
5. Enter the following into your terminal to make the script executable (make sure that fullstack.zsh is in your current working directory):
```bash
chmod +x fullstack.zsh
```
6. Make sure that you have deleted all Postgresql tables and images and close Docker.
- Open your terminal and enter the following:
```bash
docker ps -a
```
- If you have anything listed, copy the number in the CONTAINER ID column and paste it after the following code:
```bash
docker stop <paste here>
```
- (If your container was designed to delete itself once it has been stopped, the following command will result in a terminal message that it doesn't exist when you enter the next command.)
```bash
docker rm <paste here>
```
- If you have more than one listed, keep going until they're all gone.
- Once all of your containers are gone, you need to delete any and all images.  Do the following:
```bash
docker images -a
```
- Then copy the name of the image and paste it after the following code:
```bash
docker rmi <paste here>
```
- If you have more than one image, keep going until they're all gone.

## <span style="color:orange">Make it run</span>

Each time you want to run the script, follow step <u>**5**</u> in the previous section (<span style="color:yellow">How to make this work</span>) and ensure that you're in your home folder and enter the following into your Terminal:

```bash
./fullstack.zsh
```
After it updates Homebrew and npm, it will ask you what you want your project to be called.  Type in whatever name you want to give it and press return. To avoid issues with naming conflicts, make your project name all <u>**one word**</u>, <u>**lowercase**</u>, <u>**no special characters**</u>.

### <span style="color:green">Install Necessary Apps</span>

In order for everything to work, there are some things that need to be installed first.  I recommend following this list in order below.

- Install Command Line Tools for Xcode
```bash
sudo xcode-select --install
```
- Install [Homebrew](https://brew.sh)
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
- Install nvm (use [this link](https://github.com/nvm-sh/nvm?tab=readme-ov-file#installing-and-updating) to make sure you get the latest version, the version in the code below is current as of this writing):
```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.2/install.sh | bash
```
- Install npm:
```bash
npm install -g npm@11.2.0
```
- Install [VSCode](https://code.visualstudio.com/download)
- Install [Docker](https://www.docker.com)

### List of installed packages
Listed below are all of the packages that are installed when you run this script to set up your project.  It's basically ready to go for just about any type of project that you would want to build (as far as I know, anyway. At the time of this writing, I've only been doing this for a couple of months).  Hopefully, you will find everything that you might need to build whatever you want.
#### Server side
- npm
- knex
- pg
- nodemon
- express
- express-session
- cors
- dotenv
- uuid
- @uswriting/bcrypt
- @faker-js/faker

#### Client side
- npm
- Vite React
  - react
  - react-dom
  - react-router-dom
  - react-dnd
  - react-dnd-html5-backend
- Vitest
  - jsdom
  - @testing-library/react
  - @testing-library/jest-dom
- MUI
  - @mui/material
  - @mui/icons-material
- @emotion-js
  - @emotion/react
  - @emotion/styled
- chroma-js
- axios

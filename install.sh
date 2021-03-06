set -ex
mkdir -p $HOME/workspace/jupyter

cp zshrc ~/.zshrc
cp bashrc ~/.bashrc
cp gitignore ~/.gitignore
cp gitconfig ~/.gitconfig
cp pdbrc ~/.pdbrc
cp pypirc ~/.pypirc
cp condarc ~/.condarc
cp jupyterhub_config.py ~/workspace

if [[ "${unameOut}" == MINGW* ]]; then
  code="$HOME/AppData/Roaming/Code/User"
  cp keybindings.json $code
  cp vscode_settings.json $code/settings.json
fi

source ~/.bashrc
conda install -y -c conda-forge jupyter nodejs scipy matplotlib pytest twine
ipython profile create
cp ipython_startup.py ~/.ipython/profile_default/startup/

ln -si $(pwd)/zshenv ~/.zshenv
ln -si $(pwd)/zshrc ~/.zshrc
ln -si $(pwd)/zprofile ~/.zprofile


# Vimfiles
# TODO 冪等性が担保されていない(2回目の実行時に循環的な参照を作成してしまう）
ln -si $(pwd)/vimfiles/vimrc ~/.config/nvim/init.vim
ln -si $(pwd)/vimfiles/dein/dein.toml ~/.config/nvim/dein.toml
ln -si $(pwd)/vimfiles/dein/dein_lazy.toml ~/.config/nvim/dein_lazy.toml
ln -si $(pwd)/vimfiles/autoload ~/.config/nvim/autoload
ln -si $(pwd)/vimfiles/plugin ~/.config/nvim/plugin

ln -si $(pwd)/tmux.conf ~/.tmux.conf
ln -si $(pwd)/slate ~/.slate
ln -si $(pwd)/tigrc ~/.tigrc
ln -si $(pwd)/peco.json ~/.config/peco/config.json
ln -si $(pwd)/tigrc ~/.config/tig/config

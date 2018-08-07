pkg install -y vim-python wget git gdb lldb ncdu htop mc tree openssh

if [ ! -e ~/setup-pointless-repo.sh ]; then
	$PREFIX/bin/wget https://its-pointless.github.io/setup-pointless-repo.sh
	bash setup-pointless-repo.sh
fi

pkg install -y rustc cargo rust-docs rust-rls rustfmt \
	rust-std-wasm32-unknown-unknown

if [ ! -e ~/.profile ]; then
	echo no profile finded - creating
	cat > ~/.profile << EOF
export USER="user"
export PATH="\$HOME/.cargo/bin:\$PATH"
export RUST_SRC_PATH=\$HOME/rust/src/src
EOF
fi

if ! grep "set bell-style none" $PREFIX/etc/inputrc; then
	cat >> $PREFIX/etc/inputrc << EOF
set bell-style none
"\e[5~": history-search-backward
"\e[6~": history-search-forward
EOF
fi

if [ ! -e ~/.vimrc ]; then
	mkdir -p ~/.vim/bundle

	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

	cat > ~/.vim/plugins.vim << EOF
set rtp+=~/.vim/bundle/Vundle.vim

call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'airblade/vim-gitgutter'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'itchyny/lightline.vim'
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'
Plugin 'mattn/emmet-vim'
Plugin 'scrooloose/nerdtree'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'tpope/vim-eunuch'
Plugin 'tpope/vim-surround'
Plugin 'rust-lang/rust.vim'
Plugin 'prabirshrestha/async.vim'
Plugin 'prabirshrestha/vim-lsp'
Plugin 'prabirshrestha/asyncomplete.vim'
Plugin 'prabirshrestha/asyncomplete-lsp.vim'
Plugin 'w0rp/ale'
call vundle#end()

filetype plugin indent on
EOF
	cat >> ~/.vimrc << EOF
so ~/.vim/plugins.vim
set encoding=utf-8

if executable('rls')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'rls',
        \ 'cmd': {server_info->['rls']},
        \ 'whitelist': ['rust'],
        \ })
endif
EOF
fi

RUST_VERSION=`rustc --version | cut -f2 -d" "`
if [ ! -e ~/rust/rustc-${RUST_VERSION}-src ]; then
	mkdir -p ~/rust
	cd ~/rust
	wget https://static.rust-lang.org/dist/rustc-${RUST_VERSION}-src.tar.gz
	tar xvf rustc-${RUST_VERSION}-src.tar.gz
	if [ -e src ]; then rm src; fi
	ln -s rustc-${RUST_VERSION}-src src
fi

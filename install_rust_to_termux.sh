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

if [ ! -e ~/install_rls.sh ]; then
	wget https://gist.githubusercontent.com/rrichardson/c6b90ad7e6f5c41e102753dde7c663a6/raw/35789dd30043a49ca55c5651484eb19b918b77ea/install_rls.sh
	bash install_rls.sh
	cat >> ~/.vimrc << EOF
if executable('rls')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'rls',
        \ 'cmd': {server_info->['rls']},
        \ 'whitelist': ['rust'],
        \ })
endif
EOF
fi

if [ ! -e ~/rust ]; then
	mkdir ~/rust
	cd ~/rust
	wget https://static.rust-lang.org/dist/rustc-1.27.2-src.tar.gz
	tar xf rustc-1.27.2-src.tar.gz
	ln -s rustc-1.27.2-src src
fi

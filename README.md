vim-4-eva
=========
![](https://github.com/rbuchss/vim-4-eva/blob/master/vim_logo.jpg)
>my vim config

works best with vim compiled from source
to get the source run:
```bash
hg clone https://vim.googlecode.com/hg/ vim
cd vim
hg pull
hg update
```
then config with these options: (includes clipboard support)
```bash
./configure --with-features=normal \
  --with-x --enable-gui=auto \
  --prefix=${HOME} \
  --enable-cscope \
  --enable-pythoninterp \
  --enable-rubyinterp --with-ruby-command=/usr/bin/ruby \
  --enable-perlinterp \
  --with-mac-arch=x86_64 \
  --enable-multibyte
sudo make && make install
```

Logo thanks to [James Doyle](http://ohdoylerules.com/personal-project/vim-svg)

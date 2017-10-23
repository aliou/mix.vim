# Mix.vim

Mix.vim is a (WIP) plugin leveraging [projectionist.vim][] to add custom
commands
to navigate a Mix project.

[projectionist.vim]: https://github.com/tpope/vim-projectionist

## FAQ

> I installed the plugin and started Vim. Why don't any of the commands
> exist?

This plugin cares about the current file, not the current working directory.
Edit a file from a Mix project.

> I opened a new tab. Why don't any of the commands exist?

This plugin cares about the current file, not the current working directory.
Edit a file from a Mix project. You can use the `:T` family of
commands to open a new tab and edit a file at the same time.

## Installation

Using [Pathogen](https://github.com/tpope/vim-pathogen):
 ```bash
git clone https://github.com/aliou/mix.vim.git ~/.vim/bundle/mix.vim
```

Using [vim-plug](https://github.com/junegunn/vim-plug):
```vim
Plug 'aliou/mix.vim'
```

Using [NeoBundle](https://github.com/Shougo/neobundle.vim):
```vim
NeoBundle 'aliou/mix.vim'
```

Using [Vundle](https://github.com/gmarik/vundle):
```vim
Plugin 'aliou/mix.vim'
```

## License
Copyright © Aliou Diallo. Distributed under the same terms as Vim itself. See `:help license`.

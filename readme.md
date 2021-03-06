# Mix.vim

Mix.vim is a plugin leveraging [projectionist.vim][] to add custom
commands to navigate a Mix project. It also supports navigating umbrella
applications and running Mix commands using `:Mix`. Read the [help][] for a
complete list of functionalities.

[projectionist.vim]: https://github.com/tpope/vim-projectionist
[help]: doc/mix.txt

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

Install using your favorite package manager, or use Vim's built-in package
support:

    mkdir -p ~/.vim/pack/aliou/start
    cd ~/.vim/pack/aliou/start
    git clone https://aliou.io/vim/mix.vim.git
    vim -u NONE -c "helptags mix.vim/doc" -c q

## License
Copyright © Aliou Diallo. Distributed under the same terms as Vim itself. See `:help license`.

## Thanks
Massive thanks to [Tim Pope](https://github.com/tpope) for
[projectionist.vim][], [rake.vim][] and for inspiring this project.

[rake.vim]: https://github.com/tpope/vim-rake

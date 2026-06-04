# AstroNvim Template

**NOTE:** This is for AstroNvim v6+

A template for getting started with [AstroNvim](https://github.com/AstroNvim/AstroNvim)

## 🛠️ Installation

#### Prerequisites

[ascii-image-converter](https://github.com/TheZoraiz/ascii-image-converter) is required to display the logo.

Install it using your package manager or from source.
```shell
brew install ascii-image-converter
```
or
```shell
go install github.com/TheZoraiz/ascii-image-converter@latest
```

#### Make a backup of your current nvim and shared folder

```shell
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak
mv ~/.local/state/nvim ~/.local/state/nvim.bak
mv ~/.cache/nvim ~/.cache/nvim.bak
```

#### Create a new user repository from this template

Press the "Use this template" button above to create a new repository to store your user configuration.

You can also just clone this repository directly if you do not want to track your user configuration in GitHub.

#### Clone the repository

```shell
git clone https://github.com/all-dot-files/astronvim-v6.git ~/.config/nvim
```

#### Start Neovim

```shell
nvim
```

or

```shell
NVIM_APPNAME=own_app nvim
```

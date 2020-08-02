# Duncan's Dotfiles

This repo contains the dotfiles I use for working on my Macs. It's got a bunch of aliases, functions and scripts. Feel free to fork this repo and build your own dotfiles repo.

## Fresh macOS Setup
### Before re-installing
First go through this checklist to make sure you don't forget anything before wiping clean your hard drive.

* [ ] Have you committed and pushed any changes/branches to Github?
* [ ] Have you remembered to run `mackup backup`?
* [ ] Has Google Drive finished syncing?
* [ ] Have you exported any databases that need to be exported and put them somewhere useful?

### Setting up your Mac
Now that you've made sure you've done all the things, setup your mac!

1. Update macOS to the latest version through the App Store
2. Install the full version of Xcode from the App Store then run `xcode-select --install`
3. Clone this repository to `~/.dotfiles`
4. Run the `install.sh` script
5. Login to all the things
6. Restore settings for apps by running `mackup restore`
7. Restart Mac to make sure everything works

## Inspired by...

This repository was inspired by [Dries Vints' dotfiles](https://github.com/driesvints/dotfiles) repo. You can watch how Dries manages his Dotfiles over at [Laracasts](https://laracasts.com/series/guest-spotlight/episodes/1).
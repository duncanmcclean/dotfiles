# Duncan's Dotfiles

This repository contains my Dotfiles and anything I use to setup and maintain my Mac (and sometimes Linux) machines. It simplifies the process of installing software and tools on a fresh install of MacOS and it contains any configuration files I use to keep my Mac in shape.

Feel free to copy parts of this for your own dotfiles!

## Fresh macOS Setup
### Before re-installing
First go through this checklist to make sure you don't forget anything before wiping clean your hard drive.
* [ ] Have you committed and pushed any changes/branches to your Git repos?
* [ ] Have you remembered to save all import files on your Desktop to Cloud locations
* [ ] Have you made sure that all clouds have finished syncing (OneDrive and Google Drive)?
* [ ] Have you remembered to export any important information from local databases?
* [ ] Have you updated and ran [Mackup](https://github.com/lra/mackup)? `mackup backup`

### Setting up your Mac
Now that you've made sure you've done all the things, setup your mac!
1. Update macOS to the latest version through the App Store
2. Install the full version of Xcode from the App Store and run `xcode-select --install`
3. Clone this repository to your home directory.
4. Run the `setup.sh` script
5. Login to all the things
6. Restore prefrenced by running `mackup restore`
7. Restore your computer

## Thanks to..

This repository was inspired by [Dries Vints' dotfiles](https://github.com/driesvints/dotfiles) repo.
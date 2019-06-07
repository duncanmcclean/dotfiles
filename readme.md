# Installation
## MacOS
1. Open Safari, open this repository
2. Download the `setup.sh` file
3. Run it in the terminal `./setup.sh`
4. The script will now run - you may be required to enter your sudo password a few times.
5. Now copy the SSH key from your clipboard and set it up on Github.
6. Clone this repo into your user profile directory. Then reload your bash.

## Linux
1. Open the default browser, open this repository.
2. Download the `setup-linux.sh` file
3. Run it in the terminal `bash ./setup-linux.sh`
4. The script will now run - you may be required to enter your sudo password a few times.
5. Now copy the SSH key from your clipboard and set it up on Github.
6. Clone this repo into your user profile directory. Then reload your bash.

# Mac Keyboard Shortcuts
* Cmd + Tab -- menu of apps open
* Cmd + Space -- open Spotlight

# Aliases
## Statamic
* `please` - Preforms `php please`
* `pls` - Preforms `php please`

## Finder
* `show` - Show hidden files in Finder
* `hide` - Hide hidden files in Finder

## Git
* `add` - Preforms `git add`
* `all` - Preforms `git add .`
* `push` - Pushes changes of a Git repository
* `pull` - Pulls changes from a git repository
* `commit` - Preforms the first part of a commit. Usage: `commit "commit message"`
* `check` - Preforms the first part of a checkout. Usage: `check develop`
* `branch` - Displays list of Git branches
* `reset` - Preforms the first part of a git reset. Usage: `reset abababab`
* `clone` - Preforms the first part of `git clone`
* `init` - Init a git repo and create initial commit

## Valet
* `share` - Shares local valet site
* `sites` - Changes directory into the Valet sites directory

## Laravel
* `art` - Preforms `php artisan`
* `migrate` - Migrates a laravel database
* `fresh` - Migrates a laravel database and refreshes the database

## NPM / Webpack
* `dev` - Preforms `npm run dev`
* `watch` - Preforms `npm run watch`
* `prod` - Preforms `npm run prod`
* `deploy` - Preforms `npm run deploy`
* `mixupdate` - Updates Laravel Mix
* `serve` - Preforms `npm run serve`
* `npi` - Installs node dependencies

## Composer
* `comp` - Preforms `composer`
* `compi` - Installs composer dependencies
* `compn` - Nukes composer dependencies, gets rid of the lock file, reinstalls composer dependencies
* `compd` - Preforms `composer dump-autoload`

## Other
* `profile` - Reloads bash profile
* `clearmail` - Clear stupid terminal mail
* `cls` - Clears terminal
* `middle` - Runs `bundle exec middleman server`
* `jserve` - Serve a local jekyll site
* `key` - Copies SSH key to clipboard
* `static` - Clone my static boilerplate
* `phpunit` - PHP unit testing
* `test` - Runs PHPUnit tests
* `sys` - Short for `php systatic`
* `bundin` - Fixed the bundler installers - So installing bundler would look like `bundin bundler`
* `middleman` - Fixes middleman command line issues

# Github
## Two Factor Authentication setup
1. [Create a new personal access token](https://help.github.com/en/articles/creating-a-personal-access-token-for-the-command-line).
2. Remove the `origin` remote - `git remote remove origin`
3. Add the updated `origin` - `git remote add origin git@github.com:damcclean/dotfiles.git`

# Local Package Development with Composer
When developing Composer packages you may need to test the app out seperatly. You can do this by creating another directory for the new app, and using this code (Systatic is the package I'm using in the example)

```
{
    "require": {
        "damcclean/systatic": "@dev"
   },
   "repositories": [
        {
            "type": "path",
            "url": "../systatic"
        }
   ]
}

```

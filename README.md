# Docs for SReachTools-website

We use Github pages and Jekyll to power the documentation website for
[SReachTools](https://unm-hscl.github.io/SReachTools/).

## Serve the webpage

1. Serve the website using the command
    ```
    bundle exec jekyll serve
    ```
1. Pushing the changes on to github will deploy the website.


## Installation for Ubuntu

1. Install jekyll 
    ```
    sudo apt-get install ruby ruby-dev build-essential
    ```
1. Update paths 
    ```
    echo '# Install Ruby Gems to ~/gems' >> ~/.bashrc
    echo 'export GEM_HOME=$HOME/gems' >> ~/.bashrc
    echo 'export PATH=$HOME/gems/bin:$PATH' >> ~/.bashrc
    source ~/.bashrc
    ```
1. Install Jekyll and bundler
    ```
    gem install jekyll bundler
    ```
1. Getting Updates 
    ```
    bundle update
    bundle init
    bundle install
    ```

## Troubleshooting

1. In case, you receive a cryptic error of the form:

    ```
Traceback (most recent call last):
	2: from /home/abyvinod/gems/bin/bundler:23:in `<main>'
	1: from /usr/lib/ruby/2.5.0/rubygems.rb:308:in `activate_bin_path'
/usr/lib/ruby/2.5.0/rubygems.rb:289:in `find_spec_for_exe': can't find gem bundler (>= 0.a) with executable bundler (Gem::GemNotFoundException)
    ```
    it is because of Gemfile.lock. See https://stackoverflow.com/a/54038218 for
    details. The resolution is by doing the following command:
    ```
    gem install bundler -v 1.16.2
    ```
## Other tips

1. Use `git tag -a <tag name> -f` to update a tag

## Regenerate website (deprecated) 

1. When cloning the repository, make sure to do `git
   submodule update --init` to download the website at
   `sreachtools.github.io` into the `_site` folder.
1. Run docs2md to update the documentation folder. 
    - By default, the website is assumed to be a child (titled
      `SReachTools-website`) of the parent folder of `srtinit --rootpath`. 
    - For example, if `srtinit --rootpath` returns `/myworkspace/SReachTools/`,
      then the website folder must be at `/myworkspace/SReachTools-website/`.
    - Specify the path to the website folder as an argument, if this not the
      case.
1. Change directory into the `_site` folder, which now has the updated website.
1. Push the changes to the repository.

### Even older instructions

1. Perform `srtinit` on your local copy of `SReachTools`
1. Clone the repository `sreachtools.github.io` to your
   local machine as `SReachTools-website`.
1. Run the script `SReachTools-website/docs2md.m`.
1. Commit the changes in `_docs/src` for github pages to
   render.

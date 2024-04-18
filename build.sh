rm -Rf _site
bundle exec jekyll build
./half-size-images.zsh _site/assets/images
./half-size-images.zsh _site/assets/images/tablet/
rm _site/build.sh
rm _site/CODE_OF_CONDUCT.md
rm _site/History.markdown
rm _site/half-size-images.zsh
rm _site/LICENSE.txt
rm _site/mine-psd.py
rm _site/minima.gemspec
rm _site/README.md
rm _site/requirements.txt
rm _site/screenshot.png

rm _site/readme_banner.svg
rm -Rf _site/script
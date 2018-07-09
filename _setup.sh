. ~/.profile
set -o errexit
#set -o nounset

function check_env() {
  which go && which perl && which node
}
function locallib() {
  if test -e ~/perl5;
  then
    echo "local::lib already set up."
  return
  fi
  curl https://cpanmin.us | perl - local::lib App::cpanminus -L ~/perl5
}

function dotfiles() {
  if test -e ~/dotfiles;
  then
    echo "dotfiles already installed."
    return
  fi
  (
    cd $HOME
    git clone https://github.com/ediblenergy/dotfiles
    cd dotfiles
    ./deploy.pl
    )
}

function gopath() {
  if [[ "$GOPATH" != "" ]];
  then
    echo "GOPATH already set up"
    return
  fi
  echo 'export GOPATH=$HOME/go' >> ~/.profile
  echo 'export PATH=$GOPATH/bin:$PATH' >> ~/.profile
  . ~/.profile
}

function install_dep() {
  if [[ "$( which dep )" != "" ]];
  then
    echo "dep already installed."
    return
  fi
  mkdir -p $GOPATH/bin
  curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh
}

function perlenv() {
  if [[  "$PERL5LIB" != "" ]];
  then
    echo "perl env already set up."
    return
  fi
  echo 'eval $( perl -I $HOME/perl5/lib/perl5 -Mlocal::lib )' >> ~/.profile
  echo 'export PATH=$HOME/perl5/bin:$PATH' >> ~/.profile
  . ~/.profile

}

check_env \
  && locallib \
  && dotfiles \
  && gopath \
  && install_dep \
  && perlenv


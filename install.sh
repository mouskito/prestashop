if [ -d old_transmeo ]; then
    rm -rf old_transmeo
else
    if [[ -d transmeo ]]; then
        mv transmeo old_transmeo
    fi
fi
git clone git@github.com:iknsa-corp/cardif-transmeo.git transmeo

cp ~/.ssh/id_rsa vagrant-stuffs

vagrant up

# if [ -d old_transmeo ]; then
#     rm -rf old_transmeo
# else
#     if [[ -d transmeo ]]; then
#         mv pleaky old_transmeo
#     fi
# fi
git clone git@github.com:php-light/framework.git transmeo

cp ~/.ssh/id_rsa vagrant-stuffs

vagrant up

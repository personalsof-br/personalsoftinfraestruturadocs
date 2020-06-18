mkdir -p ~/.ssh
touch ~/.ssh/authorized_keys
echo "" >> ~/.ssh/authorized_keys
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCJUk9PMynRzqY0GZNZrTHY9HS8YBau/5iyVnev6KCfhNA0uFkY++w1C+RaRpZgqGcymEL4PHuhPvmrEB+nRqwXKsgQQ/yuvKAT36LN7K6T3GU4oDsWPptTh78SZkSSDaRUBQCnzVQOhH1ix3EsIua83KysQI0nVbPJ5pzrA85DHOJJnCCPMu87O3RB2j0Qg9w9nQdAijo5IVLBASheZJX5utS0+aP7ILSk21XYmJZawD8JaPstbOG0lm6qkfPo4TfN4pcf/pj2W2ymRX3nkgAB/XgkiNh/KZw/T8FmEg0tcXLjbqM65897VY8P3X363mSex39PXjoJPPbgnd2Wsgyr fabiano.bonin@personalsoft.com.br" >> ~/.ssh/authorized_keys
chmod u=rwx,g=,o= ~/.ssh
chmod u=rw,g=,o= ~/.ssh/authorized_keys
chown $USER:$USER ~/.ssh -R

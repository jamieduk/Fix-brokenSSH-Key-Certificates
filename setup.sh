# (c) J~Net 2026
#
# fix_certificate filename
#
#
# https://jnet.forumotion.com/t2212-dont-put-ssh-certificates-or-any-other-security-related-certificates-to-llm-instead-use-a-safe-bash-function-to-fix-broken-certs#3394
#
#
# Repair malformed SSH keys and certificates
# Usage: fix_certificate input_file [output_file]
sudo cp fix_certificate /usr/bin/fix_certificate
sudo chmod +x /usr/bin/fix_certificate


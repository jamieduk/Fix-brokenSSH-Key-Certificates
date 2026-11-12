#!/bin/bash
# (c) J~Net 2026
# Generate a genuine malformed SSH certificate for testing

mkdir -p ssh-test
cd ssh-test || exit 1

# Generate SSH CA
ssh-keygen -q -t ed25519 -N "" -f test_ca

# Generate user key
ssh-keygen -q -t ed25519 -N "" -f test_user

# Sign user key
ssh-keygen -q -s test_ca -I jay-test -n jay -V +52w test_user.pub

# Create consistently named broken certificate
python3 - <<'PY'
from pathlib import Path

data=Path("test_user-cert.pub").read_text()

# Introduce escaped newlines and escaped quotation marks
data=data.replace(" ", "\\n", 1)
data=data.replace("\n", "\\r\\n")
data=data.replace("jay-test", '\\"jay-test\\"')

Path("broken_cert.pub").write_text(data)

# Display original certificate information
print("[OK] Genuine malformed certificate created: broken_cert.pub")
PY

ssh-keygen -L -f test_user-cert.pub


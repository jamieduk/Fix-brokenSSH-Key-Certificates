
#!/bin/bash
# (c) J~Net 2026
# Generate genuine SSH certificate and deliberately corrupt its formatting

mkdir -p ssh-test
cd ssh-test || exit 1

# Generate SSH CA
ssh-keygen -q -t ed25519 -N "" -f test_ca

# Generate user key
ssh-keygen -q -t ed25519 -N "" -f test_user

# Sign user key with CA
ssh-keygen -q -s test_ca -I jay-test -n jay -V +52w test_user.pub

# Create deliberately malformed certificate
python3 - <<'PY'
from pathlib import Path

p=Path("test_user-cert.pub")
data=p.read_text()

# Introduce escaped newlines and escaped quotes
data=data.replace(" ", "\\n", 1)
data=data.replace("\n", "\\r\\n")
data=data.replace("jay-test", '\\"jay-test\\"')

Path("broken_cert.pub").write_text(data)
PY

echo "[OK] Genuine certificate generated."
echo "[OK] Malformed copy: broken_cert.pub"
echo "[INFO] Original certificate: test_user-cert.pub"

# Display original certificate details
ssh-keygen -L -f test_user-cert.pub


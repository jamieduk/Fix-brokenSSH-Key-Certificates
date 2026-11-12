# Fix Broken SSH Key Certificates

A Bash utility to repair malformed SSH public keys, private keys and SSH certificates by correcting formatting issues, escaped characters, line breaks and Base64 wrapping.

**Repository:** https://github.com/jamieduk/Fix-brokenSSH-Key-Certificates

**Discussion:** [Don't put SSH certificates or any other security-related certificates into an LLM](https://jnet.forumotion.com/t2212-dont-put-ssh-certificates-or-any-other-security-related-certificates-to-llm-instead-use-a-safe-bash-function-to-fix-broken-certs#3394)

---
<img width="1246" height="265" alt="Screenshot From 2026-11-12 20-54-36" src="https://github.com/user-attachments/assets/06fe3075-1ac9-49f8-8a17-77386884caff" />


## Why?

SSH keys and certificates can become malformed when copied between applications, websites, JSON responses, APIs or other systems.

Common problems include:

- Incorrect or missing line breaks.
- Windows (`CRLF`) and Unix (`LF`) line-ending inconsistencies.
- JSON-escaped newline characters (`\n` and `\r\n`).
- Escaped quotation marks (`\"`).
- Incorrectly wrapped Base64 data.
- Unnecessary whitespace and formatting characters.

Instead of uploading sensitive SSH material to an LLM or an online certificate repair service, this utility allows you to attempt repairs locally using a Bash-based tool.

## Features

- Repairs SSH public key formatting.
- Repairs SSH private key formatting where the original key material remains intact.
- Repairs SSH user certificate formatting.
- Normalises escaped newline characters.
- Handles Windows and Unix line endings.
- Reconstructs PEM-style Base64 formatting.
- Removes unnecessary whitespace.
- Checks repaired files using OpenSSH utilities.
- Creates a separate output file without overwriting the original.

## Requirements

- Linux
- Bash
- Python 3
- OpenSSH client (`ssh-keygen`)

Install the required packages on Ubuntu:

```bash
sudo apt install -y python3 openssh-client
```

## Installation

Clone the repository:

```bash
git clone https://github.com/jamieduk/Fix-brokenSSH-Key-Certificates.git
cd Fix-brokenSSH-Key-Certificates
```

Make the scripts executable:

```bash
chmod +x fix_certificate *.sh
```

Run the setup script:

```bash
./setup.sh
```

## Usage

Pass the malformed SSH key or certificate file to `fix_certificate`:

```bash
fix_certificate broken_cert.pub
```

The repaired file is created in the current directory with `.fixed` appended to its filename.

For example:

```text
broken_cert.pub
broken_cert.pub.fixed
```

You can also specify an output filename if supported by the script:

```bash
fix_certificate broken_cert.pub repaired_cert.pub
```

The original file is preserved.

## Testing

The repository includes a test script that generates a genuine SSH certificate and deliberately introduces formatting problems.

Run:

```bash
./create_broken_cert.sh
```

This generates the test files inside the `ssh-test` directory.

Copy the malformed certificate into your working directory:

```bash
cp ssh-test/broken_cert.pub .
```

Run the repair utility:

```bash
fix_certificate broken_cert.pub
```

Inspect the repaired output, including line endings and hidden characters:

```bash
cat -A broken_cert.pub.fixed
```

## Validate the repaired certificate

Use OpenSSH to inspect the repaired certificate:

```bash
ssh-keygen -L -f broken_cert.pub.fixed
```

A successfully recognised certificate should display information such as:

- Certificate type.
- Public key fingerprint.
- Signing CA.
- Key ID.
- Serial number.
- Validity period.
- Principals.
- Certificate extensions.

You can also check whether OpenSSH recognises a public key:

```bash
ssh-keygen -lf repaired_key.pub
```

For private keys, derive the corresponding public key:

```bash
ssh-keygen -y -f repaired_key
```

If OpenSSH can successfully read the repaired private key, it will output its public key.

## Supported formats

| File type | Repair support |
|---|---|
| SSH public keys | Yes |
| SSH private keys | Yes, where key material is intact |
| SSH user certificates | Yes |
| PEM-encoded keys | Yes, where structure and Base64 data are intact |
| JSON-escaped key content | Common escaped formatting supported |

## Security

**Never send private SSH keys, authentication credentials or sensitive security certificates to an LLM or an untrusted online service.**

This utility is intended to perform repairs locally, keeping sensitive key material on your own system.

The utility repairs formatting problems; it cannot reconstruct missing cryptographic data, recover damaged Base64 content or repair invalid cryptographic signatures.

A successful formatting repair does not establish that a certificate is trusted or that its signature is valid. Always perform the appropriate OpenSSH validation and verify certificate trust separately.

## Cleanup

Remove the generated test keys and certificates:

```bash
./cleanup.sh
```

This removes the test files generated inside `ssh-test` without deleting your actual SSH keys.

---

## Author

**J~Net**

GitHub: https://github.com/jamieduk

Main Site jnetai.com

Copyright (c) J~Net 2026

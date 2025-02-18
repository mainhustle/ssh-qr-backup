# SSH Key Backup with QR Codes

This script provides a secure way to back up SSH keys by compressing them, splitting large files, encoding them into QR codes, and restoring them when needed.  It is primarily designed for macOS.

## Features
- Compresses SSH private keys using Gzip
- Splits large files into smaller chunks suitable for QR codes
- Encodes the compressed files into QR codes
- Restores files by scanning QR codes and reconstructing them
- Automatically regenerates public keys from private keys

## Requirements
The following dependencies must be installed via Homebrew:

```sh
brew install qrencode imagemagick zbar
```

- `qrencode`: Used to generate QR codes from compressed SSH keys
- `imagemagick`: Adds labels (file names) to QR code images
- `zbar`: Scans and decodes QR codes during the restoration process

## Installation
Clone the repository and navigate to the project folder:

```sh
git clone https://github.com/mainhustle/ssh-qr-backup.git
cd ssh-key-backup
```

Make sure the scripts are executable:

```sh
chmod +x encode/create-qr.sh decode/create-ssh.sh
```

## Usage
### Backup Process
Put your sshkeys in `.encode/keys`
To back up your SSH keys:

```sh
cd encode
./create-qr.sh
```

This will:
1. Compress the private keys in the `./keys` directory
2. Split large compressed files if necessary
3. Encode them into QR codes in the `./qrcodes` directory

### Restore Process
To restore the SSH keys:

Scan the qr-codes and save them in the folder `.decode/qrcodes` in the filenames written in the qr-code-files.

```sh
cd decode
./create-ssh.sh
```

This will:
1. Scan QR codes from the `./qrcodes` directory
2. Decode and reconstruct split files if necessary
3. Decompress the files and regenerate public keys

## Notes
- Ensure your private keys have the correct permissions before use:

```sh
chmod 600 ~/.ssh/id_rsa
```

- Store QR codes securely, as they contain your private keys.
- When restoring, ensure the `./qrcodes` folder contains all required QR code images.

## License
This project is licensed under the MIT License.


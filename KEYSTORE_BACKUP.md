# Keystore Backup Instructions

## ⚠️ CRITICAL: Your Keystore is Your App's Identity

**Without this keystore, you CANNOT update your app on Google Play Store.**

If you lose it, you'll have to:
- Publish a completely new app with a different package name
- Lose all your reviews, ratings, and downloads
- Ask users to uninstall and reinstall

**Location:** `~/keystores/crosswatch-release-key.jks` (2.8 KB)  
**Credentials:**
- Store Password: `crosswatch2026`
- Key Password: `crosswatch2026`
- Alias: `crosswatch`

---

## Backup Methods (Do at least 2!)

### Method 1: Encrypted USB Drive (Recommended)

**Best for:** Physical backup you control

```bash
# 1. Insert USB drive
# 2. Find mount point
lsblk

# 3. Copy keystore (replace /media/auryn/USB with your mount point)
mkdir -p /media/auryn/USB/crosswatch-backup
cp ~/keystores/crosswatch-release-key.jks /media/auryn/USB/crosswatch-backup/
cp ~/git/auryn-macmillan/vibes/android/key.properties /media/auryn/USB/crosswatch-backup/

# 4. Create credentials file
cat > /media/auryn/USB/crosswatch-backup/CREDENTIALS.txt <<'EOF'
CROSSWATCH KEYSTORE CREDENTIALS
================================
Keystore: crosswatch-release-key.jks
Store Password: crosswatch2026
Key Password: crosswatch2026
Alias: crosswatch
Package: com.crosswatch.app

IMPORTANT: Keep this file secure!
Generated: January 8, 2026
EOF

# 5. Verify files copied
ls -lh /media/auryn/USB/crosswatch-backup/

# 6. Safely eject
sync
udisksctl unmount -b /dev/sdX1  # Replace sdX1 with your device
udisksctl power-off -b /dev/sdX
```

**Store USB drive in a safe place** (fireproof safe, safety deposit box, etc.)

---

### Method 2: Cloud Storage (Encrypted)

**Best for:** Off-site backup with easy access

#### Option A: Encrypted Archive

```bash
# Create encrypted backup
cd ~
tar czf - keystores/crosswatch-release-key.jks | \
  gpg --symmetric --cipher-algo AES256 -o crosswatch-keystore-backup.tar.gz.gpg

# You'll be prompted for a passphrase - USE A STRONG ONE and save it in password manager!

# Upload to cloud:
# - Google Drive
# - Dropbox
# - iCloud
# - Your preferred cloud service

# To restore later:
gpg --decrypt crosswatch-keystore-backup.tar.gz.gpg | tar xzf -
```

#### Option B: Password Manager (1Password, Bitwarden, etc.)

```bash
# Convert keystore to base64 for storage
base64 ~/keystores/crosswatch-release-key.jks > ~/crosswatch-keystore-base64.txt

# Add to password manager as secure note with:
# - Title: "Crosswatch Android Keystore"
# - Base64 content from file above
# - Store Password: crosswatch2026
# - Key Password: crosswatch2026
# - Alias: crosswatch

# To restore later:
base64 -d crosswatch-keystore-base64.txt > crosswatch-release-key.jks
```

---

### Method 3: Private Git Repository

**Best for:** Version control with access from anywhere

⚠️ **NEVER push to public repo! Only use PRIVATE repo!**

```bash
# Create separate private backup repo
cd ~
mkdir crosswatch-secrets
cd crosswatch-secrets

git init
git branch -M main

# Add keystore and credentials
mkdir keystores
cp ~/keystores/crosswatch-release-key.jks keystores/
cp ~/git/auryn-macmillan/vibes/android/key.properties ./

# Create README
cat > README.md <<'EOF'
# Crosswatch Secrets Backup

**PRIVATE REPOSITORY - DO NOT MAKE PUBLIC**

This repository contains sensitive signing keys for the Crosswatch app.

## Contents
- `keystores/crosswatch-release-key.jks` - Release signing key
- `key.properties` - Key configuration

## Credentials
- Store Password: crosswatch2026
- Key Password: crosswatch2026
- Alias: crosswatch

## Usage
To restore, copy `crosswatch-release-key.jks` to `~/keystores/` on your machine.
EOF

# Commit
git add .
git commit -m "Initial backup of Crosswatch keystore"

# Create PRIVATE repo on GitHub and push
# DO NOT SKIP: Verify repo is PRIVATE before pushing!
gh repo create crosswatch-secrets --private --source=. --remote=origin --push
```

---

### Method 4: External Hard Drive / NAS

```bash
# Copy to external storage
mkdir -p /path/to/external/drive/crosswatch-backup
cp ~/keystores/crosswatch-release-key.jks /path/to/external/drive/crosswatch-backup/
cp ~/git/auryn-macmillan/vibes/android/key.properties /path/to/external/drive/crosswatch-backup/

# Create README
cat > /path/to/external/drive/crosswatch-backup/README.txt <<'EOF'
Crosswatch Keystore Backup
Created: January 8, 2026

File: crosswatch-release-key.jks
Store Password: crosswatch2026
Key Password: crosswatch2026
Alias: crosswatch

Keep this drive in a secure location!
EOF
```

---

## Backup Checklist

Create at least 2 backups in different locations:

- [ ] **Primary Backup:** Encrypted USB drive in fireproof safe
- [ ] **Secondary Backup:** Cloud storage (encrypted)
- [ ] **Tertiary Backup:** Password manager or private git repo
- [ ] **Document passwords** in secure password manager
- [ ] **Test restoration** from one backup to verify it works

---

## Testing Your Backup

After creating backup, test it:

```bash
# 1. Copy backup keystore to temporary location
cp /path/to/backup/crosswatch-release-key.jks /tmp/test-keystore.jks

# 2. Verify it's valid (will ask for password: crosswatch2026)
keytool -list -v -keystore /tmp/test-keystore.jks -alias crosswatch

# 3. Should show:
# Alias name: crosswatch
# Creation date: (your date)
# Entry type: PrivateKeyEntry
# Certificate chain length: 1
# Valid until: (10,000 days from creation)

# 4. Clean up
rm /tmp/test-keystore.jks
```

If keytool shows the certificate info, your backup is valid! ✅

---

## Restoration Procedure

If you ever need to restore your keystore:

```bash
# 1. Create keystores directory if missing
mkdir -p ~/keystores

# 2. Copy from backup
cp /path/to/backup/crosswatch-release-key.jks ~/keystores/

# 3. Set permissions
chmod 600 ~/keystores/crosswatch-release-key.jks

# 4. Verify
keytool -list -v -keystore ~/keystores/crosswatch-release-key.jks -alias crosswatch

# 5. Update key.properties if needed
cat > ~/git/auryn-macmillan/vibes/android/key.properties <<'EOF'
storePassword=crosswatch2026
keyPassword=crosswatch2026
keyAlias=crosswatch
storeFile=/home/auryn/keystores/crosswatch-release-key.jks
EOF

# 6. Test build
cd ~/git/auryn-macmillan/vibes
export PATH="/home/auryn/bin/flutter/bin:$PATH"
flutter build appbundle --release
```

---

## Security Best Practices

1. **Never commit keystore to public repos** ✅ (already in .gitignore)
2. **Use strong passwords** (consider changing from `crosswatch2026` if needed)
3. **Encrypt backups** when storing in cloud
4. **Store passwords separately** from keystore (use password manager)
5. **Keep multiple backups** in different physical locations
6. **Test backups regularly** (every 6 months)
7. **Document where backups are** so you can find them years later

---

## Quick Commands Reference

```bash
# Verify keystore exists
ls -lh ~/keystores/crosswatch-release-key.jks

# View keystore info
keytool -list -v -keystore ~/keystores/crosswatch-release-key.jks

# Create encrypted backup
tar czf - ~/keystores/crosswatch-release-key.jks | \
  gpg --symmetric --cipher-algo AES256 -o crosswatch-backup.tar.gz.gpg

# Copy to USB
cp ~/keystores/crosswatch-release-key.jks /media/auryn/USB/

# Test build with keystore
cd ~/git/auryn-macmillan/vibes && flutter build appbundle --release
```

---

## Current Status

**Keystore Location:** ✅ `~/keystores/crosswatch-release-key.jks` (2.8 KB)  
**Backup Status:** ⏳ **NOT YET BACKED UP - DO THIS NOW!**

**Recommended Action:** Create at least 2 backups using methods above **before** publishing to Play Store!

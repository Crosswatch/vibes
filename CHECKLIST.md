# Play Store Publication Checklist

Complete guide to publishing Crosswatch to Google Play Store.

**Current Status:** Ready for final steps before submission! 🚀

---

## Phase 1: Preparation ✅ COMPLETED

### App Build ✅
- [x] Release AAB built and signed (`app-release.aab` - 40 MB)
- [x] Release APK built and signed (`app-release.apk` - 47 MB)
- [x] Signing key generated and configured
- [x] App builds successfully with proper signing

### Branding ✅
- [x] App icon created (1024x1024)
- [x] Launcher icons generated for all densities
- [x] Color scheme finalized (Electric Blue, Coral, Lime)
- [x] Logo design complete
- [x] Store graphics created:
  - [x] Icon 512x512 (`assets/store/icon-512.png`)
  - [x] Feature graphic 1024x500 (`assets/store/feature_graphic.png`)
  - [x] Promo graphic 180x120 (`assets/store/promo_graphic.png`)

### Security ✅
- [x] Keystore secured outside repository
- [x] `.gitignore` updated with sensitive files
- [x] `key.properties` excluded from git
- [x] Security audit passed
- [x] Safe to push to public GitHub

### Documentation ✅
- [x] Privacy policy created (`privacy-policy.html`)
- [x] Keystore backup instructions (`KEYSTORE_BACKUP.md`)
- [x] Screenshot guide (`SCREENSHOTS.md`)
- [x] Play Store content written (`PLAYSTORE.md`)
- [x] Publishing guide (`PUBLISHING.md`)

---

## Phase 2: Manual Steps Required ⏳ IN PROGRESS

### 1. Backup Keystore (CRITICAL) ⏳
**Status:** Instructions created, action required

**Your keystore:** `~/keystores/crosswatch-release-key.jks` (2.8 KB)  
**Credentials:** Store/Key password: `crosswatch2026`, Alias: `crosswatch`

**Action Required:**
```bash
# Quick backup to USB drive (5 minutes)
# 1. Insert USB drive
# 2. Run:
mkdir -p /media/auryn/USB/crosswatch-backup
cp ~/keystores/crosswatch-release-key.jks /media/auryn/USB/crosswatch-backup/
echo "Store Password: crosswatch2026" > /media/auryn/USB/crosswatch-backup/CREDENTIALS.txt
echo "Key Password: crosswatch2026" >> /media/auryn/USB/crosswatch-backup/CREDENTIALS.txt
echo "Alias: crosswatch" >> /media/auryn/USB/crosswatch-backup/CREDENTIALS.txt
sync
# 3. Store USB drive in safe location

# Optional: Create encrypted cloud backup
cd ~
tar czf - keystores/crosswatch-release-key.jks | \
  gpg --symmetric --cipher-algo AES256 -o crosswatch-keystore-backup.tar.gz.gpg
# Upload crosswatch-keystore-backup.tar.gz.gpg to Google Drive/Dropbox
```

**Checklist:**
- [ ] Backup 1: USB drive (in safe location)
- [ ] Backup 2: Encrypted cloud storage
- [ ] Passwords documented in password manager
- [ ] Restoration tested from one backup

**See:** `KEYSTORE_BACKUP.md` for detailed instructions

---

### 2. Host Privacy Policy ⏳
**Status:** File created, hosting required

**Action Required:**
```bash
# 1. Push privacy-policy.html to GitHub
cd ~/git/auryn-macmillan/vibes
git add privacy-policy.html PRIVACY_HOSTING.md
git commit -m "Add privacy policy for Play Store"
git push origin main

# 2. Enable GitHub Pages
# - Go to: https://github.com/auryn-macmillan/vibes/settings/pages
# - Source: Deploy from branch "main"
# - Folder: / (root)
# - Click Save

# 3. Wait 1-2 minutes, then verify URL works:
curl -I https://auryn-macmillan.github.io/vibes/privacy-policy.html
# Should return: HTTP/2 200
```

**Checklist:**
- [ ] File pushed to GitHub
- [ ] GitHub Pages enabled
- [ ] Privacy policy URL accessible
- [ ] URL saved for Play Console: `https://auryn-macmillan.github.io/vibes/privacy-policy.html`

**Optional:** Update email in privacy policy from `privacy@crosswatch.app` to your actual email

**See:** `PRIVACY_HOSTING.md` for detailed instructions

---

### 3. Capture Screenshots ⏳
**Status:** Instructions created, capture required

**Requirements:**
- Minimum: 2 screenshots
- Recommended: 4-8 screenshots
- Format: PNG or JPEG
- Dimensions: 1080x1920 recommended (portrait)

**Recommended Screenshots:**
1. Home screen with workout list (light mode)
2. Workout builder interface
3. Active timer during workout
4. Home screen or timer (dark mode)

**Quick Capture Method:**
```bash
# 1. Install app on device
cd ~/git/auryn-macmillan/vibes
export PATH="/home/auryn/bin/flutter/bin:$PATH"
adb devices  # Verify device connected
flutter install --release

# 2. Create screenshots directory
mkdir -p screenshots/phone

# 3. On device:
#    - Navigate to each screen
#    - Press Power + Volume Down to screenshot
#    - Take 4-8 screenshots

# 4. Pull screenshots from device
adb pull /sdcard/Pictures/Screenshots/ screenshots/phone/

# 5. Verify
ls -lh screenshots/phone/
```

**Checklist:**
- [ ] App installed on device
- [ ] Home screen captured (light mode)
- [ ] Workout builder captured
- [ ] Active timer captured
- [ ] Dark mode captured
- [ ] Screenshots organized in `screenshots/phone/`
- [ ] All screenshots are clear and properly sized

**See:** `SCREENSHOTS.md` for detailed instructions

---

### 4. Test Release APK (Optional but Recommended) ⏳
**Status:** APK ready, testing required

**Action Required:**
```bash
# Install release APK on device
cd ~/git/auryn-macmillan/vibes
adb install build/app/outputs/flutter-apk/app-release.apk

# Test all features:
# - Create workout
# - Edit workout
# - Run workout timer
# - Test sound/vibration
# - Toggle dark mode
# - Verify all buttons work
# - Check for crashes
```

**Checklist:**
- [ ] APK installed successfully
- [ ] All features tested and working
- [ ] No crashes or errors
- [ ] Performance is acceptable
- [ ] Dark mode works correctly

---

## Phase 3: Play Console Setup ⏳ NOT STARTED

### 1. Create Developer Account ⏳
**Cost:** $25 USD (one-time fee)  
**Time:** 10-15 minutes

**Action Required:**
1. Go to: https://play.google.com/console/signup
2. Sign in with Google account
3. Accept Developer Agreement
4. Pay $25 registration fee (credit card)
5. Complete developer profile:
   - Developer name: "Crosswatch" or your name
   - Email address
   - Website (optional): GitHub repo URL
   - Phone number (optional)

**Checklist:**
- [ ] Developer account created
- [ ] $25 fee paid
- [ ] Developer profile completed
- [ ] Account verified (may take 1-2 days)

---

### 2. Create App in Play Console ⏳
**Time:** 30-45 minutes

**Action Required:**

1. **Create App:**
   - Go to Play Console → All Apps → Create App
   - App name: `Crosswatch`
   - Default language: English (United States)
   - App type: App
   - Free/Paid: Free
   - Declarations: Check all required boxes
   - Click Create App

2. **Complete Store Listing:**
   - Go to Store Presence → Main Store Listing
   - **App name:** Crosswatch
   - **Short description:** (Copy from `PLAYSTORE.md` - 80 chars max)
   - **Full description:** (Copy from `PLAYSTORE.md` - 4000 chars max)
   - **App icon:** Upload `assets/store/icon-512.png`
   - **Feature graphic:** Upload `assets/store/feature_graphic.png`
   - **Phone screenshots:** Upload from `screenshots/phone/` (minimum 2, max 8)
   - **Tablet screenshots:** (Optional) Upload if available
   - **App category:** Health & Fitness
   - **Tags:** Fitness, HIIT, Timer, Workout, CrossFit
   - **Email:** Your contact email
   - **Privacy policy:** `https://auryn-macmillan.github.io/vibes/privacy-policy.html`
   - Click Save

3. **Set Up Main Store Listing:**
   - Store Presence → Main Store Listing
   - Complete all required fields (see `PLAYSTORE.md` for content)

4. **Complete Content Rating:**
   - Policy → App Content → Content Rating
   - Start Questionnaire
   - Select "Reference: Health, Fitness, Sports or Self-improvement app"
   - Answer all questions (likely all "No" for Crosswatch)
   - Submit and apply rating

5. **Set Up App Access:**
   - Policy → App Content → App Access
   - Select "All functionality is available without special access"
   - Save

6. **Declare Ads:**
   - Policy → App Content → Ads
   - Select "No, my app does not contain ads"
   - Save

7. **Target Audience:**
   - Policy → App Content → Target Audience
   - Select age groups: 13+ (or appropriate range)
   - Save

8. **Data Safety:**
   - Policy → App Content → Data Safety
   - Select "No, my app does not collect or share data"
   - (Match with privacy policy)
   - Save

9. **Create Release:**
   - Release → Production → Create New Release
   - Upload AAB: `build/app/outputs/bundle/release/app-release.aab`
   - Release name: `1.0.0 (1)` or similar
   - Release notes: Copy from `PLAYSTORE.md`
   - Click Save
   - Click Review Release

10. **Review and Submit:**
    - Review all sections (must all show green checkmarks)
    - Click "Start Rollout to Production"
    - Confirm submission

**Checklist:**
- [ ] App created in Play Console
- [ ] Store listing completed with descriptions
- [ ] App icon and feature graphic uploaded
- [ ] Screenshots uploaded (minimum 2)
- [ ] Content rating completed
- [ ] Privacy policy URL added
- [ ] App access declared
- [ ] Ads declaration completed
- [ ] Target audience set
- [ ] Data safety section completed
- [ ] AAB uploaded
- [ ] Release notes added
- [ ] All sections show green checkmarks
- [ ] App submitted for review

**See:** `PUBLISHING.md` for detailed Play Console instructions

---

## Phase 4: Post-Submission ⏳ NOT STARTED

### Review Process
**Typical Timeline:** 1-7 days (usually 1-3 days)

**During Review:**
- Google will test your app for policy compliance
- May request changes if issues found
- You'll receive email notifications

**Checklist:**
- [ ] Submission confirmed
- [ ] Email notifications enabled
- [ ] Monitoring Play Console for status updates

---

### After Approval

**When Approved:**
- [ ] App goes live on Play Store
- [ ] Share link: `https://play.google.com/store/apps/details?id=com.crosswatch.app`
- [ ] Announce on social media / Reddit / forums
- [ ] Monitor reviews and ratings
- [ ] Respond to user feedback

**Update README:**
```bash
# Add Play Store badge to README.md
```

---

## Quick Reference

### File Locations
```
~/keystores/
  └── crosswatch-release-key.jks                    # Signing key (CRITICAL!)

~/git/auryn-macmillan/vibes/
  ├── build/app/outputs/
  │   ├── bundle/release/app-release.aab           # For Play Store (40 MB)
  │   └── flutter-apk/app-release.apk              # For direct install (47 MB)
  ├── assets/store/
  │   ├── icon-512.png                             # Play Console icon (66 KB)
  │   ├── feature_graphic.png                      # Store banner (83 KB)
  │   └── promo_graphic.png                        # Promo graphic (16 KB)
  ├── screenshots/phone/                           # To be created
  ├── privacy-policy.html                          # Privacy policy webpage
  ├── PLAYSTORE.md                                 # Store listing content
  ├── PUBLISHING.md                                # Detailed publishing guide
  ├── KEYSTORE_BACKUP.md                           # Backup instructions
  ├── SCREENSHOTS.md                               # Screenshot guide
  └── CHECKLIST.md                                 # This file
```

### Important URLs
- **Play Console:** https://play.google.com/console
- **Privacy Policy:** https://auryn-macmillan.github.io/vibes/privacy-policy.html (after hosting)
- **App Page:** https://play.google.com/store/apps/details?id=com.crosswatch.app (after approval)
- **Developer Guide:** https://developer.android.com/distribute/console

### Key Credentials
**Keystore:**
- Location: `~/keystores/crosswatch-release-key.jks`
- Store Password: `crosswatch2026`
- Key Password: `crosswatch2026`
- Alias: `crosswatch`

**⚠️ NEVER commit these to git!**

---

## Estimated Timeline

| Task | Time | Status |
|------|------|--------|
| Backup keystore | 10 min | ⏳ TODO |
| Host privacy policy | 5 min | ⏳ TODO |
| Capture screenshots | 20 min | ⏳ TODO |
| Create Play Console account | 15 min | ⏳ TODO |
| Complete store listing | 30 min | ⏳ TODO |
| Upload AAB and submit | 15 min | ⏳ TODO |
| **Total active time** | **~90 min** | |
| Google review process | 1-7 days | ⏳ TODO |
| **Total calendar time** | **1-7 days** | |

---

## What to Do Right Now

**Priority 1: Backup Keystore (CRITICAL)**
```bash
# Quick 5-minute backup to USB
mkdir -p /media/auryn/USB/crosswatch-backup
cp ~/keystores/crosswatch-release-key.jks /media/auryn/USB/crosswatch-backup/
echo -e "Store Password: crosswatch2026\nKey Password: crosswatch2026\nAlias: crosswatch" > \
  /media/auryn/USB/crosswatch-backup/CREDENTIALS.txt
```

**Priority 2: Host Privacy Policy**
```bash
cd ~/git/auryn-macmillan/vibes
git add privacy-policy.html PRIVACY_HOSTING.md
git commit -m "Add privacy policy for Play Store"
git push origin main
# Then enable GitHub Pages in repo settings
```

**Priority 3: Capture Screenshots**
```bash
cd ~/git/auryn-macmillan/vibes
export PATH="/home/auryn/bin/flutter/bin:$PATH"
flutter install --release
mkdir -p screenshots/phone
# Take screenshots on device, then:
adb pull /sdcard/Pictures/Screenshots/ screenshots/phone/
```

**Priority 4: Create Play Console Account**
- Go to: https://play.google.com/console/signup
- Pay $25 fee
- Complete developer profile

**Priority 5: Submit to Play Store**
- Follow detailed instructions in `PUBLISHING.md`
- Upload AAB, add screenshots, fill out forms
- Submit for review!

---

## Need Help?

**Documentation:**
- `PUBLISHING.md` - Detailed Play Console guide
- `PLAYSTORE.md` - All store listing content
- `KEYSTORE_BACKUP.md` - Keystore backup methods
- `SCREENSHOTS.md` - Screenshot capture guide
- `SECURITY.md` - Security best practices

**Official Resources:**
- Play Console Help: https://support.google.com/googleplay/android-developer
- Developer Policy: https://play.google.com/about/developer-content-policy/
- Launch Checklist: https://developer.android.com/distribute/best-practices/launch/launch-checklist

**Contact:**
- Issues with this guide: Open GitHub issue
- Play Store policies: Contact Play Console support

---

## Success Criteria

You're ready to publish when:

- [x] AAB built and signed ✅
- [x] Store graphics created ✅
- [x] Security audit passed ✅
- [ ] Keystore backed up (at least 2 locations)
- [ ] Privacy policy hosted and accessible
- [ ] Screenshots captured (minimum 2, recommended 4-8)
- [ ] Play Console account created ($25 paid)
- [ ] All store listing content ready
- [ ] App tested on device (optional but recommended)

**Current Status:** 3/9 completed, 6 remaining

**Next Action:** Back up your keystore NOW! 🔐

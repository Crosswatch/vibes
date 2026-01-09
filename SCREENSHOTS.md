# Play Store Screenshot Guide

Google Play Store requires screenshots to showcase your app. Let's capture professional screenshots of Crosswatch!

## Requirements

**Minimum:** 2 screenshots  
**Recommended:** 4-8 screenshots  
**Format:** JPEG or 24-bit PNG (no alpha)  
**Dimensions:** 
- Minimum: 320px on shortest side
- Maximum: 3840px on longest side
- Recommended for phones: 1080x1920 (9:16 portrait) or 1920x1080 (16:9 landscape)

**File Size:** Max 8 MB per screenshot

---

## Recommended Screenshots for Crosswatch

**Screenshot 1: Home Screen with Workouts**
- Shows the workout list
- Demonstrates clean UI
- Shows workout variety (HIIT, Tabata, EMOM, etc.)

**Screenshot 2: Workout Builder**
- Creating a custom workout
- Shows the interval setup interface
- Highlights ease of customization

**Screenshot 3: Active Timer**
- Timer in action during a workout
- Shows large, clear countdown
- Demonstrates the vibrant color scheme

**Screenshot 4: Dark Mode**
- Same screen as Screenshot 1 or 3 but in dark mode
- Shows app works well in low-light conditions

**Screenshot 5 (Optional): Workout Details**
- Viewing workout configuration
- Shows all the intervals and settings

**Screenshot 6 (Optional): Settings/Preferences**
- App settings and customization options

---

## Method 1: Capture from Android Device (Best Quality)

### Step 1: Install the App

```bash
cd ~/git/auryn-macmillan/vibes

# Make sure Flutter is in PATH
export PATH="/home/auryn/bin/flutter/bin:$PATH"

# Connect your Android device via USB
# Enable USB debugging on device:
#   Settings → About Phone → Tap "Build number" 7 times
#   Settings → Developer Options → Enable "USB Debugging"

# Verify device connected
adb devices
# Should show: "XXXXXXXX    device"

# Install release APK
flutter install --release
# Or manually:
# adb install build/app/outputs/flutter-apk/app-release.apk
```

### Step 2: Take Screenshots

**On Device (Easiest):**
1. Open Crosswatch app
2. Navigate to the screen you want to capture
3. Take screenshot: **Power + Volume Down** (hold for 1 second)
4. Screenshots saved to `Pictures/Screenshots/` folder
5. Repeat for each screen

**Via ADB (Better for automation):**
```bash
# Create directory for screenshots
mkdir -p ~/git/auryn-macmillan/vibes/screenshots/phone

# Take screenshot from command line
adb shell screencap -p /sdcard/screenshot-1.png

# Pull to your computer
adb pull /sdcard/screenshot-1.png ~/git/auryn-macmillan/vibes/screenshots/phone/01-home.png

# Clean up device
adb shell rm /sdcard/screenshot-1.png
```

**Quick Script for All Screenshots:**
```bash
#!/bin/bash
# Save as: capture-screenshots.sh

cd ~/git/auryn-macmillan/vibes
mkdir -p screenshots/phone

echo "Starting screenshot capture..."
echo "1. Navigate to HOME SCREEN, then press Enter"
read
adb shell screencap -p /sdcard/temp.png
adb pull /sdcard/temp.png screenshots/phone/01-home.png
adb shell rm /sdcard/temp.png
echo "✓ Screenshot 1 captured"

echo "2. Navigate to WORKOUT BUILDER, then press Enter"
read
adb shell screencap -p /sdcard/temp.png
adb pull /sdcard/temp.png screenshots/phone/02-builder.png
adb shell rm /sdcard/temp.png
echo "✓ Screenshot 2 captured"

echo "3. Start a workout and navigate to ACTIVE TIMER, then press Enter"
read
adb shell screencap -p /sdcard/temp.png
adb pull /sdcard/temp.png screenshots/phone/03-timer.png
adb shell rm /sdcard/temp.png
echo "✓ Screenshot 3 captured"

echo "4. Enable DARK MODE and go to HOME SCREEN, then press Enter"
read
adb shell screencap -p /sdcard/temp.png
adb pull /sdcard/temp.png screenshots/phone/04-dark-mode.png
adb shell rm /sdcard/temp.png
echo "✓ Screenshot 4 captured"

echo "All screenshots captured!"
ls -lh screenshots/phone/
```

### Step 3: Transfer Screenshots from Device

**Method A: USB File Transfer**
1. Connect device to computer via USB
2. Select "File Transfer" mode on device
3. Navigate to `Internal Storage/Pictures/Screenshots/`
4. Copy screenshots to `~/git/auryn-macmillan/vibes/screenshots/phone/`

**Method B: ADB Pull (if taken via ADB)**
```bash
adb pull /sdcard/Pictures/Screenshots/ ~/git/auryn-macmillan/vibes/screenshots/phone/
```

**Method C: Cloud Transfer**
1. Share screenshots to Google Drive/Dropbox from device
2. Download to computer

---

## Method 2: Capture from Emulator

### Step 1: Launch Android Emulator

```bash
# List available emulators
flutter emulators

# Launch emulator (or use Android Studio's AVD Manager)
flutter emulators --launch <emulator_id>

# Wait for emulator to fully boot (30-60 seconds)

# Run app on emulator
cd ~/git/auryn-macmillan/vibes
flutter run --release
```

### Step 2: Configure Emulator Display

1. In emulator, set display to realistic phone size:
   - Click `...` (Extended Controls) in emulator toolbar
   - Go to `Settings` → `Advanced`
   - Set proper display density (e.g., 420 dpi for Pixel phones)

2. Remove development indicators:
   - Disable "Show taps" in Developer Options
   - Hide navigation bar if needed

### Step 3: Capture Screenshots

**Using Emulator Camera Button:**
- Click the 📷 camera icon in emulator sidebar
- Screenshot saved to: `~/Desktop/` or `~/Pictures/`

**Using ADB:**
```bash
adb shell screencap -p /sdcard/screenshot.png
adb pull /sdcard/screenshot.png ~/git/auryn-macmillan/vibes/screenshots/emulator/
adb shell rm /sdcard/screenshot.png
```

---

## Method 3: Frame Screenshots (Professional Look)

Add device frames to make screenshots look more professional:

### Using DeviceFrames.com (Online, Free)

1. Go to https://deviceframes.com
2. Upload your screenshot
3. Select device frame (Pixel, Galaxy, iPhone, etc.)
4. Download framed image

### Using Facebook Device Frames

```bash
# Install device-frames tool
npm install -g device-frames

# Frame your screenshots
cd ~/git/auryn-macmillan/vibes/screenshots
device-frames -i phone/01-home.png -o framed/01-home-framed.png -d "Google Pixel 7"
```

### Using Figma (Most Professional)

1. Download device mockup templates from Figma Community
2. Import screenshots into mockups
3. Export as PNG

---

## Method 4: Tablet Screenshots (Optional but Recommended)

Play Store allows separate screenshots for tablets (7" and 10"):

```bash
# Launch tablet emulator
flutter emulators --launch <tablet_emulator_id>

# Or create new tablet AVD in Android Studio:
# - Device: Pixel Tablet
# - System Image: Android 13 (API 33)
# - Resolution: 2560x1600

# Capture same screens as phone, but tablet layout
```

---

## Post-Processing Screenshots

### Optional: Add Text Overlays

Add descriptive text to screenshots to highlight features:

**Using GIMP (Free):**
```bash
# Install if needed
sudo apt install gimp

# Open screenshot
gimp screenshots/phone/01-home.png

# Add text layer with feature descriptions
# Example: "Create Custom Workouts", "Track Your Progress"
```

**Using ImageMagick (Command Line):**
```bash
# Install if needed
sudo apt install imagemagick

# Add text overlay
convert screenshots/phone/01-home.png \
  -gravity south \
  -background '#1E88E5' \
  -fill white \
  -font DejaVu-Sans-Bold \
  -pointsize 60 \
  -splice 0x150 \
  -annotate +0+75 "Your Custom Workout Timer" \
  screenshots/processed/01-home-annotated.png
```

### Crop/Resize if Needed

```bash
# Ensure screenshots meet Play Store requirements
# Target: 1080x1920 for portrait (phones)

# Resize to standard dimensions
convert input.png -resize 1080x1920 -gravity center -extent 1080x1920 output.png

# Or batch process
for img in screenshots/phone/*.png; do
  convert "$img" -resize 1080x1920 -gravity center -extent 1080x1920 \
    "screenshots/processed/$(basename "$img")"
done
```

---

## Screenshot Checklist

Capture these essential screens:

### Light Mode
- [ ] Home screen with list of workouts
- [ ] Workout builder/editor interface
- [ ] Active workout timer (large countdown visible)
- [ ] Workout details or settings

### Dark Mode
- [ ] At least one key screen in dark mode (home or timer)

### Quality Checks
- [ ] No personal information visible
- [ ] No debug/developer indicators
- [ ] Good lighting/contrast
- [ ] All text readable
- [ ] UI elements properly aligned
- [ ] Status bar looks clean (consider hiding)

---

## Upload to Play Console

Once you have your screenshots:

1. **Organize by device type:**
   ```
   screenshots/
   ├── phone/           # Required
   │   ├── 01-home.png
   │   ├── 02-builder.png
   │   ├── 03-timer.png
   │   └── 04-dark.png
   ├── tablet-7inch/    # Optional
   └── tablet-10inch/   # Optional
   ```

2. **Verify format:**
   ```bash
   # Check all screenshots meet requirements
   for img in screenshots/phone/*.png; do
     file "$img"
     identify "$img"  # Shows dimensions
   done
   ```

3. **Upload to Play Console:**
   - Go to Play Console → Your App → Store Presence → Main Store Listing
   - Scroll to "Phone screenshots"
   - Drag and drop your PNG/JPG files
   - Arrange in order (drag to reorder)
   - Add captions (optional but recommended)

---

## Screenshot Caption Examples

When uploading to Play Console, you can add captions:

1. **"Create Custom HIIT, Tabata, and Circuit Workouts"**
2. **"Easy-to-Use Workout Builder"**
3. **"Clear, Distraction-Free Timer Display"**
4. **"Beautiful Dark Mode for Late-Night Workouts"**
5. **"Track Multiple Workout Types"**

---

## Quick Start Commands

```bash
# 1. Connect device and verify
adb devices

# 2. Install app
cd ~/git/auryn-macmillan/vibes
export PATH="/home/auryn/bin/flutter/bin:$PATH"
flutter install --release

# 3. Create screenshots directory
mkdir -p screenshots/phone

# 4. Take screenshots (manual on device, then pull)
adb pull /sdcard/Pictures/Screenshots/ screenshots/phone/

# 5. Verify screenshots
ls -lh screenshots/phone/
identify screenshots/phone/*.png

# 6. Upload to Play Console (via web browser)
```

---

## Troubleshooting

**Device not detected:**
```bash
# Check USB connection
lsusb

# Restart ADB
adb kill-server
adb start-server
adb devices
```

**Screenshots too large:**
```bash
# Compress without losing quality
optipng screenshots/phone/*.png

# Or resize
mogrify -resize 1080x1920 screenshots/phone/*.png
```

**Can't find screenshots on device:**
```bash
# Search for recent screenshots
adb shell "find /sdcard -name '*.png' -mtime -1"
```

---

## Current Status

**Screenshots Captured:** ⏳ Not yet  
**Directory Created:** ⏳ Not yet  
**Next Action:** Follow Method 1 to capture from your device

**Estimated Time:** 15-30 minutes to capture and organize all screenshots

# Build and Release Process

This document explains how automatic builds and releases work for Crosswatch.

## Automatic Builds

Every push to the `main` branch triggers three workflows:

### 1. Web Deployment (deploy-web.yml)
- Builds Flutter web app
- Deploys to GitHub Pages
- Live at: https://crosswatch.github.io/crosswatch-app/

### 2. Build and Release (build-and-release.yml)
- Builds Android APK and AAB
- Builds Linux x64 tarball
- Creates Git tag from `pubspec.yaml` version
- Publishes GitHub Release with all artifacts

## Workflow Details

### Build and Release Workflow

**Triggered by:**
- Every push to `main` branch
- Manual trigger via Actions tab

**Jobs:**

1. **Version Job**
   - Reads version from `pubspec.yaml` (e.g., `1.0.0+1`)
   - Creates tag like `v1.0.0+1`
   - Only creates tag if it doesn't exist yet
   - Outputs version for other jobs

2. **Build Android Job**
   - Installs Java 17
   - Installs Flutter stable
   - Builds release APK: `crosswatch-{version}-android.apk`
   - Builds release AAB: `crosswatch-{version}-android.aab`
   - Uploads both as artifacts

3. **Build Linux Job**
   - Installs GTK and build dependencies
   - Installs Flutter stable
   - Builds release Linux app
   - Creates tarball: `crosswatch-{version}-linux-x64.tar.gz`
   - Uploads as artifact

4. **Create Release Job**
   - Downloads all build artifacts
   - Generates release notes with:
     - Feature list
     - Download links
     - Web PWA link
     - Version and commit info
   - Creates GitHub Release with tag
   - Attaches all build artifacts

## Release Artifacts

Each release includes:

| File | Description | Platform |
|------|-------------|----------|
| `crosswatch-{version}-android.apk` | Android app for direct installation | Android 5.0+ |
| `crosswatch-{version}-android.aab` | Android App Bundle for Play Store | Android 5.0+ |
| `crosswatch-{version}-linux-x64.tar.gz` | Linux desktop app (extract and run) | Linux x64 |

## Versioning

### Current Version
Check `pubspec.yaml`:
```yaml
version: 1.0.0+1
```

Format: `MAJOR.MINOR.PATCH+BUILD`
- `1.0.0` - Semantic version (user-facing)
- `+1` - Build number (increments each build)

### Updating Version

**For new releases, update `pubspec.yaml`:**

```yaml
# Before
version: 1.0.0+1

# After (patch update)
version: 1.0.1+2

# After (minor update)
version: 1.1.0+3

# After (major update)
version: 2.0.0+4
```

**Rules:**
- Increment build number (+X) for every change
- Increment patch (X.X.PATCH) for bug fixes
- Increment minor (X.MINOR.X) for new features
- Increment major (MAJOR.X.X) for breaking changes

### Automatic Tagging

The workflow automatically:
1. Reads version from `pubspec.yaml`
2. Creates tag: `v{version}` (e.g., `v1.0.0+1`)
3. Pushes tag to GitHub
4. Skips if tag already exists

**Note:** If you push multiple commits with the same version, only the first push creates a release. Update the version in `pubspec.yaml` to trigger a new release.

## Manual Release Process

If you need to release manually:

### 1. Update Version
```bash
# Edit pubspec.yaml
version: 1.0.1+2
```

### 2. Commit and Push
```bash
git add pubspec.yaml
git commit -m "chore: bump version to 1.0.1+2"
git push origin main
```

### 3. Monitor Build
- Go to: https://github.com/Crosswatch/crosswatch-app/actions
- Watch "Build and Release" workflow
- Takes ~10-15 minutes for all builds

### 4. Verify Release
- Go to: https://github.com/Crosswatch/crosswatch-app/releases
- Latest release should appear with all artifacts
- Download and test each platform

## Platform-Specific Notes

### Android
- **APK**: Direct installation
  - Download APK
  - Enable "Install from Unknown Sources"
  - Install and run
- **AAB**: Google Play Store submission
  - Upload to Play Console
  - Requires signing key (not in CI)

### Linux
- **Tarball**: Extract and run
  ```bash
  tar -xzf crosswatch-1.0.0+1-linux-x64.tar.gz
  cd bundle
  ./crosswatch
  ```
- **Dependencies**: GTK3, PulseAudio
  ```bash
  sudo apt-get install libgtk-3-0 pulseaudio
  ```

### Web (PWA)
- Automatically deployed to GitHub Pages
- No manual download needed
- Users can install as PWA from browser

## Troubleshooting

### Build Fails

**Check the logs:**
1. Go to Actions tab
2. Click on failed workflow
3. Click on failed job
4. Expand failed step

**Common issues:**
- Missing dependencies: Update workflow to install them
- Flutter version: Workflow uses latest stable
- Build timeout: Increase timeout in workflow
- Artifact upload fails: Check artifact names and paths

### Tag Already Exists

If you get "tag already exists" error:
1. Delete the tag: `git tag -d v1.0.0+1 && git push origin :refs/tags/v1.0.0+1`
2. Update version in `pubspec.yaml`
3. Push again

### Release Not Created

If builds succeed but release isn't created:
1. Check "Create Release" job logs
2. Verify `GITHUB_TOKEN` has write permissions
3. Ensure at least one build succeeded
4. Check release notes generation step

## CI/CD Best Practices

### Before Pushing to Main

1. **Test locally:**
   ```bash
   flutter test
   flutter analyze
   flutter build apk --release
   flutter build linux --release
   ```

2. **Update version** if needed:
   ```bash
   # Edit pubspec.yaml
   version: 1.0.1+2
   ```

3. **Write clear commit message:**
   ```bash
   git commit -m "feat: add new feature"
   # or
   git commit -m "fix: resolve bug"
   # or
   git commit -m "chore: bump version"
   ```

### After Push

1. **Monitor workflows:**
   - Check Actions tab
   - Ensure all jobs succeed

2. **Test release:**
   - Download artifacts
   - Test on real devices
   - Verify functionality

3. **Announce release:**
   - Update README if needed
   - Post on social media
   - Notify users

## Future Enhancements

Possible improvements to CI/CD:

- [ ] iOS build (requires macOS runner + signing)
- [ ] Windows build (requires Windows runner)
- [ ] macOS build (requires macOS runner + signing)
- [ ] Automated testing in CI
- [ ] Code coverage reports
- [ ] Signed Android builds (add keystore to secrets)
- [ ] Automated Play Store publishing
- [ ] Changelog generation from commits
- [ ] Pre-release builds for beta testing

## Resources

- **GitHub Actions docs**: https://docs.github.com/en/actions
- **Flutter CI/CD**: https://docs.flutter.dev/deployment/cd
- **Semantic Versioning**: https://semver.org/
- **GitHub Releases**: https://docs.github.com/en/repositories/releasing-projects-on-github

---

**Questions?** Open an issue or check the Actions tab for build logs.

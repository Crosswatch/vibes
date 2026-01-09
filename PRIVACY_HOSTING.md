# Hosting Privacy Policy on GitHub Pages

## Quick Setup (5 minutes)

### Option 1: GitHub Pages (Recommended - Free)

1. **Enable GitHub Pages:**
   - Go to your repo: https://github.com/auryn-macmillan/vibes
   - Click `Settings` → `Pages`
   - Under "Source", select `Deploy from a branch`
   - Select branch: `main` or `master`
   - Select folder: `/ (root)`
   - Click `Save`

2. **Access your privacy policy:**
   - Wait 1-2 minutes for deployment
   - Your URL will be: `https://auryn-macmillan.github.io/vibes/privacy-policy.html`
   - Or with custom domain: `https://crosswatch.app/privacy-policy.html` (if configured)

3. **Use this URL in Play Console:**
   - When filling out the Play Store listing, paste the URL in the "Privacy Policy" field

### Option 2: Custom Domain (Optional)

If you own `crosswatch.app`:

1. **Add CNAME file:**
   ```bash
   echo "crosswatch.app" > CNAME
   git add CNAME
   git commit -m "Add custom domain for GitHub Pages"
   git push
   ```

2. **Configure DNS:**
   - Add these records at your domain registrar:
     - Type: `A`, Host: `@`, Value: `185.199.108.153`
     - Type: `A`, Host: `@`, Value: `185.199.109.153`
     - Type: `A`, Host: `@`, Value: `185.199.110.153`
     - Type: `A`, Host: `@`, Value: `185.199.111.153`
   - Or for subdomain:
     - Type: `CNAME`, Host: `www`, Value: `auryn-macmillan.github.io`

3. **Enable HTTPS:**
   - In GitHub Pages settings, check "Enforce HTTPS"
   - Wait for SSL certificate to provision (can take 24 hours)

### Option 3: Other Free Hosting

**Google Sites:**
- Go to https://sites.google.com
- Create new site
- Copy/paste the HTML content
- Publish and get URL

**Netlify Drop:**
- Go to https://app.netlify.com/drop
- Drag and drop `privacy-policy.html`
- Get instant URL

**GitHub Gist:**
- Create gist at https://gist.github.com
- Paste HTML content
- Use https://htmlpreview.github.io/?[your-gist-raw-url]

## Testing Your Privacy Policy

After hosting, test the URL:
```bash
curl -I https://auryn-macmillan.github.io/vibes/privacy-policy.html
```

Should return `HTTP/2 200` status.

## What Google Play Requires

- ✅ Must be a publicly accessible URL (not localhost)
- ✅ Must use HTTPS (GitHub Pages provides this)
- ✅ Must explain data collection practices
- ✅ Must be written in clear language
- ✅ Must include contact information

All requirements are met by `privacy-policy.html`!

## Current Status

**File Created:** ✅ `privacy-policy.html`  
**Hosted:** ⏳ Pending (follow Option 1 above)  
**URL:** Will be `https://auryn-macmillan.github.io/vibes/privacy-policy.html`

## Next Steps

1. Commit and push this file to GitHub
2. Enable GitHub Pages in repo settings
3. Wait 1-2 minutes for deployment
4. Verify URL works
5. Use URL in Play Store submission

```bash
git add privacy-policy.html PRIVACY_HOSTING.md
git commit -m "Add privacy policy for Play Store"
git push origin main
```

## Contact Email

The privacy policy uses `privacy@crosswatch.app`. If you don't have this email:

**Option 1:** Set up email forwarding at your domain registrar  
**Option 2:** Use your personal/business email  
**Option 3:** Use GitHub email: `auryn-macmillan@users.noreply.github.com`

To update the email, edit line 131 in `privacy-policy.html`.

# Mystic Nova Brief Studio

An interior design brief app for Mystic Nova Design Studio. Clients fill in a guided questionnaire through a private link. You review their answers, generate a professional design brief, send it for approval and export it as a PDF.

The app runs for free on two services:

- **GitHub Pages** puts the app online as a website.
- **Supabase** stores projects, client answers, uploaded files and your studio login.

Follow the parts in order: **A** (Supabase), **B** (GitHub), **C** (connect them), then **D** (optional). It takes about 30–40 minutes.

> **Already tried before?** You can keep your Supabase project. Just follow every step here — they're all safe to repeat. For GitHub, start with a fresh repository (Step 5).

---

## What's in this folder

| File | What it is |
|---|---|
| `index.html` | The app |
| `config.js` | Your connection settings (filled in during Part C) |
| `supabase/schema.sql` | Sets up your database (Part A) |
| `extras/keep-awake.yml` | Optional: stops the free database from sleeping (Part D) |
| `README.md` | This guide |

> **Windows tip:** don't double-click `.js`, `.sql` or `.yml` files. Windows tries to *run* them and shows an error. To look inside one, **right-click → Open with → Notepad**.

---

## Part A — Supabase (the database)

### Step 1. Create a project (skip if you already have one)
1. Go to https://supabase.com/dashboard and sign in. You can sign in with GitHub.
2. Click **New project**.
3. Fill in:
   - **Name:** `mystic-nova-brief`
   - **Database password:** make one up and save it somewhere safe. The app doesn't use it.
   - **Region:** **Southeast Asia (Singapore)**
4. Click **Create new project** and wait 1–2 minutes.

### Step 2. Turn on client links
1. In the left menu, click **Authentication**, then **Sign In / Providers**.
2. Switch on **Allow anonymous sign-ins** and click **Save**.

This lets clients open their private link without making an account.

### Step 3. Create your studio login
1. Go to **Authentication → Users**.
2. **If your email is already listed** from an earlier try, delete it first: click the **⋯** at the end of its row, choose **Delete user**, and confirm.
3. Click **Add user → Create new user**.
4. Type your email and a password. **Write the password down.**
5. **Tick "Auto Confirm User".**
6. Click **Create user**.

### Step 4. Set up the database
1. On your computer, open the `supabase` folder. Right-click `schema.sql` → **Open with → Notepad**.
2. Press **Ctrl + A**, then **Ctrl + C**, to copy everything.
3. In Supabase, click **SQL Editor** in the left menu, then **New query** (or **+**).
4. Click in the big empty box and press **Ctrl + V**.
5. Click **Run**, the green button at the bottom right. If Supabase asks you to confirm, click **Run this query**.
6. It should say **"Success. No rows returned"**.

You don't need to change anything in the file. It automatically makes the login from Step 3 your studio account.

---

## Part B — GitHub (putting the app online)

### Step 5. Start with a fresh repository
If you made a repository before, delete it so nothing old gets in the way:
1. Open it on GitHub and click **Settings**, the tab with the gear icon.
2. Scroll to the very bottom (**Danger Zone**) and click **Delete this repository**.
3. Follow the prompts and type the name to confirm.

Then create a new one:
1. Go to https://github.com/new
2. **Repository name:** `brief`
3. Choose **Public**. This is required for free hosting. Your clients' data stays private in Supabase.
4. Click **Create repository**.

### Step 6. Upload the files
1. Unzip `mystic-nova-brief-v2.zip`: right-click it → **Extract All** → **Extract**.
2. Open the extracted folder and keep opening folders until you see `index.html` and `config.js`.
3. Select **everything in that folder** with **Ctrl + A**: `index.html`, `config.js`, `README.md`, and the `supabase` and `extras` folders.
4. On your new GitHub repository page, click **uploading an existing file**.
5. Drag the selected files into the GitHub page and wait for them all to appear.
6. Click **Commit changes**.

**Check:** your repository's main page should now list `index.html` and `config.js` directly, **not** inside another folder. If they're inside a folder, delete the repository and repeat Steps 5–6, selecting the files *inside* the folder.

### Step 7. Turn on GitHub Pages
1. In the repository, click **Settings → Pages** (in the left menu).
2. Under **Build and deployment → Source**, choose **Deploy from a branch**.
3. Under **Branch**, choose **main** and **/ (root)**, then click **Save**.
4. Click the **Actions** tab at the top. Wait until **pages build and deployment** shows a **green tick** (about 1 minute).
5. Go back to **Settings → Pages**. At the top it says **"Your site is live at …"**. Click **Visit site**.

Your web address looks like `https://your-username.github.io/brief/`. Bookmark it.

---

## Part C — Connect the app to your database

Your site opens in **demo mode**, with a yellow bar at the top. That's expected.

### Step 8. Run the connection check
1. In the yellow bar, click **Connect your database**.
2. Fill in the two boxes. Keep the Supabase dashboard open in another tab to copy from:
   - **Project URL:** in Supabase, **Project Settings** (gear icon) → **Data API**. Copy the **Project URL**. It looks like `https://abcdefghijklmnopqrst.supabase.co`.
   - **Public key:** **Project Settings → API Keys**. Copy the **Publishable key** (starts with `sb_publishable_`). If there isn't one, open the **Legacy API keys** tab and copy **anon public** (starts with `eyJ`).
   - Never use a key labelled **secret** or **service_role**. The check will warn you if you do.
3. Click **Check connection**.
4. Every line should show a **tick**. If any line shows a warning, follow its **Fix**, then click **Check again**.

### Step 9. Save the details to your website
When everything has a tick, the page shows a box called **Put these details on your website**:
1. Click **Copy config.js text**.
2. On GitHub, open your repository, click `config.js`, then the **pencil icon** (Edit this file) at the top right.
3. Click inside the text, press **Ctrl + A**, then **Delete**.
4. Press **Ctrl + V** to paste.
5. Click **Commit changes**. If a second window appears, click **Commit changes** again.
6. Wait 2 minutes, then open your website and press **Ctrl + F5**.

The yellow bar is gone, and you'll see **Studio sign in**.

### Step 10. Sign in
Sign in with the email and password from Step 3. **Type the password by hand**, because your browser might fill in an old one.

**Can't sign in?** Click **Trouble signing in? Run the connection check**. At the bottom of that page, use **Set a new studio password**: type your email and a new password, copy the text it makes, and run it in Supabase's **SQL Editor** the same way as Step 4. Then sign in with the new password.

### Step 11. First things to do
1. Go to **Studio settings** and upload your Mystic Nova logo.
2. Optionally, click **Add two example projects** on the Projects page to try everything out.
3. To see the client side, create a test project, click **Invite client → Create client link**, and open the link in a **private/incognito window**.

---

## Part D — Optional: keep the free database awake

Free Supabase projects go to sleep after **7 days without use**. This makes GitHub visit your database every 3 days so it never sleeps. GitHub won't accept this file by drag-and-drop, so you create it on GitHub instead:

1. On your computer, right-click `extras/keep-awake.yml` → **Open with → Notepad**. Press **Ctrl + A**, then **Ctrl + C**.
2. On GitHub, in your repository, click **Add file → Create new file**.
3. In the name box, type exactly: `.github/workflows/keep-awake.yml`
4. Click in the big box and press **Ctrl + V**.
5. Click **Commit changes** (twice if asked).
6. To test it: go to the **Actions** tab, click **Keep database awake** on the left, then **Run workflow → Run workflow**. A green tick means it works.

If you skip this and the database falls asleep, open your Supabase dashboard and click **Restore project**. Nothing is lost.

---

## Everyday use

1. **New project:** enter the project and client basics.
2. **Invite client:** click **Create client link**, then **Copy message**. Send it by Viber, Telegram, LINE, email or Messenger, then click **Mark as sent**.
3. **The client** opens the link, agrees to the privacy notice, fills in the brief, uploads photos and plans, and presses **Submit**. They don't need an account.
4. The project shows **Submitted**. Open it, go to **Brief responses**, and click **Import responses**.
5. Check the **Overview** tab for budget gaps, conflicting answers and missing information.
6. Open **Design brief** and click **Generate brief**. Edit any section, and add observations, recommendations and images.
7. In **Versions and approval**, click **Save version**, then **Send for approval**.
8. The client opens the **same link** and approves or requests corrections.
9. Click **Export PDF** at any time.

**Link sent to the wrong person?** Open the project, click **Invitation → Reset link**, and send the new one. The old link stops working.

**Client can't use the link?** Fill in the brief with them in **Brief responses**. Then send them the PDF and use **Record approval**.

---

## Adding a freelancer as a second studio login
1. In Supabase, go to **Authentication → Users → Add user → Create new user**, using their email. Tick **Auto Confirm User**.
2. In **SQL Editor → New query**, run this with their email:
   ```sql
   insert into public.admins (user_id) select id from auth.users where lower(email) = 'their@email.com' on conflict do nothing;
   ```

Studio logins can see **every** project, so only add people you trust.

---

## Good to know
- **Free plan limits:** 500 MB of database, 1 GB of files, and 50 MB per file. Photos are compressed automatically.
- **Backups:** every month or so, go to Supabase **Table Editor**, open `projects` and `briefs`, and use **Export → CSV**.
- **Burmese or Thai text** displays correctly in the app, but not in the PDF export.
- **Updating the app later:** upload a new `index.html` with **Add file → Upload files**. Make sure the file is named exactly `index.html`. If Windows names the download `index (1).html`, rename it first.

## Troubleshooting

| What you see | What to do |
|---|---|
| A 404 page on your website | `index.html` must be on the repository's main page, not inside a folder, and named exactly `index.html`. Also check the **Actions** tab has a green tick. |
| A yellow "Demo mode" bar | `config.js` still has the placeholder text. Repeat Steps 8–9. |
| "That email and password don't match…" | Use **Set a new studio password** on the connection check page (Step 10). |
| "This isn't a studio account" | Copy the line shown on that screen and run it in Supabase's SQL Editor. Then sign out and sign in again. |
| A client sees "has not finished setting up client access" | Turn on **Allow anonymous sign-ins** (Step 2). |
| "Could not reach the database" | Run the connection check. If your Supabase project is paused, click **Restore project** in the Supabase dashboard. |
| Changes on GitHub don't show | Wait 2 minutes, then press **Ctrl + F5**. |

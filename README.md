# Mystic Nova Brief Studio

An interior design brief app for Mystic Nova Design Studio. Clients fill in a guided questionnaire through a private link. The studio reviews their answers, generates a professional design brief, sends it for approval and exports it as a PDF.

It runs for free on:

- **GitHub Pages**, which hosts the app (the website itself)
- **Supabase**, the free database that stores projects, client answers, uploaded files and your studio login

Setup takes about 30–45 minutes and needs no coding. Until it's done, the app runs in **demo mode**, which saves only in your own browser.

---

## What you need

- A free **GitHub** account: https://github.com/signup
- A free **Supabase** account: https://supabase.com (you can sign in with GitHub)
- The files in this folder:
  - `index.html` — the app
  - `config.js` — your connection settings
  - `supabase/schema.sql` — the database setup
  - `.github/workflows/keep-awake.yml` — keeps the free database awake
  - `README.md` — this guide

---

## Part 1 — Set up the database (Supabase)

### Step 1. Create a project
1. Sign in at https://supabase.com/dashboard and click **New project**.
2. Name it `mystic-nova-brief`.
3. Create a strong database password and save it somewhere safe. The app doesn't use it, but Supabase asks for it.
4. For **Region**, choose **Southeast Asia (Singapore)**. It's the closest to Thailand and Myanmar, so the app feels faster for your clients.
5. Click **Create new project** and wait a minute or two.

### Step 2. Turn on client links
1. Go to **Authentication → Sign In / Providers**. On older dashboards this is **Authentication → Providers**.
2. Find **Allow anonymous sign-ins** and switch it **on**. Click **Save**.

This lets clients open their private link without making an account. They can still only see the project they were invited to.

### Step 3. Create your studio login
1. Go to **Authentication → Users → Add user → Create new user**.
2. Enter your email and a password, and tick **Auto Confirm User**.
3. Click **Create user**.

### Step 4. Create the database
1. Open `supabase/schema.sql` in any text editor, such as Notepad or TextEdit.
2. On the **very last line**, replace `you@example.com` with the email from Step 3.
3. In Supabase, go to **SQL Editor → New query**.
4. Paste the whole file and click **Run**. You should see "Success. No rows returned".

### Step 5. Copy your connection details
1. Go to **Project Settings → Data API** (or **API**) and copy the **Project URL**. It looks like `https://abcdefgh.supabase.co`.
2. Go to **Project Settings → API Keys** and copy the **Publishable key**. If you only see older keys, use the **anon public** key.
3. Open `config.js` and paste both values between the quotes:

```js
window.BRIEF_CONFIG = {
  supabaseUrl: 'https://abcdefgh.supabase.co',
  supabaseAnonKey: 'sb_publishable_xxxxxxxx'
};
```

> Only use the **publishable / anon public** key. It is designed to be public, and your data is protected by the database rules.
> **Never** paste the **secret** or **service_role** key anywhere in these files.

---

## Part 2 — Put the app online (GitHub Pages)

### Step 6. Create a repository
1. On GitHub, click **+ → New repository**.
2. Name it, for example `brief` or `mystic-nova-brief`.
3. Choose **Public**. Free GitHub Pages needs a public repository. That's fine: the code is public, but your clients' data lives in Supabase behind your security rules.
4. Click **Create repository**.

### Step 7. Upload the files
1. In the new repository, click **uploading an existing file** (or **Add file → Upload files**).
2. Drag in `index.html`, `config.js`, `README.md` and the `supabase` folder.
3. Also drag in the `.github` folder, so the database stays awake (see "Good to know").
   - On a Mac, press **Cmd + Shift + .** in Finder to show hidden folders that start with a dot.
4. Click **Commit changes**.

### Step 8. Turn on GitHub Pages
1. In the repository, go to **Settings → Pages**.
2. Under **Build and deployment → Source**, choose **Deploy from a branch**.
3. Set **Branch** to `main` and the folder to `/ (root)`, then click **Save**.
4. Wait 1–2 minutes and refresh the page. GitHub shows your web address, for example `https://your-username.github.io/brief/`.

### Step 9. Sign in
Open your web address, sign in with the email and password from Step 3, then:

1. Go to **Studio settings**, upload your Mystic Nova logo and check the studio details.
2. Optionally, click **Add two example projects** to try the full workflow.
3. Bookmark the page, or add it to your phone's home screen.

---

## Everyday use

1. **New project**: enter the project and client basics.
2. **Invite client**: click **Create client link**, then **Copy message**. Send it by Viber, Telegram, LINE, email or Messenger, and click **Mark as sent**.
3. **The client** opens the link, agrees to the privacy notice, fills in the brief and uploads photos, plans and reference images. Their answers save automatically. Then they press **Submit**. They don't need an account.
4. The project shows as **Submitted**. Open it, go to **Brief responses**, and click **Import responses**.
5. Check the **Overview** tab for budget gaps, conflicting answers and outstanding information.
6. Open **Design brief** and click **Generate brief**. Edit any section, add observations and recommendations, reorder or remove sections, and add images.
7. In **Versions and approval**, click **Save version**, then **Send for approval**.
8. The client opens the **same link**, reads the brief, and either approves it (signing with their name) or requests corrections.
9. Click **Export PDF** at any time. Once the client approves, the PDF shows the approval.

**If a link goes to the wrong person**, open the project, click **Invitation → Reset link** and send the new link. The old link stops working immediately.

**If a client can't use the link**, fill in the brief with them in the **Brief responses** tab. Then send them the PDF and record their decision with **Record approval**.

**AI review (optional)**: on a project's Overview tab, click **Copy AI prompt**, paste it into Claude or another AI assistant, then paste the reply back. It is always labelled as a suggestion, not a confirmed design decision.

---

## Adding a freelancer or second designer
1. In Supabase, go to **Authentication → Users → Add user** and create their login (tick **Auto Confirm User**).
2. In **SQL Editor**, run this line with their email:
   ```sql
   insert into public.admins (user_id) select id from auth.users where email = 'their@email.com' on conflict do nothing;
   ```

Studio accounts can see **every** project. Only add people you trust with all client data.

To remove someone, delete them under **Authentication → Users**.

---

## Good to know

- **Free plan limits**: 500 MB of database, 1 GB of file storage, and up to 50 MB per uploaded file. Photos are compressed automatically, so this is plenty for a small studio. Share long videos as a link in the notes instead.
- **The database sleeps after 7 days without use** on the free plan. The `keep-awake` file uploaded in Step 7 visits it every 3 days so this doesn't happen. You can check it under the repository's **Actions** tab. If the database ever does go to sleep, open your Supabase dashboard and click **Restore project**. Nothing is lost.
- **Backups**: the free plan has no automatic backups you can download. Every month or so, go to Supabase's **Table Editor**, open `projects` and `briefs`, and use **Export → CSV**.
- **Burmese and Thai text** displays correctly in the app, but not in the PDF export, which uses a Latin font.
- **Clients and devices**: a client's answers save to the studio database, not their phone. If they open the link on another device, everything is still there.
- **Forgot your password?** In Supabase **SQL Editor**, run this with your own email and new password:
  ```sql
  update auth.users set encrypted_password = extensions.crypt('NEW-PASSWORD', extensions.gen_salt('bf')) where email = 'you@example.com';
  ```
  Once you're signed in, you can change your password in **Studio settings**.
- **Your own domain (optional, later)**: buy a domain such as `mysticnova.com` (about US$10–15 a year). Then add `brief.mysticnova.com` under **Settings → Pages → Custom domain**. GitHub's guide: https://docs.github.com/pages/configuring-a-custom-domain-for-your-github-pages-site

---

## Troubleshooting

| What you see | What to do |
|---|---|
| A yellow "Demo mode" bar | `config.js` still has the placeholder values. Check Step 5 and upload the edited `config.js` again. |
| "This isn't a studio account" after signing in | The last line of `schema.sql` didn't match your email. Run that line again in SQL Editor with the exact email from Step 3. |
| The client sees "The studio has not finished setting up client access" | Turn on **Allow anonymous sign-ins** (Step 2). |
| "Could not reach the database" | Check your internet connection. Then check that the Supabase project isn't paused (see "Good to know"). |
| A page shows a 404 error on GitHub | Wait 2 minutes after Step 8. Make sure `index.html` is at the top level of the repository, not inside a folder. |
| Changes don't show after you upload a new file | GitHub Pages takes 1–2 minutes to update. Then reload with Ctrl + F5 (Windows) or Cmd + Shift + R (Mac). |

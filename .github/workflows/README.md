# Velvet Horizon — GitHub Actions Workflows

## Files in this directory

| File | Purpose |
|------|---------|
| `publish-pack.yml` | Builds the `.mrpack`, publishes a versioned GitHub Release, updates a stable `latest` pre-release, and deploys `packwiz/` to GitHub Pages |

Companion script: `.github/scripts/export-mrpack.sh`

---

## publish-pack.yml

### What it does

1. **Triggers** automatically on every push to `main` that touches any file under `packwiz/**`. Also runs on manual dispatch (see below).

2. **Job: publish-mrpack** (sequence)
   - Checks out the repo.
   - Downloads the packwiz Linux binary (precompiled, no Go install needed — shaves ~90 s off CI time).
   - Runs `packwiz refresh` to recompute index hashes for any changed files.
   - Calls `.github/scripts/export-mrpack.sh`, which runs `packwiz modrinth export` and normalises the output to `velvet-horizon.mrpack`.
   - Reads the `version` field from `packwiz/pack.toml`.
   - If a GitHub Release with tag `v<version>` already exists, appends `-build.<short-sha>` to the tag (e.g. `v1.0.0-build.a3f9c12`) to avoid collision.
   - Creates a new versioned GitHub Release via `softprops/action-gh-release@v2` and attaches the `.mrpack`.
   - Deletes and recreates the `latest` pre-release, replacing its asset with the newly built pack. This is the stable URL the launcher subscribes to.
   - Uploads the `.mrpack` as a workflow artifact (30-day retention) for debugging.

3. **Job: publish-pages** (runs in parallel)
   - Re-exports the pack and copies `packwiz/` + the `.mrpack` into `_site/`.
   - Deploys `_site/` to GitHub Pages via `actions/deploy-pages@v4`.
   - Marked `continue-on-error: true` so a Pages failure never blocks the release.

### Stable player-facing URLs

After the first successful run you will have two stable URLs:

| URL | Description |
|-----|-------------|
| `https://kkamali04.github.io/velvet-horizon/velvet-horizon.mrpack` | GitHub Pages — always serves the pack from the latest Pages deploy |
| `https://github.com/kkamali04/velvet-horizon/releases/download/latest/velvet-horizon.mrpack` | `latest` pre-release asset — always points to the most recent build |

**Recommended launcher subscription URL:**
```
https://kkamali04.github.io/velvet-horizon/velvet-horizon.mrpack
```
Pages serves it over a CDN with reliable uptime, while the release asset URL requires an unauthenticated GitHub redirect.

For the Packwiz pack.toml URL pattern (used by packwiz-installer in launchers like Prism):
```
https://kkamali04.github.io/velvet-horizon/pack.toml
```

---

## How to trigger manually

1. Go to **Actions** → **Publish Modpack (.mrpack)** in the GitHub UI.
2. Click **Run workflow** (top-right of the workflow run list).
3. Choose branch `main`.
4. Optionally set **"Append +build.<sha> suffix"** to `true` to force a unique tag even if the version hasn't changed.
5. Click **Run workflow**.

---

## Required one-time setup in GitHub repo settings

These steps need to be done **once** by the repo owner before the first workflow run:

### 1. Enable GitHub Pages

1. Go to **Settings → Pages**.
2. Under **Build and deployment**, set **Source** to **GitHub Actions** (not a branch).
3. Click **Save**.

This lets `actions/deploy-pages@v4` write to Pages without a separate branch.

### 2. Confirm Actions permissions

1. Go to **Settings → Actions → General**.
2. Under **Workflow permissions**, select **Read and write permissions**.
3. Check **Allow GitHub Actions to create and approve pull requests** (needed for the release creation step).
4. Click **Save**.

### 3. No PAT or extra secrets needed

All steps use `${{ secrets.GITHUB_TOKEN }}`, which is auto-provisioned by GitHub for every workflow run. Nothing to configure in Settings → Secrets.

---

## Updating the packwiz version

The packwiz binary version is pinned at the top of each job:

```yaml
PACKWIZ_VERSION="0.17.4"
```

To upgrade: search for `PACKWIZ_VERSION` in `publish-pack.yml` and update both occurrences (one per job). Check releases at https://github.com/packwiz/packwiz/releases.

---

## Troubleshooting

### Where to look on failure

| Symptom | Where to check |
|---------|---------------|
| Export step fails (`No .mrpack found`) | The "Export .mrpack" step log — packwiz stderr often explains why |
| Version tag collision | The "Resolve version tag" step — it auto-appends `-build.<sha>` but logs the decision |
| Release creation fails (403) | Check **Settings → Actions → General → Workflow permissions** — must be Read & Write |
| Pages deploy fails | The "Deploy to GitHub Pages" step; also check **Settings → Pages** is set to GitHub Actions source |
| `packwiz refresh` fails | Usually means a mod file has a bad URL; check `packwiz/index.toml` for stale entries |

### Re-running a failed workflow

Navigate to **Actions**, click the failed run, then click **Re-run all jobs** (top-right). No side effects — the release step is idempotent (existing tags with the same name get a build suffix).

### Testing locally before pushing

```bash
# Install packwiz locally
curl -fsSL https://github.com/packwiz/packwiz/releases/download/v0.17.4/packwiz_linux_amd64.tar.gz | tar xz
sudo mv packwiz /usr/local/bin/

# From repo root
cd packwiz && packwiz refresh
cd ..
bash .github/scripts/export-mrpack.sh
# Output: packwiz/velvet-horizon.mrpack
```

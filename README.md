# proofs.rs blog

Markdown source for [proofs.rs/blog/](https://proofs.rs/blog/), built with Hugo and the [PaperMod](https://github.com/adityatelange/hugo-PaperMod) theme. Static output is served alongside proofs.rs by its existing Cloudflare Worker.

## Write and preview

1. Add a Markdown file under `content/` with TOML front matter (`title`, `date`, `slug`, and `author`). Leave the optional `description` absent if the post does not need one. Keep a published slug and RSS GUID stable. Imported articles also retain their original URL.
2. Install **Hugo extended v0.152.2** and Git. Run `sh scripts/build.sh`. It checks out the pinned PaperMod v8.0 commit on the first build and creates `public/`. To use a specific Hugo binary, set `HUGO=/path/to/hugo`.
3. Preview with `hugo server` after the first build. Static output is mounted under `/blog/`, with the feed at `/blog/rss.xml`.
4. Commit the source, not the generated directory. The website repository syncs the verified Hugo output and records the source commit for release. See the website repository's blog deployment instructions.

The site's templates omit inline scripts and styles to match the production content security policy. The introductory lean-miri post's formulas are rendered as MathML at build time. No external image or math-rendering scripts are needed. PaperMod is distributed under the MIT license, included at `static/licenses/papermod.txt`.

## Migration from Hashnode

The [old public RSS feed](https://proofs-rs.hashnode.dev/rss.xml) contained three articles. Their titles, bylines, dates, slugs, body content, and feed GUIDs were retained. The new site provides its own page metadata and keeps the old publication accessible; old subscriptions, comments, and private drafts are not migrated automatically.

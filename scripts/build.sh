#!/bin/sh
set -eu
cd "$(dirname "$0")/.."
: "${HUGO:=hugo}"
version=$("$HUGO" version)
case "$version" in
  "hugo v0.152.2-"*"+extended"*) ;;
  *) printf '%s\n' "Expected Hugo extended v0.152.2; got: $version" >&2; exit 1 ;;
esac
THEME_REV=a2eb47bb4b805116dcd34c1605d39835121f8dbe
if [ ! -d themes/PaperMod/.git ]; then
  mkdir -p themes/PaperMod
  git -C themes/PaperMod init -q
  git -C themes/PaperMod remote add origin https://github.com/adityatelange/hugo-PaperMod.git
  git -C themes/PaperMod fetch -q --depth=1 origin "$THEME_REV"
  git -C themes/PaperMod checkout --detach -q FETCH_HEAD
fi
if [ "$(git -C themes/PaperMod rev-parse HEAD)" != "$THEME_REV" ] ||
   [ -n "$(git -C themes/PaperMod status --porcelain)" ]; then
  printf '%s\n' "PaperMod must be clean at $THEME_REV" >&2
  exit 1
fi
exec "$HUGO" --cleanDestinationDir --noBuildLock "$@"

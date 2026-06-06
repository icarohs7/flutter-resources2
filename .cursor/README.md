# Cursor integration

Project rules live under `.agents/rules/` (`.mdc` for Cursor; `flutter/*.md` for Kimi — see `.agents/rules/README.md`).

After clone, create the junction so Cursor auto-loads the `.mdc` files:

```powershell
cmd /c mklink /J .cursor\rules ..\.agents\rules
```

Run from this directory (`.cursor/`). If `rules` already exists, remove it first.

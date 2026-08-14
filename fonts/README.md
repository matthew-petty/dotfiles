# Vendored fonts

Font binaries kept in-repo for disaster recovery and machine migration, so a
fresh machine doesn't depend on a download still being available.

**This is not a Stow package.** Do not run `stow fonts` — macOS font
registration via symlink is unreliable. Copy the files instead.

## Install (macOS)

```sh
cp fonts/FiraCodeNerdFont/*.ttf ~/Library/Fonts/
```

No `sudo`, no Font Book import. Verify with:

```sh
ghostty +list-fonts | grep -i firacode
```

## Install (Linux)

```sh
mkdir -p ~/.local/share/fonts
cp fonts/FiraCodeNerdFont/*.ttf ~/.local/share/fonts/
fc-cache -fv
```

## Contents

### FiraCodeNerdFont

Nerd Fonts patched build of Fira Code, 6 weights x 3 width variants:

| Variant | Family name | Icon width |
|---|---|---|
| Mono | `FiraCode Nerd Font Mono` | single cell — correct for terminals |
| Propo | `FiraCode Nerd Font Propo` | proportional |
| (plain) | `FiraCode Nerd Font` | double width |

`ghostty/.config/ghostty/config` uses the **Mono** variant so icons in
`eza`, `starship`, and `lualine` align to the character grid.

Licensed under the SIL Open Font License; see `FiraCodeNerdFont/LICENSE`.

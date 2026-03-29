# My-Macros

Personal backup of **macros**, **keyboard shortcuts**, and **small automations**—mostly Windows-focused (AutoHotkey, Office VBA, Python launchers, Pulover Macro Creator, and related helpers).

This folder is the working copy of a **separate Git repository**. In [Windows-10-Setup-Blueprint](https://github.com/zunaidFarouque/Windows-10-Setup-Blueprint) it is included as a **submodule** (`My-Macros` → `https://github.com/zunaidFarouque/My-Macros`), so setup notes and tooling can live in the blueprint while macros stay in their own history.

## What is here

| Area                           | Contents                                                                                                                                                                                                    |
| ------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **`Python scripts/`**          | Scripts plus a shortcut generator. Run `Shortcuts creator.py` to build one-click shortcuts into `Shortcuts/`. See [`Python scripts/readme.md`](./Python%20scripts/readme.md).                               |
| **`Old but useful ones/`**     | Archived but still handy material: AutoHotkey (e.g. Kando runners, hotkey helpers, mailing workflows), Pulover Macro Creator (`.pmc`), Word VBA (e.g. Zotero-related), configs and notes alongside scripts. |
| **`_MyMacros.code-workspace`** | VS Code / Cursor workspace file opening this folder as a single project.                                                                                                                                    |

## Clone / update (submodule)

If you cloned the blueprint without submodules:

```bash
git submodule update --init --recursive
```

To pull the latest macro repo from inside `My-Macros`:

```bash
cd My-Macros
git pull
```

## Scope

This is a **personal backup and reference** tree, not a polished product. Paths, hotkeys, and dependencies match one machine and workflow; adjust before reusing elsewhere.

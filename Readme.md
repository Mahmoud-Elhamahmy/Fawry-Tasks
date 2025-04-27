# mygrep

A mini version of the `grep` command, written in Bash.

This script can:
- Search for a string in a file (case-insensitive).
- Show matching lines.
- Show line numbers with `-n`.
- Invert matches with `-v`.
- Combine options like `-vn` or `-nv`.
- Display helpful usage info with `--help`.

---

## 📜 Usage

```bash
./mygrep.sh [OPTIONS] SEARCH_STRING FILE

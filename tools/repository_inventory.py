#!/usr/bin/env python3
from pathlib import Path
from collections import Counter
root=Path(__file__).resolve().parents[1]
files=[p for p in root.rglob('*') if p.is_file() and '.git' not in p.parts]
c=Counter(p.suffix.lower() or '<none>' for p in files)
print(f'TOTAL_FILES={len(files)}')
print(f'DOCUMENTATION_MD={sum(1 for p in files if p.suffix.lower()==".md")}')
print(f'SOURCE_SQL_PLSQL={sum(1 for p in files if "src" in p.parts and p.suffix.lower() in {".sql",".pks",".pkb"})}')
print(f'TEST_FILES={sum(1 for p in files if "tests" in p.parts)}')
for ext,count in sorted(c.items()): print(f'EXTENSION {ext} {count}')

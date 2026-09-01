#!/usr/bin/env python3
from pathlib import Path
import sys
root=Path(__file__).resolve().parents[1]
errors=[]
for p in sorted((root/'src').rglob('*')):
    if p.is_file() and p.suffix.lower() in {'.sql','.pks','.pkb'}:
        head='\n'.join(p.read_text(encoding='utf-8').splitlines()[:5]).upper()
        if 'TPSDBCORE01' not in head:
            errors.append(str(p.relative_to(root)))
if errors:
    print('SOURCE_HEADER_VALIDATION=FAIL')
    print('\n'.join(errors)); sys.exit(1)
print('SOURCE_HEADER_VALIDATION=PASS')

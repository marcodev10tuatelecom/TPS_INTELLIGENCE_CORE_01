#!/usr/bin/env python3
from pathlib import Path
import re, sys
root = Path(__file__).resolve().parents[1]
pre = root / 'src' / '00-precheck'
mut = re.compile(r'^\s*(CREATE|ALTER|DROP|TRUNCATE|INSERT|UPDATE|DELETE|MERGE|GRANT|REVOKE|AUDIT|NOAUDIT)\b', re.I)
errors=[]
for p in sorted(pre.glob('*.sql')):
    for n,line in enumerate(p.read_text(encoding='utf-8').splitlines(),1):
        if line.lstrip().startswith('--'):
            continue
        if mut.search(line):
            errors.append(f'{p.relative_to(root)}:{n}:{line.strip()}')
if errors:
    print('PRECHECK_READ_ONLY_VALIDATION=FAIL')
    print('\n'.join(errors))
    sys.exit(1)
print('PRECHECK_READ_ONLY_VALIDATION=PASS')

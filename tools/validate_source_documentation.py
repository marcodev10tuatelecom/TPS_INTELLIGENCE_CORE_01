#!/usr/bin/env python3
"""TPSDBCORE01 source-documentation validator.

Purpose
-------
Validate the repository-side documentation contract for Oracle source files without
connecting to Oracle and without executing SQL/PLSQL. This tool is intentionally
read-only with respect to database state.

Exit codes
----------
0: all scanned source files satisfy the mechanical metadata/routine checks.
1: at least one file is missing required metadata or routine documentation.
2: invocation/repository path error.

This tool checks presence, not truth. Human engineering review remains mandatory.
"""
from __future__ import annotations

import argparse
import pathlib
import re
import sys
from dataclasses import dataclass
from typing import Iterable

SOURCE_EXTENSIONS = {".sql", ".pks", ".pkb"}

REQUIRED_TAGS = (
    "@file",
    "@project",
    "@database",
    "@environment",
    "@oracle_target",
    "@gate",
    "@workstream",
    "@source_state",
    "@production_state",
    "@reversibility",
    "@purpose",
    "@business_impact",
    "@objects",
    "@dependencies",
    "@upstream",
    "@downstream",
    "@d3ka_role",
    "@d3ka_links",
    "@ai_role",
    "@security",
    "@performance",
    "@transaction",
    "@idempotency",
    "@failure_modes",
    "@rollback_recovery",
    "@tests",
    "@evidence",
    "@references",
    "@links",
    "@owner",
    "@change_history",
)

ROUTINE_RE = re.compile(
    r"\b(?:FUNCTION|PROCEDURE)\s+([A-Za-z][A-Za-z0-9_$#]*)\s*(?:\(|\b)",
    re.IGNORECASE,
)
ROUTINE_DOC_RE = re.compile(r"@routine\s+([A-Za-z][A-Za-z0-9_$#]*)", re.IGNORECASE)


@dataclass(frozen=True)
class Finding:
    path: pathlib.Path
    code: str
    detail: str


def iter_sources(root: pathlib.Path) -> Iterable[pathlib.Path]:
    src = root / "src"
    if not src.is_dir():
        raise FileNotFoundError(f"source directory not found: {src}")
    for path in sorted(src.rglob("*")):
        if path.is_file() and path.suffix.lower() in SOURCE_EXTENSIONS:
            yield path


def validate_file(path: pathlib.Path, root: pathlib.Path) -> list[Finding]:
    text = path.read_text(encoding="utf-8")
    findings: list[Finding] = []
    lower = text.lower()

    for tag in REQUIRED_TAGS:
        if tag.lower() not in lower:
            findings.append(Finding(path, "MISSING_TAG", tag))

    documented = {m.group(1).upper() for m in ROUTINE_DOC_RE.finditer(text)}
    routines = {m.group(1).upper() for m in ROUTINE_RE.finditer(text)}

    for routine in sorted(routines - documented):
        findings.append(Finding(path, "MISSING_ROUTINE_DOC", routine))

    # The @file value must at least reference the repository-relative source path.
    rel = path.relative_to(root).as_posix()
    file_line = re.search(r"@file\s+([^\r\n*]+)", text, re.IGNORECASE)
    if file_line and rel.lower() not in file_line.group(1).strip().lower():
        findings.append(Finding(path, "FILE_TAG_MISMATCH", f"expected {rel}"))

    return findings


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--root", default=".", help="repository root")
    parser.add_argument(
        "--report-only",
        action="store_true",
        help="always exit 0 while still printing findings; use only during retrofit",
    )
    args = parser.parse_args()

    root = pathlib.Path(args.root).resolve()
    try:
        sources = list(iter_sources(root))
    except FileNotFoundError as exc:
        print(f"FATAL={exc}", file=sys.stderr)
        return 2

    all_findings: list[Finding] = []
    for source in sources:
        all_findings.extend(validate_file(source, root))

    print(f"SOURCE_FILES={len(sources)}")
    print(f"FINDINGS={len(all_findings)}")
    for finding in all_findings:
        rel = finding.path.relative_to(root).as_posix()
        print(f"{finding.code}|{rel}|{finding.detail}")

    status = "PASS" if not all_findings else "FAIL"
    print(f"DOCUMENTATION_GATE={status}")

    if args.report_only:
        return 0
    return 0 if not all_findings else 1


if __name__ == "__main__":
    raise SystemExit(main())

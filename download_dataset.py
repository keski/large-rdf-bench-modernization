#!/usr/bin/env python3

import argparse
import gdown
import os
from pathlib import Path
import sys

parser = argparse.ArgumentParser()
parser.add_argument("--id", required=True)
parser.add_argument("--output", required=True)

args = parser.parse_args()

outdir = Path(args.output)
outdir.mkdir(parents=True, exist_ok=True)

cwd = os.getcwd()
try:
    os.chdir(outdir)
    result = gdown.download(
        id=args.id,
        output=None,
        quiet=False,
    )
finally:
    os.chdir(cwd)

sys.exit(0 if result else 1)

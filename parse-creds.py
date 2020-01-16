#!/usr/bin/env python3

from json import load
from sys import stdin

creds = load(stdin)

print(f"""
export AWS_ACCESS_KEY_ID={creds['AccessKeyId']}
export AWS_SECRET_ACCESS_KEY={creds['SecretAccessKey']}
export AWS_SESSION_TOKEN={creds['SessionToken']}
""")

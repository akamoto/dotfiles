#!/usr/bin/env python
import hashlib

filename = input("Enter the input file name: ")
with open(filename,"rb") as f:
    bytes = f.read() # read entire file as bytes
    readable_hash = hashlib.sha256(bytes).hexdigest();
    print(readable_hash)

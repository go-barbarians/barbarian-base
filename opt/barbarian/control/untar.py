#!/usr/bin/env python
# -*- coding: utf-8 -*-
import sys
import tarfile

def main():
    fname = sys.argv[1]
    tar = tarfile.open(fname, 'r:gz')
    tar.extractall()
    tar.close()

if __name__ == '__main__':
    sys.exit(main())

#!/opt/python27/bin/python
import os, sys

def main():
   path = sys.argv[1]
   print os.path.basename(path)
if __name__ == '__main__':
    main()

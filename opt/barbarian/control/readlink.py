#!/opt/python27/bin/python
import os, sys

def main():
   path = sys.argv[1]
   try:
      print os.path.join(os.path.dirname(os.readlink(path)), os.readlink(path))
      sys.exit()
   except OSError:
      print "invalid path"
      sys.exit(2)
if __name__ == '__main__':
    main()

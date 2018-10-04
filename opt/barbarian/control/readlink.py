#!/opt/python27/bin/python
import os, sys, getopt

def main(argv):
   follow = False
   path = ''
   try:
      opts, args = getopt.getopt(argv,'f:')
   except getopt.GetoptError:
      print 'readlink [-f] <link>'
      sys.exit(2)
   for opt, arg in opts:
      if opt == '-f':
         follow = True
         path = arg
      else:
         follow = False
   if path == '':
      path = sys.argv[1]
   try:
      if follow:
         print os.path.join(os.path.dirname(os.readlink(path)), os.readlink(path))
      else:
         print os.readlink(path)
      sys.exit()
   except OSError:
      print "invalid path"
      sys.exit(2)

if __name__ == '__main__':
   main(sys.argv[1:])

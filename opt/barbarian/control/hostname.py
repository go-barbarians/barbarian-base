#!/opt/python27/bin/python
import os, sys, getopt, socket

def main(argv):
   fqdn = False
   try:
      opts = getopt.gnu_getopt(argv,'f')
   except getopt.GetoptError:
      print "usage: hostname [-f]"
      sys.exit(2)
   for opt in opts:
      if opt == '-f':
         fqdn = True
      else:
         fqdn = False
   try:
      if fqdn:
         print socket.getfqdn()
      else:
         print socket.gethostname()
      sys.exit()
   except OSError:
      print "error"
      sys.exit(2)

if __name__ == '__main__':
   main(sys.argv[1:])

#!/opt/python27/bin/python
import sys, getopt
import urllib3

def main(argv):
   url = ''
   targetfile = ''
   try:
      opts, args = getopt.getopt(argv,'hu:t:',['url=','targetfile='])
   except getopt.GetoptError:
      print 'download.py -u <url> -t <targetfile>'
      sys.exit(2)
   for opt, arg in opts:
      if opt == '-h':
         print 'download.py -u <url> -t <targetfile>'
         sys.exit()
      elif opt in ('-u', '--url'):
         url = arg
      elif opt in ('-t', '--targetfile'):
         targetfile = arg
   urllib3.disable_warnings()
   with urllib3.PoolManager() as http:
      r = http.request('GET', url)
      with open(targetfile, 'wb') as fout:
         fout.write(r.data)

if __name__ == '__main__':
    main(sys.argv[1:])

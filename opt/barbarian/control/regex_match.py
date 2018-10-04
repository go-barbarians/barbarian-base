#!/usr/bin/python
import sys, getopt
import re

def main(argv):
   regex = ''
   test_string = ''
   match_num = 0
   try:
      opts, args = getopt.getopt(argv,'hr:t:m:',['regex=','test-string=', 'match-num='])
   except getopt.GetoptError:
      print 'regex_match -r <regex> -t <string-to-test> -m <match-number>'
      sys.exit(2)
   for opt, arg in opts:
      if opt == '-h':
         print 'regex_match -r <regex> -t <string-to-test> -m <match-number>'
         sys.exit()
      elif opt in ('-r', '--regex'):
         regex = arg
      elif opt in ('-t', '--test-string'):
         test_string = arg
      elif opt in ('-m', '--match-num'):
         match_num = arg
   p = re.compile(regex)
   rez = p.search(test_string)
   print rez.group(int(match_num))

if __name__ == '__main__':
    main(sys.argv[1:])

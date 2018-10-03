#!/opt/python27/bin/python
import sys,getopt
import zipfile

def main(argv):
  targetfile = ''
  outputdir = ''
  try:
    opts, args = getopt.getopt(argv,'ht:o:',['targetfile=', 'outputdir='])
  except getopt.GetoptError:
    print 'unzip.py -t <targetfile> -o <outputdir>'
    sys.exit(2)
  for opt, arg in opts:
    if opt == '-h':
      print 'unzip.py -t <targetfile> -o <outputdir>'
      sys.exit()
    elif opt in ('-t', '--targetfile'):
      targetfile = arg
    elif opt in ('-o', '--outputdir'):
      outputdir = arg

    zip_ref = zipfile.ZipFile(targetfile, 'r')
    zip_ref.extractall(outputdir)
    zip_ref.close()

if __name__ == '__main__':
    main(sys.argv[1:])

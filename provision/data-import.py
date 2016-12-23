import argparse
import codecs
import re
import sys

parser = argparse.ArgumentParser(description='Transforms USDA data files to csv')
parser.add_argument("-i", "--input", help="a USDA compliant input file")
parser.add_argument("-o", "--output", help="the psv output file")

args = parser.parse_args()
input_file = args.input

# Check if input file has been provided. If not, exit as we cannot work without it.
if input_file is None:
	print ("You need to provide an input file. Use -h for help.")
	sys.exit()

# Check if output filename has been provided. If not use the input filename
# and change the file type to csv
if args.output is None:
	output_file = re.sub('.txt', '.psv', input_file)
else:
	output_file = args.output

print(" ----- Starting file conversion ----- ")
print("Input file: {}, Output file: {}".format(input_file, output_file))

f = open(output_file, 'w')

with codecs.open(args.input, "r",encoding='utf-8', errors='replace') as fdata:
	for line in fdata:
		line = re.sub('\^', '|', line)
		line = re.sub('~', '', line)
		f.write(line)

f.close()
print(" ----- Finished file conversion ----- ")

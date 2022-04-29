#! /bin/sh
#
# pic2graph -- compile PIC image descriptions to bitmap images
#
# by Eric S. Raymond <esr@thyrsus.com>, July 2002
# modified by Sylvain Saubier <mail@sylsau.com>, March 2022
#
# In Unixland, the magic is in knowing what to string together...
#
# Take a pic/eqn diagram on stdin, emit cropped bitmap on stdout.
# The pic markup should *not* be wrapped in .PS/.PE, this script will do that.
# An -unsafe option on the command line enables gpic/groff "unsafe" mode.
# A --format FOO option changes the image output format to any format
# supported by convert(1).  An --eqn option changes the eqn delimiters.
# All other options are passed to convert(1).  The default format in PNG.
#
# Requires the groff suite and the ImageMagick tools.  Both are open source.
# This code is released to the public domain.
#
# Here are the assumptions behind the option processing:
#
# 1. Only a few options are relevant to groff(1)/gpic(1). -C doesn't matter
# 	because we're generating our own .PS/.PE, -[ntcz] are irrelevant because
# 	we're generating Postscript. -k/-K can be needed to handle non-english
# 	input text.
#
# 2. Many options of convert(1) are potentially relevant (especially 
# 	-background, -interlace, -border, and -comment).
#
# We don't have complete option coverage on eqn because this is primarily
# intended as a pic translator; we can live with eqn defaults. 
# We're assuming portrait letter page size is large enough to render the whole
# diagram.
# 
# The -density ImageMagick option needs to be treated separately as it
# is needed for reading the input PS file.
# 
set -o errexit
set -o xtrace

groff_opts=""
convert_density="-density 600"
convert_opts=""
convert_trim="-trim"
convert_size="+repage"
format="png"
eqndelim='$$'

while [ "$1" ]
do
    case $1 in
    -U | --unsafe)
	groff_opts="$groff_opts -U";;
    -f | --format)
	format=$2
	shift;;
    -q | --quality)
	if [ $2 -eq 1 ]; then
		convert_density="-density 300"
	elif [ $2 -eq 2 ]; then
		convert_density="-density 600"
	elif [ $2 -eq 3 ]; then
		convert_density="-density 900"
	else
		convert_density="-density $2"
	fi
	shift;;
    -b)
	convert_opts="$convert_opts -background white -flatten";;
    -s)
	convert_size="-resize $2 +repage"
	shift;;
    -k)
	groff_opts="$groff_opts -k";;
    -K)
	groff_opts="$groff_opts -K $2"
	shift;;
    --eqn)
	eqndelim="$2"
	shift;;
    -v | --version)
	#echo "GNU pic2graph (groff) version @VERSION@"
	echo "pic2graph modernized edition by Sylvain Saubier, version 0.9"
	exit 0;;
    --help)
	echo "usage: pic2graph [ option ...] < in > out"
	exit 0;;
    *)
	convert_opts="$convert_opts $1";;
    esac
    shift
done

if [ "$eqndelim" ] ; then
    eqndelim="delim $eqndelim"
fi

# See if the installed version of convert(1) is new enough to support the -trim
# option.  Versions that didn't were described as "old" as early as 2008.
is_convert_recent=`convert -help | grep -e -trim`
if [ -z "$is_convert_recent" ]
then
    echo "$0: warning: falling back to old '-crop 0x0' trim method" >&2
    convert_trim="-crop 0x0"
fi

trap 'exit_status=$? ; echo $0: error > /dev/stderr && exit $exit_status' EXIT INT TERM

# Here goes:
# 1. Wrap stdin in dummy .PS/PE macros (and add possibly null .EQ/.EN)
# 2. Process through eqn and pic to emit troff markup.
# 3. Process through groff to emit Postscript.
# 4. Use convert(1) to crop the PostScript and turn it into a bitmap.
(echo ".EQ"; echo $eqndelim; echo ".EN"; echo ".PS"; cat; echo ".PE") | \
	groff -e -p $groff_opts -Tps -P-pletter | \
	convert $convert_density - $convert_opts $convert_trim $convert_size $format:-

# End

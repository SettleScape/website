#!/bin/sh
print_usage() {
    echo "Usage: $0 <input.svg> <output.ico>"
}
print_helptext() {
    echo 'Generates an .ICO file from a given .SVG file.'
    print_usage
}

## Print helptext if requested.
if [ "$1" = '-h' -o "$1" = '--help' ]; then
    print_helptext
    exit 0
fi

## Ensure that sufficient arguments were provided.
if [ ! $# -eq 2 ]; then
    echo "Error:  Invalid number of parameters." >&2
    print_usage >&2
    exit 1
fi

## Organize inputs.
IN="$1"
OUT="$2"
# unset 1 2

## Check whether OUT already exists
if [ -f "$OUT" ]; then
    echo "Error: Output file '$OUT' already exists." >&2
    exit 2
fi

## Make sure IN exists
if [ ! -f "$IN" ]; then
    echo "Error: Input file '$IN' does not exist." >&2
    exit 3
fi

## Make sure IN is a valid SVG file
if ! file "$IN" | grep -qi "svg"; then
    echo "Error: '$IN' is not a valid SVG file." >&2
    exit 4
fi

################################################################################

## Ensure clean exits for rest of script
cleanup() {
    EXIT="$?"
    set +e
    rm -rf "$TMPDIR" 2>/dev/null
    exit "$EXIT"
}
trap cleanup EXIT
set -e

## Create a temporary directory
TMPDIR=$(mktemp -d -t "svg2ico-XXXXXX") #TODO: Maybe set the prefix dynamically, per `$0`?

## Generate PNG files for all common favicon sizes
TMPFMT='.png'
for SIZE in 16 32 48 64 128 256; do
    inkscape -w "$SIZE" -h "$SIZE" -o "$TMPDIR/$SIZE.$TMPFMT" "$IN" 2>/dev/null # --export-png-use-dithering=true --export-png-compression=0
done
unset IN

## Combine the PNG files into a single ICO file
## (with flags to enable transparency and lossless compression)
convert -compress RLE -depth 32 -background transparent "$TMPDIR/"*".$TMPFMT" "$OUT" 2>/dev/null #NOTE: `convert` is `magick` on newer versions of ImageMagick.
unset TMPDIR TMPFMT OUT

## Done
cleanup

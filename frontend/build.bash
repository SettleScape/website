#!/usr/bin/env bash
## Builds a webapp

## Paths and variables
export \
    SRC_DIR="$PWD/src" \
    DIST_DIR="$PWD/dist" \
    NODE_BIN="$PWD/node_modules/.bin" \
    CSS_LIST=$(mktemp)

## Wipe the old `$DIST_DIR`
if [[ -d "$DIST_DIR" ]]; then
    if [[ $(lsof "$DIST_DIR" 2>/dev/null) ]]; then
        echo "'$DIST_DIR' is in use; please end whatever process is using it."
        exit 1
    fi
    rm -rf "$DIST_DIR"
fi
mkdir -p "$DIST_DIR"

## Define a function for each filetype
function do-ext {
    eval "$3" "$1" "$2"
    if [[ $? -eq 0 ]]; then
        echo "'$1' > '$2'"
    else
        echo "Error on '$1' > '$2'" >&2
    fi
}
function do-css {
    echo "$1" >> "$CSS_LIST" && \
    echo "'$1' >> '$DIST_DIR/styles.css'"
}
function xml {
    "$NODE_BIN/minify-xml" "$1" > "$2"
}
function svg {
    xml "$1" "$2" && \
    ./svg2ico.sh "$2" "${2%.*}.ico"
    # echo "'$1' > '${2%.*}.ico'"
}
function xxx {
    cat "$1" > "$2"
}

## Do the thing
while IFS= read -r -d $'\0' IN; do
    OUT="${IN/#$SRC_DIR/$DIST_DIR}"

    OUT_DIR="$(dirname "$OUT")"
    [[ ! -d "$OUT_DIR" ]] && mkdir -p "$OUT_DIR"

    function do-cat { cat "$IN" > "$OUT"; }
    case "${IN##*.}" in
        'css')         do-css "$IN" "$OUT"     & continue ;;
        'xml'|'xhtml') do-ext "$IN" "$OUT" xml & continue ;;
        'svg')         do-ext "$IN" "$OUT" svg & continue ;;
        *)             do-ext "$IN" "$OUT" xxx & continue ;;
    esac
done < <(find "$SRC_DIR" \( -type f -o -type l \) -print0)
wait

## Concatenate and optimize CSS
"$NODE_BIN/cleancss" -o "$DIST_DIR/styles.css" $(cat "$CSS_LIST" | sort | xargs)
rm "$CSS_LIST"

## Done
rmdir "$DIST_DIR/"* 2>/dev/null #TODO: Delete all empty directories recursively, starting at the deepest ones.
exit 0

#!/usr/bin/env bash
## Builds a webapp

## Paths
export \
    SRC_DIR="$PWD/src" \
    DIST_DIR="$PWD/dist" \
    NODE_BIN="$PWD/node_modules/.bin"

## Wipe the old `$DIST_DIR`
if [[ ! -d "$DIST_DIR" ]]; then
    if [[ $(lsof "$DIST_DIR" 2>/dev/null) ]]; then
        echo "'$DIST_DIR' is in use; please end whatever process is using it."
        exit 1
    fi
    rm -rf "$DIST_DIR"
fi
mkdir -p "$DIST_DIR"

## Do the thing
find "$SRC_DIR" -type f -print0 | while IFS= read -r -d $'\0' IN; do
    OUT="${IN/#$SRC_DIR/$DIST_DIR}"

    OUT_DIR="$(dirname "$OUT")"
    [[ ! -d "$OUT_DIR" ]] && mkdir -p "$OUT_DIR"

    function do-cat { cat "$IN" > "$OUT"; }
    case "${IN##*.}" in
        'css') "$NODE_BIN/minify" "$IN" >> "$OUT_DIR/styles.css" & continue ;;
        'xml'|'xhtml'|'svg') "$NODE_BIN/minify-xml" "$IN" > "$OUT" & continue;;
        *) do-cat & continue ;;
    esac
done
wait

## Done
exit 0

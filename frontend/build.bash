#!/usr/bin/env bash
## Builds a webapp

## Paths
export \
    SRC_DIR="$PWD/src" \
    DIST_DIR="$PWD/dist" \
    NODE_BIN="$PWD/node_modules/.bin"

## Wipe the old `$DIST_DIR`
if [[ -d "$DIST_DIR" ]]; then
    if [[ $(lsof "$DIST_DIR" 2>/dev/null) ]]; then
        echo "'$DIST_DIR' is in use; please end whatever process is using it."
        exit 1
    fi
    rm -rf "$DIST_DIR"
fi
mkdir -p "$DIST_DIR"

## Do the thing
declare -a CSS_FILES=()
while IFS= read -r -d $'\0' IN; do
    OUT="${IN/#$SRC_DIR/$DIST_DIR}"

    OUT_DIR="$(dirname "$OUT")"
    [[ ! -d "$OUT_DIR" ]] && mkdir -p "$OUT_DIR"

    function do-cat { cat "$IN" > "$OUT"; }
    case "${IN##*.}" in
        'css') CSS_FILES+=("$IN") && echo "$IN >> $DIST_DIR/styles.css" && continue ;;
        'xml'|'xhtml'|'svg') "$NODE_BIN/minify-xml" "$IN" > "$OUT" & echo "$IN > $OUT" && continue;;
        *) do-cat & echo "$IN > $OUT" && continue ;;
    esac
done < <(find "$SRC_DIR" -type f -print0)
wait

## Concatenate and optimize CSS
"$NODE_BIN/cleancss" -o "$DIST_DIR/styles.css" $(echo "${CSS_FILES[@]}" | xargs)

## Done
exit 0

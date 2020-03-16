#!/bin/bash
# md-toc.sh
############
# Generates a Table of Contents getting a markdown file as input.
#
# Inspiration for this script:
# https://medium.com/@acrodriguez/one-liner-to-generate-a-markdown-toc-f5292112fd14
#
# The list of invalid chars is probably incomplete, but is good enough for my
# needs.
# Got the list from:
# https://github.com/thlorenz/anchor-markdown-header/blob/56f77a232ab1915106ad1746b99333bf83ee32a2/anchor-markdown-header.js#L25
#
# The list of valid markdown extensions were obtained here:
# https://superuser.com/a/285878
#
# meleu - March/2020

INVALID_CHARS="'[]/?!:\`.,()*\";{}+=<>~$|#@&â€“â€”"
VALID_EXTENSIONS='markdown|mdown|mkdn|md|mkd|mdwn|mdtxt|mdtext|text|Rmd|txt'

USAGE="\nUsage:\n$0 markdownFile.md"

toc() {
  local inputFile="$1"
  local codeBlock='false'
  local line
  local level
  local title
  local anchor

  while IFS='' read -r line || [[ -n "$line" ]]; do
    if [[ "$line" = '```'* ]]; then
      [[ "$codeBlock" = 'false' ]] && codeBlock='true' || codeBlock='false'
      continue
    fi

    [[ "$codeBlock" = 'true' ]] && continue

    title="$(sed -E 's/^#+ //' <<< "$line")"

    if [[ "$line" = '# '* ]]; then
      echo "- [${title}](${inputFile})"
      continue
    fi

    level="$(sed -E 's/^#(#+).*/\1/; s/#/    /g' <<< "$line")"
    anchor="$(tr '[:upper:] ' '[:lower:]-' <<< "$title" | tr -d "$INVALID_CHARS")"

    echo "${level}- [${title}](${inputFile}#${anchor})"
  done <<< "$(grep -E '^(#{1,10} |```)' "$inputFile" | tr -d '\r')"
}

validate_file() {
  local mdfile="$1"

  if [[ -z "$mdfile" ]]; then
    echo "ERROR: missing input markdown file." >&2
    return 1
  elif [[ ! -f "$mdfile" ]]; then
    echo "ERROR: \"$mdfile\": no such file." >&2
    return 1
  elif [[ ! "${mdfile##*.}" =~ ^($VALID_EXTENSIONS)$ ]]; then
    echo "ERROR: \"$mdfile\": invalid file extension (is it a markdown formatted file?)." >&2
    echo "Valid extensions: $(tr '|' ' ' <<< "$VALID_EXTENSIONS")" >&2
    return 1
  fi
}


main() {
  local mdfile
  for mdfile in "$@"; do
    validate_file "$mdfile" && toc "$mdfile" || echo -e "$USAGE"
  done
}

[[ "$0" == "$BASH_SOURCE" ]] && main "$@"

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
# meleu - January/2019

INVALID_CHARS="'[]/?!:\`.,()*\";{}+=<>~$|#@&â€“â€”"
VALID_EXTENSIONS='markdown|mdown|mkdn|md|mkd|mdwn|mdtxt|mdtext|text|Rmd|txt'

USAGE="\nUsage:\n$0 markdownFile.md"

toc() {
  local inputFile="$1"
  local multiFiles="$2"
  local codeBlock='false'
  local line
  local level
  local title
  local anchor

  if [[ "$multiFiles" = "true" ]]; then
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
  else
    while IFS='' read -r line || [[ -n "$line" ]]; do
      level="$(sed -E 's/^#(#+).*/\1/; s/#/    /g; s/^    //' <<< "$line")"
      title="$(sed -E 's/^#+ //' <<< "$line")"
      anchor="$(tr '[:upper:] ' '[:lower:]-' <<< "$title" | tr -d "$INVALID_CHARS")"
      echo "${level}- [${title}](#${anchor})"
    done <<< "$(grep -E '^#{2,10} ' "$inputFile" | tr -d '\r')"
  fi
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

  if [[ "$#" -le 1 ]]; then
    mdfile="$1"
    validate_file "$mdfile" && toc "$mdfile" || echo -e "$USAGE"
  else
    for mdfile in "$@"; do
      validate_file "$mdfile" && toc "$mdfile" true || echo -e "$USAGE"
    done
  fi
}

[[ "$0" == "$BASH_SOURCE" ]] && main "$@"

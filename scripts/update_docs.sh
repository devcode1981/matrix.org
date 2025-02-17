#!/bin/bash -eux

# update_docs.sh: regenerates the autogenerated files on the matrix.org site.
# At present this includes:
#
#   * the spec intro and appendices, at https://matrix.org/docs/spec/ and
#      https://matrix.org/docs/spec/appendices (though note that it is planned
#      to move these to https://spec.matrix.org)
#
#   * the guides and howtos at https://matrix.org/docs/develop/
#
#   * the RapiDoc UI for the API
#
# Note that the historical versions of the CS spec and swagger, and the spec
# index, are generated manually within matrix-doc and then *committed to git*.

# Note that this file is world-readable unless someone plays some .htaccess hijinks

SELF="${BASH_SOURCE[0]}"
if [[ "${SELF}" != /* ]]; then
  SELF="$(pwd)/${SELF}"
fi
SELF="${SELF/\/.\///}"
cd "$(dirname "$(dirname "${SELF}")")"

# Set up foundations for RapiDoc API playground
rm -fr unstyled_docs/api/
mkdir -p unstyled_docs/api/

# copy the unstyled docs and add the styling
rm -rf content/docs
cp -r unstyled_docs content/docs
find "content/docs" -name '*.html' -type f |
    xargs "./scripts/add-matrix-org-stylings.pl" "./legacy-spec/html-fragments/"
cp -r legacy-spec/css content/docs/css

# Set up RapiDoc itself at the end so it doesn’t get styled
cp -r rapidoc/* content/docs/api/

#!/usr/bin/env bash
set -e
xargs=$(which gxargs || which xargs)
[ "$TRACE" ] && set -x

CONFIG=$@

for line in $CONFIG; do
  eval "$line"
done

OUTPUT_FILE="$FCI_BUILD_OUTPUT_DIR/kup_app.app.zip"
TOKEN="$GITHUB_TOKEN"

GH_API="https://api.github.com"
GH_REPO="$GH_API/repos/webskydavid/kup-app"
GH_TAGS="$GH_REPO/releases"
ACCEPT="Accept: application/vnd.github.v3+json"
AUTHORIZATION="Authorization: Token $TOKEN"
WGET_ARGS="--content-disposition --auth-no-challenge --no-cookie"
CURL_ARGS="-LJO#"

echo "----- VARS"
echo $FCI_BUILD_OUTPUT_DIR
echo $FCI_BUILD_ID
echo $FCI_BUILD_OUTPUT_DIR
echo "-----"

curl -o /dev/null \
    -sH "$AUTHORIZATION" \
    $GH_REPO || { echo "Error: Invalid token!";  exit 1; }

response=$(curl -sH "$ACCEPT" "$AUTHORIZATION" $GH_TAGS)

eval $(echo "$response" | grep -m 1 "id.:" | grep -w id | tr : = | tr -cd '[[:alnum:]]=')
[ "$id" ] || { echo "Error: Fail to get the id in latest repo "; echo "$response" | awk 'length($0)<100' >&2; exit 1; }

echo "Upload file..."
BASENAME=$(basename $OUTPUT_FILE)
echo $BASENAME

ls $FCI_BUILD_OUTPUT_DIR


curl -v \
    --data-binary @"$OUTPUT_FILE" \
    -H "Accept: application/vnd.github.v3+json" \
    -H "Authorization: token $TOKEN" \
    -H "Content-Type: application/octet-stream" \
    "https://uploads.github.com/repos/webskydavid/kup-app/releases/$id/assets?name=$BASENAME"
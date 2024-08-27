#!/bin/bash
set -euo pipefail

# This script uses tags from docker hub to determine the next version number.
show_help() {
  echo "Usage: `basename "$0"` <version>"
  echo "(Remember to push tags using 'git push --tags')"
}

if [ $# -ne 1 ]; then
  show_help
  exit 1
fi

VERSION=${1:-latest}
IMAGE_NAME="flink-kubernetes-operator"
ORG=ecraft
CONTAINER_NAME="$ORG/$IMAGE_NAME"

# Get tags from docker hub to show latest version
# DOCKERHUB_TAGS=`docker-hub -o $ORG -r $IMAGE_NAME tags --format json`
# if [[ "$DOCKERHUB_TAGS" == *"Error"* ]]; then
#   echo "Failed to retrieve tags from Docker Hub."
#   echo "Make sure the docker-hub cli is installed:"
#   echo "'pip3 install docker-hub'"
#   echo "Make sure you are logged in to docker-hub:"
#   echo "'docker-hub login'"
#   echo "$DOCKERHUB_TAGS"
# else
#   # Show the latest published version
#   LATEST_PUBLISHED=`echo $DOCKERHUB_TAGS | jq -r 'max_by(."Last updated").Name'`
#   echo "Latest published version is: $LATEST_PUBLISHED"
# fi

# Create a git tag for the given service and version number
GIT_TAG="release/$IMAGE_NAME/$VERSION"

# Create a tag
git fetch

if git ls-remote --exit-code --tags origin "$GIT_TAG" >/dev/null 2>&1; then
    echo "The tag '$GIT_TAG' has already been pushed."
    echo "The CI pipeline may have failed building this tag."
    echo "Try to clean up the non-working tags and try again."
    exit 1
fi

git tag -a "${GIT_TAG}" -m "${GIT_TAG}"
echo "Added tag ${GIT_TAG} (remember to git push --tags)"
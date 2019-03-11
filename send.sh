#!/bin/bash

if [ -z "$2" ]; then
  echo -e "WARNING!!\nYou need to pass the WEBHOOK_URL environment variable as the second argument to this script.\n" && exit
fi

echo -e "[Webhook]: Sending webhook to Discord...\\n";

case $1 in
  "success" )
    EMBED_COLOR=3066993
    AVATAR="https://about.gitlab.com/images/press/logo/png/gitlab-icon-rgb.png"
    ;;

  "failure" )
    EMBED_COLOR=15158332
    AVATAR="https://about.gitlab.com/images/press/logo/png/gitlab-icon-rgb.png"
    ;;

  * )
    EMBED_COLOR=0
    AVATAR="https://about.gitlab.com/images/press/logo/png/gitlab-icon-rgb.png"
    ;;
esac

AUTHOR_NAME="$(git log -1 "$CI_COMMIT_SHA" --pretty="%aN")"
COMMITTER_NAME="$(git log -1 "$CI_COMMIT_SHA" --pretty="%cN")"
COMMIT_SUBJECT="$(git log -1 "$CI_COMMIT_SHA" --pretty="%s")"
COMMIT_MESSAGE="$(git log -1 "$CI_COMMIT_SHA" --pretty="%b")"
JOB_NAME="$(echo "$CI_JOB_NAME" | tr _ " ")"

if [ "$AUTHOR_NAME" == "$COMMITTER_NAME" ]; then
  CREDITS="'[\`$AUTHOR_NAME\`]($CI_PAGES_URL/$GITLAB_USER_LOGIN)' authored & committed"
else
  CREDITS="$AUTHOR_NAME authored & '[\`$COMMITTER_NAME\`]($CI_PAGES_URL/$GITLAB_USER_LOGIN)' committed"
fi

if [[ $CI_MERGE_REQUEST_ID != false ]]; then
  URL="$CI_MERGE_REQUEST_PROJECT_URL"
else
  URL=""
fi

TIMESTAMP=$(date --utc +%FT%TZ)
WEBHOOK_DATA='{
  "username": "",
  "avatar_url": "https://about.gitlab.com/images/press/logo/png/gitlab-icon-rgb.png",
  "embeds": [ {
    "color": '$EMBED_COLOR',
    "author": {
      "name": "Job '"$JOB_NAME"' (Pipeline #'"$CI_PIPELINE_IID"') - '"$CI_PROJECT_PATH"'",
      "url": "'"$CI_PIPELINE_URL"'",
      "icon_url": "'$AVATAR'"
    },
    "title": "'"$COMMIT_SUBJECT"'",
    "url": "'"$URL"'",
    "description": "'"${COMMIT_MESSAGE//$'\n'/ }"\\n\\n"$CREDITS"'",
    "fields": [
      {
        "name": "Commit",
        "value": "'"[\`${CI_COMMIT_SHA:0:7}\`]($CI_PROJECT_URL/commit/$CI_COMMIT_SHA)"'",
        "inline": true
      },
      {
        "name": "Branch",
        "value": "'"[\`$CI_COMMIT_REF_NAME\`]($CI_PROJECT_URL/commits/$CI_COMMIT_REF_NAME)"'",
        "inline": true
      },
      {
        "name": "Runner",
        "value": "'"[\`$CI_RUNNER_DESCRIPTION\`]($CI_PROJECT_URL/runners/$CI_RUNNER_ID)"'",
        "inline": true
      },
      {
        "name": "Architecture",
        "value": "'"$CI_RUNNER_EXECUTABLE_ARCH"'",
        "inline": true
      }
    ],
    "timestamp": "'"$TIMESTAMP"'"
  } ]
}'

echo "$WEBHOOK_DATA"

(curl --fail --progress-bar -A "GitLabCI-Webhook" -H Content-Type:application/json -H X-Author:n3bs#8097 -d "$WEBHOOK_DATA" "$2" \
  && echo -e "\\n[Webhook]: Successfully sent the webhook.") || echo -e "\\n[Webhook]: Unable to send webhook."

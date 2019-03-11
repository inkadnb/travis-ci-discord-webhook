# Forked from 
[travis-ci-discord-webhook](https://github.com/DiscordHooks/travis-ci-discord-webhook)

# GitLab CI 🡒 Discord Webhook
[![Backers on Open Collective](https://opencollective.com/discordhooks/backers/badge.svg)](#backers)
 [![Sponsors on Open Collective](https://opencollective.com/discordhooks/sponsors/badge.svg)](#sponsors) 

If you are looking for a way to get build (success/fail) status reports from
[GitLab CI](https://about.gitlab.com/product/continuous-integration/) in [Discord](https://discordapp.com), stop
looking. You've came to the right place.

## Guide
1.  Create a webhook in your Discord Server ([Guide](https://support.discordapp.com/hc/en-us/articles/228383668-Intro-to-Webhooks)).

1.  Copy the **Webhook URL**.

1.  Go to your repository settings (for which you want status notifications)
    in GitLab CI and add an environment variable called `WEBHOOK_URL` and paste
    the **Webhook URL** you got in the previous step.

    ![Add environment variable in Travis CI](https://i.imgur.com/UfXIoZn.png)

1.  Add jobs with when conditionals similar to below to the `.gitlab-ci.yml` file of your repository.

    ```yaml
    linux_failed:
      stage: cleanup_linux
      tags:
        - linux
      script:
        - apt-get update -qq
        - apt-get install git wget curl -qq
        - wget https://raw.githubusercontent.com/inkadnb/gitlab-ci-discord-webhook/master/send.sh
        - chmod +x send.sh
        - ./send.sh failure $WEBHOOK_URL
      when: on_failure

    linux_succeeded:
      stage: cleanup_linux
      tags:
        - linux
      script:
        - apt-get update -qq
        - apt-get install git wget curl -qq
        - wget https://raw.githubusercontent.com/inkadnb/gitlab-ci-discord-webhook/master/send.sh
        - chmod +x send.sh
        - ./send.sh success $WEBHOOK_URL
      when: on_success
    ```

1.  Grab your coffee ☕ and enjoy! And, if you liked this, please ⭐**Star**
    this repository to show your love.

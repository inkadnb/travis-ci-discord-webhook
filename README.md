# Forked from 
[travis-ci-discord-webhook](https://github.com/DiscordHooks/travis-ci-discord-webhook)

# GitLab CI 🡒 Discord Webhook
If you are looking for a way to get build (success/fail) status reports from
[GitLab CI](https://about.gitlab.com/product/continuous-integration/) in [Discord](https://discordapp.com), stop
looking. You've came to the right place.

## Guide
1.  Create a webhook in your Discord Server ([Guide](https://support.discordapp.com/hc/en-us/articles/228383668-Intro-to-Webhooks)).

1.  Copy the **Webhook URL**.

1.  Go to your repository settings (for which you want status notifications)
    in GitLab CI and add the environment variables `GITLAB_URL` and `WEBHOOK_URL`  
    For the `WEBHOOK_URL` environment variable paste
    the **Webhook URL** you got in the previous step.
    For the `GITLAB_URL` environment variable paste your GitLab Domain URL. This is particularly useful if you privately host your own GitLab.

    ![Add environment variable in GitLab CI](https://i.imgur.com/ZrtYe7A.png)

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

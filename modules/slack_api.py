import os
import slack,settings

def send_slack(message,channel="random"):

    if settings.SLACK_API_TOKEN is None or len(settings.SLACK_API_TOKEN) == 0:
        SLACK_API_TOKEN = os.environ.get('SLACK_API_TOKEN')
    else:
        SLACK_API_TOKEN = settings.SLACK_API_TOKEN


    client = slack.WebClient(token=SLACK_API_TOKEN)

    response = client.chat_postMessage(
      	channel=channel,
        text=message,
        charset="utf-8")

    assert response["ok"]
    #assert response["message"]["text"] == message

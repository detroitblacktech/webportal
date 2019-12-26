import os
import slack

def send_slack(message,channel="random"):

    client = slack.WebClient(token=settings.SLACK_API_TOKEN)

    response = client.chat_postMessage(
      	channel=channel,
        text=message,
        charset="utf-8")

    #assert response["ok"]
    #assert response["message"]["text"] == message

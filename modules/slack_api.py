import os
import slack

def send_slack(message,channel="random"):

    client = slack.WebClient(token='xoxb-444188207472-653229662789-02HESGqEirCu4ixPORfR290x')

    response = client.chat_postMessage(
      	channel=channel,
        text=message,
        charset="utf-8")

    #assert response["ok"]
    #assert response["message"]["text"] == message

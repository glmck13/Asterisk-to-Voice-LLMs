# Asterisk-to-Voice-LLMs
A collection of Python scripts to connect Asterisk to live voice AI models using AudioSockets

## Background
This repository contains Python scripts that enable Asterisk to place calls over its AudioSocket interface to two different live/voice AI models: Google Gemini’s “flash-native-audio” and AWS Bedrock’s Nova Sonic.  Voice models operate exclusively in the voice domain without having to translate speech-to-text (STT) then text-to-speech (TTS).  This makes for a more natural and responsive user experience.  The models are also “live” in that they can access current information beyond what they had initially been trained on by making use Retrieval-Augmented Generation (RAG) tools.  Gemini is configured to use Google Search (no surprise!), while Nova Sonic is configured to use [Serper](https://serper.dev/).

Although the scripts can be hosted anywhere, it’s easiest to simply install and run them on the same server that’s running Asterisk.  The script installation itself is pretty easy, the more involved part is subscribing to the models and obtaining API keys.  So I’ll start with the installation stuff first.  I’m currently running the scripts on two different platforms:
+ Raspberry Pi 4B, Debian 12, Asterisk 20.7.0, FreePBX 17.0.28 (Google model only since AWS requires Python3.12+ but Debian 12 ships with Python 3.11)
+ Vultr cloud server, Debian 12, Asterisk 22.5.2, FreePBX 17.0.28, (Python3.13 compiled separately to run AWS model)

## Installing the scripts
These instructions assume the HOME directory for the “asterisk” user is set to /var/lib/asterisk.  If “asterisk” does not yet have an assigned login shell, edit /etc/passwd and set its login shell to /bin/bash. If you don’t want to assign “asterisk” a password just "sudo su – asterisk" to login.

+ First download and install the scripts as "asterisk":
```
cd $HOME
git clone 'https://github.com/glmck13/Asterisk-to-Voice-LLMs.git'
mv Asterisk-to-Voice-LLMs local; cd local
find . -name '*.sh' -o -name '*.py' | xargs -t chmod +x
cd AWS-Nova-Sonic
python3 -m venv venv
bash --rcfile ./venv/bin/activate -i
pip3 install -r requirements.txt –force-reinstall
exit
cd ..
cd Google-Gemini
python3 -m venv venv
bash --rcfile ./venv/bin/activate -i
pip3 install -r requirements.txt –force-reinstall
exit
```

+ Next, configure each env.sh file with the appropriate variable settings as described in the “Obtaining model API keys” section below

+ Add extensions to /etc/asterisk/extensions_custom.conf using the sample provided.  If the UUID function isn’t available in your asterisk implementation, use the UUID=${SHELL(uuid)} workaround.
+ Add the following lines to asterisk’s crontab:
```
@reboot /var/lib/asterisk/local/Google-Gemini/a2g.sh
@reboot /var/lib/asterisk/local/AWS-Nova-Sonic/aws.sh
```

+ Reboot the asterisk server

## Obtaining model API keys

### Google Gemini
Google's documentation can be found [here](https://ai.google.dev/gemini-api/docs).  Simply follow the instructions to "Create a Gemini API Key."  

Model prices are pretty inexpensive.  A short conversaiton with the model only costs a few cents.

### AWS Nova Sonic
AWS's documentation can be found [here](https://docs.aws.amazon.com/bedrock/latest/userguide/getting-started.html).  You need to:
+ Create an AWS account and IAM user
+ Subscribe to "Bedrock", and request access to the Nova Sonic model
+ Assign your IAM user permissions to use Bedrock/Nova
+ Retrieve your API key

Navigating the AWS interface can be a bit intimidating, so be patient.  Thakfully there's lots of help available either by reading the docs or asking your favorite AI assistant.  

In comparison to Google Gemini, the AWS Nova Sonic model costs about twice as much for a short conversation - but 2x a few pennnies is still just a few pennies!

### Serper
You only need Serper for Nova Sonic.  You can sign up for an account on their [web page](https://serper.dev).  You start with a balance of 2500 "credits" free of charge (1 query = 1 credit).  After that you pay for credit bundles as you need them.  

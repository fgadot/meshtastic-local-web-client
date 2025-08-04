# meshtastic local web client
meshtastic offline local web client

If you enable WiFi on a meshtastic Heltec board for example, you can't accessthe GUI anymore, because the board can only use one protocol at the time. 
<br><br>
One solution is to use client.meshtastic.org - The only issue with that is you need to have internet access. In some cases, you won't. 
<br><br>
A Solution is to install meshtastic web monorepo locally, but you need to install dependencies on your own machine for this, or run it in a linux virtual machine. 
<br><br>
I created this Dockerfile which will allow you to run the meshtastic web monorepo in a container. Basically, no need to install any dependency in your machine, no need to run a linux virtual machine just for that. All you need is docker (www.docker.com) which is available for Windows, macOS, and Linux. 
<br><br>
Once Docker is installed on your machine, simply copy this Dockerfile. 
Open a terminal, then enter the following commands:

<code>
docker build -t meshtastic-web:local .
</code>
<br><br>
then once it's done
<br><br>
<code>
docker run --rm -p 3000:3000 meshtastic-web:local 
</code>

<br><br>
<br><br>
Please give me your feedback if you are using this. Open an issue if it does not work for you. 
<br><br>
To terminate the docker container, simply enter twice <b>ctrl-c</b>
<br><br>
To run this in background mode (so you can close your terminal), add the <b>-d</b> flag after the <b>--rm</b>
<br><br>
<br><br>
Enjoy!
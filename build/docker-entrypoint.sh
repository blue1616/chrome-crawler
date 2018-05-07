#!/bin/sh -l
set -eu

echo 'Starting MITMProxy...'
if [ -f /home/chrome/scripts/mitmproxy-script.py ]; then
  su - chrome -c 'nohup mitmdump -s /home/chrome/scripts/mitmproxy-script.py &'
else
  su - chrome -c 'nohup mitmdump &'
fi

sleep 3
openssl x509 -in /home/chrome/.mitmproxy/mitmproxy-ca-cert.pem -inform PEM -out /home/chrome/.mitmproxy/mitmproxy-ca-cert.crt
mkdir /usr/share/ca-certificates/extra
cp /home/chrome/.mitmproxy/mitmproxy-ca-cert.crt /usr/share/ca-certificates/extra/
echo 'extra/mitmproxy-ca-cert.crt' >> /etc/ca-certificates.conf 
update-ca-certificates

su - chrome -c 'chromedriver &'

echo 'Start Crawling!!'
#su - chrome 
if [ -f /home/chrome/scripts/crawling-script.sh ]; then
  su - chrome -c '/home/chrome/scripts/crawling-script.sh'
else
  su - chrome -c 'google-chrome-stable --no-sandbox --proxy-server=localhost:8080 --ignore-certificate-errors'
fi


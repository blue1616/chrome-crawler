#!/bin/sh -l
set -eu

echo 'Starting MITMProxy...'
if [ -f /home/chrome/scripts/mitmproxy-script.py ]; then
  su - chrome -c 'nohup mitmdump -s /home/chrome/scripts/mitmproxy-script.py &'
else
  su - chrome -c 'nohup mitmdump &'
fi

su - chrome -c 'google-chrome-stable --no-sandbox --headless www.google.com'

openssl x509 -in /home/chrome/.mitmproxy/mitmproxy-ca-cert.pem -inform PEM -out /home/chrome/.mitmproxy/mitmproxy-ca-cert.crt
mkdir /usr/share/ca-certificates/extra
cp /home/chrome/.mitmproxy/mitmproxy-ca-cert.crt /usr/share/ca-certificates/extra/
echo 'extra/mitmproxy-ca-cert.crt' >> /etc/ca-certificates.conf 
update-ca-certificates

certfile="/home/chrome/.mitmproxy/mitmproxy-ca-cert.pem"
certname="mitmproxy"

for certDB in $(find /home/chrome/ -name "cert9.db")
do
  prefdir=$(dirname ${certDB});
  echo ${prefdir};
  exec_command='certutil -A -n '${certname}' -t "TCu,Cu,Tu" -i '${certfile}' -d sql:'${prefdir}
  su - chrome -c "${exec_command}"
done

su - chrome -c 'chromedriver &'

echo 'Start Crawling!!'
if [ -f /home/chrome/scripts/crawling-script.sh ]; then
  su - chrome -c '/home/chrome/scripts/crawling-script.sh'
else
  su - chrome -c 'google-chrome-stable --no-sandbox --proxy-server=localhost:8080 --ignore-certificate-errors'
fi

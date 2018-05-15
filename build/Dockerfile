FROM debian:latest

# Install Chrome
RUN apt-get update && apt-get install -y \
  apt-transport-https \
  ca-certificates \
  curl \
  gnupg \
  hicolor-icon-theme \
  libcanberra-gtk* \
  libgl1-mesa-dri \
  libgl1-mesa-glx \
  libpango1.0-0 \
  libpulse0 \
  libv4l-0 \
  fonts-symbola \
  unzip \
  python3-dev \
  python3-pip \
  python3-setuptools \
  --no-install-recommends && \
  curl -sSL https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -o /tmp/google-chrome-stable_current_amd64.deb && \
  dpkg -i /tmp/google-chrome-stable_current_amd64.deb || \
  (apt -f install -y && dpkg -i /tmp/google-chrome-stable_current_amd64.deb) && \
  rm -f /tmp/google-chrome-stable_current_amd64.deb && \
  rm -rf /var/lib/apt/lists/*

# Install noto, Japanese Font
RUN mkdir /tmp/japanesefont/ && \
  curl -sSL https://noto-website.storage.googleapis.com/pkgs/NotoSansCJKjp-hinted.zip -o /tmp/japanesefont/NotoSansCJKjp-hinted.zip && \
  unzip /tmp/japanesefont/NotoSansCJKjp-hinted.zip -d /tmp/japanesefont/ && \
  mkdir -p /usr/share/fonts/noto && \
  mv /tmp/japanesefont/*.otf /usr/share/fonts/noto && \
  chmod 644 -R /usr/share/fonts/noto/ && \
  fc-cache -fv && \
  rm -rf /tmp/japanesefont/

# Install ChromeDriver
RUN curl -sSL -O https://chromedriver.storage.googleapis.com/2.38/chromedriver_linux64.zip -o /tmp/chromedriver_linux64.zip && \
  unzip chromedriver_linux64.zip && \
  chmod +x chromedriver && \
  mv -f chromedriver /usr/local/share/chromedriver && \
  ln -s /usr/local/share/chromedriver /usr/local/bin/chromedriver && \
  rm -f /tmp/chromedriver_linux64.zip 

# Install selenium & mitmproxy
RUN pip3 install selenium
RUN pip3 install mitmproxy

# Make user to run Chrome
RUN groupadd -r chrome && useradd -r -g chrome -G audio,video chrome && \
  usermod -u 1000 chrome && groupmod -g 1000 chrome && \
  mkdir -p /home/chrome/Downloads && \
  mkdir -p /home/chrome/output && \
  mkdir -p /home/chrome/scripts && \
  chsh -s /bin/bash chrome && \
  chown -R chrome:chrome /home/chrome

# Chrome user couldn't read Fonts in /usr/share/fonts. I don't know why...
RUN mkdir -p /home/chrome/.fonts && \
  cp -p /usr/share/fonts/noto/* /home/chrome/.fonts/ && \
  chown chrome:chrome /home/chrome/.fonts/

# Setting Locale to Ja_JP.UTF-8
RUN apt-get update && apt-get install -y task-japanese \
  locales \
  locales-all \
  --no-install-recommends && \
  sed -i 's/^#\sja_JP.UTF-8\sUTF-8$/ja_JP.UTF-8 UTF-8/' /etc/locale.gen && \
  update-locale && \
  echo 'export LANG=ja_JP.UTF-8' >> /etc/profile && \
  rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y libnss3-tools \
  --no-install-recommends && \
  rm -rf /var/lib/apt/lists/*

# Run script. Switching user in this.
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

#USER chrome
#WORKDIR /home/chrome/

ENTRYPOINT ["docker-entrypoint.sh"]
#CMD ["/bin/bash"]

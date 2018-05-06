from selenium import webdriver
from selenium.webdriver.common.action_chains import ActionChains
from selenium.webdriver.common.keys import Keys
from datetime import datetime
from time import sleep

if __name__ == '__main__':

    url = 'https://www.google.co.jp/'
#    url = 'http://abehiroshi.la.coocan.jp/'

    outputdir = '/home/chrome/output/'
    timestamp = datetime.now().strftime("%Y%m%d-%H%M%S")

    options = webdriver.ChromeOptions()
    options.binary_location = '/usr/bin/google-chrome'
    options.add_argument('--no-sandbox')
#    options.add_argument('--headless')
    options.add_argument('--disable-gpu')

    options.add_argument("--start-maximized")

    options.add_argument('--ignore-certificate-errors')
    options.add_argument('--ssl-protocol=any')
    options.add_argument('--allow-running-insecure-content')
    options.add_argument('--disable-web-security')

    PROXY = 'localhost:8080'
    options.add_argument('--proxy-server=http://%s' % PROXY)

#    options.add_argument("--window-size=1400,900");

#    USERAGENT = 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/55.0.2883.87 Safari/537.36'
 #   options.add_argument('--user-agent=%s' % USERAGENT)

    LANGUAGE = 'ja'
    options.add_argument('--lang=%s' % LANGUAGE)

    capabilities = options.to_capabilities()

    driver = webdriver.Remote(command_executor='http://localhost:9515', desired_capabilities=capabilities)

    try:
        driver.get(url)
        sleep(3)
        print('title:', driver.title)
        driver.save_screenshot(outputdir + 'screenshot-' + timestamp + '.png')
    finally:
        driver.quit()

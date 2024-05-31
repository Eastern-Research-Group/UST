from selenium import webdriver
# from selenium.webdriver.common.keys import Keys
# from selenium.webdriver.common.by import By

url = 'http://cedatareporting.pa.gov/ReportServer/Pages/ReportViewer.aspx?/Public/DEP/Tanks/SSRS/Tank_Component_Sub&rs:Command=Render&P_OTHER_ID=01-00098'


driver = webdriver.Chrome()
driver.get(url)

# driver.close()


    # from selenium import webdriver
    # from selenium.common import exceptions
    # from selenium.webdriver.chrome.options import Options
    # from selenium.webdriver.chrome.service import Service
    # from selenium.webdriver.common.by import By
    # from selenium.webdriver.support.ui import WebDriverWait
    # from selenium.webdriver.support import expected_conditions
    # from webdriver_manager.chrome import ChromeDriverManager


    # options = Options()
    # options.add_argument('--disable-notifications')
    # options.add_argument('--disable-infobars')
    # options.add_argument('--mute-audio')
    # options.add_argument('--no-sandbox')
    # options.add_argument('--log-level=3')
    # options.add_experimental_option('excludeSwitches', ['enable-logging','enable-automation'])
    # options.add_argument('--disable-extensions')
    # options.add_argument('test-type')
    # options.add_argument('user-agent=Mozilla/5.0')
    # options.add_argument('--disable-blink-features=AutomationControlled')
    # options.add_experimental_option('useAutomationExtension', False)
    # # comment out the line below to show the browser (use only for debugging)
    # # options.add_argument('--headless')
    # # uncomment the line below to keep the browser window open; use only for debugging
    # options.add_experimental_option('detach', True)
    # options.add_argument('--ignore-certificate-errors')
    # options.add_argument('--ignore-ssl-errors=yes')

    # service = Service(executable_path=ChromeDriverManager().install())
    # driver = webdriver.Chrome(service=service, options=options)

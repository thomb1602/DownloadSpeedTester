import subprocess
import psutil 
import time
from datetime import datetime

# 
ethName = "Ethernet"
wifiName = "Wi-Fi"
ethResultsPath = r'C:\git\repos\tom\DownloadSpeedTester\DownloadSpeedTester\ethernet.csv'
wifiResultsPath = r'C:\git\repos\tom\DownloadSpeedTester\DownloadSpeedTester\wifi.csv'

# 
disableAdapterCmd = [f'netsh interface set interface {ethName} disable']
enableAdapterCmd = [f'netsh interface set interface {ethName} enable']
runSpeedtestCmd = ""

def doSpeedTest(wifi):

    # setup adapter choice
    adapterName = ethName
    resultsPath = ethResultsPath
    if wifi:
        adapterName = wifiName
        resultsPath = wifiResultsPath
        subprocess.run([f'netsh interface set interface {ethName} disable'], shell=True) # doesn't recognise command
    else:
        subprocess.run([f'netsh interface set interface {wifiName} disable'], shell=True)
    subprocess.run([f'netsh interface set interface {adapterName} enable'], shell=True)

    while not isUp(adapterName):
        time.sleep(1)
    
    # do test
    rawResult = subprocess.run("speedtest.exe", capture_output=True)
    upload = parseResult(rawResult.stdout, "Upload:")
    download = parseResult(rawResult.stdout, "Download:")

    # make result string and write to file
    now = datetime.now()
    result = f'"{now.strftime("%d/%m/%Y %H:%M:%S")}", "{download}", "{upload}"'
    with open(resultsPath, 'a') as resultsFile:
        resultsFile.write(result)


def isUp(adapterName):
    adapterStats = psutil.net_if_stats()
    return adapterStats[adapterName].isup

def parseResult(resultBytes, label):
    result = str(resultBytes, "utf-8")
    startIndex = result.index(label) + len(label)
    endIndex = startIndex + 10
    return result[startIndex:endIndex].strip()


doSpeedTest(True)
import subprocess
import psutil 
import time
from datetime import datetime
import configparser

# 


def doSpeedTest(wifi, config):

    # setup adapter choice
    adapterName = config.get('adapters', 'ethName')
    resultsPath = config('paths', 'ethResultsPath')
    if wifi:
        adapterName = config['adapters']['wifiName']
        resultsPath = config['paths']['wifiResultsPath']
        disableCmd = config['commands']['disableAdapter'].replace("adapterName", adapterName)
        enableCmd = config['commands']['enableAdapter'].replace("adapterName", adapterName)
    
    subprocess.run(disableCmd, shell=True)
    subprocess.run(enableCmd, shell=True)

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

# main
config = configparser.ConfigParser()
config.read('ideapad.txt')


doSpeedTest(True, config)
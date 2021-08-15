import subprocess
import psutil 
import time
from datetime import datetime
import json

def doSpeedTest(wifi, config):

    # setup adapter choice
    adapterName = config["EthAdapterName"] 
    resultsPath = config["EthResultsPath"]
    if wifi:
        adapterName = config["WifiAdapterName"] 
        resultsPath = config["WifiResultsPath"]
        disableCmd = config["DisableCmd"].replace("adapterName", adapterName)
        enableCmd = config["EnableCmd"].replace("adapterName", adapterName)
    
    subprocess.run(disableCmd, shell=True)
    subprocess.run(enableCmd, shell=True)

    while not isUp(adapterName):
        time.sleep(1)
    
    # do test
    rawResult = subprocess.run(config["SpeedtestCmd"], capture_output=True)
    upload = parseResult(rawResult.stdout, "Upload:")
    download = parseResult(rawResult.stdout, "Download:")

    # make result string and write to file
    now = datetime.now()
    result = f'"{now.strftime("%d/%m/%Y %H:%M:%S")}", "{download}", "{upload}"'
    with open(resultsPath, 'a') as resultsFile:
        resultsFile.write(result)
        resultsFile.write("\\r\\n")


def isUp(adapterName):
    adapterStats = psutil.net_if_stats()
    return adapterStats[adapterName].isup

def parseResult(resultBytes, label):
    result = str(resultBytes, "utf-8")
    startIndex = result.index(label) + len(label)
    endIndex = startIndex + 10
    return result[startIndex:endIndex].strip()

def getConfig(os):
    path = r'C:\git\repos\tom\DownloadSpeedTester\DownloadSpeedTester\python\config.json'
    with open(path, 'r') as j:
        config = json.loads(j.read())
        return config[os]

# main
os = "Ideapad"  # or Inspiron
config = getConfig(os)
doSpeedTest(True, config)
#! /usr/bin/env python3
import getopt
import json
import os
import requests
import subprocess
import sys
from pathlib import Path

def main(argv):
    global returned_data, response
    SERVER_URL = 'http://stf:7100'
    ADB_PATH = '/usr/local/android-sdk-linux/platform-tools/adb'
    # use this one to debug on Win10/Cygwin '/cygdrive/c/ProgramData/chocolatey/bin/adb'

    ADB_KEY_LOCATION = "/home/jenkins/.android/adbkey.pub" \
    # use this one to debug on Win10/Cygwin /cygdrive/c/Users/youruser/.android/adbkey.pub"

    STF_API_TOKEN = ''
    ANDROID_VERSION = ''
    CMD = ''

    if ((len(sys.argv) != 6)):
        print("DeviceFarmer STF script argument list is not long enough, please have look at usage")
        print("Usage: android-stf-test.py --token <token>  --version <android_version> connect/disconnect")
        sys.exit(1)

    try:
        opts, args = getopt.getopt(argv, "token:version:connect:disconnect",
                                   ["token=", "version=", "connect", "disconnect"])

    except getopt.GetoptError:

        print("Usage: android-stf-test.py --token <token> --version <android_version> connect/disconnect")
        sys.exit(1)

    for opt, arg in opts:
        if opt == '-h':
            print("help: android-stf-test.py --token <token>  --version <android_version> --connect <true/false>")
            sys.exit(0)

        elif opt in ("-token", "--token"):
            STF_API_TOKEN = arg
        elif opt in ("-version", "--version"):
            ANDROID_VERSION = arg
        elif opt in ("-connect", "--connect"):
            CMD = arg

    CMD = sys.argv[5]

    print(
        "-> Triggered command line arguments STF_API_TOKEN: " + STF_API_TOKEN + " - ANDROID_VERSION: " + ANDROID_VERSION + " - CMD: " + CMD + "\n")

    if (str(CMD) == "connect"):

        url = SERVER_URL + "/api/v1/devices"
        token = str(STF_API_TOKEN)
        headers = {'Content-type': 'application/json', 'Authorization': "Bearer " + token}

        print("-> Searching for corresponding DeviceFarmer STF devices with version " + ANDROID_VERSION + "...")

        try:
            response = requests.get(url, headers=headers)
            returned_data = json.loads(response.text)

        except requests.exceptions.ConnectTimeout as err:
            print('ERROR: Connection timeout occurred. Please retry later')
            print('-> Details : {content}'.format(content=err.response.content))
            exit(1)
        except requests.exceptions.HTTPError as err:
            print('ERROR: Server error occurred. Please retry later')
            print('-> Details : {content}'.format(content=err.response.content))
            exit(1)

        STF_DEVICE_SERIAL = ''

        for row in returned_data['devices']:
            try:
                if (row['using'] == False) and (row['present'] == True):
                    version = row['version'];
                    if version == str(ANDROID_VERSION):
                        STF_DEVICE_SERIAL = row['serial']
                        break;
            except KeyError:
                print("   WARNING: One device doesn't reference a 'version', skipping...")

        if (str(STF_DEVICE_SERIAL) == str()):
            print("ERROR: Did not find any currently free device matching with the android version " + ANDROID_VERSION)
            exit(0)
        else:
            print(
                "   SUCCESS: Found a device corresponding to the android version " + ANDROID_VERSION + " with serial " + STF_DEVICE_SERIAL + "\n")

        print("-> Sending our local ADB key, just in case...")

        url = SERVER_URL + "/api/v1/user/adbPublicKeys"
        token = str(STF_API_TOKEN)
        adbKeyLocation = str(ADB_KEY_LOCATION)
        headers = {'Content-type': 'application/json', 'Authorization': "Bearer " + token}
        adbKey = {"publickey": Path(adbKeyLocation).read_text()}
        data = json.dumps(adbKey)
        try:
            response = requests.post(url, data=data, headers=headers)
            if response.status_code != 200:
                print("ERROR : code: " + str(response.status_code))
                content = json.loads(response.text)
                print("-> Description: " + content['description'])
                exit(1)
        except requests.exceptions.ConnectTimeout:
            print('ERROR: Connection timeout occurred. Please retry later')
            print('--> Details : {content}'.format(content=err.response.content))
            exit(1)
        except requests.exceptions.HTTPError as err:
            print('ERROR: Server error occurred. Please retry later')
            print('--> Details : {content}'.format(content=err.response.content))
            exit(1)

        answer = json.loads(response.text)

        if answer['success'] == False:
            print("ERROR: DeviceFarmer STF service error.")
            remote = json.loads(str(answer.val))
            DESCR = remote['description']
            print("-> Details: " + DESCR)
            exit(1)

        else:
            print("   SUCCESS: Key with path  " + adbKeyLocation + " got imported" + "\n")

        print("-> Booking the device with serial: " + STF_DEVICE_SERIAL)

        url = SERVER_URL + "/api/v1/user/devices"
        token = str(STF_API_TOKEN)
        serial = str(STF_DEVICE_SERIAL)
        headers = {'Content-type': 'application/json', 'Authorization': "Bearer " + token}
        serialNo = {"serial": serial}
        data = json.dumps(serialNo)

        try:
            response = requests.post(url, data=data, headers=headers)
            if response.status_code != 200:
                print("ERROR : code: " + str(response.status_code))
                content = json.loads(response.text)
                print("-> Description: " + content['description'])
                exit(1)
        except requests.exceptions.ConnectTimeout:
            print('ERROR: Connection timeout occurred. Please retry later')
            print('--> Details : {content}'.format(content=err.response.content))
            exit(1)
        except requests.exceptions.HTTPError as err:
            print('ERROR: Server error occurred. Please retry later')
            print('--> Details : {content}'.format(content=err.response.content))
            exit(1)

        answer = json.loads(response.text)

        if (answer['success'] == False):
            print("ERROR: DeviceFarmer STF service error.")
            remote = json.loads(str(answer.val))
            DESCR = remote['description']
            print("-> Details: " + DESCR)
            exit(1)

        else:
            print("   SUCCESS: Device with serial " + STF_DEVICE_SERIAL + " is reserved" + "\n")

            print("-> Retrieving device details...")
            serial = str(STF_DEVICE_SERIAL)
            url = SERVER_URL + "/api/v1/user/devices/" + serial
            token = str(STF_API_TOKEN)
            headers = {'Content-type': 'application/json', 'Authorization': "Bearer " + token}

        try:
            response = requests.get(url, headers=headers)
            if response.status_code != 200:
                print("ERROR : code: " + str(response.status_code))
                content = json.loads(response.text)
                print("-> Description: " + content['description'])
                exit(1)
        except requests.exceptions.ConnectTimeout:
            print('ERROR: Connection timeout occurred. Please retry later')
            print('-> Details : {content}'.format(content=err.response.content))
            exit(1)
        except requests.exceptions.HTTPError as err:
            print('ERROR: Server error occurred. Please retry later')
            print('-> Details : {content}'.format(content=err.response.content))
            exit(1)

        if response.status_code == 200:
            INFO = json.loads(response.text)
            MANUFACTURER = INFO['device']['manufacturer']
            MODEL = INFO['device']['model']
            VERSION = INFO['device']['version']
            ABI = INFO['device']['abi']
            REMOTE_URL = INFO['device']['remoteConnectUrl']

            print("   SUCCESS: details of the device, MANUFACTURER:" + str(MANUFACTURER) + " - MODEL:" + str(
                MODEL) + " - VERSION:" + str(VERSION) + " - ABI:" + str(ABI) + "\n")

            print("-> Searching for the ADB connection for the device...")

            serial = str(STF_DEVICE_SERIAL)
            url = SERVER_URL + "/api/v1/user/devices/" + serial + "/remoteConnect"
            token = str(STF_API_TOKEN)
            headers = {'Content-type': 'application/json', 'Authorization': "Bearer " + token}
            serialNo = {"serial": serial}
            data = json.dumps(serialNo)

        try:
            response = requests.post(url, data=data, headers=headers)
            if response.status_code != 200:
                print("ERROR : code: " + str(response.status_code))
                content = json.loads(response.text)
                print("-> Description: " + content['description'])
                exit(1)
        except requests.exceptions.ConnectTimeout:
            print('ERROR: Connection timeout occurred. Please retry later')
            print('-> Details : {content}'.format(content=err.response.content))
            exit(1)
        except requests.exceptions.HTTPError as err:
            print('ERROR: Server error occurred. Please retry later')
            print('-> Details : {content}'.format(content=err.response.content))
            exit(1)

        RESPONSE = json.loads(response.text)
        STATUS = RESPONSE['success']

        STF_ADB_ADDRESS = ''

        if (str(STATUS) == "True"):

            STF_ADB_ADDRESS = RESPONSE['remoteConnectUrl']
            print("   SUCCESS : ADB remoteConnectUrl is reached (" + str(STF_ADB_ADDRESS) + ")" + "\n")

            try:

                # print ("-> Killing ADB server... ")
                # killadb_status = os.system(ADB_PATH+" kill-server > /dev/null ")

                # print ("-> Starting ADB server... ")
                # startadb_status = os.system(ADB_PATH+"  start-server > /dev/null ")

                # if (killadb_status == 0 and startadb_status == 0):

                # print ("   SUCCESS: ADB successfully restarted "+"\n")

                # print("-> Downloading granted adb keys ADB device (" + str(STF_ADB_ADDRESS) + ")...")
                # adbPrivKeyDownload = os.system(
                #    "curl -s -o /home/jenkins/.android/adbkey https://kazan.atosworldline.com/share/data/technical-user-kazan-mobile/docker/ressources/adbkey")
                # adbPrubKeyDownload = os.system(
                #   "curl -s -o /home/jenkins/.android/adbkey.pub https://kazan.atosworldline.com/share/data/technical-user-kazan-mobile/docker/ressources/adbkey.pub")

                # if (adbPrivKeyDownload == 0 and adbPrubKeyDownload == 0):
                #    print("   SUCCESS: Download of adbkey and abkey.pub " + "\n")
                # else:
                #    print("ERROR: download ADB keys from kazan mobile sharedspace " + STF_ADB_ADDRESS)
                #   exit(1)

                print("-> Connecting to ADB device (" + str(STF_ADB_ADDRESS) + ")...")
                result = os.system(ADB_PATH + " -e connect " + str(STF_ADB_ADDRESS) + " > /dev/null ")

                if (result == 0):
                    print("   SUCCESS: Connecting ADB device with address: (" + str(STF_ADB_ADDRESS) + ") " + "\n")

                else:
                    print("ERROR: connecting to ADB for device with address: " + STF_ADB_ADDRESS)
                    exit(1)




            except subprocess.CalledProcessError as ex:
                print("ERROR: connecting to ADB for device with address: " + STF_ADB_ADDRESS)
                exit(1)
        else:
            print("ERROR: ADB information request failed")
            remote = json.loads(str(RESPONSE.val))
            DESCR = remote['description']
            print(DESCR)
            exit(1)

    if (str(CMD) == "disconnect"):

        print("--> Searching for serial numbers of devices used by you from DeviceFarmer STF...")
        url = SERVER_URL + "/api/v1/user/devices/"
        token = str(STF_API_TOKEN)
        headers = {'Content-type': 'application/json', 'Authorization': "Bearer " + token}

        try:
            response = requests.get(url, headers=headers)
        except requests.exceptions.ConnectTimeout:
            print('Oops. Connection timeout occurred, please try again later!')
        except requests.exceptions.HTTPError as err:
            print('Oops. HTTP Error occurred, please try again later')
            print('Response is: {content}'.format(content=err.response.content))

        returned_data = json.loads(response.text)

        try:
            for row in returned_data['devices']:
                STF_DEVICE_SERIAL = row['serial']
                if not STF_DEVICE_SERIAL:
                    print("ERROR: Did not find any serial number of the device  used by you, failed to disconnect")
                    exit(0)

                print("   SUCCESS : Found device linked with serial number: " + STF_DEVICE_SERIAL)

                print("\n" + "-> Disconnecting device ADB session from DeviceFarmer STF...")
                url = SERVER_URL + "/api/v1/user/devices/" + STF_DEVICE_SERIAL + "/remoteConnect"
                headers = {'Content-type': 'application/json', 'Authorization': "Bearer " + token}
                response = requests.delete(url, headers=headers)

                RESPONSE = json.loads(response.text)

                STATUS = RESPONSE['success']

                if str(STATUS) == "True":
                    print("   SUCCESS : The device ADB session is removed")
                    DESC = RESPONSE['description']
                else:
                    DESC = RESPONSE['description']
                    print("ERROR: while disconnecting device ADB session with serial :" + STF_DEVICE_SERIAL + DESC)
                    print("error details - " + DESC)
                    exit(1)

                print("\n" + "-> Unreserved the device by user session...")

                url = SERVER_URL + "/api/v1/user/devices/" + STF_DEVICE_SERIAL

                headers = {'Content-type': 'application/json', 'Authorization': "Bearer " + token}

                response = requests.delete(url, headers=headers)

                RESPONSE = json.loads(response.text)

                STATUS = RESPONSE['success']

                if str(STATUS) == "True":
                    DESC = RESPONSE['description']
                    print("   SUCCESS : User device is unreserved" + "\n")
                    killserver = os.system(ADB_PATH + "  kill-server > /dev/null")
                    exit(0)
                else:
                    DESC = RESPONSE['description']
                    print("ERROR:  User device failed to be unreserved ")
                    print("error details - " + DESC + "\n")
                    exit(1)

        except requests.exceptions.ReadTimeout:
            print('Oops. Connection ReadTimeout occurred, try again later!')
        except requests.exceptions.HTTPError as err:
            print('Oops. HTTP Error occurred, try again later')
            print('Response is: {content}'.format(content=err.response.content))

        print("ERROR: Did not find any devices for disconnect...")
        exit(0)


if __name__ == "__main__":
    main(sys.argv[1:])


from email.mime.multipart import MIMEMultipart
from pynput.keyboard import Key,Controller
from email.mime.base import MIMEBase
from email.mime.text import MIMEText
from getpass import getpass,getuser
from email import encoders
import smtplib
import email
import time
import ssl
import sys
import os

def TakeScreenShot():
    try:
        keyboard = Controller()
        keyboard.press(Key.alt)
        keyboard.press('s')
        keyboard.release(Key.alt)
        keyboard.release('s')
        time.sleep(5)
    except:
        return

def main():
    #
    print("[*] Freezer Screen Shot Transmission Script ")
    #
    target_directory = "C:\\temp"
    #
    TakeScreenShot()
    #
    os.chdir(target_directory)
    #
    dir_listing = os.listdir()
    #
    image_path = ''
    #
    for d in dir_listing:
        #
        if(d.endswith('.jpg')):
            #
            image_path = d
            #
            print("[*] Located: %s " % image_path)
            #
    time_stamp = time.ctime()
    #
    sender = 'freezer.farm@wsu.edu'
    #
    #recipient = '<email.addr>'
    #
    body = "Screen Shot -> " + time_stamp
    #
    message = MIMEMultipart()
    #
    message['From']    = sender
    #
    message['To']      = recipient
    #
    message['Subject'] = "Screen Shot -> " + time_stamp
    #
    message.attach(MIMEText(body,"plain"))
    #
    attachment = image_path 
    #
    if(os.path.exists(os.path.abspath(attachment))):
        #
        print('[*] File exists ')
        #
    else:
        #
        print("[!] File could not be located, departing ")
        #
        sys.exit(1)
        #
    with open(attachment,"rb") as attached_file:
        #
        part = MIMEBase("application","octet-stream")
        #
        part.set_payload(attached_file.read())
        #
    encoders.encode_base64(part)
    #
    part.add_header(
        "Content-Disposition",
        f"attachment; filename={attachment}",
        )
    #
    message.attach(part)
    #
    text = message.as_string()
    #
    address_list = ['<email.addr>','<email.addr>','<email.addr>']
    #
    for address in address_list:
        #
        with smtplib.SMTP("<smtp.server.addr>",25) as server:
            #
            server.sendmail(sender,address,text)
            #
        print("[*] Screen shot successfully transmitted to: %s " % address)
        #
    os.remove(os.path.abspath(attachment))
    #
    print("[*] Sreen shot: %s -> Successfully Removed" % attachment)


if(__name__ == '__main__'):
    #
    while(True):
        #
        try:
            #
            main()
            #
            os.system('cls')
            #
        except Exception as e:
            #
            print("[!] Error: %s " % e)
            #
            pass
            #
        time.sleep(3600)

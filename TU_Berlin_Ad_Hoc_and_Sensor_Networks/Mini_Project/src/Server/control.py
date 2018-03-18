import os
import sys

def direction(dir):
    if(dir == "forward"):
        forward();
    elif(dir == "backward"):
        backward();
    elif(dir == "left"):
        left();
    elif(dir == "right"):
        right();
    elif(dir == "stop"):
        stop();
    else:
        print sys.argv[1]

def forward():
    os.system("echo forward | nc6 -u fec0::2 2000 &")
    os.system("killall -9 nc6")
    os.system("echo forward | nc6 -u fec0::3 2000 &")
    os.system("killall -9 nc6")

def backward():
        os.system("echo backward | nc6 -u fec0::2 2000 &")
        os.system("killall -9 nc6")
        os.system("echo backward | nc6 -u fec0::3 2000 &")
        os.system("killall -9 nc6")

def left():
        os.system("echo forward | nc6 -u fec0::2 2000 &")
        os.system("killall -9 nc6")
        os.system("echo stop | nc6 -u fec0::3 2000 &")
        os.system("killall -9 nc6")

def right():
        os.system("echo stop | nc6 -u fec0::2 2000 &")
        os.system("killall -9 nc6")
        os.system("echo forward | nc6 -u fec0::3 2000 &")
        os.system("killall -9 nc6")

def stop():
        os.system("echo stop | nc6 -u fec0::2 2000 &")
        os.system("killall -9 nc6")
        os.system("echo stop | nc6 -u fec0::3 2000 &")
        os.system("killall -9 nc6")

#direction(sys.argv[1])

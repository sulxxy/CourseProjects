import os
import sys

def direction(dir):
    if(dir == "forward"):
        os.system("echo forward | nc6 -u fec0::2 2000 &")
        os.system("killall -9 nc6")
        print "test"
        os.system("echo forward | nc6 -u fec0::3 2000 &")
        os.system("killall -9 nc6")
        print "testA"
    elif(dir == "backward"):
        os.system("echo backward | nc6 -u fec0::2 2000 &")
        os.system("killall -9 nc6")
        print "test"
        os.system("echo backward | nc6 -u fec0::3 2000 &")
        os.system("killall -9 nc6")
        print "testA"
    elif(dir == "left"):
        os.system("echo forward | nc6 -u fec0::2 2000 &")
        os.system("killall -9 nc6")
        print "test"
        os.system("echo stop | nc6 -u fec0::3 2000 &")
        os.system("killall -9 nc6")
        print "testA"
    elif(dir == "right"):
        os.system("echo stop | nc6 -u fec0::2 2000 &")
        os.system("killall -9 nc6")
        print "test"
        os.system("echo forward | nc6 -u fec0::3 2000 &")
        os.system("killall -9 nc6")
        print "testA"
    elif(dir == "stop"):
        os.system("echo stop | nc6 -u fec0::2 2000 &")
        os.system("killall -9 nc6")
        print "test"
        os.system("echo stop | nc6 -u fec0::3 2000 &")
        os.system("killall -9 nc6")
        print "testA"
    else:
        print sys.argv[1]

direction(sys.argv[1])

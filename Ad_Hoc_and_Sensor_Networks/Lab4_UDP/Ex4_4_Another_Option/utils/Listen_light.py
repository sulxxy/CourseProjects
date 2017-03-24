import socket
import Sensing_Light
import re # regular expression
import sys

port = 7000
if __name__ == '__main__':
   
    s = socket.socket(socket.AF_INET6, socket.SOCK_DGRAM)
    s.bind(('', port))

    while True:
        data, addr = s.recvfrom(1024)
        if (len(data) > 0):

            rpt = Sensing_Light.Sensing_Light(data=data, data_length=len(data))

            print addr
            print rpt

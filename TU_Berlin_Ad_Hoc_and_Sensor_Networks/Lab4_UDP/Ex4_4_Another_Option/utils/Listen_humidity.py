import socket
import Sensing_Humidity
import re # regular expression
import sys

port = 8000
if __name__ == '__main__':

    s = socket.socket(socket.AF_INET6, socket.SOCK_DGRAM)
    s.bind(('', port))
    
    while True:
        data, addr = s.recvfrom(1024)
        if (len(data) > 0):

            rpt = Sensing_Humidity.Sensing_Humidity(data=data, data_length=len(data))

            print addr
            print rpt


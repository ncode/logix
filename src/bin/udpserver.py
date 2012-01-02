import gevent
import socket
from gevent import monkey
monkey.patch_all()

s = socket.socket(family=socket.AF_INET, type=socket.SOCK_DGRAM, proto=socket.IPPROTO_UDP)
s.bind(('', 8000))
while 1: 
    data, peer = s.recvfrom(120) 
    print data

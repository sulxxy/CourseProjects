import socket
import Sensing

import plotly.plotly as py
import plotly.tools as tls
import plotly.graph_objs as go
import time
import datetime

stream_tokens = tls.get_credentials_file()['stream_ids']
token_1 = stream_tokens[-1]
stream_id1 = dict(token=token_1, maxpoints=60)
trace1 = go.Scatter(x=[], y=[], stream=stream_id1, name='trace1')

data = [trace1]
layout = go.Layout(
    title='Streaming Light',
    yaxis=dict(
            title='y for light intensity'
    )
)
fig = go.Figure(data=data, layout=layout)
plot_url = py.plot(fig, filename='multple-trace-axes-streaming')
s_1 = py.Stream(stream_id=token_1)
s_1.open()

i=0

port = 7000

if __name__ == '__main__':

    s = socket.socket(socket.AF_INET6, socket.SOCK_DGRAM)
    s.bind(('', port))

    while True:
        data, addr = s.recvfrom(1024)
        if (len(data) > 0):

            rpt = Sensing.Sensing(data=data, data_length=len(data))
            x = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S.%f')
            s_1.write(dict(x=x,y=rpt.get_light()))
            time.sleep(0.2)
            i += 1
s_1.close()



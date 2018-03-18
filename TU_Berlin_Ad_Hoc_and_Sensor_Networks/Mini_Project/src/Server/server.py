from flask import Flask, request, redirect, url_for
from flask import render_template
import os
import control
app = Flask(__name__)

@app.route('/')
def init_webserver():
    return render_template('control.html')

@app.route('/', methods=['GET', 'POST'])
def set_threshold():
    threshold_value = int(request.form['text'])
    print "new threshold received: "
    print threshold_value
    os.system("echo th_set 100 | nc6 -u fec0::4 2000 &")
    os.system("killall -9 nc6")
    return render_template('control.html')

@app.route('/ctrl', methods=['GET','POST'])
def ctrl_wheels():
    if(request.method == 'POST'):
        print "***********"
        print request.form
        print "***********"
        id = request.form['dir']
        if id == 'forward':
            #forward command
            control.forward()
            print 'FORWARD command received'
        elif id == 'backward':
            #backward command
            control.backward()
            print 'BACKWARD command received'
        elif id == 'left':
            #moveleft command
            control.left()
            print 'MOVELEFT command received'
        elif id == 'right':
            #moveright command
            control.right()
            print 'MOVERIGHT command received'
        elif id == 'stop':
            #moveright command
            control.stop()
            print 'STOP command received'
    return redirect(url_for('init_webserver'))

@app.route('/data')
def render_data():
    return render_template("data.html")

app.run(host="0.0.0.0",port=5000)

#INSTRUCTIONS ON HOW TO CONNECT NEUROSKY MINDWAVE TO RPI AND USE SUPERCOLLIDER TO MAKE MUSIC USING YOUR BRAINWAVES

##FIRST STEP @@@@@@@@@@

For python to be able to parse binary code from neyrosky mindwave it needs the following module

https://pypi.python.org/pypi/NeuroPy/0.1

download or clone and install

##STEP TWO @@@@@@@@@@

###Create 2 executable files: The first file should be created with
```javascript
$ touch jacksclangstart.sh #you can use any name
```

###Then edit it using your favorite editor (I use emacs you can also use nano)
```javascript
$ sudo emacs jacksclangstart.sh
```

###Copy & paste the following in the file
```javascript
#!/bin/sh 
/usr/local/bin/jackd -P75 -dalsa -dhw:1 -p1024 -n3 -s -r44100 & 
sleep 1 su root -c “sclang -D /home/pi/neucode.scd” 
#where (neucode.scd) will be your SuperCollider script
```

###Then create the second file
```javascript
$ touch rfconnect.sh #you can use any name
```

###Then edit it using your favorite editor (I use emacs you can also use nano)
```javascript
$ sudo emacs rfconnect.sh
```

###Then copy $ paste the following in the file
```javascript
rfcomm connect 0 XX:XX:XX:XX:XX #where you place the code for bluetooth of your device(neurosky mindwave-it is usually within the box)
```

###if not the try:
```javascript
$ hcitool scan
```

###and you should see the mindwave device (have it on pairing mode first)

##STEP THREE @@@@@@@@@@

###Assuming you already have a python script ready now its time to create an autostart procedure with crontab so every time you boot the Rpi It should run 4 things:

1.the jack driver

2.the sc script

3.the bluetooth connection

4.the python script


###At the terminal type: 
```javascript 
$ sudo crontab -e
``` 

###Then paste the following:
```javascript
@reboot /home/pi/rfconnect.sh
@reboot /bin/sh /home/pi/jacksclangstart.sh 
@reboot sleep 15; python /home/pi/mind_test.py &
#where (mind_test.py) shoyld be your python script file
```
Reboot est voila!

##THAT SHOULD DO IT @@@@@@@@@@

#CODE EXAMPLES

##CODE EXAMPLE FOR PYTHON USING THE “NeuroPy” MODULE
```javascript
from NeuroPy import NeuroPy
import time
import OSC

port = 57120
sc = OSC.OSCClient()
sc.connect(('127.0.0.1',port)) #send locally to sc
object1 = NeuroPy("/dev/rfcomm0")

zero = 0

time.sleep(1)

object1.start()

def sendOSC(name, val):
    msg = OSC.OSCMessage()
    msg.setAddress("/neurovals")
    msg.extend([object1.attention, object1.meditation, object1.rawValue, object1.delta, object1.theta, object1.lowAlpha, object1.highAlpha, object1.lowBeta, object1.highBeta, object1.lowGamma, object1.midGamma, object1.poorSignal, object1.blinkStrength])
    try:
        sc.send(msg)
    except:
        pass
    print msg #debug

while True:
    val = [object1.attention, object1.meditation, object1.rawValue, object1.delta, object1.theta, object1.lowAlpha, object1.highAlpha, object1.lowBeta, object1.highBeta, object1.lowGamma, object1.midGamma, object1.poorSignal, object1.blinkStrength]
        if val!=zero:
            time.sleep(0.5)
            sendOSC("/neurovals", val)
```

##SUPECOLLIDER CODE SCRIPT EXAMPLE
```javascript
( 
s.waitForBoot {
{ SynthDef.new(\noise,
{ arg freq=440, amp=0.2, pha = 0; var sig, env, sig2, gen;

sig=SinOsc.ar (freq, 0.05); 
sig2=LFTri.ar (freq, 0.08) ;
env = Env.triangle(4, amp); 
gen = EnvGen.kr(env, doneAction: 2);
sig=[sig+sig2]*gen; Out.ar(0,(sig * amp).dup);

}).play;

5.wait;

OSCdef.new( \bang, { arg msg, time, addr, port; [msg, time, addr, port].postln;

Synth(\noise, [freq:msg[1] * 100]);

},’/bang’ )
}.fork; 
} 
)
```
##GOOD LUCK

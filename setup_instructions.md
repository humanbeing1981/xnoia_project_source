#INSTRUCTIONS ON HOW TO CONNECT NEUROSKY MINDWAVE TO RPI AND USE SUPERCOLLIDER TO MAKE MUSIC USING YOUR BRAINWAVES

##FIRST STEP

For python to be able to parse binary code from neyrosky mindwave it needs the following module

https://pypi.python.org/pypi/NeuroPy/0.1

download or clone and install

##STEP TWO

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
#!/bin/sh /usr/local/bin/jackd -P75 -dalsa -dhw:1 -p1024 -n3 -s -r44100 & sleep 1 su root -c “sclang -D /home/pi/neucode.scd” #where (neucode.scd) will be your SuperCollider script
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

##STEP THREE

###Assuming you already have a python script ready now its time to create an autostart procedure with crontab so every time you boot the Rpi It should run 4 things:

the jack driver
the sc script
the bluetooth connection
the python script
At the terminal type: “`javascript $ sudo crontab -e “` Then paste the following:
```javascript
@reboot /home/pi/rfconnect.sh @reboot /bin/sh /home/pi/jacksclangstart.sh @reboot sleep 15; python /home/pi/mind_test.py & #where (mind_test.py) shoyld be your python script file
```
##THAT SHOULD DO IT

Reboot est voila!

##CODE EXAMPLE FOR PYTHON USING THE “neuroPy” MODULE
```javascript
from NeuroPy import NeuroPy import time object1=NeuroPy(‘/dev/rfcomm0’) time.sleep(2)

object1.start()

def attention_callback(attention_value): “this function will be called everytime NeuroPy has a new value for attention” print “Value of attention is”,attention_value #do other stuff (fire a rocket), based on the obtained value of attention_value #do some more stuff return None

#set call back: object1.setCallBack(“attention”,attention_callback)

#call start method object1.start()

while True: if(object1.meditation>70): #another way of accessing data provided by headset (1st being call backs) object1.stop() #if meditation level reaches above 70, stop fetching data from the headset

#other variables: attention,meditation,rawValue,delta,theta,lowAlpha,highAlpha,lowBeta,highBeta,lowGamma,midGamma, poorSignal and blinkStrength
```
##SUPECOLLIDER CODE SCRIPT EXAMPLE
```javascript
sudo sclang neucode.scd

( s.waitForBoot { { SynthDef.new(\noise, { arg freq=440, amp=0.2, pha = 0; var sig, env, sig2, gen;

sig=SinOsc.ar (freq, 0.05); sig2=LFTri.ar (freq, 0.08) ; env = Env.triangle(4, amp); gen = EnvGen.kr(env, doneAction: 2);

sig=[sig+sig2]*gen; Out.ar(0,(sig * amp).dup);

}).play; 5.wait;

OSCdef.new( \bang, { arg msg, time, addr, port; [msg, time, addr, port].postln;

Synth(\noise, [freq:msg[1] * 100]);

},’/bang’ ) }.fork; } )
```
##GOOD LUCK

###examples of python code
```javascript
from NeuroPy import NeuroPy import time import OSC

port = 57120 sc = OSC.OSCClient() sc.connect((‘192.168.1.4’,port)) #send locally to laptop object1 = NeuroPy(“/dev/rfcomm0”)

def sendOSC(name, val): msg = OSC.OSCMessage() msg.setAddress(name) msg.append(val) try: sc.send(msg) except: pass print msg #debug

def attention_callback(attention_value): print “Value of attention is”, attention_value sendOSC(“/att”, attention_value) return None

def meditation_callback(meditation_value): print “Value of meditation is”, meditation_value sendOSC(“/med”, meditation_value) return None

def blinkStrength_callback(blinkStrength_value): print “Value of blinkStrength is”, blinkStrength_value sendOSC(“/bStngth”, blinkStrength_value) return None

def rawValue_callback(rawValue_value): print “Value of rawValue is”, rawValue_value sendOSC(“/rvl”, rawValue_value) return None

def poorSignal_callback(poorSignal_value): print “Value of poorSignal is”, poorSignal_value sendOSC(“/pSgnl”, poorSignal_value) return None

#set call back: object1.setCallBack(“attention”, attention_callback) object1.setCallBack(“meditation”, meditation_callback) object1.setCallBack(“blinkStrength”, blinkStrength_callback) object1.setCallBack(“rawValue”, rawValue_callback) object1.setCallBack(“poorSignal”, meditation_callback)

#call start method object1.start()
```
###a working one
```javascript
from NeuroPy import NeuroPy import time import OSC

port = 57120 sc = OSC.OSCClient() sc.connect((‘192.168.1.4’,port)) #send locally to laptop object1 = NeuroPy(“/dev/rfcomm0”)

zero = 0

time.sleep(1)

object1.start()

def sendOSC(name, val): msg = OSC.OSCMessage() msg.setAddress(“/neurovals”) msg.extend([object1.attention, object1.meditation, object1.rawValue, object1.delta, object1.theta, object1.lowAlpha, object1.highAlpha, object1.lowBeta, object1.highBeta, object1.lowGamma, object1.midGamma, object1.poorSignal, object1.blinkStrength]) try: sc.send(msg) except: pass print msg #debug

while True: val = [object1.attention, object1.meditation, object1.rawValue, object1.delta, object1.theta, object1.lowAlpha, object1.highAlpha, object1.lowBeta, object1.highBeta, object1.lowGamma, object1.midGamma, object1.poorSignal, object1.blinkStrength] if val!=zero: time.sleep(2) sendOSC(“/neurovals”, val)
```
###some sc examples
```javascript
( s.waitForBoot { { SynthDef.new(\noise, { arg freq = 440, amp = 0.2, vol = 0.2, pha = 0, chron = 1; var sig, env, sig2, sig3, gen;

sig = SinOsc.ar (freq, pha); sig2 = LFTri.ar (freq, pha); sig3 = LFNoise2.ar (freq, vol); env = Env.triangle(chron, vol); gen = EnvGen.kr(env, doneAction: 2);

sig=[sig+sig2+sig3]*gen; Out.ar(0,(sig * amp).dup);

}).play; 5.wait;

OSCdef.new( \neurovals, { arg msg, time, addr, port, wildcard; [msg, time, addr, port].postln; if ((msg[1] <= 14), {wildcard = 2*261.63}); if ((msg[1] > 14) && (msg[1] <= 28), {wildcard = 2*293.66}); if ((msg[1] > 28) && (msg[1] <= 42), {wildcard = 2*329.63}); if ((msg[1] > 42) && (msg[1] <= 56), {wildcard = 2*349.23}); if ((msg[1] > 56) && (msg[1] <= 70), {wildcard = 2*392.00}); if ((msg[1] > 70) && (msg[1] <= 84), {wildcard = 2*440.00}); if ((msg[1] > 84), {wildcard = 2*493.88}); Synth(\noise, [freq:wildcard, chron:msg[1] / 25, pha:msg[1] / 100, vol:msg[1] / 100 / 4]);

},’/neurovals’ ) }.fork; } )
```
###and another one
```javascript
( s.waitForBoot; {

Ndef.new(\melodia, { arg amp = 0.2; var sig, sig1, env, sig2, sig3;

sig1 =Splay.ar(BPF.ar(PinkNoise.ar(0.01),[rrand(50,200),rrand(100,900), rrand(200,1200),rrand(500,2500),rrand(1000,3000)],rrand(0.01,$

sig2 = ({ SinOsc.ar(Rand(300,400) + ({exprand(1, 1.3)} ! rrand(1, 9))) * 0.1});

sig3 = ({ (Ringz.ar(Impulse.ar([rrand(0.5,10)]), 80, [rrand(0.1,2)]).dup) * 0.1 });

sig=[sig1+sig2+sig3];

Out.ar(0,(sig * amp).dup);

}).play;

5.wait;

Ndef(\melodia).play; Ndef(\melodia).fadeTime = 5;

OSCdef.new( \att, { arg msg, time, addr, port; [msg, time, addr, port].postln; if ((msg[1] <= 14), {Ndef(\melodia).rebuild;}); if ((msg[1] > 14) && (msg[1] <= 28), {Ndef(\melodia).rebuild;}); if ((msg[1] > 28) && (msg[1] <= 42), {Ndef(\melodia).rebuild;}); if ((msg[1] > 42) && (msg[1] <= 56), {Ndef(\melodia).rebuild;}); if ((msg[1] > 56) && (msg[1] <= 70), {Ndef(\melodia).rebuild;}); if ((msg[1] > 70) && (msg[1] <= 84), {Ndef(\melodia).rebuild;}); if ((msg[1] > 84), {Ndef(\melodia).rebuild;});

},’/att’

);

}.fork;

)
```

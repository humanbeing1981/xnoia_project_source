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


(
{
	var synth, state_stream;

    Server.default.waitForBoot;

    "/home/alex/Desktop/synths_file.scd".loadPaths;
    1.wait;

    state_stream = Pseq([\omonoia, \pronoia, \epinoia, \amvlinoia, \paranoia, \dixonoia, \krypsinoia,\anoia, \oxynoia, \symponoia] 
        collect: { | s, i | [s, i] }, inf).asStream;

    OSCdef.new(

        \selectsend,
        {
            arg msg, time, addr, port;
            [msg, time, addr, port].postln;

            if (msg[3] > 200)
			{
                var word, angle, addr;
                #word, angle = r.next;
                addr = NetAddr("127.0.0.1", 12001); // 12001  default port for PROCESSING
                synth.release;
                synth = Synth (word);
                addr.sendMsg (\angle, angle);
            }

        },'/neurovals'
    );

    OSCdef.new(
        \base,
        {
            arg msg, time, addr, port;
            [msg, time, addr, port].postln;

            if (msg[1] == msg[1])
            {   synth.set(\freq, msg[1].linlin(0, 100, 300, 1000););
                synth.set(\tempo, msg[1].linlin(0, 100, 1, 8););
                synth.set(\amp, msg[1].linlin(0, 100, 0.5, 1););
                synth.set(\phase, msg[1].linlin(0, 100, 0, 1););
                synth.set(\iphase, msg[1].linlin(0, 100, 0, 1););
                synth.set(\numharms, msg[1].linlin(0, 100, 2, 200););
                synth.set(\width, msg[1].linlin(0, 100, 0, 1););
                synth.set(\aval, msg[1].linlin(0, 100, 0.1, 0.5););
                synth.set(\bval, msg[1].linlin(0, 100, 0.1, 0.5););
                synth.set(\mod, msg[1].linlin(0, 100, 1, 10););
                synth.set(\ampHz, msg[1].linlin(0, 100, 2, 8););
                synth.set(\tone, msg[1].linlin(0, 100, 1, 5););
                synth.set(\maxPartial, msg[1].linlin(0, 100, 2, 8););
                synth.set(\slideTime, msg[1].linlin(0, 100, 0.1, 1.4););
                synth.set(\detune, msg[1].linlin(0, 100, 0.01, 0.3););
                synth.set(\rq, msg[1].linlin(0, 100, 1, 3););
                synth.set(\freqlag, msg[1].linlin(0, 100, 0.01, 0.1););
            }

        },'/neurovals'

    );

}.fork;

)


(
SynthDef(\omonoia, { | amp = 1, phase = 0, freq = 440, gate = 1, mod = 2 |
	var env, sines, sines2, sines3, sines4, sig, trig, dseq, out;
	env = EnvGen.ar(Env.adsr, gate, doneAction: 2) * amp;
	sines = SinOsc.ar(freq, phase, amp) * SinOsc.ar(freq * mod);
	sines2 = Saw.ar(freq, amp) * SinOsc.ar(freq * mod);
	sines3 = SinOsc.ar(freq, phase, amp) * Saw.ar(freq * mod);
	sines4 = Saw.ar(freq, amp) * SinOsc.ar(freq * mod);
	sig = sines + sines2 + sines3 + sines4;
	trig = Impulse.ar(sig/2, phase, amp);
	dseq = Dseq([(freq/100), (freq/200), (freq/300), (freq/400)], inf);
	out = PMOsc.ar(freq, mod * freq)  * (SinOsc.ar((Demand.ar(trig, 0, dseq)), phase, amp));
	Out.ar(0, out * env *1.5).dup;
}).add;
////////////////////////////////////////////////////////////////////////////////{///////////////
SynthDef(\dianoia, {| freq = 440, amp = 1, art = 1, gate = 1 |
	var env, snd1, snd2;
	env = EnvGen.ar(Env.adsr, gate, doneAction: 2);
	snd1 = SinOsc.ar(freq/2);
	snd2 = SinOsc.ar(Line.ar((freq+15)/2, freq/2, art));
	Out.ar(0, [(snd1+snd2).dup] * amp * env * 1.5);
}).add;
/////////////////////////////////////////////////////////////////////////////////////////////
SynthDef(\pronoia, { |freq = 440, gate = 1, amp = 1, slideTime = 0.17, ffreq = 1100, width =
	0.15,
	detune = 1.005, preamp = 4|
	var sig,
	env = Env.adsr(0.01, 0.3, 0.4, 0.1);
	freq = Lag.kr(freq, slideTime);
	sig = Mix(VarSaw.ar([freq, freq * detune], 0, width, preamp)).distort * amp
	* EnvGen.kr(env, gate, doneAction: 2);
	sig = LPF.ar(sig, ffreq);
	Out.ar(0, sig ! 2)
}).add;
/////////////////////////////////////////////////////////////////////////////////////////////
SynthDef(\oxynoia, { |out, freq = 440, gate = 0.5, plfofreq = 6, mw = 0, ffreq =
	2000, rq = 0.3, freqlag = 0.05, amp = 1|
	var sig, plfo, fcurve;
	plfo = SinOsc.kr(plfofreq, mul:mw, add:1);
	freq = Lag.kr(freq, freqlag) * plfo;
	fcurve = EnvGen.kr(Env.adsr(0, 0.3, 0.1, 20), gate);
	fcurve = (fcurve - 1).madd(0.7, 1) * ffreq;
	sig = Mix.ar([Pulse.ar(freq, 0.9), Saw.ar(freq*1.007)]);
	sig = RLPF.ar(sig, fcurve, rq)
	* EnvGen.kr(Env.adsr(0.04, 0.2, 0.6, 0.1), gate, doneAction:2)
	* amp;
	Out.ar(out, sig ! 2)
}).add;
///////////////////////////////////////////////////////////////////////////////////////////
SynthDef(\epinoia, { |freq = 440, gate = 1, amp = 1, slideTime = 0.17, ffreq = 1100, width =
	0.15, detune = 1.005, preamp = 4, mod = 5, phase = 0|
	var sig, dseq, trig, out, env;
	env = Env.adsr(0.01, 0.3, 0.4, 0.1);
	freq = Lag.kr(freq, slideTime*mod);
	sig = LPF.ar(sig, ffreq);
	sig = Mix(VarSaw.ar([freq, freq * detune+mod], 0, width, preamp)).distort * amp
	* EnvGen.kr(env, gate, doneAction: 2);
	trig = Impulse.ar(freq/1.2, phase, amp);
	dseq = Dseq([1,3,6,7,8,5,3,2], inf);
	out =  sig * DelayN.ar((SinOsc.ar((Demand.ar(trig, 0, dseq)), phase, amp)),1,1);
	Out.ar(0, out+trig ! 2);
}).add;

//////////////////////////////////////////////////////////////////////////////////////////////

SynthDef.new(\dixonoia, {|ampHz = 4, freq = 40, maxPartial = 4, width = 0.5, gate = 1, amp = 1|
	var amp1, amp2, freq1, freq2, sig1, sig2;
	var env;
	env = Env.adsr;
	amp1 = LFPulse.kr(ampHz, 0, 0.12) * 0.65;
	amp2 = LFPulse.kr(ampHz, 0.5, 0.12) * 0.65;
	freq1 = LFNoise0.kr(4).exprange(freq, freq * maxPartial).round(freq);
	freq2 = LFNoise0.kr(4).exprange(freq, freq * maxPartial).round(freq);
	freq1 = freq1 * LFPulse.kr(8, add:1);
	freq2 = freq2 * LFPulse.kr(6, add:1);
	sig1 = Pulse.ar(freq1, width, amp1);
	sig2 = Pulse.ar(freq2, width, amp2);
	Out.ar(0, (sig1+sig2).dup * EnvGen.kr (env, gate, doneAction: 2) * amp);

}).add;
///////////////////////////////////////////////////////////////////////////////////////////////
SynthDef(\paranoia, { |freq = 440, phase = 1, amp = 1, gate = 1, tempo = 1, in = 0, aval = 0.2, bval = 0.5 |
	var env, dseq, trig, out, sig, n;
	in = InFeedback.ar(in,1);
	n = LFNoise0;
	sig = SinOsc.ar(freq/3000, in * n.ar(aval, aval*4, aval*8), n.ar(bval, bval*2, bval*4)) * 0.2;
	9.do{sig = AllpassC.ar(sig, aval, bval, bval)};
	sig.tanh;
	env = Env.adsr;
	dseq = Drand([(freq/100), (freq/200)*2, (freq/300)*4, (freq/400)*8], inf);
	trig = Impulse.ar(tempo);
	out =  ([SinOsc.ar((Demand.ar(trig, 0, dseq)), phase, amp)
		+ SinOsc.ar(freq/2, phase, amp * 2)])* EnvGen.kr(env, gate, doneAction: 2) * amp;
	Out.ar(0, (sig+out).dup * 1.2);
}).add;
/////////////////////////////////////////////////////////////////////////////////////////////////

SynthDef(\krypsinoia, { | phase = 0, amp = 1, freq = 300, gate = 1, mod = 5 |
	var synth, env, input, rlpf;
	env = EnvGen.ar(Env.adsr, gate, doneAction: 2) * amp;
	input = Impulse.ar(freq/4, phase, amp);
	synth = DynKlank.ar(`[[freq, freq/1.1, freq/1.2, freq/1.3], [1,0.8,0.4,0.1], [1,0.8,0.4,0.1]], input, freq/300, decayscale: 10);
	rlpf = RLPF.ar(synth, 200);
	Out.ar(0, synth * rlpf * env * 1.5);
}).add;

//////////////////////////////////////////////////////////////////////////////////////////////
SynthDef(\amvlinoia, { | freq = 261, tone = 3, art = 1, amp = 1, gate = 1, mod = 5, phase = 0 |
	var env, out, dseq, trig;
	env = EnvGen.ar(Env.adsr, gate, doneAction: 2) * amp;
	trig = Impulse.ar(freq/2, phase, amp);
	dseq = Dseq([(freq/100), (freq/200), (freq/300), (freq/400)], inf);
	out = PMOsc.ar(freq, mod * freq)  * (SinOsc.ar((Demand.ar(trig, 0, dseq)), phase, amp));
	Out.ar(0, out * env * 1.5);
}).add;
//////////////////////////////////////////////////////////////////////////////////////////////
SynthDef(\anoia, {| freq = 261, tone = 3, art = 1, amp = 1, gate = 1, mod = 5, phase = 0|
	var env, out, dseq, trig;
	env = EnvGen.ar(Env.adsr, gate, doneAction: 2) * amp;
	trig = Impulse.ar(freq/2, phase, amp);
	dseq = Drand([(freq/10), (freq/20), (freq/30), (freq/40)], inf);
	out = PMOsc.ar(freq, mod * freq)  * DelayN.ar((SinOsc.ar((Demand.ar(trig, 0, dseq)), phase, amp)));
	Out.ar(0, out * env * 1.5);
}).add;
)
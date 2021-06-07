
~bufs = Buffer.readChannel(s, path: "/Users/student/Music/Ableton/Bouncar/bagpipe song.wav", channels: [0]);

(
SynthDef.new(\flute, {
	arg  cPos, dur = 0.2, pan = 0, amp = 0.1, out, buf;
	var rate, env, sig, trigRate, trig, bufDur;
	rate = MouseY.kr(0.4, 0.42);
	bufDur = BufDur.kr(buf);
	trigRate = MouseY.kr(2, 120, 1);
	trig = Impulse.kr(trigRate);
	// cPos = Line.kr(0, 1, bufDur/2, 1);
	cPos = MouseX.kr(0, bufDur/2) + TRand.kr(-0.01, 0.01, trig);
	pan = WhiteNoise.kr(0.7);
	dur = TRand.kr(10, 15, trig)/trigRate;
	sig = TGrains.ar(6, trig, buf, rate, cPos, dur, pan, amp);
	// sig = BLowPass.ar(sig, 900);
	Out.ar(out, sig);
}).add;
)

Synth(\flute, [\buf, ~bufs]);

s.options.outDevice = ("MOTU UltraLite mk3 Hybrid");
s.options.numOutputBusChannels_(6);

s.meter

PanAz
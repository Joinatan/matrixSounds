s.boot

(
SynthDef(\sawPad, {
arg freq = 400, out = 0, atk = 1.0, dec = 0.1, sus = 0.8, rel = 1.2, amp = 0.2, detune = 0.01, rq = 0.4;
var sig, env;
env = EnvGen.kr(Env.adsr([atk, dec, sus, rel]), doneAction:2);
sig = VarSaw.ar({Rand(freq * (1 - detune), freq * (1 + detune))}!5, width: LFNoise2.kr(1).range(0.7, 1.0));
sig = BLowPass.ar(sig, LFNoise2.kr(1).range(1500, 3000), rq: rq);
sig = Splay.ar(sig);
Out.ar(out, sig * env * amp);
}).add;
)

(
Synth.new(\sawPad, [\freq, 50.midicps]);
Synth.new(\sawPad, [\freq, 53.midicps]);
Synth.new(\sawPad, [\freq, 57.midicps]);
Synth.new(\sawPad, [\freq, 52.midicps]);
)

(
{LFNoise2.ar(0.01).poll}.play
)

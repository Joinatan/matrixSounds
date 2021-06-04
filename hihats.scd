
/*
---------------------simple white noise hihat
*/
SynthDef(\hihat, {
arg freq = 400, out = 0, atk = 0.1, dec = 0.1, sus = 0.8, rel = 0.2, amp = 0.2;
var sig, env;
env = EnvGen.kr(Env.perc(atk, rel), doneAction:2);
sig = WhiteNoise.ar(0.2!2);
Out.ar(out, sig * env * amp);
}).add;

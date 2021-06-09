//elchock
(
{
    |freq = 200, amp = 0.2|
    var sig, lfo;
    sig = {LFNoise0.ar(LFNoise1.kr(LFNoise1.kr(0).range(5, 14)).range(940, 950))}!2 * amp; 
    lfo = {LFPulse.kr(LFNoise0.kr(8).range(1.8, 19.0)).range(0.8, 1.0)};
    lfo = lfo.pow(2);
    // sig = BHiPass.ar(sig, 100);
    // lfo = LFPulse.kr(SinOsc.kr(3).range(2, 15)).range(0, 1);
    sig = sig * lfo;
}.play;
)
//sprakande el
(
{
    |freq = 200, amp = 0.2|
    var sig, lfo;
    sig = {LFNoise0.ar(LFNoise0.kr(LFNoise0.kr(0).range(2, 4)).range(220, 250))}!2 * amp; 
    lfo = {SinOsc.kr(LFNoise0.kr(8).range(0.5, 20)).range(0.3, 1.01)};
    lfo = lfo.pow(13);
    // sig = BHiPass.ar(sig, 100);
    // lfo = LFPulse.kr(SinOsc.kr(3).range(2, 15)).range(0, 1);
    sig = sig * lfo;
}.play;
)

s.meter;

{WhiteNoise.ar}

{LFNoise0.ar(LFNoise0.kr(5).range(200, 4000))!2 * 0.2}.play;


(
{
    var sig;
    sig = SinOsc.ar(500 + SinOsc.ar(2000, mul:400));
    sig * 0.2!2;
}.play;
)

(
SynthDef(\fm1, {
    arg out = 0, freq = 400, gate = 1, amp = 0.2, index = 1, iScale = 5,
    //carrier
    cAtk = 0.01, cDec = 0.2, cSus = 0.8, cRel = 0.2, cRatio = 1,
    //modulator
    mAtk = 1.01, mDec = 1.2, mSus = 0.1, mRel = 0.2, mRatio = 1,
    //mVib
    mVibFreq = 0, mVibWidth = 0,
    //mTremolo
    mTremoloRate = 0, mTremoloAmount = 0;
    var cEnv, mEnv, iEnv, car, mod, mVib, mTremolo;
    mVib = LFNoise2.kr(mVibFreq).range(1 - mVibWidth, 1 + mVibWidth);
    mTremolo = LFNoise2.kr(mTremoloRate).range(1 - mTremoloAmount, 1 + mTremoloAmount);
    iEnv = EnvGen.kr(Env.adsr(mAtk, mDec, mSus, mRel, peakLevel: index * iScale, bias: index), gate: gate);
    cEnv = EnvGen.kr(Env.adsr(cAtk, cDec, cSus, cRel), gate: gate, doneAction:2);
    mod = SinOsc.ar((freq * mRatio * mVib), mul: freq * mRatio * iEnv * mTremolo);
    car = SinOsc.ar((freq * cRatio) + mod)!2;
    Out.ar(out, car * cEnv * amp);
}).add;
)

(
Synth.new(\fm1, [\mul, 0.5, \index, 1, \mRatio, 2, \freq, 80, \mVibFreq, 2.1, \mVibWidth, 0.1, \mTremoloAmount, 0.8, \mTremoloRate, 10, \cAtk, 1])
)

//reaperSC sounddevice
//
//adat 1 from reaper
//bus 18 out from SC
/*
---------------------Server settings
*/
(
s.options.numOutputBusChannels = 16;
s.options.numInputBusChannels = 22;
s.options.memSize = 2.pow(20);
s.options.blockSize = 64;
s.options.device = "reaperSC";

/*
---------------------Busses and buffers
*/
if(b.isNil, {
    b = ();
    b.numChans = s.options.numOutputBusChannels;
    b.audio = ();
    b.control = ();
    //grains
    b.audio.inGrains;
    b.audio.buffer = ();
    //to reaper
    b.inReaper = 18;
    b.outReper = 12;
});


s.waitForBoot({

    b.audio.fxBus = Bus.audio(s, b.numChans);
    b.audio.buffer.grainBuf = Buffer.alloc(s, s.sampleRate * 5, 1);
    //grain buffers
    b.audio.micBus = Bus.audio(s, 1);
    b.audio.phasorBus = Bus.audio(s, 1);
    //groups
    b.micGroup = Group.new();
    b.phasorGroup = Group.after(b.micGroup);
    b.recGroup = Group.after(b.phasorGroup);
    b.granularGroup = Group.after(b.recGroup);
    
    //synthParameters
    b.synths = ();
    b.synths.granulator = ();
    b.synths.granulator.grainDur = 0.05;
    b.synths.granulator.durRand = 1.00;
    b.synths.granulator.sync = 1;
    b.synths.granulator.dens = 40;
    b.synths.granulator.rateRand = 1;
    b.synths.granulator.rate = 1;
    b.synths.granulator.atk = 1;
    b.synths.granulator.rel = 1;
    b.synths.granulator.rel = 0;
    b.synths.granulator.pan= 0;
    b.synths.granulator.panRand = 4;

    s.sync;

    SynthDef(\soundIn, {
    arg in=0, out=0, amp=1;
    var sig;
    sig = SoundIn.ar(in) * amp;
    Out.ar(out, sig);
    }).add;

    SynthDef(\phasor, {
    arg out=0, buf=0;
    var sig;
    sig = Phasor.ar(0, BufRateScale.kr(buf), 0, BufFrames.kr(buf));
    Out.ar(out, sig);
    }).add;

    SynthDef(\rec, {
    arg phasorIn=0, audioIn=0, buf=0;
    var sig, phasor;
    sig = In.ar(audioIn, 1);
    phasor = In.ar(phasorIn, 1);
    BufWr.ar(sig, buf, phasor);
    }).add;

    SynthDef(\granulator, {
    arg amp=0.5, out=0, atk=1, rel=1, gate=1, sync=1, dens=40, baseDur=0.05, durRand=1, rate=1, rateRand=1, pan=0, panRand=0, grainEnv=(-1), phasorBus=0, phasorSampleDelay=20000, phasorRandSamples=5000, buf=0, minPhasorDelay=1000;
    var sig, env, densCtrl, durCtrl, rateCtrl, panCtrl, phasor, phasorRand, totalDelay, maxGrainDur;
    env = EnvGen.kr(Env.asr(atk, 1, rel), gate:gate, doneAction:2);
    densCtrl = Select.ar(sync, [Dust.ar(dens), Impulse.ar(dens)]);
    durCtrl = baseDur * LFNoise1.ar(100).exprange(1/durRand, durRand);
    rateCtrl = rate * LFNoise1.ar(100).exprange(1/rateRand, rateRand);
    // panCtrl = pan + LFNoise1.kr(100).bipolar(panRand);
    panCtrl = pan + WhiteNoise.kr(100).bipolar(panRand);

    phasorRand = LFNoise1.ar(200).bipolar(phasorRandSamples);
    totalDelay = max(phasorSampleDelay - phasorRand, minPhasorDelay);

    phasor = In.ar(phasorBus, 1);
    phasor = phasor - totalDelay;
    phasor = phasor / BufFrames.kr(buf);

    maxGrainDur = (totalDelay / rateCtrl) / SampleRate.ir;
    durCtrl = min(durCtrl, maxGrainDur);

    sig = GrainBuf.ar(
        4, 
        densCtrl,
        durCtrl,
        buf,
        rateCtrl,
        phasor,
        2,
        panCtrl,
        grainEnv
    );
    
    Out.ar(out, sig * env * amp);
    }).add;


"granulatorOsc.scd".loadRelative;

    s.sync;

Synth.new(\soundIn, [\in, b.inReaper, \out, b.audio.micBus], b.micGroup);
Synth.new(\phasor, [\buf, b.audio.buffer.grainBuf, \out, b.audio.phasorBus], b.phasorGroup);
Synth.new(\rec, [\phasorIn, b.audio.phasorBus, \audioIn, b.audio.micBus, \buf, b.audio.buffer.grainBuf], b.recGroup);
g = Synth.new(\granulator, [
    \amp, 0.5,
    \buf, b.audio.buffer.grainBuf,
    // \out, 0,
    \out, b.outReper,
    \atk, b.synths.granulator.atk,
    \rel, b.synths.granulator.rel,
    \gate, 1,
    \sync, b.synths.granulator.sync,
    \dens, b.synths.granulator.dens,
    \baseDur, b.synths.granulator.grainDur,
    \durRand, b.synths.granulator.durRand,
    \rate, b.synths.granulator.rate,
    \rateRand, b.synths.granulator.rateRand,
    \pan, b.synths.granulator.pan,
    \panRand, b.synths.granulator.panRand,
    \grainEnv, -1,
    \phasorBus, b.audio.phasorBus,
    \phasorSampleDelay, s.sampleRate/3,
    // \phasorRandSamples, 0,
    \phasorRandSamples, s.sampleRate/6,
    \minPhasorDelay, 1000
], b.granularGroup);
});
)

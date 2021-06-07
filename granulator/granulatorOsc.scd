OSCdef(
    \masterVolume,
    {
        arg msg, time, addr, port;
        // [msg, time, addr, port].postln;
        s.volume = msg[1];
        ('MASTER_vol: '++msg[1]).postln;
    },
    '/fmMain/master'
);
OSCdef(
    \sync,
    {
        arg msg, time, addr, port;
        // [msg, time, addr, port].postln;
        b.synths.granulator.grainDur = msg[1];
        b.granularGroup.set(\sync, msg[1]);
        ('Sync: '++msg[1]).postln;
    },
    '/granulator/sync'
);
OSCdef(
    \grainDur,
    {
        arg msg, time, addr, port;
        // [msg, time, addr, port].postln;
        b.synths.granulator.grainDur = msg[1];
        b.granularGroup.set(\baseDur, msg[1]);
        ('grainDur: '++msg[1]).postln;
    },
    '/granulator/grainDur'
);
OSCdef(
    \durRand,
    {
        arg msg, time, addr, port;
        // [msg, time, addr, port].postln;
        b.synths.granulator.grainDur = msg[1];
        b.granularGroup.set(\durRand, msg[1]);
        ('Random duration: '++msg[1]).postln;
    },
    '/granulator/durRand'
);
OSCdef(
    \dens,
    {
        arg msg, time, addr, port;
        // [msg, time, addr, port].postln;
        b.synths.granulator.density = msg[1];
        b.granularGroup.set(\dens, msg[1]);
        ('Density: '++msg[1]).postln;
    },
    '/granulator/dens'
);

OSCdef(
    \rateRand,
    {
        arg msg, time, addr, port;
        // [msg, time, addr, port].postln;
        b.synths.granulator.rateRand = msg[1];
        b.granularGroup.set(\rateRand, msg[1]);
        ('Random rate: '++msg[1]).postln;
    },
    '/granulator/rateRand'
);

OSCdef(
    \rate,
    {
        arg msg, time, addr, port;
        // [msg, time, addr, port].postln;
        b.synths.granulator.rate = msg[1];
        b.granularGroup.set(\rate, msg[1]);
        ('Rate: '++msg[1]).postln;
    },
    '/granulator/rate'
);

OSCdef(
    \atk,
    {
        arg msg, time, addr, port;
        // [msg, time, addr, port].postln;
        b.synths.granulator.atk = msg[1];
        b.granularGroup.set(\atk, msg[1]);
        ('Atk: '++msg[1]).postln;
    },
    '/granulator/atk'
);
OSCdef(
    \rel,
    {
        arg msg, time, addr, port;
        // [msg, time, addr, port].postln;
        b.synths.granulator.rel = msg[1];
        b.granularGroup.set(\rel, msg[1]);
        ('Rel: '++msg[1]).postln;
    },
    '/granulator/rel'
);

OSCdef(
    \pan,
    {
        arg msg, time, addr, port;
        // [msg, time, addr, port].postln;
        b.synths.granulator.pan = b.synths.granulator.pan + msg[1];
        if(b.synths.granulator.pan >= 3, {b.synths.granulator.pan = 0});
        if(b.synths.granulator.pan <= 0, {b.synths.granulator.pan = 3});
        b.granularGroup.set(\pan, b.synths.granulator.pan);
        ('Pan: '++b.synths.granulator.pan).postln;
    },
    '/granulator/pan'
);
OSCdef(
    \panRand,
    {
        arg msg, time, addr, port;
        // [msg, time, addr, port].postln;
        b.synths.granulator.panRand = msg[1];
        b.granularGroup.set(\panRand, msg[1]);
        ('PanRand: '++msg[1]).postln;
    },
    '/granulator/panRand'
);
/*
    \amp, 0.5,
    \buf, b.audio.buffer.grainBuf,
    // \out, 0,
    \out, b.outReper,
    \atk, 1,
    \rel, 1,
    \gate, 1,
    \sync, 1,
    \dens, 40,
    \baseDur, 0.05,
    \durRand, 2.2,
    \rate, 1,
    \rateRand, 1.01,
    \pan, 0,
    \panRand, 4,
    \grainEnv, -1,
    \phasorBus, b.audio.phasorBus,
    \phasorSampleDelay, s.sampleRate/3,
    // \phasorRandSamples, 0,
    \phasorRandSamples, s.sampleRate/6,
    \minPhasorDelay, 1000
], b.granularGroup);
*/

/*
---------------------Server settings
*/
(
s.options.numOutputBusChannels = 14;
s.options.memSize = 2.pow(20);
s.options.blockSize = 64;

/*
---------------------Busses and buffers
*/
if(b.isNil, {
    b = ();
    b.numChans = s.options.numOutputBusChannels;
    b.audio = ();
    b.audio.fxBus = Bus.audio(s, b.numChans);
    b.control = ();
    b.control.lfo = Bus.control(s, 1);
    b.tempo = 120/60;
    b.click = TempoClock.new(b.tempo);

    //groups
    b.synths = ();
    b.synths.fm = Group.new(addAction: \addToHead);
    //update open stage controll
    // b.updateController.();
});


b.op = Array.newClear(4);
4.do({
    |i|

    b.op[i] = ();
    b.op[i].ratio = 1.0;
    b.op[i].fine = 0.0;
    b.op[i].fbLevel = 0;
    b.op[i].amp = 0.2;
    b.op[i].env = Array.newClear(4);
    b.op[i].env[0] = 0.11;
    b.op[i].env[1] = 0.2;
    b.op[i].env[2] = 0.8;
    b.op[i].env[3] = 0.2;
    b.op[i].detune = 0;

    //sends
    b.op[i].send = Array.fill(4, {arg i; 0});

    if(i == 0, {
        b.op[i].masterEnv = Array.newClear(4);
        b.op[i].masterEnv[0] = 2;
        b.op[i].masterEnv[1] = 2;
        b.op[i].masterEnv[2] = 1;
        b.op[i].masterEnv[3] = 2;
        b.op[i].cutOff = 20000;

    };)
});




b.synths.fm = Group.new(addAction: \addToHead);

/*
---------------------call diffrent modulefiles
*/
"fmOsc.scd".loadRelative;
"fmMidi.scd".loadRelative;
"fmMidiPattern.scd".loadRelative;

b.updateController.value();
s.waitForBoot({


/*
---------------------fm7
*/

SynthDef(\fm7, {
    arg out = 0, amp = 0.2, index = 0, gate = 1, cutOff = 20000,
    //masterEnv
    atk = 1.1, dec = 0.2, sus = 0.6, rel = 2.4,
    //op0
    atk0 = 0.1, dec0 = 0.2, sus0 = 0.6, rel0 = 0.4,
    //op1
    atk1 = 0.1, dec1 = 0.2, sus1 = 0.6, rel1 = 0.4,
    //op2
    atk2 = 0.1, dec2 = 0.2, sus2 = 0.6, rel2 = 0.4,
    //op3
    atk3 = 0.1, dec3 = 0.2, sus3 = 0.6, rel3 = 0.4;

    var masterEnv, env0, env1, env2, env3, ctl, mod, ctl2, mod2, opOut, out0, out1, sig, sig2, outArray, spreadMod0, spreadMod1, spreadMod2, spreadMod3;

    masterEnv = EnvGen.kr(Env.adsr(atk, dec, sus, rel), gate: gate, doneAction:2);

    env0 = EnvGen.kr(Env.adsr(atk0, dec0, sus0, rel0), gate: gate);
    env1 = EnvGen.kr(Env.adsr(atk1, dec1, sus1, rel1), gate: gate);
    env2 = EnvGen.kr(Env.adsr(atk2, dec2, sus2, rel2), gate: gate);
    env3 = EnvGen.kr(Env.adsr(atk3, dec3, sus3, rel3), gate: gate);

    spreadMod0 = \freq.kr(400) * \detune0.kr(0) * Rand(-1, 1);
    spreadMod1 = \freq.kr * \detune1.kr(0) * Rand(-1, 1);
    spreadMod2 = \freq.kr * \detune2.kr(0) * Rand(-1, 1);
    spreadMod3 = \freq.kr * \detune3.kr(0) * Rand(-1, 1);
    


    opOut = [0, 1];
    //channel1
    ctl = [ 
        [ \freq.kr(400) * (\op0Ratio.kr(1) + \op0Fine.kr(0)) + spreadMod0, 0, 1 * env0],
        [ \freq.kr(400) * (\op1Ratio.kr(1) + \op1Fine.kr(0)) + spreadMod1, 0, 1 * env1],
        [ \freq.kr(400) * (\op2Ratio.kr(1) + \op2Fine.kr(0)) + spreadMod2, 0, 1 * env2],//\op2Amp.kr(0) * env2],
        [ \freq.kr(400) * (\op3Ratio.kr(1) + \op3Fine.kr(0)) + spreadMod3, 0, 1 * env3],//\op3Amp.kr(0) * env3],
        [ 0,   0,    0   ],
        [ 0,   0,    0   ] 
    ];

        mod = [  
            [\op0_0.kr(0).linlin(0, 40, 0, 4), \op1_0.kr(0), \op2_0.kr(0), \op3_0.kr(0), 0, 0],
            [\op0_1.kr(0), \op1_1.kr(0).linlin(0, 40, 0, 4), \op2_1.kr(0), \op3_1.kr(0), 0, 0],
            [\op0_2.kr(0), \op1_2.kr(0), \op2_2.kr(0).linlin(0, 40, 0, 4), \op3_2.kr(0), 0, 0],
            [\op0_3.kr(0), \op1_3.kr(0), \op2_3.kr(0), \op3_3.kr(0).linlin(0, 40, 0, 4), 0, 0],
            [0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0]
        ];
        sig = FM7.ar(ctl, mod);
        sig = Mix.ar([
            sig[0] * \op0Amp.kr(0),
            sig[1] * \op1Amp.kr(0),
            sig[2] * \op2Amp.kr(0),
            sig[3] * \op3Amp.kr(0)
        ]);

        //channel2
    ctl2 = [ 
        [ \freq.kr(400) * (\op0Ratio.kr(1) + \op0Fine.kr(0)) + spreadMod0, 0, 1 * env0],
        [ \freq.kr(400) * (\op1Ratio.kr(1) + \op1Fine.kr(0)) + spreadMod1, 0, 1 * env1],
        [ \freq.kr(400) * (\op2Ratio.kr(1) + \op2Fine.kr(0)) + spreadMod2, 0, 1 * env2],//\op2Amp.kr(0) * env2],
        [ \freq.kr(400) * (\op3Ratio.kr(1) + \op3Fine.kr(0)) + spreadMod3, 0, 1 * env3],//\op3Amp.kr(0) * env3],
        [ 0,   0,    0   ],
        [ 0,   0,    0   ] ];

        mod2 = [  
            [\op0_0.kr(0).linlin(0, 40, 0, 4), \op1_0.kr(0), \op2_0.kr(0), \op3_0.kr(0), 0, 0],
            [\op0_1.kr(0), \op1_1.kr(0).linlin(0, 40, 0, 4), \op2_1.kr(0), \op3_1.kr(0), 0, 0],
            [\op0_2.kr(0), \op1_2.kr(0), \op2_2.kr(0).linlin(0, 40, 0, 4), \op3_2.kr(0), 0, 0],
            [\op3_3.kr(0), \op3_1.kr(0), \op3_2.kr(0), \op3_3.kr(0).linlin(0, 40, 0, 4), 0, 0],
            [0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0]
        ];
        sig2 = FM7.ar(ctl2, mod2);
        sig2 = Mix.ar([
            sig2[0] * \op0Amp.kr(0),
            sig2[1] * \op1Amp.kr(0),
            sig2[2] * \op2Amp.kr(0),
            sig2[3] * \op3Amp.kr(0)
        ]);
        sig = BLowPass.ar([sig, sig2], freq: cutOff.linlin(0, 20000, 20, 20000));
        //mix
        Out.ar(out, sig * amp * masterEnv);
    }).add;
}
);
)






//(
//)

//(
//SynthDef(\fm1, {
//    arg out = 0, fm1Freq = 400, gate = 1, amp = 0.2, index = 1, iScale = 5,
//    //carrier
//    op1Env1 = 0.01, op1Env2 = 0.2, op1Env3 = 0.8, op1Env4 = 0.2, op1Ratio = 1, op1Fine = 0,
//    //modulator
//    mAtk = 1.01, mDec = 1.2, mSus = 0.1, mRel = 0.2, mRatio = 1,
//    //mVib
//    mVibFreq = 0, mVibWidth = 0,
//    //mTremolo
//    mTremoloRate = 0, mTremoloAmount = 0;
//    var cEnv, mEnv, iEnv, car, mod, mVib, mTremolo;
//    4.do({
//        |i|

//    });
//    mVib = LFNoise2.kr(mVibFreq).range(1 - mVibWidth, 1 + mVibWidth);
//    mTremolo = LFNoise2.kr(mTremoloRate).range(1 - mTremoloAmount, 1 + mTremoloAmount);
//    iEnv = EnvGen.kr(Env.adsr(mAtk, mDec, mSus, mRel, peakLevel: index * iScale, bias: index), gate: gate);
//    cEnv = EnvGen.kr(Env.adsr(op1Env1, op1Env2, op1Env3, op1Env4), gate: gate, doneAction:2);
//    mod = SinOsc.ar((fm1Freq * mRatio * mVib), mul: fm1Freq * mRatio * iEnv * mTremolo);
//    car = SinOsc.ar((fm1Freq * (op1Ratio + op1Fine)) + mod)!2;
//    Out.ar(out, car * cEnv * amp);
//}).add;
//)
//(

///*
//---------------------new synthDef
//*/

//SynthDef(\fm2, {
//    arg out = 0, freq = 400, gate = 1, amp = 0.2, index = 1, iScale = 5,
//    //op1
//    op1Env0 = 0.01, op1Env1 = 0.2, op1Env2 = 0.8, op1Env3 = 0.2, op1Ratio = 1, op1Fine = 0,
//    op1FB = 0,
//    //op2
//    op2Env0 = 0.01, op2Env1 = 0.2, op2Env2 = 0.8, op2Env3 = 0.2, op2Ratio = 1, op2Fine = 0;

//    var op1Env, mEnv, iEnv, op1, op1Mod, op2, mVib, mTremolo, mod1;
//    //envelopes
//    iEnv = EnvGen.kr(Env.adsr(op2Env0, op2Env1, op2Env2, op2Env3, peakLevel: index * iScale, bias: index), gate: gate);
//    op1Env = EnvGen.kr(Env.adsr(op1Env0, op1Env1, op1Env2, op1Env3), gate: gate, doneAction:2);
//    //modin
//    mod1 = LocalIn.ar(20);
//    mod1 = mod1[0, 1] * op1FB;
//    //operatos
//    // op1Mod = SinOsc.ar((freq * (op1Ratio + op1Fine)), mul: op1Env * op1FB);

//    op2 = SinOsc.ar((freq * (op2Ratio + op2Fine)), mul: freq * op2Ratio * iEnv);

//    op1 = SinOsc.ar((freq * (op1Ratio + op1Fine)), phase:  mod1)!2 * op1Env;
//    // op1 = SinOsc.ar((freq * (op1Ratio + op1Fine)) + op2 + mod1)!2 * op1Env;
//    //modout
//    LocalOut.ar(op1[0,1]);

//    //out
//    Out.ar(out, op1 * amp);
//}).add;
//)
////multiple synthdefs
//(
//4.do({
//    |i|
//    SynthDef(\op++i, {
//        arg out = 0, modOut1 = 0, freq = 400, gate = 1, amp = 0.2, index = 1, iScale = 5,
//        env0 = 0.01, env1 = 0.2, env2 = 0.8, env3 = 0.2, ratio = 1, fine = 0;
//        var sig, env;
//        env = EnvGen.kr(Env.adsr(env0, env1, env2, env3), gate: gate, doneAction:2);
//        sig = SinOsc.ar((freq * (ratio + fine)))!2;
//        Out.ar(modOut1, sig * env * amp);
//        Out.ar(out, sig * env * amp);
//    }).add;
//})
//)

//(
//b.fm1Freq = 100;
//2.do({
//    |i|
//    Pbindef(\nyFms++i,
//        \instrument, \op0,
//        \dur, 1,
//        \index, 0,
//        \legato, 0.1,
//        // \amp, Pfunc{b.op[0].amp},
//        \amp, 0.1,
//        \freq, Pfunc{b.fm1Freq},
//        \ratio, Pfunc{b.op[i].ratio},
//        \fine, Pfunc{b.op[i].fine},
//        \env0, Pfunc{b.op[i].env[0]},
//        \env1, Pfunc{b.op[i].env[1]},
//        \env2, Pfunc{b.op[i].env[2]},
//        \env3, Pfunc{b.op[i].env[3]},
//        \modOut1, Pfunc{b.op[1].send[0]}
//    ).stop;
//})
//)
//(
//(
//(
//Pbindef(\fmi,
//    \instrument, \fm7,
//    \group, b.synths.fm,
//    \dur, 1,
//    \legato, 0.8,
//    \index, Pfunc{b.op[0].amp},
//    \amp, 0.29, 
//    \freq, [100, 150],
//    \atk, Pfunc{b.op[0].masterEnv[0]},
//    \dec, Pfunc{b.op[0].masterEnv[1]},
//    \sus, Pfunc{b.op[0].masterEnv[2]},
//    // \rel, Pfunc{b.op[0].masterEnv[3]}.trace,
//    \rel, 0, 
//    // \op0FB, Pfunc{b.op[0].fbLevel},

//    //op0
//    // \op0Amp, Pfunc{b.op,
//    \op0Amp, Pfunc{b.op[0].amp},
//    \op0_0, Pfunc{b.op[0].send[0]},
//    \op0Ratio, Pfunc{b.op[0].ratio},
//    \op0Fine, Pfunc{b.op[0].fine},
//    \atk0, Pfunc{b.op[0].env[0]},
//    \rel0, Pfunc{b.op[0].env[3]},
//    \detune0, Pfunc{b.op[0].detune},


//    //op1
//    \op1Amp, Pfunc{b.op[1].amp},
//    \op1_0, Pfunc{b.op[1].send[0]},
//    \op1_1, Pfunc{b.op[1].send[1]},
//    \op1Ratio, Pfunc{b.op[1].ratio},
//    \op1Fine, Pfunc{b.op[1].fine},
//    \atk1, Pfunc{b.op[1].env[0]},
//    \rel1, Pfunc{b.op[1].env[3]},
//    \detune1, Pfunc{b.op[1].detune},

//    //op2
//    \op2Amp, Pfunc{b.op[2].amp},
//    \op2_0, Pfunc{b.op[2].send[0]},
//    \op2_2, Pfunc{b.op[2].send[2]},
//    \op2Ratio, Pfunc{b.op[2].ratio}.trace,
//    \op2Fine, Pfunc{b.op[2].fine},
//    \atk2, Pfunc{b.op[2].env[0]},
//    \rel2, Pfunc{b.op[2].env[3]},
//    \detune2, Pfunc{b.op[2].detune},

//    //op
//    \op3Amp, Pfunc{b.op[3].amp},
//    \op3_0, Pfunc{b.op[3].send[0]},
//    \op3_2, Pfunc{b.op[3].send[2]},
//    \op3Ratio, Pfunc{b.op[3].ratio},
//    \op3Fine, Pfunc{b.op[3].fine},
//    \atk3, Pfunc{b.op[3].env[0]},
//    \rel3, Pfunc{b.op[3].env[3]},
//    \detune3, Pfunc{b.op[3].detune},
//    // \op1_0, 5,
//).play;
//)
//)

//(
//b.fm1Freq = 100;
//Pbindef(\fmpsatass,
//    \instrument, \fm2,
//    \dur, 1,
//    \index, 0.2,
//    \legato, 0.1,
//    \amp, Pfunc{b.op[0].amp},
//    \fm1Freq, Pfunc{b.fm1Freq},
//    \op1Ratio, Pfunc{b.op[0].ratio},
//    \op1Fine, Pfunc{b.op[0].fine},
//    \op1Env0, Pfunc{b.op[0].env[0]},
//    \op1Env1, Pfunc{b.op[0].env[1]},
//    \op1Env2, Pfunc{b.op[0].env[2]},
//    \op1Env3, Pfunc{b.op[0].env[3]},
//    \op1FB, Pfunc{b.op[0].fbLevel}.trace,
//    //op2
//    \op2Ratio, Pfunc{b.op[1].ratio},
//    \op2Fine, Pfunc{b.op[1].fine},
//    \op2Env0, Pfunc{b.op[1].env[0]},
//    \op2Env1, Pfunc{b.op[1].env[1]},
//    \op2Env2, Pfunc{b.op[1].env[2]},
//    \op2Env3, Pfunc{b.op[1].env[3]},
//).play;
//)



/*
---------------------midi
*/

MIDIClient.init;
MIDIIn.connectAll;


b.synths.notes = Array.newClear(128);
MIDIdef.noteOn(\noteOn, {
    |vel, nn, chan, src|
    // \freq, nn.midicps,

    switch(src,
        -979944653, {
    var valueArray = [
        \atk, b.op[0].masterEnv[0],
        \dec, b.op[0].masterEnv[1],
        \sus, b.op[0].masterEnv[2],
        \rel, b.op[0].masterEnv[3], 
        \cutOff, b.op[0].cutOff,

        //op0
        // \op0Amp, Pfunc{b.op,
        \op0Amp, b.op[0].amp,
        \op0_0, b.op[0].send[0],
        \op0_1, b.op[0].send[1],
        \op0_2, b.op[0].send[2],
        \op0_3, b.op[0].send[3],
        \op0Ratio,b.op[0].ratio,
        \op0Fine, b.op[0].fine,
        \atk0, b.op[0].env[0],
        \dec0, b.op[0].env[1],
        \sus0, b.op[0].env[2],
        \rel0, b.op[0].env[3],
        \detune0, b.op[0].detune,


        //op1
        \op1Amp, b.op[1].amp,
        \op1_0, b.op[1].send[0],
        \op1_1, b.op[1].send[1],
        \op1_2, b.op[1].send[2],
        \op1_3, b.op[1].send[3],
        \op1Ratio, b.op[1].ratio,
        \op1Fine, b.op[1].fine,
        \atk1, b.op[1].env[0],
        \dec1, b.op[1].env[1],
        \sus1, b.op[1].env[2],
        \rel1, b.op[1].env[3],
        \detune1, b.op[1].detune,

        //op2
        \op2Amp, b.op[2].amp,
        \op2_0, b.op[2].send[0],
        \op2_2, b.op[2].send[2],
        \op2_2, b.op[2].send[2],
        \op2_3, b.op[2].send[3],
        \op2Ratio, b.op[2].ratio,
        \op2Fine, b.op[2].fine,
        \atk2, b.op[2].env[0],
        \dec2, b.op[2].env[1],
        \sus2, b.op[2].env[2],
        \rel2, b.op[2].env[3],
        \detune2, b.op[2].detune,

        //op3
        \op3Amp, b.op[3].amp,
        \op3_0, b.op[3].send[0],
        \op3_2, b.op[3].send[2],
        \op3_2, b.op[3].send[2],
        \op3_3, b.op[3].send[3],
        \op3Ratio, b.op[3].ratio,
        \op3Fine, b.op[3].fine,
        \atk3, b.op[3].env[0],
        \dec3, b.op[3].env[1],
        \sus3, b.op[3].env[2],
        \rel3, b.op[3].env[3],
        \detune3, b.op[3].detune,
        \out, 12 
    ];
    b.synths.notes[nn] = Synth(\fm7, 
    [\freq, nn.midicps] ++
    valueArray, target:b.synths.fm;)
});
});

MIDIdef.noteOff(\noteOff, {
    |vel, nn, chan, src|
    switch(src,
        -979944653, {
    b.synths.notes[nn].set(\gate, 0)
});
});

i = [2, 9, 3];
o = [9, 5,5,5,5];
i = i++o;
i;

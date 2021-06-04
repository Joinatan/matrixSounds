//update controller osc
b.osc = NetAddr.new("127.0.0.1", 8080);
// b.oscBundle = OSCBundle.new;
b.updateController = {
4.do({ arg operator;
    Task.new({
    var arr = [3, 2, 0, 1];
        //masterEnv
        b.osc.sendMsg('/fmMain/env/'++operator, b.op[0].masterEnv[operator]);
        //cutOff
        b.osc.sendMsg('/fmMain/cutOff', b.op[0].cutOff);
        //outputVolume
        b.osc.sendMsg('/op'++operator++'/master', b.op[operator].amp);
        //fine
        b.osc.sendMsg('/op'++operator++'/fine', b.op[operator].fine);
        // b.osc.sendMsg('/op'++arr[operator]++'/fine', b.op[operator].fine);
        //ratio
        0.01.wait;
        b.osc.sendMsg('/op'++operator++'/ratio/'++b.op[operator].ratio++'/1', 1);
        0.01.wait;
        //spread
        b.osc.sendMsg('/op'++operator++'/spread', b.op[operator].detune);
        0.01.wait;

        ('/op'++operator++'/spread').postln;
    4.do({ arg i;
        var sends = i + 1;
        //sends
        b.osc.sendMsg('/op'++operator++'/send/'++sends, b.op[operator].send[i]);
        0.01.wait;
        //envelopes
        b.osc.sendMsg('/op'++operator++'/env'++i, b.op[operator].env[i]);

        0.01.wait;
    })
}).play;
});
};

//OSC
/*
---------------------osc
*/

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
    \cutOff,
    {
        arg msg, time, addr, port;
        // [msg, time, addr, port].postln
        b.op[0].cutOff = msg[1];
        b.synths.fm.set('cutOff', msg[1]);
        ('Cutoff: '++msg[1]).postln;
    },
    '/fmMain/cutOff'
);


/*
---------------------iterate number op operators
*/
4.do({
    |i|
    // var env = i + 1;
    var vol = i + 1;

    /*
    ---------------------op vol
    */
    OSCdef(
        \opVol++vol,
        {
            arg msg, time, addr, port;
            // [msg, time, addr, port].postln;
            b.synths.fm.set('op'++i++'Amp', msg[1]);
            b.op[i].amp = msg[1];
            ('OP_'++vol++'_vol: '++msg[1]).postln;
            // b.sendMsg("/fmMain/feedback/", msg[1]);
        },
        // '/fmMain/fader/'++vol,
        '/op'++i++'/master',
    );

    /*
    ---------------------master Env
    */
    OSCdef(
        \masterEnv++i,
        {
            arg msg, time, addr, port;
            b.op[0].masterEnv[i] = msg[1];
            ('MASTER_ENV_'++i++': '++msg[1]).postln;
        },
        '/fmMain/env/'++i,
    );

    /*
    ---------------------opEnv
    */

    4.do({
        |envNum|
        OSCdef(
            \opEnv++i++envNum,
            {
                arg msg, time, addr, port;
                b.op[i].env[envNum] = msg[1];
                ('OP'++i++'_ENV_'++envNum++': '++msg[1]).postln;
            },
            // '/op1/env/'++env,
            '/op'++i++'/env/'++envNum,
        );
    });

    /*
    ---------------------spread
    */
    OSCdef(
        \opSpread++i,
        {
            arg msg, time, addr, port;
            b.op[i].detune = msg[1];
            b.synths.fm.set('detune'++i, b.op[i].detune);
            ('OP'++i++'_SPREAD_: '++msg[1]).postln;
        },
        '/op'++i++'/spread',
    );

    /*
    ---------------------op sends
    */
    4.do({
        |opNumber|
        var opNum = opNumber;
        OSCdef(
            \op++i++opNum,
            {
                arg msg, time, addr, port;
                ('OP'++i++'_to_'++opNumber++': '++ msg[1]).postln;
                b.synths.fm.set('op'++i++'_'++opNumber, msg[1]);
                b.op[i].send[opNumber] = msg[1];
            },
            '/op'++i++'/send/'++opNum,
        );
    });

    /*
    ---------------------op1 feedback
    */

    // OSCdef(
    //     \opFB,
    //     {
    //         arg msg, time, addr, port;
    //         ('OP0_FB: '++ msg[1]).postln;
    //         b.op[0].fbLevel = msg[1];
    //     },
    //     '/op0/feedback',
    // );


    /*
    ---------------------fine tuning
    */

    OSCdef(
        \opFine++i,
        {
            arg msg, time, addr, port;
            b.op[i].fine = msg[1];
            b.synths.fm.set('op'++i++'Fine', msg[1]);
            ('OP'++i++'_FINE: '++msg[1]).postln;
        },
        '/op'++i++'/fine'
    );
    /*
    ---------------------ratio steps
    */
    OSCdef(
        \op1Ratio ++ i,
        {
            arg msg, time, addr, port;
            b.op[i].ratio = msg[1];
            b.synths.fm.set('op'++i++'Ratio', b.op[i].ratio);
            ('OP'++i++'_RATIO: '++b.op[i].ratio).postln;
        },
        '/op'++i++'/ratio',
    );
    //old touch osc

    // 8.do({
    //     |iRatio|
    //     var ratio = iRatio + 1;
    //     OSCdef(
    //         \op1Ratio ++ ratio,
    //         {
    //             arg msg, time, addr, port;
    //             b.op[i].ratio = ratio;
    //             b.synths.fm.set('op'++i++'Ratio', b.op[i].ratio);
    //             ('OP'++i++'_RATIO: '++ratio).postln;
    //         },
    //         '/op'++i++'/ratio/'++ratio++'/1',
    //     );
    // });
});

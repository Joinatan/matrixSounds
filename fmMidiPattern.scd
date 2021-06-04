/*
---------------------midipattern
*/



p = Pbindef(
    \hej,
    \dur, 1,
);
t = TempoClock.new(120/60).permanent_(true);



MIDIdef.noteOn(\noteOnPattern, {
    |vel, nn, chan, src|
    switch(src,
        1210500475, {
            t.beats = 0;
            'hej'.postln;
            p.play(t, quant:4);
        },
);
});

MIDIdef.noteOff(\noteOffPattern, {
    |vel, nn, chan, src|
    switch(src,
        1210500475, {'hejda'.postln; p.stop;},

);
});

// t.isRunning;
// t.beats ;
// t.beats = 0;
// t.stop;
// t.play;


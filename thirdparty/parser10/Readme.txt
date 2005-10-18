
  TParser version 10.1

  By
    Renate Schaaf (1993)
    Alin Flaider (1996, 1997)
    Stefan Hoffmeister (1996, 1997)


Demo program:
-------------

You can try the component without having to install it 
first. Open DEMO.DPR, ignore all errors complaining about 
a missing TParser.

Compile, run and have fun.



Installation:
-------------

  Delphi 1, Delphi 2:
  -------------------
    Copy P10BUILD.PAS,
         PARSER10.PAS,
         PARSER10.D16, { Delphi 1 }
         PARSER10.D32  { Delphi 2 }
    to your component directory.

    Select Component | Install
    Install PARSER10.PAS into your component library.


  Delphi 3:
  ---------
    Copy PARSER10.PAS, P10BUILD.PAS, PARSER10.D32 and PARSER.DPK 
    to your component directory. 
    PARSER10.D32 and PARSER.DPK must be in the same directory as
    in contrast to Delphi 1/2 the .DPK loads the bitmap.

    Select File | Open
    Load PARSER.DPK and select Install

    The package has been marked design-only.


  The correct mini icon (either .d16 or .d32) will be used
  automatically

  PARSER10.PAS uses P10BUILD.PAS - the parsing engine.

  [The .rc file contains the mini icon source ]
  [PARSER10.TXT contains some documentation   ]


Use and modification of TParser is entirely free, provided
that you preserve the following credits. Of course you use
the component entirely at your own risk.


Orginal credits:
----------------

  This component is based on the original parser Pars7 developed 
by Renate Schaaf (schaaf@math.usu.edu). Pars7 was fast indeed, 
but somehow restricted to scientific purposes due to the limited
number of predefined variables. Unfortunately, Pars7 also was quite 
stack hungry and had several elusive bugs while deallocating 
expression tree.

  Now dressed as a component, TParser has low stack demands even in
its 16 bit version, accepts practically an unlimited number of
variables, and several parts of the builder code were entirely 
rewritten for the sake of clarity.

  I would greatly appreciate suggestions, bug reports, any feed-back
that might contribute to further improve TParser's speed and 
functionality.

    Alin Flaider, aflaidar@datalog.ro


There is very little to add:
----------------------------

Now the component shares exactly the same source code in 16bit and
32bit - a lot of {$IFDEF}s but no maintenance nightmares...

Additionally the code has been streamlined a lot, making parsing
much faster than before. The code is more stable than ever before
with less risk of causing memory leaks due to sloppy use.

You really should run the demo and analyze the source code as I
have documented the demo extensively instead of writing extensive
documentation.

If you find bugs don't hesitate to contact me - I will do my best.
All bugs I am aware of (none currently) will be either documented
or fixed as soon as possible, so please *DO* report every problem!

Stefan
Stefan.Hoffmeister@Uni-Passau.de
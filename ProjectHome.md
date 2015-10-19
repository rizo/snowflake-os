Welcome to Snowflake, an operating system being written in the [O'Caml](http://caml.inria.fr/) language.

It is currently a very immature project, with little structure or design. A lot of code is mostly proof-of-concept, with some proper interfaces between components needing to be created.

It has the beginnings of audio output that works with [Virtual Box](http://www.virtualbox.org/)'s AC'97 audio controller. Have also experimented with using the [Bitstring](http://code.google.com/p/bitstring/) library for parsing network protocols, although it lacks network drivers and a network stack to really test the design.

Have also started working on what will hopefully be a basic yet functional ELF32 linker, capable of linking Snowflake. In theory, it should then be possible to link Snowflake using Snowflake; a very small step towards self-hosting.
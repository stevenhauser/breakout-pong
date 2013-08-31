# Breakout / Pong / Tetris

Simple, experimental, HTML-based breakout-style game that uses
[Backbone](http://backbonejs.org) and is scaffolded via [Yeoman](http://yeoman.io/).
I haven't built many games except very simple ones and this is mostly a
learning project for me.

## Demo

Presumably you can play a demo of this in-progress experiment [here](http://stevenhauser.github.io/breakout-pong/) but no guarantees on its unbrokenness.

## Todos

- **Improve graphics.**
  They're only simple debugging graphics right now.
- **Write specs.**
  Either learn Mocha or switch to Jasmine.
- **Improve collisions.**
  They're fairly accurate but bouncing is a little odd.
- **Investigate performance.**
  Framerate seems fine but memory is looking pretty saw-toothed.
- **Remove detached bricks.**
  If a set of bricks is hanging off of one and it's destroyed,
  all of the others should drop, too.
- **Push new rows.**
  Add new brick rows to the top after a bit.
- **Clean up some slop.**
- **Create levels.**
- **Create menu/start screen.**
- **Create pause menu.**
- **Create win screen.**

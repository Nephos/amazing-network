# Informations

There is no needed dependancies, unless you want html documentation.

## How to use ?

simply use it from your shell:

```bash
$ ./check_intersections -r 1.1.1.1/32,1.1.1.2/24,255.255.255.255/32,1.1.1.1/30
------|-------------------------------------------------------------------
base  | ip: 1.1.1.1/32         net: 1.1.1.1         broad: 1.1.1.1
------|-------------------------------------------------------------------
err.! | ip: 1.1.1.2/24         net: 1.1.1.0         broad: 1.1.1.255
err!! | ip: 255.255.255.255/32 net: 255.255.255.255 broad: 255.255.255.255
yes   | ip: 1.1.1.1/30         net: 1.1.1.0         broad: 1.1.1.3
```

## What is this ?

This programm has been created to study IP networks,
in the epitech context, with the network exams module.

## What it is not ?

This is not a program designed to cheat mothafoka.
If you are not skilled enough to compute this simple calculations
yourself, you should just go back to tek1 n00b.

## Network dev !

You can generate the documentation (using the gem yard ``gem install yard``).
You can also run the unitary tests via ``rake test``.

# Todo

- Improve unitary tests
- Implement the routing
- Implement Router
- Create interface to create network
- Add ping! with TTL
- Add a map view of the network (Oh yeah, without dependancies !!!!!)

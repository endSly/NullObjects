NullObjects
===========

NullObjects is a library for building [Null
Objects](http://en.wikipedia.org/wiki/Null_Object_pattern) in Objective-C. It's inspired by Ruby's [Naught](https://github.com/avdi/naught).

### Usage

<code>NONull</code> is a replacement for NSNull but it acts more similarity to nil. It never raises an exception when method is call.

#### Simple Null Object

```objective-C

#import <NullObjects/NullObjects.h>

id null = [NONull null];

[null foo]; // == nil

```

#### Blackhole

```objective-C

#import <NullObjects/NullObjects.h>

id null = [NONull blackhole];

[null foo]; // == [NONull blackhole]

```

### Replacing NSNull

Some system libraries uses <code>NSNull</code> for represent null object. <code>NONull</code> can replace <code>NSNull</code> object:

```objective-C

#import <NullObjects/NullObjects.h>

[NSNull actAsNullObject];
[NSNull actAsBlackhole];

```



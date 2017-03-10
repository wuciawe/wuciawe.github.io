---
layout: post
category: [jvm]
tags: [jvm, java]
infotext: 'it is mainly about nested class, also refers to static keyword and inheritance'
---
{% include JB/setup %}

In this post, I will mainly talk about the nested class in Java. `static` keyword 
and something of inheritance will be mentioned very shortly.

### The Nested Class

According to [Java Tutorial](http://docs.oracle.com/javase/tutorial/java/javaOO/nested.html){:target='_blank'}, 
we have

> __Terminology__: Nested classes are divided into two categories: static and non-static. 
> Nested classes that are declared static are called static nested classes. Non-static 
> nested classes are called inner classes.

#### Static Class

Top level class can not be declared as `static`. Only nested classes can be declared 
as `static`.

A static class is a class declared as a static member of another class. It can access 
other static members of the class. The containing class is like a package in the view 
of namespace. Following is an example:

{% highlight java %}
class O {
  static int n = 1;
  
  static class I {
    int b = n;
  }
}
{% endhighlight %}

Use the command `javap -c -s -v -p <class>`, we can decompile the class, where `O` is 
like:

{% highlight console %}
{
  private static int n;
    descriptor: I
    flags: ACC_PRIVATE, ACC_STATIC

  O();
    descriptor: ()V
    flags:
    Code:
      stack=1, locals=1, args_size=1
         0: aload_0
         1: invokespecial #2                  // Method java/lang/Object."<init>":()V
         4: return
      LineNumberTable:
        line 1: 0

  static int access$000();
    descriptor: ()I
    flags: ACC_STATIC, ACC_SYNTHETIC
    Code:
      stack=1, locals=0, args_size=0
         0: getstatic     #1                  // Field n:I
         3: ireturn
      LineNumberTable:
        line 1: 0

  static {};
    descriptor: ()V
    flags: ACC_STATIC
    Code:
      stack=1, locals=0, args_size=0
         0: iconst_1
         1: putstatic     #1                  // Field n:I
         4: return
      LineNumberTable:
        line 2: 0
}
{% endhighlight %}

And `I` is like:

{% highlight console %}
{
  int b;
    descriptor: I
    flags:

  O$I();
    descriptor: ()V
    flags:
    Code:
      stack=2, locals=1, args_size=1
         0: aload_0
         1: invokespecial #1                  // Method java/lang/Object."<init>":()V
         4: aload_0
         5: invokestatic  #2                  // Method O.access$000:()I
         8: putfield      #3                  // Field b:I
        11: return
      LineNumberTable:
        line 4: 0
        line 5: 4
}
{% endhighlight %}

We can see that the static class `I` can easily access the `private static` member of 
`O` with the compiler auto-generated `synthetic` method `access$000`.

The nested classes are compiled as sperated classes with respect to their 
containing classes. In order to overcome the privilege restriction, some synthetic 
methods are generated.

The static class is very useful in many design patterns, such as 
[singleton pattern]({%post_url 2014-08-20-design-pattern-part-1%}), and 
[builder pattern](http://rwhansen.blogspot.com/2007/07/theres-builder-pattern-that-joshua.html){:target='_blank'}.

Top level classes and static class are semantically the same.

#### Inner Class

An inner class is a class declared as a non-static member of another class. Every 
instance of an inner class is tied to a particular instance of its containing class. 
Following is an example:

{% highlight java %}
class O {
  int n = 1;

  class I {
    int b = n;
  }

  I getAnI(){
    return new I();
  }
}

class M {
  O o = new O();
  O.I i1 = o.getAnI();
  O.I i2 = o.new I();
}
{% endhighlight %}

Here I show two ways to create instances of an inner class in class `M`. Note the 
`o.new I()`, it gives the compiler a way to tie inner class instance to its containing 
class instance.

Decompiled for `O`:

{% highlight console %}
{
  int n;
    descriptor: I
    flags:

  O();
    descriptor: ()V
    flags:
    Code:
      stack=2, locals=1, args_size=1
         0: aload_0
         1: invokespecial #1                  // Method java/lang/Object."<init>":()V
         4: aload_0
         5: iconst_1
         6: putfield      #2                  // Field n:I
         9: return
      LineNumberTable:
        line 1: 0
        line 2: 4

  O$I getAnI();
    descriptor: ()LO$I;
    flags:
    Code:
      stack=3, locals=1, args_size=1
         0: new           #3                  // class O$I
         3: dup
         4: aload_0
         5: invokespecial #4                  // Method O$I."<init>":(LO;)V
         8: areturn
      LineNumberTable:
        line 9: 0
}
{% endhighlight %}

Decompiled for `I`:

{% highlight console %}
{
  int b;
    descriptor: I
    flags:

  final O this$0;
    descriptor: LO;
    flags: ACC_FINAL, ACC_SYNTHETIC

  O$I(O);
    descriptor: (LO;)V
    flags:
    Code:
      stack=2, locals=2, args_size=2
         0: aload_0
         1: aload_1
         2: putfield      #1                  // Field this$0:LO;
         5: aload_0
         6: invokespecial #2                  // Method java/lang/Object."<init>":()V
         9: aload_0
        10: aload_0
        11: getfield      #1                  // Field this$0:LO;
        14: getfield      #3                  // Field O.n:I
        17: putfield      #4                  // Field b:I
        20: return
      LineNumberTable:
        line 4: 0
        line 5: 9
}
{% endhighlight %}

The synthetic field `final O this$0;` inside the inner class is the result of tying, via 
this field the inner class instance can access its containing class instance non-static 
members.

In the inner class `this` refers to itself, `O.this` refers to its containing class 
instance.

Inner classes in static contexts, i.e. an anonymous class used in static initilizer 
block, do not have lexically enclosing instances.

An inner class may not have static members.

The inner class includes: __local inner class__, __anonymouse class__ and 
__non-static member class__. What I have already shown is the __non-static member class__.

##### Local Inner Class

A local inner class is declared inside of a block. The local inner class instance is 
tied to and can access the final local variables of its containing method. When the 
instance uses a final local of its containing method, the variable retains the value it 
held at the time of the instance's creation, even if the variable has gone out of scope.

A local inner class is neither the member of a class or package, it is not declared 
whith an access level.

If a loal inner class is declared in an instance method, an instantiation of the inner 
class is tied to the instance held by the containing method's `this` at the time of the 
instance's creation.

{% highlight java %}
class O {
  void m(int x) {
    final double z = 0.1;
    double z1 = 0.2;
    class I {
      int y = x;
      double u = z;
      double u1 = z1;
    }
    I i = new I();
  }
}
{% endhighlight %}

Decompiled `O`:

{% highlight console %}
{
  O();
    descriptor: ()V
    flags:
    Code:
      stack=1, locals=1, args_size=1
         0: aload_0
         1: invokespecial #1                  // Method java/lang/Object."<init>":()V
         4: return
      LineNumberTable:
        line 1: 0

  void m(int);
    descriptor: (I)V
    flags:
    Code:
      stack=6, locals=7, args_size=2
         0: ldc2_w        #2                  // double 0.2d
         3: dstore        4
         5: new           #4                  // class O$1I
         8: dup
         9: aload_0
        10: iload_1
        11: dload         4
        13: invokespecial #5                  // Method O$1I."<init>":(LO;ID)V
        16: astore        6
        18: return
      LineNumberTable:
        line 4: 0
        line 10: 5
        line 11: 18
}
{% endhighlight %}

Decompiled `I`:

{% highlight console %}
{
  int y;
    descriptor: I
    flags:

  double u;
    descriptor: D
    flags:

  double u1;
    descriptor: D
    flags:

  final int val$x;
    descriptor: I
    flags: ACC_FINAL, ACC_SYNTHETIC

  final double val$z1;
    descriptor: D
    flags: ACC_FINAL, ACC_SYNTHETIC

  final O this$0;
    descriptor: LO;
    flags: ACC_FINAL, ACC_SYNTHETIC

  O$1I();
    descriptor: (LO;ID)V
    flags:
    Code:
      stack=3, locals=5, args_size=4
         0: aload_0
         1: aload_1
         2: putfield      #1                  // Field this$0:LO;
         5: aload_0
         6: iload_2
         7: putfield      #2                  // Field val$x:I
        10: aload_0
        11: dload_3
        12: putfield      #3                  // Field val$z1:D
        15: aload_0
        16: invokespecial #4                  // Method java/lang/Object."<init>":()V
        19: aload_0
        20: aload_0
        21: getfield      #2                  // Field val$x:I
        24: putfield      #5                  // Field y:I
        27: aload_0
        28: ldc2_w        #6                  // double 0.1d
        31: putfield      #8                  // Field u:D
        34: aload_0
        35: aload_0
        36: getfield      #3                  // Field val$z1:D
        39: putfield      #9                  // Field u1:D
        42: return
      LineNumberTable:
        line 5: 0
        line 6: 19
        line 7: 27
        line 8: 34
    Signature: #26                          // ()V
}
{% endhighlight %}

Now the `I` is generated as `O$1I`, also note the difference between the `final` `z` and 
non-`final` `z1`.

##### Anonymous Class

An anonymous class is an unnamed inncer class whose instance are created in expressions 
and statements. It is syntactically convenient way of writing a local inner class. It 
can be used to add new members or methods.

Let's see an example:

{% highlight java %}
class C {}

class O {
  int m() {
    return new C(){
      int m(){
        return 1;
      }
    }.m();
  }
}
{% endhighlight %}

Decompiled `O`:

{% highlight console %}
{
  O();
    descriptor: ()V
    flags:
    Code:
      stack=1, locals=1, args_size=1
         0: aload_0
         1: invokespecial #1                  // Method java/lang/Object."<init>":()V
         4: return
      LineNumberTable:
        line 3: 0

  int m();
    descriptor: ()I
    flags:
    Code:
      stack=3, locals=1, args_size=1
         0: new           #2                  // class O$1
         3: dup
         4: aload_0
         5: invokespecial #3                  // Method O$1."<init>":(LO;)V
         8: invokevirtual #4                  // Method O$1.m:()I
        11: ireturn
      LineNumberTable:
        line 5: 0
        line 9: 8
}
{% endhighlight %}

Decompiled anonymous class:

{% highlight console %}
{
  final O this$0;
    descriptor: LO;
    flags: ACC_FINAL, ACC_SYNTHETIC

  O$1(O);
    descriptor: (LO;)V
    flags:
    Code:
      stack=2, locals=2, args_size=2
         0: aload_0
         1: aload_1
         2: putfield      #1                  // Field this$0:LO;
         5: aload_0
         6: invokespecial #2                  // Method C."<init>":()V
         9: return
      LineNumberTable:
        line 5: 0

  int m();
    descriptor: ()I
    flags:
    Code:
      stack=1, locals=1, args_size=1
         0: iconst_1
         1: ireturn
      LineNumberTable:
        line 7: 0
}
{% endhighlight %}

Everything should be clear enough. There also exists a special way to create an anonymous 
class, called __double brace initialization__.

The first brace creates a new anonymous inner class. The second brace creates an instance 
initializers like static block in Class.

{% highlight java %}
class C {
  int i = 1;
}

class O {
  int m() {
    C c = new C(){{ i = 2;}};
    return c.i;
  }
}
{% endhighlight %}

Decompiled for anonymous class:

{% highlight console %}
{
  final O this$0;
    descriptor: LO;
    flags: ACC_FINAL, ACC_SYNTHETIC

  O$1(O);
    descriptor: (LO;)V
    flags:
    Code:
      stack=2, locals=2, args_size=2
         0: aload_0
         1: aload_1
         2: putfield      #1                  // Field this$0:LO;
         5: aload_0
         6: invokespecial #2                  // Method C."<init>":()V
         9: aload_0
        10: iconst_2
        11: putfield      #3                  // Field i:I
        14: return
      LineNumberTable:
        line 7: 0
}
{% endhighlight %}

### `static`

Now let's talk about the keyword `static` that is mensioned so many times in the above.

This keyword can be used to decorate fields and methods of a Class in Java. As we 
see above, it can also be used to decorate nested class. And there exists `static 
block` for initialization of class instances (static fields).

At the bytecode level, all of the static initializers (static fields that are 
non-final or initialized to a nonconstant expression) are compiled and concatenated 
into one method, called `clinit`.

`clinit` is called automatically by the JVM after a class is loaded.

The __initialization-on-demand holder__ idiom is a __lazy-loaded singleton__. 

{% highlight java %}
class A {
  private A();
  private static class H {
    private static final A INSTANCE = new A();
  }
  public static A getInstance(){
    return H.INSTANCE;
  }
}
{% endhighlight %}

It works, because when class `A` is loaded by the JVM, the class goes through 
initialization. Since the class does not have any static variables to initialize, 
the initialization completes trivially.

The static class `H` within `A` is not initialized until the JVM determines that 
`H` must be executed. The static class `H` is only executed when the static method 
`getInstance` is invoked on the class `A`, and the first time this happens the JVM 
will load and initialize the `H` class. The initialization of `H` class results in 
static variable `INSTANCE` being initialized.

So it is lazy and concurrent safy, as the `JLS` guarantees the class initialization 
phase is serial.

### Something related to Inheritance

Let's first look at the following code:

{% highlight java %}
class B {
  int n0 = -1;
  int n = 1;
  int myN(){
    return n;
  }
  static int sMyN(){
    return 1;
  }
}
class C extends B {
  int n = 2;
  int myN(){
    return n;
  }
  static int sMyN(){
    return 2;
  }
}
class I {
  void m(){
    C c = new C();
    B b = c;
    int bn0 = b.n0;
    int cn0 = c.n0;
    int bn = b.n;
    int cn = c.n;
    int bn1 = b.myN();
    int cn1 = c.myN();
    int bn2 = b.sMyN();
    int cn2 = c.sMyN();
  }
}
{% endhighlight %}

There is a base class `B`, extended by class `C`. Let's see the decompiled `I`:

{% highlight console %}
{
  I();
    descriptor: ()V
    flags:
    Code:
      stack=1, locals=1, args_size=1
         0: aload_0
         1: invokespecial #1                  // Method java/lang/Object."<init>":()V
         4: return
      LineNumberTable:
        line 20: 0

  void m();
    descriptor: ()V
    flags:
    Code:
      stack=2, locals=11, args_size=1
         0: new           #2                  // class C
         3: dup
         4: invokespecial #3                  // Method C."<init>":()V
         7: astore_1
         8: aload_1
         9: astore_2
        10: aload_2
        11: getfield      #4                  // Field B.n0:I
        14: istore_3
        15: aload_1
        16: getfield      #5                  // Field C.n0:I
        19: istore        4
        21: aload_2
        22: getfield      #6                  // Field B.n:I
        25: istore        5
        27: aload_1
        28: getfield      #7                  // Field C.n:I
        31: istore        6
        33: aload_2
        34: invokevirtual #8                  // Method B.myN:()I
        37: istore        7
        39: aload_1
        40: invokevirtual #9                  // Method C.myN:()I
        43: istore        8
        45: aload_2
        46: pop
        47: invokestatic  #10                 // Method B.sMyN:()I
        50: istore        9
        52: aload_1
        53: pop
        54: invokestatic  #11                 // Method C.sMyN:()I
        57: istore        10
        59: return
      LineNumberTable:
        line 22: 0
        line 23: 8
        line 24: 10
        line 25: 15
        line 26: 21
        line 27: 27
        line 28: 33
        line 29: 39
        line 30: 45
        line 31: 52
        line 32: 59
}
{% endhighlight %}

We can see that the non-static method `myN` is virtual, which means it is dynamic 
binding. `C` overrides `myN`.

`C` inherits `n0` from `B`, it also hides `n` of `B`. The fields are different from 
the methods.

And the static method `sMyN` is not virtual. The static methods do not belong to the 
objects, they belong to the class. `C` hides `sMyN`.

---
layout: post
category: [scala, object oriented]
tags: [scala, object oriented]
infotext: 'About the type system of Scala'
---
{% include JB/setup %}

Many people argue that the type system in Scala is pretty complicated and strict. That's true. And sometimes the complexity 
really confuses me in designing the type structure of a project. It really needs some thoughts before determining the type 
structure. Some compiling error or runtime error finally turns out to be the result of not understanding the type system 
of Scala enough. So in this post, I will talk about something about the type system in Scala, which I think is fundamental and 
important. I think the content will probably be incomplete and not well organized because of my restricted understanding 
of it..

<!-- more -->

## Type System

The `Any` is the base of all the types in Scala.

The `AnyVal` is the subtype of `Any`, and the base class of all the primitive value types such as `Int`, `Char`, `Boolean` and so on.

The `AnyRef` is the subtype of `Any`, and the bse class of all the other objects in Scala. It is pretty like the `java.lang.Object` in 
Java. All the references are of the type `AnyRef`.

While the `Nothing` is the subtype of all the types in Scala, it extends everything in Scala.

I do think things like the inheritance, conform, etc are highly related with the concept of [Variance(Covariance/Countervariance)]({% post_url 2014-09-04-variance-in-scala %}).

## Class and Object

The concept of `class` in Scala is pretty similar with that in other object oriented programming languages. And the class name denotes the type of the class.
  
The concept of `object` in Scala is that it denotes the singleton object and the `companion object` of the class with the same name. 
In order to get the type of an `object`, you need to use `object.type` instead of the name of the `object`. The companion object 
has the same access rights as its related class.

## Trait and Type Linearization

The `trait` is something like the `interface` in Java, but has differences. The `trait` in Scala can have something like `field` in 
Java which is not allowed in Java for `interface`. Since the functions in Scala are first class citizens as well as values, 
then it will be common for `trait` to contain both functions and values.(??? oops, maybe this is a mistake, methods are 
different from functions, and there are also something like function literals and function values, there will be some post 
about these.)

Like that in Java, you can extends only one base class but with multiple traits in Scala. Thanks to the `type linearization`, you 
will meet the `diamond problem` in Scala. The `diamond problem` is the problem that we are not sure what we want to refer to in 
multiple inheritance, for example:

If type A defines a method commonMethod(), and type B and type C both inherit type A and override the commonMethod(), and then 
type D extends both B and C, which version of commonMethod() will super.commonMethod() really call?

With `type linearization`, there will be no such kind of ambiguity. It works as follows:

-   start building a list of types, the first element is the type we're linearing right now
-   expand each supertype recursively and put all their types into this list
-   remove duplicates from the resulting list, by scanning it from the left to right, removing all the types that already appeared

{% highlight scala %}
trait A {def common = "A"}
// Any with AnyRef with A

trait B extends A { override def common = "B" }
// Any with AnyRef with A with B

trait C extends A { override def common = "C" }
// Any with AnyRef with A with C

class D extends B with C
new D common == "C"
// Any with AnyRef with A with B with Any with AnyRef with A with C with D
// Any with AnyRef with A with B with C with D

class E extends C with B
new E common == "B"
// Any with AnyRef with A with C with B with E
{% endhighlight %}

Simply thinking, the right wins providing the implementation and the left one decides the super call along the linearization.

## Structural Subtyping, Refinement Types, Early Initialization

When a class inherits from another, the first class is said to be a `nominal` subtype of the other one. It's a `nominal` 
subtype because each type has a name, and the names are explicitly declared to have a subtyping relationship. Scala also 
supports `structural subtyping`, where the subtyping relationship is of the types having the same members. To get structural 
subtyping in Scala, use Scala's `refinement types`.

Following is an example:

{% highlight scala %}
using(new PrintWriter("data")){
    writer => writer.println(new Date)
}

using(serverSocket.accept()){
    socket => socket.getOutputStream().write("hello world".getBytes)
}

def using[T <: { def close():Unit }, S](obj: T)(operation: T => S) = {
    val result = operation(obj)
    obj.close()
    result
}
{% endhighlight %}

In the above example, the upper bound of type T is a refined type, which refines type Any with a method close(). It is a 
structural type as well, as it has no name.

Another thing should be noticed is that `structural subtyping` may cause negative impacts at runtime performance, since it 
is implemented by using reflection.

[Here](http://stackoverflow.com/questions/25518226/scala-parameter-type-in-structural-refinement){:target="_blank"} is a 
problem I met before related with this topic.

Now, it's time for early initialization.

Before that, I will first talk about one difference between class and trait in Scala. The class may take parameters in 
initialization, but the trait can not have parameters in initialization. For example:

{% highlight scala %}
class A (val a: Double, val b: Int){
    require(b != 0)
    val c = a / b
}

trait B {
    val a: Double
    val b: Int
    require(b != 0)
    val c = a / b
}

new A(2.0, 2) // works fine

new B{
    val a = 2.0
    val b = 2
} // this will throw runtime exception
{% endhighlight %}

Because trait can not take parameters in the process of initialization, new B{...} is actually a refinement. It first 
instantiates the trait B, then refine it with concrete definitions of a and b, which is actually a new type which is 
anonymous and is the subtype of trait B. This is common, the super class should be instantiated first then be the subclass.

In order to make the refinements available in the instantiation of the trait, one way is to use the early initialization, 
the other way is to use `lazy val`s.

{% highlight scala %}
new {
    val a = 2.0
    val b = 2
} with B
{% endhighlight %}

The above codes illustrate the use of early initialization. Just first initialise a type with corresponding fields then mix 
in the trait. Although it also uses the refinement mechanism, they are different.

{% highlight scala %}
new B {
    val a = 2.0
    val b = 2
}
// Any with AnyRef with B with anno

new {
    val a = 2.0
    val b = 2
} with B
// Any with AnyRef with anno with B
{% endhighlight %}

Sure, the resulted type is different. (The anno denotes the anonymous type.)

And because pre-initialized fields are initialized before the superclass constructor is called, their initializers cannot
refer to the object that's being constructed. Consequently, if such an initializer refers to `this`, the reference goes to 
the object containing the class or object that's being constructed, not the constructed object itself. The pre-initialized 
fields behave in this respect like class constructor arguments.

## Path Dependent Type and Type Projection

The inner class types in Java can be represented as `Type Projection` in Scala, while Scala provides a more strict thing 
called path dependent type.

{% highlight scala %}
class Parent{ // outer class
    class Child // inner class
}

class Family(p: Parent){
    type ChildOfParent = p.Child
    
    def add(c: ChildOfParent) = ??? // only accept child of specific parent
}

class School{
    def add(c: Parent#Child) = ??? // accept children of any parent
}
{% endhighlight %}

In the above example, it illustrates the difference between path dependent type and the type projection. The path dependent 
type is more strict restriction of type. I think this is very a nice mechanism for the type system. It's very intuitive.

## Coming soon

There are some other things remained to write in this post.

Actually I find another blog writing related things, see [here](http://ktoso.github.io/scala-types-of-types/){:target="_blank"}.
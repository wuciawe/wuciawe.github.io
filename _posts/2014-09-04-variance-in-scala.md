---
layout: post
category: [scala]
tags: [scala, java, object orianted, functional programming]
infotext: 'Introduction to the Variance in Scala, which is important to generic type designs. Taking it carefully to own type safe codes.'
---
{% include JB/setup %}

> Let q(x) be a property provable about objects x of type T. Then q(y) should be provable for objects y of type S where 
> S is a subtype of T.
>  --- --- `Liskov substitution principle`

What `Liskov substitution principle` talks about is: it is safe to assume that a type `T` is a subtype of a type `U` if 
you can substitute a value of type `T` wherever a value of type `U` is required. This principle plays important rule in 
object oriented languages, as superclass handler can refer to its subclass instance according to this rule.

When you design generic types, you may face the problem what is the substitutability between different parametrized 
generic instances. In this case, you can use variance to determine when one can substitute another. And immutable data types 
are always easier to analyze than mutable ones.
 
<!-- more -->

## Covariant, contravariant and invariant

The covariant means that, if type A is the subtype of type S and the generic type G[T] is covariant, then G[A] is also 
the subtype of G[S].

The contravariant means that, if type A is the subtype of type S and the generic type G[T] is contravariant, then G[A] is 
the supertype of G[S].

While invariant means that, if generic type G[T] is invariant, then G[A] and G[S] can not substitute each other regardless 
relationship between A and S.

## Mutable data type with variance

The `Array` in Java is covariant by default. Following code in Java compiles fine, but it will cause runtime error:

{% highlight java %}
public class testj {
    public static void main(String[] args) {
        String[] a = {"123"};
        Object[] arr = a;
        arr[0] = 1;
        String s = a[0];
    }
}
{% endhighlight %}

Because `Array` is covariant, arr can hold a. When you assign int 1 to a's first element, what you really do is trying 
to assign an int to a String Array, which will cause problem.

Let's imagine that, `Array` is immutable, every time updating `Array` will create a new instance of `Array` and the old 
one keeps no change. Than above code may work perfectly great.

## Functions' variance in Scala

In Scala, functions will be instantiated as the subclass of FunctionN[+T1, ..., +TN, -Tr], where T1 to TN are types of 
arguments and contravariant and Tr is type of return value and covariant. It's best to illustrate it with an example:

{% highlight scala %}
object test {
  class Animal {
    def eat(): Unit = {}
  }
  
  class Bird extends Animal{
    def fly(): Unit = {}
  }
  
  def f1(a: Animal): String = {
    a.eat()
    "feeling full"
  }
  
  val f2: (Bird) => Any = f1
}
{% endhighlight %}

We have a superclass Animal and it's subclass Bird, a function f1 with type (Animal) => String and another function f2 
with type (Bird) => Any. Since Any is the super class of String and the return value should be covariant, and Bird 
is the subclass of Animal and arguments should be contravariant, f2 can hold the value of f1 as f1.type conforms to f2.type.

Let's what's really happened with f2. When we call f2 with argument of type Bird, a Bird instance is sent to f1, and f1 
requires argument of type Animal and all the operations in f1 is on an instance of Animal, which means operations in f1 
are always valid with Bird and f1 requires less than f2. When f2 finishes it's work and return the result, what we expect 
is an instance of Any, while the real returned valued by f1 is an instance of type String, which is also an instance of 
Any and that means f1 provides more than f2. Every thing satisfies intuition well.

## Checking variance annotation

`(this paragraph is picked from the book Programming in Scala)`

To verify correctness of variance annotations, the Scala compiler classifies all positions in a class or trait body as 
positive, negative, or neutral. A “position” is any location in the class (or trait, but from now on we’ll just write 
“class”) body where a type parameter may be used. Every method value parameter is a position, for example, because a 
method value parameter has a type, and therefore a type parameter could appear in that position.

The compiler checks each use of each of the class’s type parameters. Type parameters annotated with + may only be used 
in positive positions, while type parameters annotated with - may only be used in negative positions. A type parameter 
with no variance annotation may be used in any position, and is, therefore, the only kind of type parameter that can be 
used in neutral positions of the class body.

To classify the positions, the compiler starts from the declaration of a type parameter and then moves inward through 
deeper nesting levels. Positions at the top level of the declaring class are classified as positive. By default, 
positions at deeper nesting levels are classified the same as that at enclosing levels, but there are a handful of 
exceptions where the classification changes. Method value parameter positions are classified to the flipped 
classification relative to positions outside the method, where the flip of a positive classification is negative, the 
flip of a negative classification is positive, and the flip of a neutral classification is still neutral.

Besides method value parameter positions, the current classification is also flipped at the type parameters of methods. 
A classification is sometimes flipped at the type argument position of a type, such as the Arg in C[Arg], depending on 
the variance of the corresponding type parameter. If C ’s type parameter is annotated with a + then the classification 
stays the same. If C ’s type parameter is annotated with a - , then the current classification is flipped. If C ’s type 
parameter has no variance annotation then the current classification is changed to neutral.

Finally an example:

{% highlight scala %}
abstract class Cat[-T, +U] {
  def meow[W(−)](volume: T(−), listener: Cat[U(+), T(−)](−) )
    : Cat[Cat[U(+) , T(−) ](−) , U(+)](+)
}
{% endhighlight %}

## Lower Bound and Upper Bound

Say we are going to implement an immutable Array which is covariant, and try it as:

{% highlight scala %}
class ImmutableArray[+T]private(list: List[T]){
  def this(args: T*) = this(args.toList)
  def apply(idx: Int, arg: T): ImmutableArray[T] ={
    val (a, b) = list splitAt idx
    new ImmutableArray[T](a ::: arg :: b.tail)
  }
  override def toString = list.mkString(" ")
}
{% endhighlight %}

You fails because you try to put covariant values to the contravariant positions as the arguments of functions. In this case, 
you can use `Lower Bound` to solve this problem: 

{% highlight scala %}
object test {
  class ImmutableArray[+T]private(list: List[T]){
    def apply[U >: T](idx: Int, arg: U): ImmutableArray[U] ={
      val (a, b) = list splitAt idx
      new ImmutableArray[U](a ::: arg :: b.tail)
    }
    override def toString = list.mkString(" ")
  }
  object ImmutableArray{
    def apply[U](args: U*) = new ImmutableArray[U](args.toList)
  }

  def main(args: Array[String]) {
    val arr1 = ImmutableArray[Int](1,2,3,4)
    println(arr1)
    val arr2 = arr1(1, 'a')
    println(arr1)
    println(arr2)
  }
}
{% endhighlight %}

With the help of `Lower Bound` `>:`, type U must be at least type T and conforms to the requirement of contravariant. 
When we want to update the arr1 with type ImmutableArray[Int] , what we really get is a new instance of ImmutableArray[AnyVal] 
arr2 without changing the content of arr1.

The use of `Upper Bound` is similar, when you want to compare two instances of type T, you may require T with uppper bound 
with Ordered[T] as T <: Ordered[T], then you can directly use <, >, <=, >= on the instances.

## Special case with object private data

Sometimes, efficiency is essential so that we introduce mutable data into the functional objects keeping object still purely 
functional, such as adding private cache field into an object to avoid redundant calculations. How to make an object 
containing mutable fields covariant/contravariant?

The answer is: when a covariant value with modifier `private[this]` appears at the position requiring contravariant value, 
the compiler will omit the variance checking rule, vice versa. This is because problems with variance only occur once 
the compile-time and run-time type of an object differ. If we have object-private (or object-protected) fields, this 
situation cannot occur. There will be no cast. For more explanation, 
[see here]( http://stackoverflow.com/questions/16428847/why-is-it-safe-not-to-check-object-private-or-object-protected-definitions-for-t ){:target="_blank"}.
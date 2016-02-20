---
layout: post
category: [scala, algorithm]
tags: [scala, sort]
infotext: 'The implementation of merge sort in Scala taking advantage of tail recursion.'
---
{% include JB/setup %}

The most used data collection in Scala is immutable `List`. Many algorithms can be implemented with `List`, which are safer, more 
functional and easier to understand than that with mutable collections, regardless of efficiency. In the book `Programming in Scala`, 
there is an implementation of merge sort. But it's not so good.

<!-- more -->

If you use the merge sort in book with large `List`, you will face the `java.lang.StackOverflowError`. To explain it, let's first 
watch following code:

{% highlight scala linenos=table %}
import scala.util.Random

object test {
  def msort0[T <% Ordered[T]](xs: List[T]): List[T] = {
    def merge(xs: List[T], ys: List[T]): List[T] = (xs, ys) match {
      case (_, Nil) => xs
      case (Nil, _) => ys
      case (x :: xs1, y :: ys1) =>
        if (x < y) x :: merge(xs1, ys)
        else y :: merge(xs, ys1)
    }
    val n = xs.length / 2
    if (n == 0) xs
    else {
      val (ys, zs) = xs splitAt n
      merge(msort0(ys), msort0(zs))
    }
  }

  def main(args: Array[String]) {
    val list = Seq.fill(50000)(Random.nextInt(500)).toList
    println(msort0(list))
  }
}
{% endhighlight %}

In the above code, the `msort0` function will recursively call itself in the statement `merge(msort0(ys), mosrt0(zs))`. 
Further more, in the `merge` function, it will also recursively call itself. None of them are tail recursion, which means 
that every function call will stay in the stack until its children function calls return results, and it will result in 
too many functions being on the stack and finally cause the `StackOverflowError`.

Below is a better way to implement the merge sort:

{% highlight scala linenos=table %}
import scala.annotation.tailrec
import scala.util.Random

object test {

  def msort[T <% Ordered[T]](xs: List[T]): List[T] = {

    @tailrec
    def merge(res: List[T], xs: List[T], ys: List[T]): List[T] = (xs, ys) match {
      case (_, Nil) => res.reverse ::: xs
      case (Nil, _) => res.reverse ::: ys
      case (x :: xs1, y :: ys1) =>
        if (x < y) merge(x :: res, xs1, ys)
        else merge(y :: res, xs, ys1)
    }

    val n = xs.length / 2
    if (n == 0) xs
    else {
      val (ys, zs) = xs splitAt n
      merge(Nil, msort(ys), msort(zs))
    }
  }

  def main(args: Array[String]) {
    val list = Seq.fill(50000)(Random.nextInt(500)).toList
    println(msort(list))
  }
}
{% endhighlight %}

Although the `msort` function is still not tail recursive, the `merge` function is now tail recursive which can utilize 
the compiler to optimizing corresponding byte code with direct jumping back instead of creating new function call in the 
stack. As a result, the tail recursive function gets similar efficiency with loops and is stack-saving.

So in the above case, time of creating new function stack has been reduced dramatically. And finally we avoid `StackOverflowError` 
in the `main` method.
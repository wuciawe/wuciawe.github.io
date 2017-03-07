---
layout: post
category: [scala]
tags: [scala]
infotext: 'simplified implementation of Promise and Future in Scala.'
---
{% include JB/setup %}

I was always wondering what is the magic behind the `Future[T]` in Scala, and finally I found no 
magic but everything falling back to the old Java concurrent things. All the callback functions 
are finally turned into a `java.lang.Runnable`s and are managed by some 
`java.util.concurrent.Executor`.

`Future[T]` in Scala is implemented internally with `Promise[T]`. The terms future and promise 
are often used interchangeably, there are some differences in usage. A future is a `read-only` 
placeholder view of a variable, while a promise is a writable, __single assignment__ container 
which sets the value of the future.

Use one sentance to discribe the implementation would be: the body of the future and all the 
callbacks are essentially runnables, which use promises to store the result of the expression.

Following is the simplified version of `Future[T]` and `Promise[T]`.

{% highlight scala %}
package concurrent

import scala.Option
import scala.util.{Try, Success, Failure}

trait Future[+T] {
  private def internalExecutor = Future.InternalCallbackExecutor
  def onSuccess[U](pf: PartialFunction[T, U])(implicit executor: ExecutionContext): Unit = onComplete {
    case Success(v) =>
      pf.applyOrElse[T, Any](v, Predef.conforms[T])
    case _ =>
  }
  def onFailure[U](callback: PartialFunction[Throwable, U])(implicit executor: ExecutionContext): Unit = onComplete {
    case Failure(t) =>
      callback.applyOrElse[Throwable, Any](t, Predef.conforms[Throwable])
    case _ =>
  }
  def onComplete[U](func: Try[T] => U)(implicit executor: ExecutionContext): Unit
  def isCompleted: Boolean
  def value: Option[Try[T]]
  // other monadic methods
}

object Future {
  private[concurrent] object InternalCallbackExecutor extends ExecutionContext with java.util.concurrent.Executor {}
  def apply[T](body: =>T)(implicit execctx: ExecutionContext): Future[T] = impl.Future(body)
}
{% endhighlight %}

The heart of the `Future[T]` is the `onComplete` method, everything else is based on it.

{% highlight scala %}
package concurrent.impl

import scala.concurrent.ExecutionContext
import scala.util.control.NonFatal
import scala.util.{Try, Success, Failure}

private[concurrent] object Future {
  class PromiseCompletingRunnable[T](body: => T) extends Runnable {
    val promise = new Promise.DefaultPromise[T]()

    override def run() = {
      promise complete {
        try Success(body) catch { case NonFatal(e) => Failure(e) }
      }
    }
  }

  def apply[T](body: =>T)(implicit executor: ExecutionContext): scala.concurrent.Future[T] = {
    val runnable = new PromiseCompletingRunnable(body)
    executor.prepare.execute(runnable)
    runnable.promise.future
  }
}
{% endhighlight %}

Everytime we create a `Future` we create a `Promise`, which stores the result of the expression 
by calling the `complete` method. The evaluation of the expression is encapsulated in a 
`Runnable` to run in some thread managed by the `executor`, so the `Future` returns immediately.

Now, let's look at the simplified implementation of `Promise[T]`.

{% highlight scala %}
package concurrent

import scala.util.{ Try, Success, Failure }

trait Promise[T] {
  private implicit def internalExecutor: ExecutionContext = Future.InternalCallbackExecutor
  def future: Future[T]
  def isCompleted: Boolean
  def complete(result: Try[T]): this.type =
    if (tryComplete(result)) this else throw new IllegalStateException("Promise already completed.")
  def tryComplete(result: Try[T]): Boolean
}

object Promise {
  def apply[T](): Promise[T] = new impl.Promise.DefaultPromise[T]()
}
{% endhighlight %}

`tryComplete` returns `false` when the `Promise` has already been written, so that the `complete` 
method can be called only once, or it will throw an exception, thus the __single assignment__ 
property is promised.

Finally, we get to the base of everything. Let's go through the implementation step by step, the 
simplified implementation.

{% highlight scala %}
package concurrent.impl

private[concurrent] trait Promise[T] extends concurrent.Promise[T] with concurrent.Future[T] {
  def future: this.type = this
}
{% endhighlight %}

A trait to be used below, you can see that sometimes `Future` and `Promise` are interchangeable.

{% highlight scala %}
private class CallbackRunnable[T](val executor: ExecutionContext, val onComplete: Try[T] => Any) extends Runnable {
  // must be filled in before running it
  var value: Try[T] = null

  override def run() = {
    require(value ne null) // must set value to non-null before running!
    try onComplete(value) catch { case NonFatal(e) => executor reportFailure e }
  }

  def executeWithValue(v: Try[T]): Unit = {
    require(value eq null) // can't complete it twice
    value = v
    // Note that we cannot prepare the ExecutionContext at this point, since we might
    // already be running on a different thread!
    try executor.execute(this) catch { case NonFatal(t) => executor reportFailure t }
  }
}
{% endhighlight %}

This is the `Runnable` that encapsulates the callback function.

{% highlight scala %}
private[concurrent] object Promise {
  /** A DefaultPromise has three possible states. It can be:
   *
   *  1. Incomplete, with an associated list of callbacks waiting on completion.
   *  2. Complete, with a result.
   *  3. Linked to another DefaultPromise.
   */
  class DefaultPromise[T] with Promise[T] { self =>
{% endhighlight %}

The implementation! A Promise has three states: incomplete, complete, link 
to another Promise. The third state is produced under the chaining of 
futures and promises.

{% highlight scala %}
    // a simplified version of state, the state is updated by the CAS 
    // in the original code
    @volatile var state: Any = Nil
    
    // an abstraction, there is a compressedRoot method to make every linked 
    // Promise linking with the last Promise in the chain
    //
    // also, related, a link method is used in flatMap, to update the state 
    // to an other promise. flatMap is a place where memoy leak is possible 
    // to rise
    private def root: DefaultPromise[T] = ???
{% endhighlight %}

Compressing the root is necessary for preventing memory leaks. It also benifits 
subsequent calls.

{% highlight scala %}
    def value: Option[Try[T]] = value0
    @tailrec
    private def value0: Option[Try[T]] = state.synchronized match {
      case c: Try[_] => Some(c.asInstanceOf[Try[T]])
      case _: DefaultPromise[_] => root.value0
      case _ => None
    }
    
    override def isCompleted: Boolean = isCompleted0
    @tailrec
    private def isCompleted0: Boolean = state.synchronized match {
      case _: Try[_] => true
      case _: DefaultPromise[_] => root.isCompleted0
      case _ => false
    }
    
    def tryComplete(value: Try[T]): Boolean = {
      tryCompleteAndGetListeners(value) match {
        case null             => false
        case rs if rs.isEmpty => true
        case rs               => rs.foreach(r => r.executeWithValue(resolved)); true
      }
    }
{% endhighlight %}

When a `Promise` has already been completed, `tryCompleteAndGetListeners` will return 
a `null`, or it will return the callback function list. If the callback function list 
is not empty, then `tryComplete` schedule those callbacks.

{% highlight scala %}
    @tailrec
    private def tryCompleteAndGetListeners(v: Try[T]): List[CallbackRunnable[T]] = {
      state.synchronized match {
        case raw: List[_] => state = raw.asInstanceOf[List[CallbackRunnable[T]]]; state
        case _: DefaultPromise[_] => root.tryCompleteAndGetListeners(v)
        case _ => null
      }
    }
{% endhighlight %}

If the `state` is a list of callbacks, it means that the `Promise` has not been completed 
yet, thus complete it and return the list of callbacks. Return `null` otherwise.

{% highlight scala %}
    def onComplete[U](func: Try[T] => U)(implicit executor: ExecutionContext): Unit = {
      val preparedEC = executor.prepare
      val runnable = new CallbackRunnable[T](preparedEC, func)
      dispatchOrAddCallback(runnable)
    }
    @tailrec
    private def dispatchOrAddCallback(runnable: CallbackRunnable[T]): Unit = {
      state.synchronized match {
        case r: Try[_]          => runnable.executeWithValue(r.asInstanceOf[Try[T]])
        case _: DefaultPromise[_] => root.dispatchOrAddCallback(runnable)
        case listeners: List[_] => state = runnable :: listeners
      }
    }
  }
{% endhighlight %}

When adding a callback to a `Promise`, if the `Promise` has already been completed, 
we schedule the callback, otherwise, we add it into the callback list.

{% highlight scala %}
  final class KeptPromise[T](suppliedValue: Try[T]) extends Promise[T] {

    val value = Some(suppliedValue)

    override def isCompleted: Boolean = true

    def tryComplete(value: Try[T]): Boolean = false

    def onComplete[U](func: Try[T] => U)(implicit executor: ExecutionContext): Unit = {
      val completedAs = value.get
      val preparedEC = executor.prepare
      (new CallbackRunnable(preparedEC, func)).executeWithValue(completedAs)
    }
  }
{% endhighlight %}

This is for an already completed `Future`, useful in future-composition, chaining.

{% highlight scala %}
}
{% endhighlight %}

Now things become pretty clear.

### References

[link](https://mauricio.github.io/2014/05/01/scala-promises-futures-memcached-and-netty-having-fun.html){:target='_blank'}

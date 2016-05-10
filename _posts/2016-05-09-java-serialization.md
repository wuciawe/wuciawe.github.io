---
layout: post
category: [java]
tags: [java, serialization]
infotext: 'java serialization'
---
{% include JB/setup %}

### Default Java Serialization

> An `ObjectOutputStream` writes primitive data types and graphs of Java objects to an `OutputStream`. 
The objects can be read (reconstituted) using an `ObjectInputStream`. Persistent storage of objects 
can be accomplished by using a file for the stream. If the stream is a network socket stream, the 
objects can be reconstituted on another host or in another process.

> Only objects that support the `java.io.Serializable` interface can be written to streams. The class 
of each serializable object is encoded including the class name and signature of the class, the 
values of the object's fields and arrays, and the closure of any other objects referenced from the 
initial objects.
  
> The method `writeObject` is used to write an object to the stream. Any object, including `String`s and 
`Array`s, is written with `writeObject`. Multiple objects or primitives can be written to the stream. 
The objects must be read back from the corresponding `ObjectInputstream` with the same types and in 
the same order as they were written.
  
> Primitive data types can also be written to the stream using the appropriate methods from 
`DataOutput`. `String`s can also be written using the `writeUTF` method.

> The default serialization mechanism for an object writes the class of the object, the class 
signature, and the values of all non-transient and non-static fields. References to other objects 
(except in transient or static fields) cause those objects to be written also. **Multiple references 
to a single object are encoded using a reference sharing mechanism so that graphs of objects can be 
restored to the same shape as when the original was written.**

In order to serialize an object, a custom defined class object, with the default serialization mechanism, 
simply extending the `java.io.Serializable`, then the JVM will handle all of it.

And according to the above documentation from `ObjectOutputStream`, the default java serialization will 
using a reference sharing mechanism to record the graphs of objects, so that when multiple objects 
refers to the same object, then only one object will be serialized by default.

And in the inheritance, if a super class doesn't extend the `java.io.Serializable`, to make its subclasses 
serializable, the super class must have a constructor which takes no arguments so as to be called by 
JVM to create the super part of the subclass in the deserialization phase.

#### serialVersionUID

`serialVersionUID` is an ID which is stamped on object when it get serialized usually hashcode of 
object, you can use tool serialver to see `serialVersionUID` of a serialized object . `serialVersionUID` 
is used for version control of object. you can specify `serialVersionUID` in your class file also. 
Consequence of not specifying `serialVersionUID` is that when you add or modify any field in class 
then already serialized class will not be able to recover because `serialVersionUID` generated for new 
class and for old serialized object will be different. Java serialization process relies on correct 
`serialVersionUID` for recovering state of serialized object and throws `java.io.InvalidClassException` 
in case of `serialVersionUID` mismatch.

### Customized Serialization

One way to change the default behavior of serialization is to mark some fields as `transient` and then 
serialize those fields by your defined function.

For example, a `Point` class,

{% highlight java linenos=table %}
public class Point extends Serializable {
    private transient int x;
    private transient int y;
    
    ...
    
    private void writeObject(ObjectOutputStream oos) throws IOException {
        oos.defaultWriteObject();
        oos.writeInt(x);
        oos.writeInt(y);
    }
    private void readObject(OjbectInputStream ois) throws IOException, ClassNotFoundException {
        ois.defaultReadObject();
        x = ois.readInt();
        y = ois.readInt();
    }
}
{% endhighlight %}

The above code will improve the deserialization performance. But the below code will produce wrong logic,

{% highlight java linenos=table %}
public class PointCollection extends Serializable {
    private transient Point[] points;
    
    ...
    
    private void writeObject(ObjectOutputStream oos) throws IOException {
        oos.defaultWriteObject();
        oos.writeInt(points.length);
        for(int i = 0; i < points.length; ++i) {
            oos.writeInt(points[i].getX());
            oos.writeInt(points[i].getY());
        }
    }
    private void readObject(OjbectInputStream ois) throws IOException, ClassNotFoundException {
        ois.defaultReadObject();
        int length = ois.readInt();
        points = new Point[length];
        for(int i = 0; i < length; ++i) {
            points[i] = new Point(ois.readInt(), ois.readInt());
        }
    }
}
{% endhighlight %}

The problem is that in the original object, `Point` instances in the `points` field may share references 
with each other referring to some `Point`s, but after the deserialization, every `Point` in the `points` 
is a distinct object instance.

### Extending `java.io.Externalizable`

By extending `java.io.Serializable`, without implementing the logic, the JVM will automatically use 
reflection to marshal and unmarshal the object. Before Java 1.3, reflection was very slow, so by 
extending `java.io.Externalizable`, and implementing the `writeExternal` method and `readExternal` 
method help to get around of the bottleneck caused by reflection.

And by extending `java.io.Externalizable`, it means that it is a must to maintain the logic manually.

And also be careful with case of generating wrong logic in customized serialization above.

### Kryo

Kryo is a 3rd party serialization library. And after some searching, it seems that there exists other 
3rd party serialization library that claims achieving better performance compared with Kryo. And all 
of them seem to have some issue on stability.

### Serialization of closure in Scala

Here are two pieces of useful resource on this topic, [link1](http://stackoverflow.com/questions/32892995/spark-tasknotserializable-when-using-anonymous-function){:target='_blank'}, 
and [link2](http://erikerlandson.github.io/blog/2015/03/31/hygienic-closures-for-scala-function-serialization/){:target='_blank'}, and 
spark also implements how to clean the closure so as to serialize less stuff as [link3](https://github.com/apache/spark/blob/c1bc4f439f54625c01a585691e5293cd9961eb0c/core/src/main/scala/org/apache/spark/util/ClosureCleaner.scala#L148){:target='_blank'}.

In summary, when a function get serialized in Scala, then Scala will serialize the whole closure of 
that function, so it can recreate the function correctly.

{% highlight scala linenos=table %}
object Foo {
  val capturedValue = 11

  def f() = (x: Int) => capturedValue * x
}

val f = Foo.f
{% endhighlight %}

In the above example, the function value `f` is serializable, and since the variable `Foo.capturedValue` is 
involved in the closure, it will be serialized together.

But in the following exmaple, unless the class `Foo` extends `java.io.Serializable`, it is not serializable.

{% highlight scala linenos=table %}
class Foo {
  val capturedValue = 11

  def f() = (x: Int) => capturedValue * x
}

val f = new Foo().f
{% endhighlight %}
In this case, Scala will serialize the entire instance of Foo class so as to serialize the `f` function, 
even the closure only includes one specific value of that instance.

So to avoid serialize the entire instance in this kind of cases, Spark does some work to eliminate 
unnecessary serializations.
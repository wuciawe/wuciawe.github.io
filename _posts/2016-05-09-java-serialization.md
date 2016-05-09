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

#### SerialVersionUID

SerialVersionUID is an ID which is stamped on object when it get serialized usually hashcode of 
object, you can use tool serialver to see serialVersionUID of a serialized object . SerialVersionUID 
is used for version control of object. you can specify serialVersionUID in your class file also. 
Consequence of not specifying serialVersionUID is that when you add or modify any field in class 
then already serialized class will not be able to recover because serialVersionUID generated for new 
class and for old serialized object will be different. Java serialization process relies on correct 
serialVersionUID for recovering state of serialized object and throws java.io.InvalidClassException 
in case of serialVersionUID mismatch.

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

### Extending `Externalizable`

// TODO

### Kryo

// TODO

### Serialization of anonymous functions in Scala

// TODO
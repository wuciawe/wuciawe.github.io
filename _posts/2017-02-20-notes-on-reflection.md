---
layout: post
category: [jvm]
tags: [jvm, reflection]
infotext: 'introduction to reflection in java'
---
{% include JB/setup %}

In computer science, reflection is the ability of a program to examine, introspect, and modify 
its own structure and behaviour at runtime.

To perform this self-examination, a program needs to have a representation of itself. This 
information we call `metadata`. In object-oriented world, metadata is organized into objects, 
called `metaobject`s. The runtime self-examination of the metaobjects is called `introspection`.

In general, there are three techniques that a refection API can use to facilitate behaviour 
change: direct metaobject modification, operations for using metadata (dynamic method invocation), 
and `intercession`, in which code is permitted to intercede in various phases of program 
execution. Java supplies a rich set of operations for using metadata and just a few important 
intercession capabilities. In addition, Java does not allow direct metaobject modification.

Following are the related APIs provided by Java.

### java.lang.Class

The method `java.lang.Object.getClass()` makes any object in Java can query its class at runtime. 
Besides that, Class literals are another way to specify a class object statically. Syntactically, 
any class name followed by `.class` evalutes to a class object. For example, `int[].class` gives 
the class object of array of ints.

The `Class` also provides a static method `forName` to obtain the class object. For arrays, the 
name is coded as: `[B` as `byte` array, `[C` as `char` array, `[D` as `double` array, `[F` as 
`float` array, `[I` as `int` array, `[J` as long array, `[L<type>;` for reference `type` array, 
`[S` as `short` array, and `[Z` as `boolean` array.

- `getName`: full qualified name
- `getComponentType`: if the target object is a Class for an array, returns the component type
- `isArray`: is array
- `isInterface`: is interface
- `isPrimitive`: is primitive or void

To introspect the inheritance hierarchy, use

- `getInterfaces`: get direct interfaces
- `getSuperclass`: get direct superclass, null for Object, interface, primitive and void
- `isAssignableFrom`: is the superclass of the parameter class. a class is the super class of 
itself.
- `isInstance`: the parameter object is assignable to the class

`Class.class.isInstance(Class.class)` evaluates to true. In Java, all objects have an 
instantiating class, and all class are objects. The class object for Class is an instance of 
itself.

There is another circular relationship. Both `Class.class.isInstance(Object.class)` and 
`Object.class.isAssignableFrom(Class.class)` evaluate to true. In Java, each object has one 
instantiating class, and all classes are kinds of objects.

#### java.lang.reflect.Array

`Array` is provided by Java to perform reflective operations on all array objects, reference 
arrays and primitive arrays.

- `newInstance`: create a new array
- `getLength`: return the length of the array object
- `get`/`set`: get or set the element at index
- `getBoolean`/`setBoolean`: get or set primitive element at index

For example,

{% highlight java linenos=table %}
// to create an array of String with length 5
Array.newInstance(String[].class, 5);

// to create a two-dimensional String array
Array.newInstance(String.class, new int[]{2,3});

// to create a three-dimensional String array
Array.newInstance(String[].class, new int[]{2,3});
{% endhighlight %}

#### construction

Calling `newInstance` method of `Class` creates a new instance of the class, which is equivalent 
to calling the default constructor of the class.

##### java.lang.reflect.Constructor

A specific constructor can be queried with `getConstructor`, `getDeclaredConstructor`, 
`getConstructors`, and `getDeclaredConstrucotrs` methods provided by `Class`.

The `Constructor` metaobject is a subclass of `AccessibleObject` and implements the `Member` 
interface which will be introduced below soon, and it also supports following methods:

- `getExceptionTypes`: get the types of exceptions that can be thrown from the constructor
- `getParameterTypes`: get parameters' type
- `newInstance`: invoke the constructor

### java.lang.reflect.Member

Both `Method` and `Field` implement the interface `Member`, which has methods: 

- `getDeclaringClass`: return the class object that declares this member
- `getName`: name of the method
- `getModifiers`: an int encodes the modifier

##### Modifier

The `Modifier` has static methods: `isPublic`, `isPrivate`, `isProtected`, `isStatic`, `isFinal`, 
`isSynchronized`, `isVolatile`, `isNative`, `isInterface`, `isTransient`, `isAbstract` and 
`isStrict`, all of them accept an int as argument.

### java.lang.reflect.AccessibleObject

`AccessibleObject` is the parent class of both `Method` and `Field`, it provides methods:

- `setAccessible`: it suppresses or enables runtime access checking.
- `isAccessible`: accessible or not

### java.lang.reflect.Method

The `getMethod`, `getDeclaredMethod`, `getMethods` and `getDeclaredMethods` methods of class 
objects enable the ability to query method objects of a class, introspecting on method's 
parameters.

`getMethod` returns the public method of the class. `getDeclaredMethod` returns the declared 
method of the target class, no inherited will be returned but all visibilities.

- `getExceptionTypes`: the exceptions declared to be thrown
- `getParameterTypes`: class objects of parameters
- `getReturnType`: class object of return
- `invoke`: dynamic invocation

### java.lang.reflect.Field

The `getField`, `getDeclaredField`, `getFields` and `getDeclaredFields` methods of class object 
enable the ability to query field objects of a class.

The JLS defines a field as being identified by both the declaring class and field name. Java 
allows a class to declare a field named the same as one declared by a superclass.

- `getType`: class object of the field
- `get`/`set`: get/set the reference value
- `getBoolean`/`setBoolean`: get/set the primitive boolean value

### java.lang.reflect.Proxy

The proxy delegates some or all of the calls it receives to its target and thus acts as either 
an intermediary or a substitute. In its role as an intermediary, the proxy may add functionality 
either before or after the method is forwarded to the target.

The `Proxy` is the only way of approximating method invocation intercession in Java. `Intercession` 
is any reflective ability that modifies the behaviour of a program by directly taking control of 
that behaviour. Method invocatin intercession is the ability to intercept method calls. The 
intercepting code can determine the behaviour that results from the method call.

Java does not support reflective facilities for interceding on method calls. The `Proxy` is an 
approximation.

The `Proxy` provides following static methods:

- `getProxyClass`: it retrieves the proxy class specified by a class loader and an array of 
interfaces. If such a proxy class does not exist, it is dynamically constructed.
- `newProxyInstance`: it accomplishes following steps in a single call

{% highlight java linenos=table %}
Object proxy1 = Proxy.newProxyInstance(SomeInterface.getClassLoader(), Class[]{SomeInterface.class}, new SomeIH(obj))

// is equivalent to

Proxy p = Proxy.getProxyClass(SomeInterface.getClassLoader(), Class[]{SomeInterface.class});
Constructor c = p.getConstructor(new Class[]{InvocationHandler.class});
Object proxy2 = c.newInstance(new Object[]{new SomeIH(obj)});
{% endhighlight %}

- `isProxyClass`: determine if an object refers to a proxy instance
- `getInvocationHandler`: return the `InvocationHandler` that was used to construct the proxy

Each class constructed by these factory methods is a public final subclass of Proxy, referred to as 
a `proxy class`. The instance of one of these dynamically constructed proxies is referred as a `proxy 
instance`. The interfaces that the proxy class implements in this way are called `proxied interface`s.

In summary, the Java `Proxy` class accomplishes implementation of interfaces by dynamically creating 
a class that implements a set of given interfaces. It is the only way to dynamically create classes 
from inside the Java. This specification also allows the creation of proxy classes for interfaces 
that were not available when the application was compiled.

#### InvocationHandler

`Proxy` allows programmers to accomplish the deltegation task by providing the `InvocationHandler` 
interface. It provides the `invoke(Object,Method,Object[]):Object` method. A proxy instance forwards 
method calls to its invocation handler by calling `invoke`. The original arguments for the method call 
are passed to invoke as an object array.

A proxy instance is an `java.lang.Object`, not every call of `Object` will be forwarded:

- `hashCode`, `equals`, and `toString` are dispatched to the invoked method in the same manner as any 
other proxied method
- `clone` is interceded by the invocation handler only when a proxied interface extends `Cloneable`
- `finalize` is interceded by the invocation handler only when a proxied interface declares an 
override to `finalize`
- Method intercession does not take place for the other methods declared by `java.lang.Object`. A call 
to `wait` on a proxy instance waits on the proxy instance'l lock, rather than being forwarded to an 
invocation handler.

#### proxy chain

The proxies can be arranged in a chain so as to compose the properties implemented by each proxy.

Ensuring the proxies can be chained requires careful design. The invocation handler for tracing is 
programmed with the assumption that its target is the real target and not another proxy. If the 
target is another proxy, the invocation handler may not perform the correct operation. For example, 
if we want to call `wait` method of Object or use `synchronized` keyword in the invoke method, in 
most cases we intend to call those methods on the real target. To remedy this problem, we can use an 
abstract class for deriving invocation handlers for chainable proxies.

{% highlight java linenos=table %}
public abstract class InvocationHandlerBase implements InvocationHandler {
  protected Object nextTarget;
  protected Object realTarget = null;
  InvocationHandlerBase( Object target ) {
    nextTarget = target;
    if ( nextTarget != null ) {
      realTarget = findRealTarget(nextTarget);
      if (realTarget == null) throw new RuntimeException("findRealTarget failure");
    }
  }
  protected final Object getRealTarget() { return realTarget; }
  protected static final Object findRealTarget( Object t ) {
    if ( !Proxy.isProxyClass(t.getClass()) ) return t;
    InvocationHandler ih = Proxy.getInvocationHandler(t);
    if ( InvocationHandlerBase.class.isInstance( ih ) ) {
      return ((InvocationHandlerBase)ih).getRealTarget();
    } else {
      try {
        Field f = findField( ih.getClass(), "target" );
        if ( Object.class.isAssignableFrom(f.getType()) && !f.getType().isArray() ) {
          f.setAccessible(true); // suppress access checks
          Object innerTarget = f.get(ih);
          return findRealTarget(innerTarget);
        }
        return null;
      } catch (NoSuchFieldException e){
        return null;
      } catch (SecurityException e){
        return null;
      } catch (IllegalAccessException e){
        return null;
      } // IllegalArgumentException cannot be raised
    }
  }
  
  public static Field findField( Class cls, String name ) throws NoSuchFieldException {
    if ( cls != null ) {
      try {
        return cls.getDeclaredField( name );
      } catch(NoSuchFieldException e){
        return findField( cls.getSuperclass(), name );
      }
    } else {
      throw new NoSuchFieldException();
    }
  }
}
{% endhighlight %}

### Call stack

Each thread of execution has a call stack consisting of stack frames. Each frame in the call stack 
represents a method call. Stack frames contain information such as an identification of the method, 
the location of the statement that is currently executing, the arguments to the method, local 
variables and so on. Each stack frame represents the method last called by the method in the frame 
below it. In Java, the frame at the bottom of a call stack represents the main method of the 
application or the run method of a thread. Call stack introspection allows a thread to examine its 
context.

Java supports call stack introspection though an indirect facility. Thread management can be thought 
as indirect way to modify the call stack.

When an instance of `Throwable` is created, the call stack information can be referenced through 
that instance:

- `printStackTrace`: print the throwable and the call stack
- `getStackTrace`: return an array of `StackTraceElement`

The `StackTraceElement` has following methods: `getFileName`, `getLineNumber`, `getClassName`, 
`getMethodName`, and `isNativeMethod`.

Another way to introspect the call stack is to use `java.util.logging`.

### java.lang.ClassLoader

Each class in Java is loaded by a class loader, an object that constructs a class object from 
bytecodes. The ability to intercede in the loading process unequivocally implies that the class 
loader is a reflective facility.

Every class loader has a parent class loader. When calling the `loadClass` of a class loader, it 
will first check if the class has been loaded already with `findLoadedClass`. If not, it will 
attempts to load the class. Before a class loader attempts to load a class, it usually delegates to 
its parent class load. The ultimate parent in the loading chain of responsibility is almost always 
the system class loader. If its parent can not load the class, it then calls `findClass` to find 
the class and read its bytecodes, and create the class object using `defineClass`.

The class loader that produces a class using `defineClass` is called the class's defining loader, 
and can be referenced by the `getClassLoader` method of the `Class`. Any class loader that 
participates in the `loadClass` process for a class is an initiating loader for that class.

Calling `getClassLoader` on an array class will return the defining class loader for the element 
type. If the element is primitive, it returns `null`.

It is encouraged to override `findClass` rather than `loadClass`, because the implementation of 
`loadClass` defined by `ClassLoader` supports the delegation model.

A class in Java language is identified by its fully qualified name, a class object in the virtual 
machine is actually identified by both its fully qualified name and defining loader. A class loader 
defines a runtime namespace.

When a class is loaded by executing `defineClass`, all classes that it references are also loaded 
by its defining loader. That is, the JVM loads each referenced class using `loadClass` on the 
referencer's defining loader. A call to `Class.forName` uses the defining loader for the calling 
object to perform the load.

#### Replace Class

Following is an example to dynamically replace active class (but with no loaded subclasses) with 
`Proxy` and specialized `class loader`.

`SimpleClassLoader` is a class loader which is able to expand the search path of class definitions.

`Product` is the class the client want to instantialize and replace.

`ProductFactory` is the abstract factory which provide `Product` instances. `newInstance` creates 
new instances, stores those newly created instances in a filed `instances`, and return the `Proxy` 
of those instances to the clients. `reload` loads new definition of the `Product` called 
"ProductImpl", which has static method `evolve` for converting old objects to new ones. In the 
process of reload, all old instances are converted to new ones.

`ProductIH` implements `InvocationHandler`, which also provides methods to access its `target`.

{% highlight java linenos=table %}
import java.lang.ref.WeakReference;
import java.lang.reflect.*;
import java.util.*;
import java.io.*;

public class SimpleClassLoader extends ClassLoader {
    String[] dirs;

    public SimpleClassLoader(String path) {
        dirs = path.split(System.getProperty("path.separator"));
    }

    public SimpleClassLoader(String path, ClassLoader parent) {
        super(parent);
        dirs = path.split(System.getProperty("path.separator"));
    }

    public void extendClasspath(String path) {
        String[] exDirs = path.split(System.getProperty("path.separator"));
        String[] newDirs = new String[dirs.length + exDirs.length];
        System.arraycopy(dirs, 0, newDirs, 0, dirs.length);
        System.arraycopy(exDirs, 0, newDirs, dirs.length, exDirs.length);
        dirs = newDirs;
    }

    public synchronized Class findClass(String name) throws ClassNotFoundException {
        for (int i = 0; i < dirs.length; i++) {
            byte[] buf = getClassData(dirs[i], name);
            if (buf != null) return defineClass(name, buf, 0, buf.length);
        }
        throw new ClassNotFoundException();
    }

    protected byte[] getClassData(String directory, String name) {
        String classFile = directory + "/" + name.replace('.', '/') + ".class";
        int classSize = (new Long((new File(classFile)).length())).intValue();
        byte[] buf = new byte[classSize];
        try {
            FileInputStream filein = new FileInputStream(classFile);
            classSize = filein.read(buf);
            filein.close();
        } catch (FileNotFoundException e) {
            return null;
        } catch (IOException e) {
            return null;
        }
        return buf;
    }
}

public interface Product {}

abstract public class ProductFactory {
    static private ClassLoader cl = null;
    static private String directory = null;
    static private Class implClass;
    static private List instances = new ArrayList();

    public static Product newInstance() throws InstantiationException, IllegalAccessException {
        Product obj = (Product) implClass.newInstance();
        Product anAProxy = ProductIH.newInstance(obj);
        instances.add(new WeakReference(anAProxy));
        return anAProxy;
    }

    public static void reload(String dir) throws ClassNotFoundException, InstantiationException, IllegalAccessException, NoSuchMethodException, InvocationTargetException {
        cl = new SimpleClassLoader(dir);
        implClass = cl.loadClass("ProductImpl");
        if (directory == null) {
            directory = dir;
            return;
        }
        directory = dir;
        List newInstances = new ArrayList();
        Method evolve = implClass.getDeclaredMethod("evolve", new Class[]{Object.class});
        for (int i = 0; i < instances.size(); i++) {
            Proxy x = (Proxy) ((WeakReference) instances.get(i)).get();
            if (x != null) {
                ProductIH aih = (ProductIH) Proxy.getInvocationHandler(x);
                Product oldObject = aih.getTarget();
                Product replacement = (Product) evolve.invoke(null, new Object[]{oldObject});
                aih.setTarget(replacement);
                newInstances.add(new WeakReference(x));
            }
        }
        instances = newInstances;
    }
}

public class ProductIH implements InvocationHandler {
    private Product target = null;
    static private Class[] productAInterfaces = {Product.class};

    public static Product newInstance(Product obj) {
        return (Product) Proxy.newProxyInstance(obj.getClass().getClassLoader(), productAInterfaces, new ProductIH(obj));
    }

    private ProductIH(Product obj) { target = obj; }

    public void setTarget(Product x) { target = x; }

    public Product getTarget() { return target; }

    public Object invoke(Object t, Method m, Object[] args) throws Throwable {
        Object result = null;
        try {
            result = m.invoke(target, args);
        } catch (InvocationTargetException e) {
            throw e.getTargetException();
        }
        return result;
    }
}
{% endhighlight %}

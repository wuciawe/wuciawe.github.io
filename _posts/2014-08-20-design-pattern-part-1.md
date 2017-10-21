---
layout: post
tagline: Creational Patterns
category: [design pattern, object oriented]
tags: [design pattern, object oriented, creational pattern]
infotext: 'A short summary of Creational Pattern. In this post, it includes Class Creational: Factory Method; Object Creational: Abstract Factory, Builder, Prototype and Singleton.'
---
{% include JB/setup %}

> `Creational design patterns` abstract the instantiation process. They help make a system independent of how its objects 
> are created, composed, and represented. A `class creational pattern` uses inheritance to vary the class that’s 
> instantiated, whereas an `object creational pattern` will delegate instantiation to another object.

In this post, I'll talk about both `class creational pattern`( [Factory Method](#factory-method) ) and `object creational pattern`( 
[Abstract Factory](#abstract-factory), [Builder](#builder), [Prototype](#prototype), [Singleton](#singleton) ).

<!-- more -->

## Object Creational

### Abstract Factory

> Abstract Factory is a very central design pattern for `Dependency Injection`.

#### Intent

Provide an interface for creating families of related or dependent objects without specifying their concrete classes.

#### Examples

Multiple examples can be found [here](http://stackoverflow.com/questions/2280170/why-do-we-need-abstract-factory-design-pattern).

Following is an example from [stackoverflow](http://stackoverflow.com/questions/1943576/is-there-a-pattern-for-initializing-objects-created-via-a-di-container/1945023#1945023):

{% highlight java linenos=table %}
interface IMyIntf {
    public String getRunTimeParam();
}

interface IMyIntfFactory {
    IMyIntf Create(String runTimeParam) throws Exception;
}

class MyIntf implements IMyIntf {
    public String getRunTimeParam() {
        return runTimeParam;
    }

    private String runTimeParam;

    public MyIntf(String runTimeParam) throws Exception {
        if (runTimeParam == null) {
            throw new Exception("runTimeParam");
        }
        this.runTimeParam = runTimeParam;
    }

}

class MyIntfFactory implements IMyIntfFactory {
    public MyIntf Create(String runTimeParam) throws Exception {
        return new MyIntf(runTimeParam);
    }
}

public class Main{
    public static void main(String[] args) throws Exception {
        MyIntfFactory factory = new MyIntfFactory();
        IMyIntf intf = factory.Create("parameter");
        System.out.println(intf.getRunTimeParam());
    }
}
{% endhighlight %}

In all consumers where you need an IMyIntf instance, you simply take a dependency on IMyIntfFactory by requesting it 
through `Constructor Injection`.

Any DI Container worth its salt will be able to auto-wire an IMyIntfFactory instance for you if you register it 
correctly.

#### Consequences

The Abstract Factory pattern has the following benefits and liabilities:

-   It isolates concrete classes.
-   It makes exchanging product families easy.
-   It promotes consistency among products.
-   Supporting new kinds of products is difficult.

#### Related Patterns

AbstractFactory classes are often implemented with factory methods ([Factory Method](#factory-method)), but they can also be implemented 
using [Prototype](#prototype).

A concrete factory is often a singleton([Singleton](#singleton)).

### Builder

#### Intent

Separate the construction of a complex object from its representation so that the same construction process can create 
different representations.

#### Examples

Following is an example from [stackoverflow](http://stackoverflow.com/questions/757743/what-is-the-difference-between-builder-design-pattern-and-factory-design-pattern):

{% highlight java linenos=table %}
// Builder
class Fruit {
    private final String name;
    private final String color;
    private final String firmness;
    
    public static class Builder{
        private String name;
        private String color;
        private String firmness;
        
        public Builder name(String name) {
            this.name = name;
            return this;
        }

        public Builder color(String color) {
            this.color = color;
            return this;
        }

        public Builder firmness(String firmness) {
            this.firmness = firmness;
            return this;
        }

        Fruit build() {
            return new Fruit(this); // Pass in the builder
        }
    }

    private Fruit(Builder builder){
        this.name = builder.name;
        this.color = builder.color;
        this.firmness = builder.firmness;
    }
}

// Usage
Fruit fruit = new Fruit.Builder().name("apple").color("red").firmness("crunchy").build();
{% endhighlight %}

#### Consequences

Here are key consequences of the Builder pattern:

-   It lets you vary a product’s internal representation.
-   It isolates code for construction and representation.
-   It gives you finer control over the construction process.

#### Related Patterns

[Abstract Factory](#abstract-factory) is similar to Builder in that it too may construct complex objects. The primary difference is that the 
Builder pattern focuses on constructing a complex object step by step. Abstract Factory’s emphasis is on families of 
product objects( either simple or complex). Builder returns the product as a final step, but as far as the Abstract 
Factory pattern is concerned, the product gets returned immediately.

A [Composite]({% post_url 2014-08-20-design-pattern-part-2 %}#composite) is what the builder often builds.

### Prototype

> A `prototype` is a template of any object before the actual object is constructed. Prototype design pattern is used in 
> scenarios where application needs to create a number of instances of a class, which has almost the same state or differs 
> very little.

#### Intent

Specify the kinds of objects to create using a prototypical instance, and create new objects by copying this prototype.

#### Examples

{% highlight java linenos=table %}
public interface PrototypeCapable extends Cloneable {
    public PrototypeCapable clone() throws CloneNotSupportedException;
}

public class Movie implements PrototypeCapable {
    public String name = null;

    @Override
    public Movie clone() throws CloneNotSupportedException {
        System.out.println("Cloning Movie object..");
        return (Movie) super.clone();
    }
}

public class Album implements PrototypeCapable {
    public String name = null;

    @Override
    public Album clone() throws CloneNotSupportedException {
        System.out.println("Cloning Album object..");
        return (Album) super.clone();
    }
}

public class PrototypeFactory {
    public static class ModelType {
        public static final String MOVIE = "movie";
        public static final String ALBUM = "album";
    }

    private static java.util.Map<String, PrototypeCapable> prototypes = new java.util.HashMap<String, PrototypeCapable>();

    static {
        prototypes.put(ModelType.MOVIE, new Movie());
        prototypes.put(ModelType.ALBUM, new Album());
    }

    public static PrototypeCapable getInstance(final String s) throws CloneNotSupportedException {
        return ((PrototypeCapable) prototypes.get(s)).clone();
    }
}

Movie movie = PrototypeFactory.getInstance(ModelType.MOVIE);
Album album = PrototypeFactory.getInstance(ModelType.ALBUM);
{% endhighlight %}

#### Consequences

Prototype has many of the same consequences that Abstract Factory and Builder have: It hides the concrete product 
classes from the client. Moreover, these patterns let a client work with application-specific classes without modification.

Additional benefits of the Prototype pattern are listed below:

-   Adding and removing products at run-time.
-   Specifying new objects by varying values.
-   Specifying new objects by varying structure.
-   Reduced subclassing.
-   Configuring an application with classes dynamically.

The main liability of the Prototype pattern is that each subclass of Prototype `must` implement the Clone operation, 
which may be difficult. For example, adding Clone is difficult when the classes under consideration already exist. 
Implementing Clone can be difficult when their internals include objects that don’t support copying or have circular 
references.

#### Related Patterns

Prototype and [Abstract Factory](#abstract-factory) are competing patterns in some ways. They can 
also be used together, however. An Abstract Factory might store a set of prototypes from which to clone and return 
product objects.

Designs that make heavy use of the [Composite]({% post_url 2014-08-20-design-pattern-part-2 %}#composite) and 
[Decorator]({% post_url 2014-08-20-design-pattern-part-2 %}#decorator) patterns often can benefit from Prototype as well.

### Singleton

#### Intent

Ensure a class only has one instance, and provide a global point of access to it.

#### Examples

`Note: `for more information about `double checked locking pattern`, check [here](http://en.wikipedia.org/wiki/Double_checked_locking_pattern#Usage_in_Java).

{% highlight java linenos=table %}
//double checked
public class DoubleCheckedSingleton {
    private static volatile DoubleCheckedSingleton instance = null;

    // private constructor
    private DoubleCheckedSingleton() {
    }

    public static DoubleCheckedSingleton getInstance() {
        if (instance == null) {
            synchronized (DoubleCheckedSingleton.class) {
                // Double check
                if (instance == null) {
                    instance = new DoubleCheckedSingleton();
                }
            }
        }
        return instance;
    }
}

//static block initialization, eager
public class StaticBlockSingleton {
    private static final StaticBlockSingleton INSTANCE;

    static {
        try {
            INSTANCE = new StaticBlockSingleton();
        } catch (Exception e) {
            throw new RuntimeException("Uffff, i was not expecting this!", e);
        }
    }

    public static StaticBlockSingleton getInstance() {
        return INSTANCE;
    }

    private StaticBlockSingleton() {
        // ...
    }
}

//Bil Pugh solution
public class BillPughSingleton {
    private BillPughSingleton() {
    }

    private static class LazyHolder {
        private static final BillPughSingleton INSTANCE = new BillPughSingleton();
    }

    public static BillPughSingleton getInstance() {
        return LazyHolder.INSTANCE;
    }
}

//distributed case, adding readResolve()
public class DemoSingleton implements Serializable {
    private volatile static DemoSingleton instance = null;
 
    public static DemoSingleton getInstance() {
        if (instance == null) {
            instance = new DemoSingleton();
        }
        return instance;
    }
 
    protected Object readResolve() {
        return instance;
    }
 
    private int i = 10;
 
    public int getI() {
        return i;
    }
 
    public void setI(int i) {
        this.i = i;
    }
}
{% endhighlight %}

#### Consequences

The Singleton pattern has several benefits:

-   Controlled access to sole instance.
-   Reduced name space.
-   Permits refinement of operations and representation.
-   Permits a variable number of instances.
-   More flexible that class operations.

#### Related Patterns

Many patterns can be implemented using the Singleton pattern. See [Abstract Factory](#abstract-factory), [Builder](#builder), and [Prototype](#prototype).

## Class Creational

### Factory Method

> also known as Virtual Constructor

#### Intent

Define an interface for creating an object, but let subclasses decide which class to instantiate. Factory Method lets a 
class defer instantiation to subclasses.

#### Examples

Following is an example from [stackoverflow](http://stackoverflow.com/questions/13029261/design-patterns-factory-vs-factory-method-vs-abstract-factory):

{% highlight java linenos=table %}
abstract class FruitPicker {

  protected abstract Fruit makeFruit();

  public void pickFruit() {
    private final Fruit f = makeFruit(); // The fruit we will work on..
    // operations on the Fruit object f
  }
}

class OrangePicker extends FruitPicker {

  @Override
  protected Fruit makeFruit() {
    return new Orange();
  }
}
{% endhighlight %}

#### Consequences

Factory methods eliminate the need to bind application-specific classes into your code. The code only deals with the 
Product interface; therefore it can work with any user-defined ConcreteProduct classes.

A potential disadvantage of factory methods is that clients might have to subclass the Creator class just to create a 
particular ConcreteProduct object. Subclassing is fine when the client has to subclass the Creator class anyway, but 
otherwise the client now must deal with another point of evolution.

Here are two additional consequences of the Factory Method pattern:

-   Provides hooks for subclasses.
-   Connects parallel class hierarchies.

#### Related Patterns

[Abstract Factory](#abstract-factory) is often implemented with factory methods.

Factory methods are usually called within [Template Methods]({% post_url 2014-08-21-design-pattern-part-5 %}#template-method). 

[Prototypes](#prototype) don’t require subclassing Creator. However, they often require an Initialize operation on the Product class. 
Creator uses Initialize to initialize the object. Factory Method doesn’t require such an operation.

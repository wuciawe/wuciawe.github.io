---
layout: post
tagline: Creational Patterns
category: [design pattern, object oriented]
tags: [design pattern, object oriented, creational pattern]
---
{% include JB/setup %}

> Creational design patterns abstract the instantiation process. They help make a system independent of how its objects 
> are created, composed, and represented. A class creational pattern uses inheritance to vary the class that’s 
> instantiated, whereas an object creational pattern will delegate instantiation to another object.

<!-- more -->

## Object Creational

### Abstract Factory

> Abstract Factory is a very central design pattern for `Dependency Injection`.

#### Intent

Provide an interface for creating families of related or dependent objects without specifying their concrete classes.

#### Applicability

Use the Abstract Factory pattern when:

-   a system should be independent of how its products are created, composed and represented.
-   a system should be configured with one of multiple families of products.
-   a family of related product objects is designed to be used together, and you need to enforce this constraint.
-   you want to provide a class library of products, and you want to reveal just their interfaces, not their 
implementations.

#### Examples

Multiple examples can be found [here](http://stackoverflow.com/questions/2280170/why-do-we-need-abstract-factory-design-pattern).

Following is an example from [stackoverflow](http://stackoverflow.com/questions/1943576/is-there-a-pattern-for-initializing-objects-created-via-a-di-container/1945023#1945023):

{% highlight java %}
public interface IMyIntf {
    public String getRunTimeParam();
}

public interface IMyIntfFactory {
    IMyIntf Create(String runTimeParam) throws Exception;
}

public class MyIntf implements IMyIntf {
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

public class MyIntfFactory implements IMyIntfFactory {
    public MyIntf Create(String runTimeParam) throws Exception {
        return new MyIntf(runTimeParam);
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

AbstractFactory classes are often implemented with factory methods (Factory Method), but they can also be implemented 
using Prototype.

A concrete factory is often a singleton(Singleton).

### Builder

#### Intent

Separate the construction of a complex object from its representation so that the same construction process can create 
different representations.

#### Applicability

Use the Builder pattern when

-   the algorithm for creating a complex object should be independent of the parts that make up the object and how 
they’re assembled.
-   the construction process must allow different representations for the object that’s constructed.

#### Examples

Following is an example from [stackoverflow](http://stackoverflow.com/questions/757743/what-is-the-difference-between-builder-design-pattern-and-factory-design-pattern):

{% highlight java %}
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

Abstract Factory is similar to Builder in that it too may construct complex objects. The primary difference is that the 
Builder pattern focuses on constructing a complex object step by step. Abstract Factory’s emphasis is on families of 
product objects( either simple or complex). Builder returns the product as a final step, but as far as the Abstract 
Factory pattern is concerned, the product gets returned immediately.

A Composite is what the builder often builds.

### Prototype

> A prototype is a template of any object before the actual object is constructed. Prototype design pattern is used in 
> scenarios where application needs to create a number of instances of a class, which has almost same state or differs 
> very little.

#### Intent

Specify the kinds of objects to create using a prototypical instance, and create new objects by copying this prototype.

#### Applicability

Use the Prototype pattern when a system should be independent of how its products are created, composed, and 
represented; and

-   when the classes to instantiate are specified at run-time, for example, by dynamic loading; or
-   to avoid building a class hierarchy of factories that parallels the class hierarchy of products; or
-   when instances of a class can have on of only a few different combinations of state. It may be more convenient to 
install a corresponding number of prototypes and clone them rather than instantiating the class manually, each time 
with the appropriate state.

#### Examples

{% highlight java %}
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
classes from the client, thereby reducing the number of names clients know about. Moreover, these patterns let a client 
work with application-specific classes without modification.

Additional benefits of the Prototype pattern are listed below:

-   Adding and removing products at run-time.
-   Specifying new objects by varying values.
-   Specifying new objects by varying structure.
-   Reduced subclassing.
-   Configuring an application with classes dynamically.

The main liability of the Prototype pattern is that each subclass of Prototype must implement the Clone operation, 
which may be difficult. For example, adding Clone is difficult when the classes under consideration already exist. 
Implementing Clone can be difficult when their internals include objects that don’t support copying or have circular 
references.

#### Related Patterns

Prototype and Abstract Factory are competing patterns in some ways, as we discuss at the end of this chapter. They can 
also be used together, however. An Abstract Factory might store a set of prototypes from which to clone and return 
product objects.

Designs that make heavy use of the Composite and Decorator patterns often can benefit from Prototype as well.

### Singleton

#### Intent

Ensure a class only has one instance, and provide a global point of access to it.

#### Applicability

Use the Singleton pattern when

-   there must be exactly one instance of a class, and it must be accessible to clients from a well-known access point.
-   when the sole instance should be extensible by subclassing, and clients should be able to use an extended instance 
without modifying their code.

#### Examples

`Note: `for more information about `double checked locking pattern`, check [here](http://en.wikipedia.org/wiki/Double_checked_locking_pattern#Usage_in_Java).

{% highlight java %}
//double checked
public class EagerSingleton {
    private static volatile EagerSingleton instance = null;

    // private constructor
    private EagerSingleton() {
    }

    public static EagerSingleton getInstance() {
        if (instance == null) {
            synchronized (EagerSingleton.class) {
                // Double check
                if (instance == null) {
                    instance = new EagerSingleton();
                }
            }
        }
        return instance;
    }
}

//static block initialization
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

Many patterns can be implemented using the Singleton pattern. See Abstract Factory, Builder, and Prototype.

## Class Creational

### Factory Method

> also known as Virtual Constructor

#### Intent

Define an interface for creating an object, but let subclasses decide which class to instantiate. Factory Method lets a 
class defer instantiation to subclasses.

#### Applicability

Use the Factory Method pattern when

-   a class can’t anticipate the class of objects it must create.
-   a class wants its subclasses to specify the objects it creates.
-   classes delegate responsibility to one of several helper subclasses, and you want to localize the knowledge of 
which helper subclass is the delegate.

#### Examples

Following is an example from [stackoverflow](http://stackoverflow.com/questions/13029261/design-patterns-factory-vs-factory-method-vs-abstract-factory):

{% highlight java %}
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

Abstract Factory is often implemented with factory methods. The Motivation example in the Abstract Factory pattern 
illustrates Factory Method as well.

Factory methods are usually called within Template Methods. In the document example above, NewDocument is a template 
method.

Prototypes don’t require subclassing Creator. However, they often require an Initialize operation on the Product class. 
Creator uses Initialize to initialize the object. Factory Method doesn’t require such an operation.
---
layout: post
tagline: Structural Patterns
category: [design pattern, object oriented]
tags: [design pattern, object oriented, structural pattern]
---
{% include JB/setup %}


<!-- more -->

### Facade

#### Intent

Provide a unified interface to a set of interfaces in a subsystem. Facade defines a higher-level interface that makes 
the subsystem easier to use.

#### Applicability

Use the Facade pattern when

-   you want to provide a simple interface to a complex subsystem. Subsystems often get more complex as they evolve. 
Most patterns, when applied, result in more and smaller classes. This makes the subsystem more reusable and easier to 
customize, but it also becomes harder to use for clients that don’t need to customize it. A facade can provide a simple 
default view of the subsystem that is good enough for most clients. Only clients needing more customizability will need 
to look beyond the facade.
-   there are many dependencies between clients and the implementation classes of an abstraction. Introduce a facade to 
decouple the subsystem from clients and other subsystems, thereby promoting subsystem independence and portability.
-   you want to layer your subsystems. Use a facade to define an entry point to each subsystem level. If subsystem are 
dependent, then you can simplify the dependencies between them by making them communicate with each other solely 
through their facades.

#### Examples

{% highlight java %}
interface Shape {
    void draw();
}

class Rectangle implements Shape {
    @Override
    public void draw() {
        System.out.println("Rectangle::draw()");
    }
}

class Square implements Shape {
    @Override
    public void draw() {
        System.out.println("Square::draw()");
    }
}

class Circle implements Shape {
    @Override
    public void draw() {
        System.out.println("Circle::draw()");
    }
}

class ShapeMaker {
    private Shape circle;
    private Shape rectangle;
    private Shape square;

    public ShapeMaker() {
        circle = new Circle();
        rectangle = new Rectangle();
        square = new Square();
    }

    public void drawCircle() {
        circle.draw();
    }

    public void drawRectangle() {
        rectangle.draw();
    }

    public void drawSquare() {
        square.draw();
    }
}
{% endhighlight %}

#### Consequences

The Facade pattern offers the following benefits:

-   It shields clients from subsystem components, thereby reducting the number of objects that clients deal with and 
making the subsystem easier to use.
-   It promotes weak coupling between the subsystem and its clients. Often the components in a subsystem are strongly 
coupled. Weak coupling lets you vary the components of the subsystem without affecting its clients. Facades help layer 
a system and the dependencies between objects. They can eliminate complex or circular dependencies. This can be an 
important consequence when the client and the subsystem are implemented independently.
    Reducing compilation dependencies is vital in large software systems. You want to save time by minimizing 
recompilation when subsystem classes change. Reducing compilation dependencies with facades can limit the 
recompilation need for small change in an important subsystem. A facade can also simplify porting systems to other 
platforms, because it’s less likely that building one subsystem requires building all others.
-   It doesn’t prevent applications from using subsystem classes if they need to. Thus you can choose between ease of 
use and generality.

#### Related Patterns

Abstract Factory can be used with Facade to provide an interface for creating subsystem objects in a 
subsystem-independent way. Abstract Factory can also be used as an alternative to Facade to hide platform-specific 
classes.

Mediator is similar to Facade in that it abstracts functionality of existing classes. However, Mediator’s purpose is to 
abstract arbitrary communication between colleague objects, often centralizing, functionality that doesn’t belong in 
any one of them. A mediator’s colleagues are aware of and communicate with the mediator instead of communicating with 
each other directly. In contrast, a facade merely abstracts the interface to subsystem objects to make them easier to use; 
it doesn’t define new functionality, and subsystem classes don’t know about it.

Usually only one Facade object is required. Thus Facade objects are often Singletons.

### Flyweight

#### Intent

Use sharing to support large numbers of fine-grained objects efficiently.

#### Applicability

The Flyweight pattern’s effectiveness depends heavily on how and where it’s used. Apply the Flyweight pattern when all 
of the following are true:

-   An application uses a large number of objects.
-   Storage costs are high because of the sheer quantity of objects.
-   Most object state can be made extrinsic.
-   Many groups of objects may be replaced by relatively few shared objects once extrinsic state is removed.
-   The application doesn’t depend on object identity. Since flyweight objects may be shared, identity tests will 
return true for conceptually distinct objects.

#### Examples

{% highlight java %}
import java.util.HashMap;

interface Shape {
    void draw();
}

class Circle implements Shape {
    private String color;
    private int x;
    private int y;
    private int radius;

    public Circle(String color) {
        this.color = color;
    }

    public void setX(int x) {
        this.x = x;
    }

    public void setY(int y) {
        this.y = y;
    }

    public void setRadius(int radius) {
        this.radius = radius;
    }

    @Override
    public void draw() {
        System.out.println("Circle: Draw() [Color : " + color
                + ", x : " + x + ", y :" + y + ", radius :" + radius);
    }
}

class ShapeFactory {
    private static final HashMap<String, Shape> circleMap = new HashMap();

    public static Shape getCircle(String color) {
        Circle circle = (Circle) circleMap.get(color);

        if (circle == null) {
            circle = new Circle(color);
            circleMap.put(color, circle);
            System.out.println("Creating circle of color : " + color);
        }
        return circle;
    }
}

class FlyweightPatternDemo {
    private static final String colors[] =
            {"Red", "Green", "Blue", "White", "Black"};

    public static void main(String[] args) {

        for (int i = 0; i < 20; ++i) {
            Circle circle =
                    (Circle) ShapeFactory.getCircle(getRandomColor());
            circle.setX(getRandomX());
            circle.setY(getRandomY());
            circle.setRadius(100);
            circle.draw();
        }
    }

    private static String getRandomColor() {
        return colors[(int) (Math.random() * colors.length)];
    }

    private static int getRandomX() {
        return (int) (Math.random() * 100);
    }

    private static int getRandomY() {
        return (int) (Math.random() * 100);
    }
}
{% endhighlight %}

#### Consequences

Flyweights may introduce run-time costs associated with transferring, finding, and/or computing extrinsic state, 
especially if it was formerly stored as intrinsic state. However, such costs are offset by space savings, which 
increase as more flyweights are shared.

Storage savings are a function of several factors:

-   the reduction is the total number of instances that comes from sharing
-   the amount of intrinsic state per object
-   whether extrinsic state is computed or stored

The more flyweights are shared, the greater the storage savings. The savings increase with the amount of shared state. 
The greatest savings occur when the objects use substantial quantities of both intrinsic and extrinsic state, and the 
extrinsic state can be computed rather than stored. Then you save on storage in two ways: Sharing reduces the cost of 
intrinsic state, and you trade extrinsic state for computation time.

The Flyweight pattern is often combined with the Composite pattern to represent a hierarchical structure as a graph 
with shared leaf nodes. A consequence of sharing is that flyweight leaf nodes cannot store a pointer to their parent. 
Rather, the parent pointer is passed to the flyweight as part of its extrinsic state. This has the parent pointer is 
passed to the flyweight as part its extrinsic state. This has a major impact on how the objects in the hierarchy 
communicate with each other.

#### Related Patterns

The Flyweight pattern is often combined with the Composite pattern to implement a logically hierarchical structure in 
terms of a directed-acyclic graph with shared leaf nodes.

It’s often best to implement State and Strategy objects as flyweights.

### Proxy

#### Intent

> also known as Surrogate

Provide a surrogate or placeholder for another object to control access to it.

#### Applicability

Proxy is applicable whenever there is a need for a more versatile or sophisticated reference to an object than a simple 
pointer. Here are several common situations in which the Proxy pattern is applicable:

-   A remote proxy provides a local representative for an object in a different address space.
-   A virtual proxy creates expensive objects on demand.
-   A protection proxy controls access to the original object. Protection proxies are useful when objects should have 
different access rights.
-   A smart reference is a replacement for a bare pointer that performs additional actions when an object is accessed. 
Typical uses include
    -   counting the number of references to the real object so that it can be freed automatically when there are no 
more references( also called smart pointers)
    -   loading a persistent object into memory when it’s first referenced.
    -   checking that the real object is locked before it’s accessed to ensure that no other object can change it.

#### Examples

{% highlight java %}
interface Image {
    void display();
}

class RealImage implements Image {
    private String fileName;

    public RealImage(String fileName) {
        this.fileName = fileName;
        loadFromDisk(fileName);
    }

    @Override
    public void display() {
        System.out.println("Displaying " + fileName);
    }

    private void loadFromDisk(String fileName) {
        System.out.println("Loading " + fileName);
    }
}

class ProxyImage implements Image {
    private RealImage realImage;
    private String fileName;

    public ProxyImage(String fileName) {
        this.fileName = fileName;
    }

    @Override
    public void display() {
        if (realImage == null) {
            realImage = new RealImage(fileName);
        }
        realImage.display();
    }
}

public class ProxyPatternDemo {
    public static void main(String[] args) {
        Image image = new ProxyImage("test_10mb.jpg");

        //image will be loaded from disk
        image.display();
        System.out.println("");
        //image will not be loaded from disk
        image.display();
    }
}
{% endhighlight %}

#### Consequences

The Proxy pattern introduces a level of indirection when accessing an object. The additional indirection has many uses, 
depending on the kind of proxy:

-   A remote proxy can hide the fact that an object resides in a different address space.
-   A virtual proxy can perform optimizations such as creating an object on demand.
-   Both protection proxies and smart references allow additional housekeeping tasks when an object is accessed.

There’s another optimization that the Proxy pattern can hide from the client. It’s called copy-on-write, and it’s 
related to creation on demand. Copying a large and complicated object can be an expensive operation. If the copy is 
never modified, then there’s no need to incur this cost. By using a proxy to postpone the copying process, we ensure 
that we pay the price of copying the object only if it’s modified.

To make copy-on-write work, the subject must be reference counted. Copying the proxy will do nothing more than 
increment this reference count. Only when the client requests an operation that modifies the subject does the proxy 
actually copy it. In that case the proxy must also decrement the subject’s reference count. When the reference count 
goes to zero, the subject gets deleted.

Copy-on-write can reduce the cost of copying heavyweight subjects significantly.

#### Related Patterns

Adapter: An adapter provides a different interface to the object it adapts. In contrast, a proxy provides the same 
interface as its subject. However, a proxy used for access protection might refuse to perform an operation that the 
subject will perform, so its interface may be effectively a subset of the subject’s.

Decorator: Although decorators can have similar implementations as proxies, decorators have a different purpose. A 
decorator adds one or more responsibilities to an object, whereas a proxy controls access to an object.

Proxies vary in the degree to which they are implemented like a decorator. A protection proxy might be implemented 
exactly like a decorator. On the other hand, a remote proxy will not contain a direct reference to its real subject but 
only an indirect reference, such as ”host ID and local address on host.” A virtual proxy will start off with an 
indirect reference such as a file name but will eventually obtain and use a direct reference.
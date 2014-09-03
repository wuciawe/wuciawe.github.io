---
layout: post
tagline: Structural Patterns
category: [design pattern, object oriented]
tags: [design pattern, object oriented, structural pattern]
infotext: 'A short summary of Structural Pattern. In this post, it includes Class Structural: Adapter; Object Structural: Adapter, Bridge, Composite and Decorator.'
---
{% include JB/setup %}

> Structural patterns are concerned with how classes and objects are composed to form larger structures. Structural 
> class patterns use inheritance to compose interfaces or implementations.

In this post, I'll talk about `Class Structural`( [Adapter](#adapter) ) and `Object Structural`( [Adapter](#adapter), 
[Bridge](#bridge), [Composite](#composite), [Decorator](#decorator) ). [In next post]({% post_url 2014-08-21-design-pattern-part-3 %}), 
I'll talk about the other three `Object Structural` patterns( [Facade]( {% post_url 2014-08-21-design-pattern-part-3 %}#facade ), 
[Flyweight]({% post_url 2014-08-21-design-pattern-part-3 %}#flyweight), [Proxy]({% post_url 2014-08-21-design-pattern-part-3 %}#proxy) ).

<!-- more -->

## Class Structural

### Adapter

> also Object Structural, also known as Wrapper

#### Intent

Convert the interface of a class into another interface clients expect. Adapter lets classes work together that could 
not otherwise because of incompatible interfaces.

#### Examples

`Class Adapter` – This form uses inheritance and extends the source interface.

`Object Adapter` – This form uses composition and adapter contains the source object.

{% highlight java %}
class rLine {
    public void do_draw(int x1, int y1, int x2, int y2) {
        System.out.println("line from (" + x1 + ',' + y1 + ") to (" + x2 + ',' + y2 + ')');
    }
}

class rRectangle {
    public void do_draw(int x, int y, int w, int h) {
        System.out.println("rectangle at (" + x + ',' + y + ") with width " + w + " and height " + h);
    }
}

interface Shape {
    void draw(int x1, int y1, int x2, int y2);
}

//Using inheritance for adapter pattern
class Line extends rLine implements Shape {
    @Override
    public void draw(int x1, int y1, int x2, int y2) {
        do_draw(x1, y1, x2, y2);
    }
}

class Rectangle extends rRectangle implements Shape {
    @Override
    public void draw(int x, int y, int w, int h) {
        do_draw(x, y, w, h);
    }
}

//Using composition for adapter pattern
class Line2 implements Shape {
    private rLine adaptee = new rLine();

    @Override
    public void draw(int x1, int y1, int x2, int y2) {
        adaptee.do_draw(x1, y1, x2, y2);
    }
}

class Rectangle2 implements Shape {
    private rRectangle adaptee = new rRectangle();

    @Override
    public void draw(int x1, int y1, int x2, int y2) {
        adaptee.do_draw(Math.min(x1, x2), Math.min(y1, y2), Math.abs(x2 - x1), Math.abs(y2 - y1));
    }
}
{% endhighlight %}

#### Consequences

Class and object adapters have different trade-offs. A class adapter

-   adapts Adaptee to Target by committing to a concrete Adaptee class. As a consequence, a class adapter won’t work 
when we want to adapt a class and all its subclasses.
-   lets Adapter override some of Adaptee’s behavior, since Adapter is a subclass of Adaptee.
-   introduces only one object, and no additional pointer indirection is needed to get to the adaptee.

An object adapter

-   lets a single Adapter work with many Adaptees—that is, the Adaptee itself and all of its subclasses( if any). The 
Adapter can also add functionality to all Adaptees at once.
-   makes it harder to override Adaptee behavior. It will require subclassing Adaptee and making Adapter refer to the 
subclass rather than the Adaptee itself.

Here are other issues to consider when using the Adapter pattern:

-   How much adapting does Adapter do?
-   Pluggable adapters.
-   Using two-way adapters to provide transparency.

#### Related Patterns

[Bridge](#bridge) has a structure similar to an object adapter, but Bridge has a different intent: It is meant to separate an 
interface from its implementation so that they can be varied easily and independently. An adapter is meant to change 
the interface of an existing object.

[Decorator](#decorator) enhances another object without changing its interface. A decorator is thus more transparent to the 
application than an adapter is. As a consequence, Decorator supports recursive composition, which isn’t possible with 
pure adapters.

[Proxy]({% post_url 2014-08-21-design-pattern-part-3 %}#proxy) defines a representative or surrogate for another object and does not change its interface.

## Object Structural

### Adapter

> also Class Structural

### Bridge

> also known as Handle/Body

#### Intent

Decouple an abstraction from its implementation so that the two can vary independently.

#### Examples

{% highlight java %}
interface ITV {
    public void on();
    public void off();
    public void switchChannel(int channel);
}

class SamsungTV implements ITV {
    @Override
    public void on() {
        System.out.println("Samsung is turned on.");
    }

    @Override
    public void off() {
        System.out.println("Samsung is turned off.");
    }

    @Override
    public void switchChannel(int channel) {
        System.out.println("Samsung: channel - " + channel);
    }
}

class SonyTV implements ITV {
    @Override
    public void on() {
        System.out.println("Sony is turned on.");
    }

    @Override
    public void off() {
        System.out.println("Sony is turned off.");
    }

    @Override
    public void switchChannel(int channel) {
        System.out.println("Sony: channel - " + channel);
    }
}

abstract class AbstractRemoteControl {
    private ITV tv;

    public AbstractRemoteControl(ITV tv){
        this.tv = tv;
    }

    public void turnOn(){
        tv.on();
    }

    public void turnOff(){
        tv.off();
    }

    public void setChannel(int channel){
        tv.switchChannel(channel);
    }
}

class LogitechRemoteControl extends AbstractRemoteControl {
    public LogitechRemoteControl(ITV tv) {
        super(tv);
    }

    public void setChannelKeyboard(int channel){
        setChannel(channel);
        System.out.println("Logitech use keyword to set channel.");
    }
}
{% endhighlight %}

#### Consequences

The Bridge pattern has the following consequences:

-   Decoupling interface and implementation.
-   Improved extensibility.
-   Hiding implementation details from clients.

#### Related Patterns

An [Abstract Factory]({% post_url 2014-08-20-design-pattern-part-1 %}#abstract-factory) can create and configure a particular Bridge.

The [Adapter](#adapter) pattern is geared toward making unrelated classes work together. It is usually applied to systems after 
they’re designed. Bridge, on the other hand, is used up-front in a design to let abstractions and implementations vary 
independently.

### Composite

#### Intent

Compose objects into tree strictures to represent part-whole hierarchies. Composite lets clients treat individual 
objects and compositions of objects uniformly.

#### Examples

{% highlight java %}
import java.util.ArrayList;

// Define a "lowest common denominator"
interface AbstractFile {
    public void ls();
}

// File implements the "lowest common denominator"
class File implements AbstractFile {
    public File(String name) {
        m_name = name;
    }

    public void ls() {
        System.out.println(CompositeDemo.g_indent + m_name);
    }

    private String m_name;
}

// Directory implements the "lowest common denominator"
class Directory implements AbstractFile {
    public Directory(String name) {
        m_name = name;
    }

    public void add(Object obj) {
        m_files.add(obj);
    }

    public void ls() {
        System.out.println(CompositeDemo.g_indent + m_name);
        CompositeDemo.g_indent.append("   ");
        for (int i = 0; i < m_files.size(); ++i) {
            // Leverage the "lowest common denominator"
            AbstractFile obj = (AbstractFile) m_files.get(i);
            obj.ls();
        }
        CompositeDemo.g_indent.setLength(CompositeDemo.g_indent.length() - 3);
    }

    private String m_name;
    private ArrayList m_files = new ArrayList();
}

public class CompositeDemo {
    public static StringBuffer g_indent = new StringBuffer();

    public static void main(String[] args) {
        Directory one = new Directory("dir111"), two = new Directory("dir222"),
                thr = new Directory("dir333");
        File a = new File("a"), b = new File("b"), c = new File("c"), d = new
                File("d"), e = new File("e");
        one.add(a);
        one.add(two);
        one.add(b);
        two.add(c);
        two.add(d);
        two.add(thr);
        thr.add(e);
        one.ls();
    }
}
{% endhighlight %}

#### Consequences

The Composite pattern

-   defines class hierarchies consisting of primitive objects and composite objects. Primitive objects can be composed 
into more complex objects, which in turn can be composed, and so on recursively. Wherever client code expects a 
primitive object, it can also take a composite object.
-   makes the client simple. Clients can treat composite structures and individual objects uniformly. Clients normally 
don’t know (and shouldn’t care) whether they’re dealing with a leaf or a composite component. This simplifies client 
code, because it avoids having to write tag-and-case-statement-style functions over the classes that define the 
composition.
-   makes it easier to add new kinds of components. Newly defined Composite or Leaf subclasses work automatically with 
existing structures and client code. Clients don’t have to be changed for new Component classes.
-   can make your design overly general. The disadvantage of making it easy to add new components is that it makes it 
harder to restrict the components of a composite. Sometimes you want a composite to have only certain components. With 
Composite, you can’t rely on the type system to enforce those constraints for you. You’ll have to use run-time checks 
instead.

#### Related Patterns

Often the component-parent link is used for a [Chain of Responsibility]({% post_url 2014-08-21-design-pattern-part-4 %}#chain-of-responsibility).

[Decorator](#decorator) is often used with Composite. When decorators and composites are sued together, they will usually have a 
common parent class. So decorators will have to support the Component interface with operations like Add, Remove, and 
GetChild.

[Flyweight]({% post_url 2014-08-21-design-pattern-part-3 %}#flyweight) lets you share components, but they can no longer refer to their parents.

[Iterator]({% post_url 2014-08-21-design-pattern-part-4 %}#iterator) can be used to traverse composites.

[Visitor]({% post_url 2014-08-21-design-pattern-part-5 %}#visitor) localizes operations and behavior that would otherwise be distributed across Composite and Leaf classes.

### Decorator

#### Intent

> also known as Wrapper

Attach additional responsibilities to an object dynamically. Decorators provide a flexible alternative to subclassing 
for extending functionality.

#### Examples

{% highlight java %}
interface Shape {
    void draw();
}

class Rectangle implements Shape {

    @Override
    public void draw() {
        System.out.println("Shape: Rectangle");
    }
}

class Circle implements Shape {

    @Override
    public void draw() {
        System.out.println("Shape: Circle");
    }
}

abstract class ShapeDecorator implements Shape {
    protected Shape decoratedShape;

    public ShapeDecorator(Shape decoratedShape) {
        this.decoratedShape = decoratedShape;
    }

    public void draw() {
        decoratedShape.draw();
    }
}

class RedShapeDecorator extends ShapeDecorator {

    public RedShapeDecorator(Shape decoratedShape) {
        super(decoratedShape);
    }

    @Override
    public void draw() {
        decoratedShape.draw();
        setRedBorder(decoratedShape);
    }

    private void setRedBorder(Shape decoratedShape) {
        System.out.println("Border Color: Red");
    }
}

public class DecoratorPatternDemo {
    public static void main(String[] args) {

        Shape circle = new Circle();

        Shape redCircle = new RedShapeDecorator(new Circle());

        Shape redRectangle = new RedShapeDecorator(new Rectangle());
        System.out.println("Circle with normal border");
        circle.draw();

        System.out.println("\nCircle of red border");
        redCircle.draw();

        System.out.println("\nRectangle of red border");
        redRectangle.draw();
    }
}
{% endhighlight %}

#### Consequences

The Decorator pattern has at least two key benefits and two liabilities:

-   More flexibility than static inheritance.
-   Avoids feature-laden classes high up in the hierarchy.
-   A decorator and its component aren’t identical.
-   Lots of little objects.

#### Related Patterns

[Adapter](#adapter): A decorator is different from an adapter in that a decorator only changes an object’s responsibilities, not 
its interface; an adapter will give an object a completely new interface.

[Composite](#composite): A decorator can be viewed as a degenerate composite with only one component. However, a decorator adds 
additional responsibilities—it isn’t intended for object aggregation.

[Strategy]({% post_url 2014-08-21-design-pattern-part-5 %}#strategy): A decorator lets you change the skin of an object; a strategy lets you change the guts. These are two 
alternative ways of changing an object.
---
layout: post
tagline: Behavioral Patterns
category: [design pattern, object oriented]
tags: [design pattern, object oriented, behavioral pattern]
---
{% include JB/setup %}

> Behavioral patterns are concerned with algorithms and the assignment of responsibilities between objects. Behavioral 
> patterns describe not just patterns of objects or classes but also the patterns of communication between them. These 
> patterns characterize complex control flow that’s different to follow at run-time. They shift your focus away form 
> flow of control to let you concentrate just on the way objects are interconnected.

## Object Behavioral

### Chain of Responsibility

#### Intent

Avoid coupling the sender of a request to its receiver by giving more than one object a chance to handle the request. 
Chain the receiving objects and pass the request along the chain until an object handles it.

#### Applicability

Use Chain of Responsibility when

-   more than one object may handle a request, and the handler isn’t known a priori. The handler should be ascertained 
automatically.
-   you want to issue a request to one of several objects without specifying the receiver explicitly.
-   the set of objects that can handle a request should be specified dynamically.

#### Examples

{% highlight java %}
abstract class AbstractLogger {
    public static int INFO = 1;
    public static int DEBUG = 2;
    public static int ERROR = 3;

    protected int level;

    //next element in chain or responsibility
    protected AbstractLogger nextLogger;

    public void setNextLogger(AbstractLogger nextLogger) {
        this.nextLogger = nextLogger;
    }

    public void logMessage(int level, String message) {
        if (this.level <= level) {
            write(message);
        }
        if (nextLogger != null) {
            nextLogger.logMessage(level, message);
        }
    }

    abstract protected void write(String message);

}

class ConsoleLogger extends AbstractLogger {
    public ConsoleLogger(int level) {
        this.level = level;
    }

    @Override
    protected void write(String message) {
        System.out.println("Standard Console::Logger: " + message);
    }
}

class ErrorLogger extends AbstractLogger {
    public ErrorLogger(int level) {
        this.level = level;
    }

    @Override
    protected void write(String message) {
        System.out.println("Error Console::Logger: " + message);
    }
}

class FileLogger extends AbstractLogger {
    public FileLogger(int level) {
        this.level = level;
    }

    @Override
    protected void write(String message) {
        System.out.println("File::Logger: " + message);
    }
}

public class ChainPatternDemo {
    private static AbstractLogger getChainOfLoggers() {

        AbstractLogger errorLogger = new ErrorLogger(AbstractLogger.ERROR);
        AbstractLogger fileLogger = new FileLogger(AbstractLogger.DEBUG);
        AbstractLogger consoleLogger = new ConsoleLogger(AbstractLogger.INFO);

        errorLogger.setNextLogger(fileLogger);
        fileLogger.setNextLogger(consoleLogger);

        return errorLogger;
    }

    public static void main(String[] args) {
        AbstractLogger loggerChain = getChainOfLoggers();

        loggerChain.logMessage(AbstractLogger.INFO,
                "This is an information.");

        loggerChain.logMessage(AbstractLogger.DEBUG,
                "This is an debug level information.");

        loggerChain.logMessage(AbstractLogger.ERROR,
                "This is an error information.");
    }
}
{% endhighlight %}

#### Consequences

Chain of Responsibility has the following benefits and liabilities:

-   Reducing coupling.
-   Added flexibility in assigning responsibilities to objects.
-   Receipt isn’t guaranteed.

#### Related Patterns

Chain of Responsibility is often applied in conjunction with Composite. There, a component’s parent can act as its 
successor.

### Command

> also known as Action, Transaction

#### Intent

Encapsulate a request as an object, thereby letting you parametrize clients with different requests, queue or log 
requests, and support undoable operations.

#### Applicability

Use the Command pattern when you want to

-   parametrize objects by an action to perform, as menuItem objects did above. You can express such parametrization 
in a procedural language with a callback function, that is, a function that’s registered somewhere to be called at a 
later point. Commands are an object-oriented replacement for callbacks.
-   specify, queue, and execute requests at different times. A command object can have a lifetime independent of the 
original request. If the receiver of a request can be represented in an address space-independent way, then you can 
transfer a command object for the request to a different process and fulfill the request there.
-   support undo. The Command’s Execute operation can store state for reversing its effects in the command itself. The 
Command interface must have an added-Unexecute operation that reverses the effects of a previous call to Execute. 
Execute commands are stored in a history list. Unlimited-level undo and redo is achieved by traversing this list 
backwards and forwards calling Unexecute and Execute, respectively.
-   support logging changes so that they can be reapplied in case of a system crash. By augmenting the Command 
interface with load and store operations, you can keep a persistent log of changes. Recovering from a crash involves 
reloading logged commands from disk and re-executing them with the Execute operation.
-   structure a system around high-level operations built on primitives operations. Such a structure is common in 
information systems that support transactions. A transaction encapsulates a set of changes to data. The Command pattern 
offers a way to model transactions. Commands have a common interface, letting you invoke all transactions the same way. 
The pattern also makes it easy to extend the system with new transactions.

#### Examples

{% highlight java %}
import java.util.ArrayList;
import java.util.List;

interface Order {
    void execute();
}

class Stock {
    private String name = "ABC";
    private int quantity = 10;

    public void buy() {
        System.out.println("Stock [ Name: " + name + ", Quantity: " + quantity + " ] bought");
    }

    public void sell() {
        System.out.println("Stock [ Name: " + name + ", Quantity: " + quantity + " ] sold");
    }
}

class BuyStock implements Order {
    private Stock abcStock;

    public BuyStock(Stock abcStock) {
        this.abcStock = abcStock;
    }

    public void execute() {
        abcStock.buy();
    }
}

class SellStock implements Order {
    private Stock abcStock;

    public SellStock(Stock abcStock) {
        this.abcStock = abcStock;
    }

    public void execute() {
        abcStock.sell();
    }
}

class Broker {
    private List<Order> orderList = new ArrayList<Order>();

    public void takeOrder(Order order) {
        orderList.add(order);
    }

    public void placeOrders() {
        for (Order order : orderList) {
            order.execute();
        }
        orderList.clear();
    }
}

public class CommandPatternDemo {
    public static void main(String[] args) {
        Stock abcStock = new Stock();

        BuyStock buyStockOrder = new BuyStock(abcStock);
        SellStock sellStockOrder = new SellStock(abcStock);

        Broker broker = new Broker();
        broker.takeOrder(buyStockOrder);
        broker.takeOrder(sellStockOrder);

        broker.placeOrders();
    }
}
{% endhighlight %}

#### Consequences

The Command pattern has the following consequences:

-   Command decouples the object that invokes the operation from the one that knows how to perform it.
-   Commands are first-class objects. They can be manipulated and extended like any other object.
-   You can assemble commands into a composite command. An example is the MacroCommand class described earlier. In 
general, composite commands are an instance of the Composite pattern.
-   It’s easy to add new Commands, because you don’t have to change existing classes.

#### Related Patterns

A Composite can be used to implement MacroCommands.

A Memento can keep state the command requires to undo its effect.

A command that must be copied before being placed on the history list acts as Prototype.

### Iterator

> also known as Cursor

#### Intent

Provide a way to access the elements of an aggregate object sequentially without exposing its underlying representation.

#### Applicability

Use the Iterator pattern

-   to access an aggregate object’s contents without exposing its internal representation.
-   to support multiple traversals of aggregate objects.
-   to provide a uniform interface for traversing different aggregate structures (that is, to support polymorphic 
iteration).

#### Examples

{% highlight java %}
interface Iterator {
    public boolean hasNext();

    public Object next();
}

interface Container {
    public Iterator getIterator();
}

class NameRepository implements Container {
    public String names[] = {"Robert", "John", "Julie", "Lora"};

    @Override
    public Iterator getIterator() {
        return new NameIterator();
    }

    private class NameIterator implements Iterator {

        int index;

        @Override
        public boolean hasNext() {
            if (index < names.length) {
                return true;
            }
            return false;
        }

        @Override
        public Object next() {
            if (this.hasNext()) {
                return names[index++];
            }
            return null;
        }
    }
}

public class IteratorPatternDemo {
    public static void main(String[] args) {
        NameRepository namesRepository = new NameRepository();

        for (Iterator iter = namesRepository.getIterator(); iter.hasNext(); ) {
            String name = (String) iter.next();
            System.out.println("Name : " + name);
        }
    }
}
{% endhighlight %}

#### Consequences

The Iterator pattern has three important consequences:

-   It supports variations in the traversal of an aggregate.
-   Iterators simplify the Aggregate interface.
-   More than one traversal can be pending on an aggregate.

#### Related Patterns

Composite: Iterators are often applied to recursive structures such as Composites.

Factory Method: Polymorphic iterators rely on factory methods to instantiate the appropriate Iterator subclass.

Memento is often used in conjunction with the Iterator pattern. An iterator can use a memento to capture the state of 
an iteration. The iterator stores the memento internally.

### Mediator

#### Intent

Define an object that encapsulates how a set of objects interact. Mediator promotes loose coupling by keeping objects 
from referring to each other explicitly, and it lets you vary their interaction independently.

#### Applicability

Use the Mediator pattern when

-   a set of objects communicate in well-defined but complex ways. The resulting interdependencies are unstructured and 
difficult to understand.
-   reusing an object is difficult because it refers to and communicates with many other objects.
-   a behavior that’s distributed between several classes should be customizable without a lot of subclassing.

#### Examples

{% highlight java %}
import java.util.Date;

class ChatRoom {
    public static void showMessage(User user, String message) {
        System.out.println(new Date().toString() + " [" + user.getName() + "] : " + message);
    }
}

class User {
    private String name;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public User(String name) {
        this.name = name;
    }

    public void sendMessage(String message) {
        ChatRoom.showMessage(this, message);
    }
}

public class MediatorPatternDemo {
    public static void main(String[] args) {
        User robert = new User("Robert");
        User john = new User("John");

        robert.sendMessage("Hi! John!");
        john.sendMessage("Hello! Robert!");
    }
}
{% endhighlight %}

#### Consequences

The Mediator pattern has the following benefits and drawbacks:

-   It limits subclassing.
-   It decouples colleagues.
-   It simplifies object protocols.
-   It abstracts how objects cooperate.
-   It centralizes control.

#### Related Patterns

Facade differs from Mediator in that it abstracts a subsystem of objects to provide a more convenient interface. Its 
protocol is unidirectional; that is, Facade objects make requests of the subsystem classes but not vice versa. In 
contrast, Mediator enables cooperative behavior that colleague objects don’t or can’t provide, and the protocol is 
multi-directional.

### Memento

> also known as Token

#### Intent

Without violating encapsulation, capture and externalize an object’s internal state so that the object can be restored 
to this state later.

#### Applicability

Use the Memento pattern when

-   a snapshot of (some portion of) an object’s state must be saved so that it can be restored to that state later, and
-   a direct interface to obtaining the state would expose implementation details and break the object’s encapsulation.

#### Examples

{% highlight java %}
import java.util.ArrayList;
import java.util.List;

class Memento {
    private String state;

    public Memento(String state) {
        this.state = state;
    }

    public String getState() {
        return state;
    }
}

class Originator {
    private String state;

    public void setState(String state) {
        this.state = state;
    }

    public String getState() {
        return state;
    }

    public Memento saveStateToMemento() {
        return new Memento(state);
    }

    public void getStateFromMemento(Memento Memento) {
        state = Memento.getState();
    }
}

class CareTaker {
    private List<Memento> mementoList = new ArrayList<Memento>();

    public void add(Memento state) {
        mementoList.add(state);
    }

    public Memento get(int index) {
        return mementoList.get(index);
    }
}

public class MementoPatternDemo {
    public static void main(String[] args) {
        Originator originator = new Originator();
        CareTaker careTaker = new CareTaker();
        originator.setState("State #1");
        originator.setState("State #2");
        careTaker.add(originator.saveStateToMemento());
        originator.setState("State #3");
        careTaker.add(originator.saveStateToMemento());
        originator.setState("State #4");

        System.out.println("Current State: " + originator.getState());
        originator.getStateFromMemento(careTaker.get(0));
        System.out.println("First saved State: " + originator.getState());
        originator.getStateFromMemento(careTaker.get(1));
        System.out.println("Second saved State: " + originator.getState());
    }
}
{% endhighlight %}

#### Consequences

The Memento pattern has several consequences:

-   Preserving encapsulation boundaries.
-   It simplifies Originator.
-   Using mementos might be expensive.
-   Defining narrow and wide interfaces.
-   Hidden costs in caring for mementos.

#### Related Patterns

Command: Commands can use mementos to maintain state for undoable operations.

Iterator: Mementos can be used for iteration as described earlier.

### Observer

> also known as Dependents, Publish-Subscribe

#### Intent

define a one-to-many dependency between objects so that when one object changes state, all its dependents are notified 
and updated automatically.

#### Applicability

Use the Observer pattern in any of the following situations:

-   When an abstraction has two aspects, one dependent on the other. Encapsulating these aspects in separate objects 
lets you vary and reuse them independently.
-   When a change to one object requires changing others, and you don’t know how many objects need to be changed.
-   When an object should be able to notify other objects without making assumptions about who these objects are. In 
other words, you don’t want these objects tightly coupled.

#### Examples

{% highlight java %}
import java.util.ArrayList;
import java.util.List;

class Subject {
    private List<Observer> observers
            = new ArrayList<Observer>();
    private int state;

    public int getState() {
        return state;
    }

    public void setState(int state) {
        this.state = state;
        notifyAllObservers();
    }

    public void attach(Observer observer) {
        observers.add(observer);
    }

    public void notifyAllObservers() {
        for (Observer observer : observers) {
            observer.update();
        }
    }
}

abstract class Observer {
    protected Subject subject;

    public abstract void update();
}

class BinaryObserver extends Observer {
    public BinaryObserver(Subject subject) {
        this.subject = subject;
        this.subject.attach(this);
    }

    @Override
    public void update() {
        System.out.println("Binary String: "
                + Integer.toBinaryString(subject.getState()));
    }
}

class OctalObserver extends Observer {
    public OctalObserver(Subject subject) {
        this.subject = subject;
        this.subject.attach(this);
    }

    @Override
    public void update() {
        System.out.println("Octal String: "
                + Integer.toOctalString(subject.getState()));
    }
}

public class ObserverPatternDemo {
    public static void main(String[] args) {
        Subject subject = new Subject();

        new OctalObserver(subject);
        new BinaryObserver(subject);

        System.out.println("First state change: 15");
        subject.setState(15);
        System.out.println("Second state change: 10");
        subject.setState(10);
    }
}
{% endhighlight %}

#### Consequences

The Observer pattern lets you vary subjects and observers independently. You can reuse subjects without reusing their 
observers, and vice versa. It lets you add observers without modifying the subject or other observers.

Further benefits and liabilities of the Observer pattern include the following:

-   Abstract coupling between Subject and Observer.
-   Support for broadcast communication.
-   Unexpected updates.

#### Related Patterns

Mediator: By encapsulating complex update semantics, the ChangeManager acts as mediator between subjects and observers.

Singleton: The ChangeManager may use the Singleton pattern to make it unique and globally accessible.
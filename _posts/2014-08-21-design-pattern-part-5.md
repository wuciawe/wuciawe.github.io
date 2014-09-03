---
layout: post
tagline: Behavioral Patterns
category: [design pattern, object oriented]
tags: [design pattern, object oriented, behavioral pattern]
infotext: 'A short summary of Behavioral Pattern. In this post, it includes Object Behavioral: State, Strategy and Visitor; Class Behavioral: Template Method.'
---
{% include JB/setup %}

[In last post]({% post_url 2014-08-21-design-pattern-part-4 %}), I’ve talked about `Object Behavioral`( [Chain of Responsibility]({% post_url 2014-08-21-design-pattern-part-4 %}#chain-of-responsibility), 
[Command]({% post_url 2014-08-21-design-pattern-part-4 %}#command), [Iterator]({% post_url 2014-08-21-design-pattern-part-4 %}#iterator), [Mediator]({% post_url 2014-08-21-design-pattern-part-4 %}#mediator), [Memento]({% post_url 2014-08-21-design-pattern-part-4 %}#memento), [Observer]({% post_url 2014-08-21-design-pattern-part-4 %}#observer) ). 
In this post, I'll talk about the other three `Object Behavioral`( 
[State](#state), [Strategy](#strategy), 
[Visitor](#visitor) ) and `Class Behavioral`( [Interpreter](#interpreter), 
[Template Method](#template-method) )

<!-- more -->

### State

> also known as Ojbects for States

#### Intent

Allow an object to alter its behavior when its internal state changes. The object will appear to change its class.

#### Examples

{% highlight java %}
interface State {
    public void doAction(Context context);
}

class StartState implements State {
    public void doAction(Context context) {
        System.out.println("Player is in start state");
        context.setState(this);
    }

    public String toString() {
        return "Start State";
    }
}

class StopState implements State {
    public void doAction(Context context) {
        System.out.println("Player is in stop state");
        context.setState(this);
    }

    public String toString() {
        return "Stop State";
    }
}

class Context {
    private State state;

    public Context() {
        state = null;
    }

    public void setState(State state) {
        this.state = state;
    }

    public State getState() {
        return state;
    }
}

public class StatePatternDemo {
    public static void main(String[] args) {
        Context context = new Context();

        StartState startState = new StartState();
        startState.doAction(context);

        System.out.println(context.getState().toString());

        StopState stopState = new StopState();
        stopState.doAction(context);

        System.out.println(context.getState().toString());
    }
}
{% endhighlight %}

#### Consequences

The State pattern has the following consequences:

-   It localizes state-specific behavior and partitions behavior for different states.
-   It makes state transitions explicit.
-   State objects can be shared.

#### Related Patterns

The [Flyweight]({% post_url 2014-08-21-design-pattern-part-3 %}#flyweight) pattern explains when and how State objects can be shared.

State objects are often [Singletons]({% post_url 2014-08-20-design-pattern-part-1 %}#singleton).

### Strategy

> also known as Policy

#### Intent

Define a family of algorithms, encapsulate each one, and make them interchangeable. Strategy lets the algorithm vary 
independently from clients that use it.

#### Examples

{% highlight java %}
interface Strategy {
    public int doOperation(int num1, int num2);
}

class OperationAdd implements Strategy {
    @Override
    public int doOperation(int num1, int num2) {
        return num1 + num2;
    }
}

class OperationSubstract implements Strategy {
    @Override
    public int doOperation(int num1, int num2) {
        return num1 - num2;
    }
}

class OperationMultiply implements Strategy {
    @Override
    public int doOperation(int num1, int num2) {
        return num1 * num2;
    }
}

class Context {
    private Strategy strategy;

    public Context(Strategy strategy) {
        this.strategy = strategy;
    }

    public int executeStrategy(int num1, int num2) {
        return strategy.doOperation(num1, num2);
    }
}

public class StrategyPatternDemo {
    public static void main(String[] args) {
        Context context = new Context(new OperationAdd());
        System.out.println("10 + 5 = " + context.executeStrategy(10, 5));

        context = new Context(new OperationSubstract());
        System.out.println("10 - 5 = " + context.executeStrategy(10, 5));

        context = new Context(new OperationMultiply());
        System.out.println("10 * 5 = " + context.executeStrategy(10, 5));
    }
}
{% endhighlight %}

#### Consequences

The Strategy pattern has the following benefits and drawbacks:

-   Families of related algorithms.
-   An alternative to subclassing.
-   Strategies eliminate conditional statements.
-   A choice of implementations.
-   Clients must be aware of different Strategies.
-   Communication overhead between Strategy and Context.
-   Increased number of objects.

#### Related Patterns

[Flyweight]({% post_url 2014-08-21-design-pattern-part-3 %}#flyweight): Strategy objects often make good flyweights.

### Visitor

#### Intent

Represent an operation to be performed on the elements of an object structure. Visitor lets you define a new operation 
without changing the classes of the elements on which it operates.

#### Examples

{% highlight java %}
interface ComputerPart {
    public void accept(ComputerPartVisitor computerPartVisitor);
}

class Keyboard implements ComputerPart {
    @Override
    public void accept(ComputerPartVisitor computerPartVisitor) {
        computerPartVisitor.visit(this);
    }
}

class Monitor implements ComputerPart {
    @Override
    public void accept(ComputerPartVisitor computerPartVisitor) {
        computerPartVisitor.visit(this);
    }
}

class Mouse implements ComputerPart {
    @Override
    public void accept(ComputerPartVisitor computerPartVisitor) {
        computerPartVisitor.visit(this);
    }
}

class Computer implements ComputerPart {
    ComputerPart[] parts;

    public Computer() {
        parts = new ComputerPart[]{new Mouse(), new Keyboard(), new Monitor()};
    }


    @Override
    public void accept(ComputerPartVisitor computerPartVisitor) {
        for (int i = 0; i < parts.length; i++) {
            parts[i].accept(computerPartVisitor);
        }
        computerPartVisitor.visit(this);
    }
}

interface ComputerPartVisitor {
    public void visit(Computer computer);

    public void visit(Mouse mouse);

    public void visit(Keyboard keyboard);

    public void visit(Monitor monitor);
}

class ComputerPartDisplayVisitor implements ComputerPartVisitor {
    @Override
    public void visit(Computer computer) {
        System.out.println("Displaying Computer.");
    }

    @Override
    public void visit(Mouse mouse) {
        System.out.println("Displaying Mouse.");
    }

    @Override
    public void visit(Keyboard keyboard) {
        System.out.println("Displaying Keyboard.");
    }

    @Override
    public void visit(Monitor monitor) {
        System.out.println("Displaying Monitor.");
    }
}

public class VisitorPatternDemo {
    public static void main(String[] args) {
        ComputerPart computer = new Computer();
        computer.accept(new ComputerPartDisplayVisitor());
    }
}
{% endhighlight %}

#### Consequences

Some of the benefits and liabilities of the Visitor pattern are as follows:

-   Visitor makes adding new operations easy.
-   A visitor gathers related operations and separates unrelated ones.
-   Adding new ConcreteElement classes is hard.
-   Visiting across class hierarchies.
-   Accumulating state.
-   Breaking encapsulation.

#### Related Patterns

[Composite]({% post_url 2014-08-20-design-pattern-part-2 %}#composite): Visitors can be used to apply an operation over an object structure defined by the Composite pattern.

[Interpreter](#interpreter): Visitor may be applied to do the interpretation.

## Class Behavioral

### Interpreter

#### Intent

Given a language, define a representation for its grammar along with an interpreter that uses the representation to 
interpret sentences in the language.

#### Examples

{% highlight java %}
interface Expression {
    public boolean interpret(String context);
}

class TerminalExpression implements Expression {
    private String data;

    public TerminalExpression(String data) {
        this.data = data;
    }

    @Override
    public boolean interpret(String context) {
        if (context.contains(data)) {
            return true;
        }
        return false;
    }
}

class OrExpression implements Expression {
    private Expression expr1 = null;
    private Expression expr2 = null;

    public OrExpression(Expression expr1, Expression expr2) {
        this.expr1 = expr1;
        this.expr2 = expr2;
    }

    @Override
    public boolean interpret(String context) {
        return expr1.interpret(context) || expr2.interpret(context);
    }
}

class AndExpression implements Expression {
    private Expression expr1 = null;
    private Expression expr2 = null;

    public AndExpression(Expression expr1, Expression expr2) {
        this.expr1 = expr1;
        this.expr2 = expr2;
    }

    @Override
    public boolean interpret(String context) {
        return expr1.interpret(context) && expr2.interpret(context);
    }
}

public class InterpreterPatternDemo {
    //Rule: Robert and John are male
    public static Expression getMaleExpression() {
        Expression robert = new TerminalExpression("Robert");
        Expression john = new TerminalExpression("John");
        return new OrExpression(robert, john);
    }

    //Rule: Julie is a married women
    public static Expression getMarriedWomanExpression() {
        Expression julie = new TerminalExpression("Julie");
        Expression married = new TerminalExpression("Married");
        return new AndExpression(julie, married);
    }

    public static void main(String[] args) {
        Expression isMale = getMaleExpression();
        Expression isMarriedWoman = getMarriedWomanExpression();

        System.out.println("John is male? " + isMale.interpret("John"));
        System.out.println("Julie is a married women? "
                + isMarriedWoman.interpret("Married Julie"));
    }
}
{% endhighlight %}

#### Consequences

The Interpreter pattern has the following benefits and liabilities:

-   It’s easy to change and extend the grammar.
-   Implementing the grammar is easy, too.
-   Complex grammars are hard to maintain.
-   Adding new ways to interpret expressions.

#### Related Patterns

[Composite]({% post_url 2014-08-20-design-pattern-part-2 %}#composite): The abstract syntax tree is an instance of the Composite pattern.

[Flyweight]({% post_url 2014-08-21-design-pattern-part-3 %}#flyweight) shows how to share terminal symbols within the abstract syntax tree.

[Iterator]({% post_url 2014-08-21-design-pattern-part-4 %}#iterator): The interpreter can use an Iterator to traverse the structure.

[Visitor](#visitor) can be used to maintain the behavior in each node in the abstract syntax tree in one class.

### Template Method

#### Intent

Define the skeleton of an algorithm in an operation, deferring some steps to subclasses. Template Method lets 
subclasses redefine certain steps of an algorithm without changing the algorithm’s structure.

#### Examples

{% highlight java %}
abstract class Game {
    abstract void initialize();

    abstract void startPlay();

    abstract void endPlay();

    //template method
    public final void play() {
        //initialize the game
        initialize();

        //start game
        startPlay();

        //end game
        endPlay();
    }
}

class Cricket extends Game {
    @Override
    void endPlay() {
        System.out.println("Cricket Game Finished!");
    }

    @Override
    void initialize() {
        System.out.println("Cricket Game Initialized! Start playing.");
    }

    @Override
    void startPlay() {
        System.out.println("Cricket Game Started. Enjoy the game!");
    }
}

class Football extends Game {
    @Override
    void endPlay() {
        System.out.println("Football Game Finished!");
    }

    @Override
    void initialize() {
        System.out.println("Football Game Initialized! Start playing.");
    }

    @Override
    void startPlay() {
        System.out.println("Football Game Started. Enjoy the game!");
    }
}

public class TemplatePatternDemo {
    public static void main(String[] args) {
        Game game = new Cricket();
        game.play();
        System.out.println();
        game = new Football();
        game.play();
    }
}
{% endhighlight %}

#### Consequences

Template methods are a fundamental technique for code reuse. They are particularly important in class libraries, 
because they are the means for factoring out common behavior in library classes.

Template methods lead to an inverted control structure that’s sometimes referred to as “the Hollywood principle”, that 
is, “Don’t call us, we’ll call you”. This refers to how a parent class calls the operations of a subclass and not the 
other way around.

Template methods call the following kinds of operations:

-   concrete operations (either on the ConcreteClass or on client classes);
-   AbstractClass operations (i.e., operations that are generally useful to subclasses);
-   primitive operations (i.e., abstract operations);
-   factory methods; and
-   hook operations, which provide default behavior that subclasses can extend if necessary. A hook operation often 
does nothing by default.

It’s important for template methods to specify which operations are hooks (may be overridden) and which are abstract 
operations (must be overridden). To reuse an abstract class effectively, subclass writers must understand which 
operations are designed for overriding.

A subclass can extend a parent class operation’s behavior by overriding the operation and calling the parent operation 
explicitly.

Unfortunately, it’s easy to forget to call the inherited operation. We can transform such an operation into a template 
method to give the parent control over how subclasses extend it. The idea is to call a hook operation from a template 
method in the parent class. Then subclasses can then override this hook operation.

#### Related Patterns

[Factory Methods]({% post_url 2014-08-20-design-pattern-part-1 %}#factory-method) are often called by template methods.

[Strategy](#strategy): Template methods use inheritance to vary part of an algorithm. Strategies use delegation to vary the entire 
algorithm.
---
layout: post
tagline: Behavioral Patterns
category: [design pattern, object oriented]
tags: [design pattern, object oriented, behavioral pattern]
---
{% include JB/setup %}

<!-- more -->

### State

> also known as Ojbects for States

#### Intent

Allow an object to alter its behavior when its internal state changes. The object will appear to change its class.

#### Applicability

Use the State pattern in either of the following cases:

-   An object’s behavior depends on its state, and it must change its behvior at run-time depending on that state.
-   Operations have large, multipart conditional statements that depend on the object’s state. This state is usually 
represented by one or more enumerated constants. Often, several operations will contain this same conditional 
structure. The State pattern puts each branch of the conditional in a separate class. This lets you treat the object’s 
state as an object in its own right that can vary independently from other objects.

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

The Flyweight pattern explains when and how State objects can be shared.

State objects are often Singletons.

### Strategy

> also known as Policy

#### Intent

Define a family of algorithms, encapsulate each one, and make them interchangeable. Strategy lets the algorithm vary 
independently from clients that use it.

#### Applicability

Use the Strategy pattern when

-   many related classes differ only in their behavior. Strategies provide a way to configure a class with one of many behaviors.
-   you need different variants of an algorithm. For example, you might define algorithms reflecting different 
space/time trade-offs. Strategies can be used when these variants are implemented as a class hierarchy of algorithms.
-   an algorithm uses data that clients shouldn’t know about. Use the Strategy pattern to avoid exposing complex, 
algorithm-specific data structures.
- a class defines many behaviors, and these appear as multiple conditional statements in its operations. Instead of 
many conditionals, move related conditional branches into their own Strategy class.

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

Flywieght: Strategy objects often make good flyweights.

### Visitor

#### Intent

Represent an operation to be performed on the elements of an object structure. Visitor lets you define a new operation 
without changing the classes of the elements on which it operates.

#### Applicability

Use the Visitor pattern when

-   an object structure contains many classes of objects with differing interfaces, and you want to perform operations 
on these objects that depend on their concrete classes.
-   many distinct and unrelated operations need to be performed on objects in an object structure, and you want to 
avoid “polluting” their classes with these operations. Visitor lets you keep related operations together by defining 
them in one class. When the object structure is shared by many applications, use Visitor to put operations in just 
those applications that need them.
-   the classes defining the object structure rarely change, but you often want to define new operations over the 
structure. Changing the object structure classes requires redefining the interface to all visitors, which is 
potentially costly. If the object structure classes change often, then it’s probably better to define the operations in 
those classes.

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

Composite: Visitors can be used to apply an operation over an object structure defined by the Composite pattern.

Interpreter: Visitor may be applied to do the interpretation.

## Class Behavioral

### Interpreter

#### Intent

Given a language, define a representation for its grammar along with an interpreter that uses the representation to 
interpret sentences in the language.

#### Applicability

Use the Interpreter pattern when there is a language to interpret, and you can represent statements in the language as 
abstract syntax trees. The Interpreter pattern works best when

-   the grammar is the simple. For complex grammar, the class hierarchy for the grammar becomes large and unmanageable. 
Tools such as parser generators are a better alternative in such cases. They can interpret expressions without building 
abstract syntax trees, which can save space and possibly time.
-   efficiency is not a critical concern. The most efficient interpreters are usually not implemented by interpreting 
parse trees directly but by first translating them into another form. For example, regular expressions are often 
transformed into state machines. But even then, the translator can be implemented by the Interpreter pattern, so the 
pattern is still applicable.

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

Composite: The abstract syntax tree is an instance of the Composite pattern.

Flyweight shows how to share terminal symbols within the abstract syntax tree.

Iterator: The interpreter can use an Iterator to traverse the structure.

Visitor can be used to maintain the behavior in each node in the abstract syntax tree in one class.

### Template Method

#### Intent

Define the skeleton of an algorithm in an operation, deferring some steps to subclasses. Template Method lets 
subclasses redefine certain steps of an algorithm without changing the algorithm’s structure.

#### Applicability

The Template Method pattern should be used

-   to implement the invariant parts of an algorithm once and leave it up to subclasses implement the behavior that can 
vary.
-   when common behavior among subclasses should be factored and localized in a common class to avoid code duplication. 
This is a good example of ”refactoring to generalize”. You first identify the differences in the existing code and then 
separate the differences into new operations. Finally, you replace the differing code with a template method that calls 
one of these new operations.
-   to control subclasses extensions. You can define a template method that calls “hook” operations at specific points, 
thereby permitting extensions only at those points.

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

Factory Methods are often called by template methods.

Strategy: Template methods use inheritance to vary part of an algorithm. Strategies use delegation to vary the entire 
algorithm.
---
layout: post
category: [jvm]
tags: [jvm, bytecode]
infotext: 'brief introduction to JVM bytecode instructions and classfile.'
---
{% include JB/setup %}

[In last post]({%post_url 2017-03-03-notes-on-memory-and-jvm%}), 
I introduced how memory looks like in the JVM and pointed out that most mnemonics interact with the 
stack operand as well. Now, I am going to introduce bytecode.

### Types in JVM

Though Java, a language runs on JVM, is known for being strong type and static type, JVM does not 
have much information about type. There is no type information on stack operand. The values on the 
stack operand are either primitive values, references or addresses, or in other words, the stack 
operand has no idea what type the object on it is.

For primitives, there are specific instructions for them correspondingly. The primitives and the 
object references are denoted as:

- __boolean__: `z`
- __byte__: `b`
- __char__: `c`
- __short__: `s`
- __int__: `i`
- __long__: `l`
- __float__: `f`
- __double__: `d`
- __reference__: `a`

### Instructions

Java bytecode is the instruction set of the Java virtual machine. Each bytecode is composed of one, 
or in some cases two bytes that represent the instruction (opcode), along with zero or more bytes 
for passing parameters. Currently, in Jan 2017, there are 205 opcodes in use out of 256 possible 
byte-long opcodes.

Instructions fall into a number of broad groups:

- Load and store (e.g. aload_0, istore)
- Operand stack management (e.g. swap, dup2)
- Arithmetic and logic (e.g. ladd, fcmpl)
- Type conversion (e.g. i2b, d2i)
- Object creation and manipulation (new, putfield)
- Control transfer (e.g. ifeq, goto)
- Method invocation and return (e.g. invokespecial, areturn)

There are also a few instructions for a number of more specialized tasks such as exception throwing, 
synchronization, etc.

#### Load and Store

`load` means pushing some value onto the stack operand. It has several forms:

- load value from local variable array: `t`__load__

  `t` denotes the possible types: `i`, `l`, `f`, `d`, `a`. boolean, byte, char and short are treated 
  as int. So there are 5 opcodes in total.

- load value from local variable array: `t`__load___`#`

  In the above `t`load opcodes, a parameter is required to specify the index of the variable in the 
  local variable array. So there are 2 bytes used. In order to make bytecode more compact, frequently 
  accessed indices have specific opcodes. `#` takes value ranges from 0 to 3. So there are 20 opcodes 
  in total.

- load some specific constant: `t`__const___`#`

  These opcodes are used for load frequently used values. When `t` is `i`, `#` ranges from `m1` to 
  `5`, denoting integers from -1 to 5. When `t` is `l`, `#` ranges from 0 to 1. when `t` is `f`, `#` 
  ranges from 0 to 2. When `t` is `d`, `#` ranges from 0 to 1. When `t` is `a`, `#` is `null`. So 
  there are 15 in total.

- load `byte` constant: __bipush__

- load `short` constant: __sipush__

- load other constant: __ldc__, __ldc_w__, __ldc2_w__

  ldc is for loading constants from constant pool with a byte parameter denoting the index in constant 
  pool. ldc is for loading constants from constant pool needing two byte parameters denoting the 
  index in constant pool. ldc2_w is for loading double and long, having two byte parameters.

- load value from an array: `t`__aload__

  It is an operator on an array reference on the stack operand, where `t` denotes the possible 
  types: `b`, `c`, `s`, `i`, `f`, `d`, `a`. So there are 8 opcodes in total.

`store` means storing some value from the stack operand. It has several forms:

- store value into the local variable array: `t`__store__

  `t` denotes the possible types: `i`, `l`, `f`, `d`, `a`. So there are 5 opcodes in total.

- store value into the local variable array: `t`__store___`#`

  `#` takes value ranges from 0 to 3. So there are 20 opcodes in total.

- store value into an array: `t`__astore__

  It is an operator on an array reference on the stack operand, where `t` denotes the possible 
  types: `b`, `c`, `s`, `i`, `f`, `d`, `a`. So there are 8 opcodes in total.
  
So there are 86 opcodes in this section.

#### Stack Operand Management

The opcodes used for operand stack management include:

- discard top stack operand(s): __pop__, __pop2__

- duplicate top stack operand(s): __dup__, __dup_x1__, __dup_x2__, __dup2__, __dup2_x1__, __dup2_x2__

  where __dup__ means make 1 to 1,1; __dup_x1__ makes 2,1 to 1,2,1; __dup_x2__ makes 3,2,1 to 
  1,3,2,1; __dup2__ makes 2,1 to 2,1,2,1; __dup2_x1__ makes 3,2,1 to 2,1,3,2,1; __dup2_x2__ makes 
  4,3,2,1 to 2,1,4,3,2,1.

- exchange the top2 stack operands: __swap__

So there are 9 opcodes in this section.

#### Arithmetic and Logic

Arithmetic operations include addition, subtraction, multiplication, division, negation, and 
bit-shifting:

- addition: `t`__add__

  `t` takes value from `i`, `l`, `f`, `d`.

- subtraction: `t`__sub__

  `t` takes value from `i`, `l`, `f`, `d`.

- multiplication: `t`__mul__

  `t` takes value from `i`, `l`, `f`, `d`.

- division: `t`__div__

  `t` takes value from `i`, `l`, `f`, `d`.

- remainder from division: `t`__rem__

  `t` takes value from `i`, `l`, `f`, `d`.

- negation: `t`__neg__

  `t` takes value from `i`, `l`, `f`, `d`.

- shifting: __ishl__, __lshl__, __ishr__, __lshr__, __iushr__, __iushr__

Besides all those arithmetic operations on stack operands, there is one for increment local 
variable: __iinc__. It increments a local variable at some index by a signed byte constant.

Logic operations include logical and, logical or, and logical xor:

- and: `t`__and__

  `t` is `i` or `l`.

- or: `t`__or__

  `t` is `i` or `l`.

- xor: `t`__xor__

  `t` is `i` or `l`.

There are also some comparison operations: __lcmp__, __fcmpl__, __fcmpg__, __dcmpl__, __dcmpg__. 
__lcmp__ compares two long operands, results in 0 if equivalent, 1 if first operand is larger, -1 if 
first operand is smaller. `f` denotes float, and `d` denotes double. In the JVM, the comparision of 
floating-point number always fails if one of the number being compared is `NaN`. __fcmpg__ results 
in 1 when one of the operands is `NaN`. __fcmpl__ results in -1 when one of the operands is `NaN`. 
Similar do __dcmpl__ and __dcmpg__.

So there are 42 opcodes in this section.

#### Type Conversion

Type conversion operations are for converting primitive values from one type to another.

- conversion between `i`, `l`, `f`, `d`: `t`__2__`t'`

  `t` is one of `i`, `l`, `f`, `d`, and `t'` is one of the remainings.

- conversion from `i` to `b`, `s`, and `c`: __i2__`t`

  `t` is one of `b`, `s`, `c`.

Yes, there is no boolean, `z`, in the JVM. `z`s are stored as `i`s in the JVM, occupying 4 bytes 
instead of 1 bit in the memory.

So there are 15 opcodes in this section.

#### Object Creation and Manipulation

For non-array objects:

- creation: __new__

  __new__ only creates a reference of a type. In order to initialize the object, it is required to 
  call `<init>` on that object reference. __new__/__dup__/__invokespecial__/__astore__ is a common 
  pattern to new an object and store it into a local variable.

- manipulation: __getstatic__, __putstaic__, __getfield__, __putfield__

- type: __checkcast__, __instanceof__

For arrays:

- creation: __newarray__, __anewarray__, __multianewarray__

- manipulation: __arraylength__

So there are 11 opcodes in this section.

#### Control Transfer

The JVM uses `goto`s to implement control flows:

- __goto__, __goto_w__

  go to instruction at some branchoffset.

- __jsr__/__ret__, __jsr_w__

  the pair of opcodes are used to implement `finally` clause in Java prior to Java6, deprecated 
  until then.

- switches: __tableswitch__, __lookupswitch__

- comparing with `0`: __ifeq__, __ifne__, __iflt__, __ifge__, __ifgt__, __ifle__

- comparing 2 `int`s: __if_icmp__`t`

  `t` takes one of `eq`, `ne`, `lt`, `ge`, `gt`, `le`

- comparing with `null`: __ifnull__, __ifnonnull__

- comparing 2 `reference`s: __if_acmpeq__, __if_acmpne__

So there are 23 opcodes in this section.

#### Method Invocation and Return

Method invocation includes:

- __invokevirtual__

  Methods in Java is by default `virtual`, unless noted as `final`, which means that each Java class 
  is associated with a `virtual method table` that contains links to the bytecode of each method of 
  a class. The table is inherited from the superclass of a particular class and extended with regard 
  to the new methods of the subclass.
  
  __invokevirtual__ enables the dynamic binding in JVM. It also ensures that the method being 
  called is on the class instance without using interface, and the method access is not `private`.
  
  Since the method in the vtable is known at compile time, the JVM can be optimized to remember each 
  method's position in the table, so as to call methods efficiently.

- __invokespecial__

  __invokespecial__ is for invoking instance initialization methods, `private` methods, and methods 
  of a specific superlcass of the current class. That means there is no dynamic binding, 
  __invokespecial__ always invoke the particular class'version of a method.
  
  In Java 8, __invokespecial__ is also used to call default methods via `super`.

- __invokestatic__

  __invokestatic__ is used to call the class methods, those methods declared with the `static` 
  keyword. There is no need to load the target object reference to the operand stack. The method is 
  identified by a reference in the constant pool. Only the parameters are passed in, so the first 
  local variable of the method being called is not `this`.

- __invokeinterface__

  The differences between __invokeinterface__ and __invokevirtual__ contains:
  
  - __invokeinterface__ does not check the accessibility of the method, all methods in interface is 
  declared `public` as until Java 8. For more information, check [this SO question](http://stackoverflow.com/questions/27368432/why-does-java-8-not-allow-non-public-default-methods){:target='_blank'}.
  - __invokeinterface__ has a different method lookup process. The method table of an interface 
  can have different offsets. So __invokeinterface__ has no chance for the style of optimization 
  that __invokevirtual__ does. For more information, check 
  [Efficient Implementation of Java Interfaces: Invokeinterface Considered Harmless](http://www.research.ibm.com/people/d/dgrove/papers/oopsla01.pdf){:target='_blank'}.

- __invokedynamic__

  It is introduced with Java 7, originally targeting to support dynamic languages running on the 
  JVM. In Java 8, __invokedynamic__ is used under the hood to implement lambda expressions and 
  default methods, as well as the primary dispatch mechanism.
  
  __invokedynamic__ allows user code to decide which method to call at runtime, instead of some 
  constant pointing to the Constant Pool. `java.lang.invoke.MethodHandle` represents the methods 
  that __invokedynamic__ can target, it receives some special treatment from the JVM, in order to 
  operate correctly. Method handles are invoked by using polymorphic signature. A polymorphic 
  signature is created by the Java compiler dependant on the types of the actual arguments and the 
  expected return type at a call site. When __invokedynamic__ is first encountered, it does not 
  have a known target. A method handle (bootstrap method) is invoked, which returns a `CallSite` 
  containing another method handle, that is the actual target of the __invokedynamic__ call.
  
  Currently the lambda expression in Java is implemented as follows: the lambda's body is copied into 
  a private method inside of the class in which the expression is defined. Given that the lambda 
  expression makes no use of non-static fields or methods of the enclosing class, the method is also 
  defined to be static. (final fields are directly copied.) The lambda expression itself is substituted 
  by an __invokedynamic__ call site. For bootstrapping a call site, __invokedynamic__ instruction 
  currently delegates to the `LambdaMetafactory` class which is responsible for creating a class that 
  implements the functional interface and which invokes the appropriate method that contains the 
  lambda's body stored in the original class. The method contains the lambda's body is private. So 
  the generated class is loaded using anonymous class loading, so as to receive the host class's full 
  security context.

Return includes: __ireturn__, __lreturn__, __freturn__, __dreturn__, __areturn__, __return__. The 
__return__ is for returning `void` from a method invocation.

So there are 11 opcodes in this section.

#### Others

Opcodes for other specific tasks includes:

- __nop__

  perform no operation

- monitor: __monitorenter__/__monitorexit__
- __athrow__

  throws an error or exception, the rest of the stack is cleared, leaving only a reference to the 
  `Throwable`.

- __wide__

  execute opcode, where opcode is `t`__load__, `t`__store__, or ret, but assume the index is 16 bit; 
  or execute __iinc__, where the index is 16 bits and the constant to increment by is a signed 16 
  bit short.

- reserved for debuggers: __breakpoint__, __impdep1__, __impdep2__

So there are 8 opcodes in this section.

### Class File

A compiled class file consists of the following structure:

{% highlight c %}
ClassFile {
    u4			      magic;
    u2			      minor_version;
    u2			      major_version;
    u2			      constant_pool_count; // constant pool for the class
    cp_info		    contant_pool[constant_pool_count – 1]; // numeric literals, string literals, class references, field references, and method references are all here
    u2			      access_flags; // modifiers for the class
    u2			      this_class; // index into constant pool pointing to the fully qualified name of this class
    u2			      super_class;  // index into constant pool pointing to a symbolic reference to the super class
    u2			      interfaces_count;
    u2			      interfaces[interfaces_count]; // indices into the constant pool pointing to symbolic references to interfaces implemented
    u2			      fields_count;
    field_info		fields[fields_count]; // indices into the constant pool pointing to fields
    u2			      methods_count;
    method_info		methods[methods_count]; // indices into the constant pool pointing to methods, bytecode is present for method not being abstract nor native
    u2			      attributes_count;
    attribute_info	attributes[attributes_count]; // additional information
}
{% endhighlight %}

To decompile the classfile, use 

{% highlight shell %}
javap -c -v -p -s -sysinfo -constants xxx
{% endhighlight %}

To view the assembler code, use 

{% highlight shell %}
javaw -XX:+UnlockDiagnosticVMOptions -XX:+PrintAssembly xxx
{% endhighlight %}

#### Loading, Linking and Initialization

The JVM starts up by loading an initial class using the bootstrap classloader. The class is then linked 
and initialized before `main` is invoked. The execution of this method will in turn drive futher 
loading, linking and initialization as required.

- __Loading__

  Load the byte array of the class definition. Any class or interface named as a direct superclass is 
  also loaded.

- __Linking__, it contains three steps verifying, preparing, and optionally resolving.

  - __verifying__, it confirms the representation is structurally correct and obeys the semantic 
  requirements.
  - __preparing__, it allocates the memory for static storage and any data structures used by the 
  JVM such as method tables. Static fields are created and initialized to their default values, no 
  initializers or code is executed at this stage as that happens as part of initialization.
  - __resolving__, it checks symbolic references by loading the referenced classes or interfaces 
  and checks the references are correct. If this does not take place at this point the resolution 
  of symbolic references can be deferred until just prior to their use by a bytecode instruction.

- __Initialization__, it executes the initialization method `<clinit>`.

### References

[link1](http://mydailyjava.blogspot.com/2015/03/dismantling-invokedynamic.html){:target='_blank'}, 
[link2](https://www.beyondjava.net/blog/java-programmers-guide-java-byte-code/){:target='_blank'}, 
and [link3](http://blog.jamesdbloom.com/JVMInternals.html){:target='_blank'}.

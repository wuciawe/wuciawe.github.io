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
- __invokespecial__
- __invokestatic__
- __invokeinterface__
- __invokedynamic__

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

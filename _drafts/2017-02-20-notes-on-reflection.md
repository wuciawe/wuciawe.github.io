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


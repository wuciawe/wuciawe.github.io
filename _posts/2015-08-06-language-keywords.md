---
layout: post
category: [C++, java, scala]
tags: [c++, java, scala, keywords]
infotext: "An incomplete list of keywords of c++, java and scala."
---
{% include JB/setup %}

-   `abstract`
    -   **c++** 
    -   **java** Used in a class declaration to specify that the class contains `abstract` methods. Used in a class method 
     declaration to specify that the class method is a `abstract` method that has no concrete implementation. An abstract 
     class can not be instantiated.
    -   **scala** Makes a declaration abstract. Unlike Java, the keyword is usually not required for abstract members.
-   `auto`
    -   **c++** specifies that the type of the variable that is being declared will be automatically deduced from its initializer. 
    For functions, specifies that the return type is a trailing return type or will be deduced from its return statements.
    -   **java**
    -   **scala**
-   `const`
    -   **c++** The `const` keyword can be used to tell the compiler that a certain variable should not be modified once it 
    has been initialized.
    -   **java** Reserved, but no use nor function
    -   **scala**
{% highlight cpp %}
// const keyword use case in cpp

const int Constant1 = 96; // an integer constant
    
const int * Constant2 // Constant2 is a variable pointer to a constant integer
int const * Constant2 // same as above
    
int * const Constant3 // Constant3 is constant pointer to a variable integer
    
int const * const Constant4 // Constant4 is constant pointer to a constant integer
    
// Basically ‘const’ applies to whatever is on its immediate left 
// (other than if there is nothing there in which case it applies 
// to whatever is its immediate right).

const char *Function1() { return "Some text"; } // the return value of Function1 is unalterable

void Subroutine4(big_structure_type const &Parameter1); // the variable is passed without copying and is unalterable

class Class2
{
  void Method1() const; // Method1 cannot alter any member variables in the object
  int MemberVariable1;
}

const int*const Method3(const int*const&)const;
// a const member function named Method3 that 
// takes a reference to a const pointer to an int const (or a const int) and 
// returns a const pointer to an int const (const int)
{% endhighlight %}
-   `constexpr`
    -   **c++** specifies that the value of a variable or function can appear in constant expressions
    -   **java**
    -   **scala**
-   `decltype`
    -   **c++** inspects the declared type of an entity or queries the return type of an expression.
    -   **java**
    -   **scala**
-   `explicit`
    -   **c++** specifies constructors and conversion operators that don't allow implicit conversions or copy-initialization.
    -   **java**
    -   **scala**
{% highlight cpp %}
explicit class_name ( params ) // specifies that this constructor is only considered for direct initialization (including explicit conversions)
explicit operator type ( ) // specifies that this user-defined conversion function is only considered for direct initialization (including explicit conversions)
{% endhighlight %}
-   `extends`
    -   **c++** 
    -   **java** Used in a class declaration to specify the superclass; used in an interface declaration to specify one or 
    more superinterfaces. Also used to specify an upper bound on a type parameter in Generics.
    -   **scala** it indicates  inheritance. that class or trait is declared as child of the parent type of the class or trait.
-   `extern`
    -   **c++** static or thread storage duration and external linkage; provides for linkage between modules written in different 
    programming languages; explicit instantiation declaration
    -   **java**
    -   **scala**
{% highlight cpp %}
// share a variable between a few modules.
// define it in one module, 
// and use extern in the others.

// file1.cpp:
int global_int = 1;

// file2.cpp:
extern int global_int;
cout << "global_int = " << global_int;
{% endhighlight %}
-   `final`
    -   **c++** 
    -   **java** An entity once defined cannot be changed nor derived from later. A final class cannot be extended, a final 
    method cannnot be overridden, a final variable can occur at most once as a left-hand expression. All methods in a final 
    class are implicitly `final`.
    -   **scala** It addes "prohibit" attribute  .For class it means   prohibit inheritance and for method  prohibit   overriding.
-   `implements`
    -   **c++**
    -   **java** In a class declaration to specify one or more interfaces that are implemented by the current class. A 
    class inherits the types and abstract methods declared by the interfaces.
    -   **scala**
-   `implicit`
    -   **c++**
    -   **java**
    -   **scala** Marks a method as eligible to be used as an implicit type converter. Marks a method parameter as optional, 
    as long as a type-compatible substitute object is in the scope where the method is called. 
-   `implicitly`
    -   **c++**
    -   **java**
    -   **scala** Marks a method as eligible to be used as an implicit type converter. Marks a method parameter as optional, 
    as long as a type-compatible substitute object is in the scope where the method is called. 
-   `inline`
    -   **c++** declares `inline` function; `inline namespace`
    -   **java**
    -   **scala**
-   `interface`
    -   **c++** 
    -   **java** Used to declare a special type of class that only contains `abstract` methods, `constant` (`static` `final`) fields 
    and `static` `interface`s. It can later be implemented by classes that declare the interface with the `implements` keyword.
    -   **scala**
-   `lazy`
    -   **c++**
    -   **java**
    -   **scala** According to O'reilly book( as I do not come across yet) :   Defer evaluation of a val.
-   `mutable`
    -   **c++** applies to non-static class members of non-reference non-const type and specifies that the member does not affect 
    the externally visible state of the class (as often used for mutexes, memo caches, lazy evaluation, and access instrumentation). 
    mutable members of const classes are modifiable; allows lambda function body to modify the parameters captured by copy, and to 
    call their non-const member functions
    -   **java**
    -   **scala**
-   `namespace`
    -   **c++** provides a method for preventing name conflicts; namespace aliases; using namespace
    -   **java**
    -   **scala**
-   `object`
    -   **c++**
    -   **java**
    -   **scala** it starts signleton version of class
-   `override`
    -   **c++**
    -   **java**
    -   **scala** it indicates change of original member of class for non final members
-   `package`
    -   **c++** 
    -   **java** A group of types.
    -   **scala** it starts declaration of package (scope)
-   `sealed`
    -   **c++** 
    -   **java**
    -   **scala** Applied to a parent class to require all directly derived classes to be declared in the same source file.
-   `sizeof`
    -   **c++** returns size in bytes of the object representation of type or the return value of an expression; sizeof...( parameter_pack ) 
    returns the number of elements in a parameter pack
    -   **java**
    -   **scala**
-   `static`
    -   **c++** static or thread storage duration and internal linkage; declares members not bound to specific instances in class
    -   **java** Used to declare a field, method, or inner class as a class field. Classes maintain one copy of class 
    fields regardless of how many instances exist of that class. `static` also is used to define a method as a class method. 
    Class methods are bound to the class instead of to a specific instance, and can only operate on class fields. (Classes 
    and interfaces declared as static members of another class or interface are actually top-level classes and are not inner classes.)
    -   **scala**
-   `super`
    -   **c++** 
    -   **java** Used to access members of a class inherited by the class in which it appears. Allows a subclass to access 
    overridden methods and hidden members of its superclass. The `super` keyword is also used to forward a call from a 
    constructor to a constructor in the superclass. Also used to specify a lower bound on a type parameter in Generics.
    -   **scala** An object refers to parent of itself.
-   `synchronized`
    -   **c++** 
    -   **java** Used in the declaration of a method or code block to acquire `the mutex lock` for an object while the current 
    thread executes the code. For `static` methods, the object locked is the class's Class. Guarantees that at most one thread 
    at a time operating on the same object executes that code. The mutex lock is automatically released when execution exits 
    the synchronized code. Fields, classes and interfaces cannot be declared as synchronized.
    -   **scala**
-   `template`
    -   **c++** templates are parametrized by one or more template parameters, of three kinds: type template parameters, 
    non-type template parameters, and template template parameters.
    -   **java**
    -   **scala**
-   `this`
    -   **c++** The keyword `this` is a prvalue expression whose value is the address of the object, on which the member function 
    is being called. It can appear in the following contexts: 1) within the body of any non-static member function, including member 
    initializer list 2) within the declaration of a non-static member function anywhere after the (optional) cv-qualifier sequence, 
    including dynamic exception specification(deprecated), noexcept specification, and the trailing return type 3) within brace-or-equal 
    initializer of a non-static data member
    -   **java** Used to represent an instance of the class in which it appears. `this` can be used to access class members 
    and as a reference to the current instance. The `this` keyword is also used to forward a call from one constructor in a 
    class to another constructor in the same class.
    -   **scala** An object refers to itself.
-   `trait`
    -   **c++**
    -   **java**
    -   **scala** A mixin module that adds additional state and behavior to an instance of a class.
-   `transient`
    -   **c++** 
    -   **java** Declares that an instance field is not part of the default serialized form of an object. When an object 
    is serialized, only the values of its non-transient instance fields are included in the default serial representation. 
    When an object is deserialized, `transient` fields are initialized only to their default value. If the default form is 
    not used, e.g. when a serialPersistentFields table is declared in the class hierarchy, all transient keywords are ignored.
    -   **scala**
-   `type`
    -   **c++**
    -   **java**
    -   **scala** It starts a type declaration.
-   `typedef`
    -   **c++** provides a way to create an alias that can be used anywhere in place of a (possibly complex) type name
    -   **java**
    -   **scala**
-   `typeid`
    -   **c++** queries information of a type, used where the dynamic type of a polymorphic object must be known and for static 
    type identification.
    -   **java**
    -   **scala**
-   `typename`
    -   **c++** in a template declaration, `typename` can be used as an alternative to class to declare type template parameters 
    and template template parameters; inside a declaration or a definition of a `template`, typename can be used to declare that 
    a dependent name is a type.
    -   **java**
    -   **scala**
-   `union`
    -   **c++** A union is a special class type that can hold only one of its non-static data members at a time; If a function or 
    a variable exists in scope with the name identical to the name of a union type, union can be prepended to the name for disambiguation, 
    resulting in an elaborated type specifier
    -   **java**
    -   **scala**
-   `using`
    -   **c++** using-directives for namespaces and using-declarations for namespace members;  using-declarations for class members; 
    type alias and alias template declaration
    -   **java**
    -   **scala**
-   `virtual`
    -   **c++** specifies that a non-static member function is virtual and supports dynamic binding; virtual base class, for each 
    distinct base class that is specified `virtual`, the most derived object contains only one base class subobject of that type, 
    even if the class appears many times in the inheritance hierarchy
    -   **java**
    -   **scala**
-   `volatile`
    -   **c++** an object whose type is volatile-qualified, or a subobject of a volatile object, or a mutable subobject of a const-volatile 
    object. Every access (read or write operation, member function call, etc.) on the volatile object is treated as a visible side-effect 
    for the purposes of optimization (that is, within a single thread of execution, volatile accesses cannot be reordered or optimized out. 
    This makes volatile objects suitable for communication with a signal handler, but not with another thread of execution, see std::memory_order). 
    Any attempt to refer to a volatile object through a non-volatile glvalue (e.g. through a reference or pointer to non-volatile type) results in 
    undefined behavior.
    -   **java** Used in field declarations to specify that the variable is modified asynchronously by concurrently running 
    threads. Methods, classes and interfaces thus cannot be declared volatile, nor can local variables or parameters.
    -   **scala**
-   `with`
    -   **c++**
    -   **java**
    -   **scala** keyword is similar to Java’s implements keyword for interfaces. In Scala it includes the trait in class or object.
-   `yield`
    -   **c++**
    -   **java**
    -   **scala** is a result ( as collection ) from for loop
-   `<:`
    -   **c++**
    -   **java**
    -   **scala** It is used in abstract and  parametrized  type declarations
-   `>:`
    -   **c++**
    -   **java**
    -   **scala** It is used in abstract and  parametrized  type declarations
-   `<%`
    -   **c++**
    -   **java**
    -   **scala** It is used in abstract and   parametrized  type “view bounds” declarations.
-   `#`
    -   **c++**
    -   **java**
    -   **scala** it used in type projections

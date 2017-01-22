---
layout: post
category: [java, scala]
tags: [java, scala]
infotext: "It has been a while not updating notes. It feels good to get rid of that shit project. This note is about two exceptions that are mingled by many people: ClassNotFoundException and NoClassDefFoundError."
---
{% include JB/setup %}

Days before, after the maintainment of the cluster, I met the NoClassDefFoundError when I tried to 
resubmit the application to the yarn. At first, I thought that was caused by messing the classpath 
up, or distribution of the application. After several try of re-compiling and re-distributing, I 
found that the real cause is the failure of initialising an `object`.

Later, I searched the NoClassDefFoundError, and the ClassNotFoundException came to me. These two 
exceptions are very frustrating.

### ClassNotFoundException

ClassNotFoundException comes when you try to load a class at runtime by using `Class.forName()`,  
`Classloader.loadClass()` or `Classloader.findSystemClass()` explicitly and the requested class is 
not present in classpath.

ClassNotFoundException is a checked Exception derived directly from `java.lang.Exception class`.

### NoClassDefFoundError

NoClassDefFoundError is a result of implicit loading of class because of a method call from that 
class or any variable access.

In case of NoClassDefFoundError, requested class was present at compile time but not available at 
runtime. Sometimes due to an exception during class initialization, e.g. exception from static block 
causes NoClassDefFoundError when a failed-to-load class was later referenced by the runtime.

NoClassDefFoundError is an Error derived from `LinkageError`.

NoClassDefFoundError can also be caused due to multiple classloaders in J2EE environments. 
ClassLoader works on three principle delegation, visibility, and uniqueness. Delegation means 
every request to load a class is delegated to parent classloader, visibility means an ability 
to found classes loaded by the classloader, all child classloader can see classes loaded by 
parent classloader, but parent classloader can not see the class loaded by child classloaders. 
Uniqueness enforce that class loaded by the parent will never be reloaded by child classloaders. 
Now suppose if a class say User is present in both WAR file and EJB-JAR file and loaded by WAR 
classloader which is child classloader which loads the class from EJB-JAR. When a code in EJB-JAR 
refers to this User class, Classloader which loaded all EJB class doesn’t found that because it 
was loaded by WAR classloader which is a child of it.

This will result in java.lang.NoClassDefFoundError for User class. Also, If the class is present 
in both JAR file and you will call equals method to compare those two object, it will result in 
ClassCastException as object loaded by two different classloaders can not be equal.

### References

[link1](http://javarevisited.blogspot.in/2011/06/noclassdeffounderror-exception-in.html){:target='_blank'}, 
[link2](http://javarevisited.blogspot.com/2011/07/classnotfoundexception-vs.html), and 
[link3](http://javarevisited.blogspot.com/2011/08/classnotfoundexception-in-java-example.html).
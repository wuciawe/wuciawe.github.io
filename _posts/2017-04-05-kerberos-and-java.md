Kerberos V5 is a trusted third party network authentication protocol designed to provide 
strong authentication using secret key cryptography. When using Kerberos V5, the user's 
password is never sent across the network, not even in encrypted form, except during 
Kerberos V5 administration. Kerberos was developed in the mid-1980's as part of MIT's 
Project Athena.

JAVA AUTHENTICATION AND AUTHORIZATION SERVICE (JAAS)

JAAS is a pluggable framework and programming interface specifically targeted for 
authentication and access control based on the authenticated identities.

The JAAS framework can be divided into two components: an authentication component and an 
authorization component.

The JAAS authentication component provides the ability to reliably and securely determine who 
is currently executing Java code, regardless of whether the code is running as an application, 
an applet, a bean, or a servlet.

The JAAS authorization component supplements the existing Java security framework by providing 
the means to restrict the executing Java code from performing sensitive tasks, depending on its 
codesource and depending on who is executing the code.

Pluggable and Stackable Framework

JAAS authentication framework is based on Pluggable Authentication Module (PAM).
JAAS authentication is performed in a pluggable fashion allowing system administrators to add 
appropriate authentication modules. This permits Java applications to remain independent of 
underlying authentication technologies, and new or updated authentication technologies can be 
seamlessly configured without requiring modifications to the application itself.

JAAS authentication framework also supports the stacking of authentication modules. Multiple modules 
can be specified and they are invoked by the JAAS framework in the order they were specified. The 
success of the overall authentication depends on the results of the individual authentication modules.

Subject

JAAS uses the term Subject to refer to any entity that is the source of a request to access resources. 
A Subject may be a user or a service. Since an entity may have many names or principals JAAS uses 
Subject as an extra layer of abstraction that handles multiple names per entity.Thus a Subject is 
comprised of a set of principals. There are no restrictions on principal names.

A Subject is only populated with authenticated principals. Authentication typically involves the 
user providing proof of identity, such as a password.

A Subject may also have security related attributes, which are referred to as credentials. The 
credentials can be public or private. Sensitive credentials such as private cryptographic keys 
are stored in the private credentials set of the Subject.

The Subject class has methods to retrieve the principals, public credentials and private 
credentials associated with it.

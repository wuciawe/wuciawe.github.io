---
layout: post
category:
tags: [java, kerberos]
infotext: 'The process of kerberos authentication, notes on jaas and jgss.'
---
{% include JB/setup %}

### Kerberos protocol

Kerberos V5 is a trusted third party network authentication protocol designed to provide 
strong authentication using secret key cryptography. It aims at client/server model, and 
provides mutual anthentication. When using Kerberos V5, the user's password is never sent 
across the network, not even in encrypted form, except during Kerberos V5 administration. 
Kerberos was developed in the mid-1980's as part of MIT's Project Athena.

The system contains three parts:

- Client - __Client ID__
- Server - __Server ID__
- Key Distribution Center - __KDC__
  - Authentication Server - __AS__
  - Ticket Granting Server - __TGS__

Users and services in a Kerberos realm are known as "principals", each has its own secret 
encryption key stored on the KDC centrally, which makes it easy for administrators to manage 
keys. The Kerberos protocol enhances security by ensuring no clear text keys are transmitted. 
The user asks the Kerberos for a temporary key, called __TGT__, which proves user's identity. 
And the user will eventually use this __TGT__ to receive all of the services it wants to access, 
a.k.a. enabling single sign on.

Following is the whole process of the authentication, it contains 6 steps:

1. __Client__ `->` Clear Text, User xxx wants Service `->` __AS__

   __AS__ checks if User xxx is in database.

2. __Client__ `<-` message __A__ { Client/TGS session key }(Client secret key), 
message __B__ { Ticket Granting Ticket - __TGT__: Client ID; Client network address; 
ticket validity period; Client/TGS session key }(TGS secret key) `<-` __AS__

   __Client__ decrypts message __A__ obtaining Client/TGS session key.

3. __Client__ `->` message __C__ { message __B__ + Server ID }, message __D__ { Authenticator: 
Client ID; timestamp }(Client/TGS session key) `->` __TGS__

   __AS__ decrypts message __C__ and message __D__, checks the Client ID from message __C__ with 
   the Client ID from message __D__ and ticket validity period from message __C__ with timestamp 
   from message __D__.

4. __Client__ `<-` message __E__ { Client/Server ticket: Client ID; network address; validity period; 
Client/Server session key }(Server secret key), 
message __F__ { Client/Server session key }(Client/TGS session key) `<-` __TGS__

   __Client__ decrypts message __F__, obtaining Client/Server session key.

5. __Client__ `->` message __G__ { message __E__ }, message __H__ { Authenticator: Client ID; 
timestamp }(Client/Server session key) `->` __Server__

   __Server__ decrypts message __G__ and message __H__, checks the Client ID from message __G__ with 
   the Client ID from message __H__ and ticket validity period from message __G__ with timestamp 
   from message __H__.

6. __Client__ `<-` message __I__ { timestamp from message __H__ + 1 }(Client/Server session key) 
`<-` __Server__

   __Client__ decrypts message __I__, checks timestamp = timestamp + 1.

`Notation:` message __X__ { content __C__ }(key __k__) means that the message __X__'s content __C__ 
is encrypted by key __k__.

### Java Authentication and Authorization Service - JAAS

JAAS is a pluggable framework and programming interface specifically targeted for 
authentication and access control based on the authenticated identities.

The JAAS framework can be divided into two components: an authentication component and an 
authorization component.

- The JAAS authentication component provides the ability to reliably and securely determine who 
is currently executing Java code, regardless of whether the code is running as an application, 
an applet, a bean, or a servlet.

- The JAAS authorization component supplements the existing Java security framework by providing 
the means to restrict the executing Java code from performing sensitive tasks, depending on its 
codesource and depending on who is executing the code.

The design of JAAS borrows many concepts from other systems: 

- stackable feature: the Unix Pluggable Authentication Module (PAM) framework
- transactional: two-phase commit (2PC) protocals
- security configuration concepts, including Policy files and Permissions: the J2SE 1.2 security packages
- Subject: X.509 certificates.

#### Pluggable and Stackable Framework

JAAS authentication framework is based on Pluggable Authentication Module (PAM) and is performed 
in a pluggable fashion allowing system administrators to add appropriate authentication modules. 
This permits Java applications to remain independent of underlying authentication technologies, 
and new or updated authentication technologies can be seamlessly configured without requiring 
modifications to the application itself.

JAAS authentication framework also supports the stacking of authentication modules. Multiple modules 
can be specified and they are invoked by the JAAS framework in the order they were specified. The 
success of the overall authentication depends on the results of the individual authentication modules.

#### Subject

JAAS uses the term Subject to refer to any entity that is the source of a request to access resources.

A Subject may be a user or a service. Since an entity may have many names or principals, JAAS uses 
Subject as an extra layer of abstraction that handles multiple names per entity. Thus a Subject is 
comprised of a set of principals. There are no restrictions on principal names.

A Subject is only populated with authenticated principals. Authentication typically involves the 
user providing proof of identity, such as a password.

A Subject may also have security related attributes, which are referred to as credentials. The 
credentials can be public or private. Sensitive credentials such as private cryptographic keys 
are stored in the private credentials set of the Subject.

The `Subject` class has methods to retrieve the principals, public credentials and private 
credentials associated with it.

JAAS provides two methods `doAs` and `doAsPrivileged` that can be used to associate an 
authenticated Subject with the AccessControlContext dynamically.

The `LoginContext` class provides the basic methods used to authenticate Subjects. It also allows 
an application to be independent of the underlying authentication technologies.

Upon successful authentication the Ticket Granting Ticket (TGT) is stored in the Subject's private 
credentials set and the Kerberos principal is stored in the Subject's principal set.

Based on certain configurable options, Krb5LoginModule can also use an existing credentials cache, 
such as a native cache in the operating system, to acquire the TGT and/or use a keytab file 
containing the secret key to implicitly authenticate a principal.

### Java Generic Security Service Application Program Interface - Java GSS-API

The API, described in a language independent form in `RFC 2743`, accommodates the following 
security services: authentication, message confidentiality and integrity, sequencing of protected 
messages, replay detection, and credential delegation.

The API is designed such that an implementation may support multiple mechanisms simultaneously, 
giving the application the ability to choose one at runtime. Mechanisms are identified by means 
of unique object identifier's (OID's) that are registered with the IANA. For instance, the 
Kerberos V5 mechanism is identified by the OID {iso(1) member-body(2) United States(840) 
mit(113554) infosys(1) gssapi(2) krb5(2)}.

Another important feature of the API is that it is token based. i.e., Calls to the API generate 
opaque octets that the application must transport to its peer. This enables the API to be 
transport independent.

In the case of the Kerberos V5 mechanism, there is no more than one round trip of tokens during 
context establishment. The client first sends a token generated by its `initSecContext()` 
containing the Kerberos AP-REQ message. In order to generate the AP-REQ message, the Kerberos 
provider obtains a service ticket for the target server using the client's TGT. The service ticket 
is encrypted with the server's long-term secret key and is encapsulated as part of the AP-REQ 
message. After the server receives this token, it is passed to the `acceptSecContext()` method 
which decrypts the service ticket and authenticates the client. If mutual authentication was not 
requested, both the client and server side contexts would be established, and the server side 
`acceptSecContext()` would generate no output.

However, if mutual authentication were enabled, then the server's `acceptSecContext()` would 
generate an output token containing the Kerberos AP-REP message. This token would need to be 
sent back to the client for processing by its `initSecContext()`, before the client side context 
is established.

#### Message Protection

Once the security context is established, it can be used for message protection. Java GSS-API 
provides both message integrity and message confidentiality.

The wrap method is used to encapsulate a cleartext message in a token such that it is integrity 
protected. Optionally, the message can also be encrypted by requesting this through a properties 
object. The wrap method returns an opaque token that the caller sends to its peer. The original 
cleartext is returned by the peer's unwrap method when the token is passed to it. The properties 
object on the unwrap side returns information about whether the message was simply integrity 
protected or whether it was encrypted as well. It also contains sequencing and duplicate token 
warnings.

The mechanisms do not themselves perform a user login. Instead, the login is performed prior to 
using Java GSS-API and the credentials are assumed to be stored in some cache that the mechanism 
provider is aware of. The `GSSManager.createCredential()` method merely obtains references to 
those credentials and returns them in a GSS-centric container, the `GSSCredential`.

This model has the advantage that credential management is simple and predictable from the 
application's point of view. An application, given the right permissions, can purge the 
credentials in the `Subject` or renew them using standard Java API's. If it purged the 
credentials, it would be sure that the Java GSS-API mechanism would fail, or if it renewed a time 
based credential it would be sure that the mechanism would succeed.

#### Default Credential Acquisition Model

Following is the sequence of events relevant to credential acquisition when the Kerberos V5 
mechanism is used by the client application:

1. The application invokes a JAAS login, which in turn invokes the configured `Krb5LoginModule`.

2. `Krb5LoginModule` obtains a __TGT__ (`KerberosTicket`) for the user either from the KDC or from 
an existing ticket cache, and stores this `TGT` in the private credentials set of a Subject

3. The application retrieves the populated `Subject`, then calls `Subject.doAs/doAsPrivileged` 
which places this `Subject` on the access control context of the thread executing __ClientAction__.

4. __ClientAction__ calls `the GSSManager.createCredential` method, passing it the Kerberos V5 OID 
in desiredMechs.

5. `GSSManager.createCredential` invokes the Kerberos V5 GSS-API provider, asking for a Kerberos 
credential for initiating security contexts.

6. The Kerberos provider obtains the `Subject` from the current access control context, and searches 
through its private credential set for a valid `KerberosTicket` that represents the __TGT__ for 
the user.

7. The `KerberosTicket` is returned to the `GSSManager` which stores it in a `GSSCredential` 
container instance to be returned to the caller.

On the server side, when the Kerberos login is successful in step 2, Krb5LoginModule stores the 
`KerberosKey` for the server in the `Subject` in addition to the `KerberosTicket`. Later on the 
`KerberosKey` is retrieved in steps 5 through 7 and used to decrypt the service ticket that the 
client sends.

### References

[Single Sign-on Using Kerberos in Java](https://docs.oracle.com/javase/8/docs/technotes/guides/security/jgss/single-signon.html){:target='_blank'}

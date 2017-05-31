- Client Client ID
- Server Server ID
- Key Distribution Center KDC
  - Authentication Server AS
  - Ticket Granting Server TGS

1 Client -> Clear Text, User xxx wants Service -> AS

AS checks if User xxx is in database.

2 Client <- A: Client/TGS session key (Client secret key) B: Ticket Granting Ticket (TGT) - Client ID,
Client network address - ticket validity period, Client/TGS session key (TGS secret key) <- AS

Client decrypts A obtaining Client/TGS session key.

3 Client -> C: B + Server ID D: Authenticator - Client ID, timestamp (Client/TGS session key) -> TGS

AS decrypts C and D, checks Client ID from C with Client ID from D and ticket validity period from C and timestamp from D.

4 Client <- E: Client/Server ticket - Client ID, network address - validity period, Client/Server session key (Server secret key) 
F: Client/Server session key (Client/TGS session key) <- TGS

Client decrypts F, obtaining Client/Server session key.

5 Client -> G: E H: Authenticator - Client ID and timestamp (Client/Server session key) -> Server

Server decrypts G and H, checks Client ID from G with Client ID from H and ticket validity period from G with timestamp from H.

6 Client <- I: timestamp from H + 1 (Client/Server session key) <- Server

Client decrypts I, checks timestamp = timestamp + 1.

Easy for administrators to manage passwords by storing them centrally. Enhance security by ensuring no 
clear text passwords are transmitted. Allow users to access different services with the same password. Single sign on.

Users and services in a Kerberos realm are known as "principals", each has its own secret 
encryption key stored on the KDC.

TGT proves user's identity.
User principal will eventually use this TGT to receive all of the services it wants to access.

Kerberos V5 is a trusted third party network authentication protocol designed to provide 
strong authentication using secret key cryptography. When using Kerberos V5, the user's 
password is never sent across the network, not even in encrypted form, except during 
Kerberos V5 administration. Kerberos was developed in the mid-1980's as part of MIT's 
Project Athena.

Stackable feature; the Unix Pluggable Authentication Module (PAM) framework.
Transactional; two-phase commit (2PC) protocals
security configuration concepts, including Policy files and Permissions; the J2SE 1.2 security packages
Subject; X.509 certificates

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

JAAS provides two methods doAs and doAsPrivileged that can be used to associate an authenticated 
Subject with the AccessControlContext dynamically.

The LoginContext class provides the basic methods used to authenticate Subjects. It also allows an 
application to be independent of the underlying authentication technologies.

Upon successful authentication the Ticket Granting Ticket (TGT) is stored in the Subject's private 
credentials set and the Kerberos principal is stored in the Subject's principal set.

Based on certain configurable options, Krb5LoginModule can also use an existing credentials cache, 
such as a native cache in the operating system, to acquire the TGT and/or use a keytab file containing 
the secret key to implicitly authenticate a principal.

JAVA GENERIC SECURITY SERVICE APPLICATION PROGRAM INTERFACE (Java GSS-API)

Generic Security Service API (GSS-API)

The API, described in a language independent form in RFC 2743 [6], accommodates the following security 
services: authentication, message confidentiality and integrity, sequencing of protected messages, replay 
detection, and credential delegation.

The API is designed such that an implementation may support multiple mechanisms simultaneously, giving 
the application the ability to choose one at runtime. Mechanisms are identified by means of unique object 
identifier's (OID's) that are registered with the IANA. For instance, the Kerberos V5 mechanism is 
identified by the OID {iso(1) member-body(2) United States(840) mit(113554) infosys(1) gssapi(2) krb5(2)}.

Another important feature of the API is that it is token based. i.e., Calls to the API generate opaque 
octets that the application must transport to its peer. This enables the API to be transport independent.

In the case of the Kerberos V5 mechanism, there is no more than one round trip of tokens during context 
establishment. The client first sends a token generated by its initSecContext() containing the Kerberos AP-REQ 
message [2]. In order to generate the AP-REQ message, the Kerberos provider obtains a service ticket for the 
target server using the client's TGT. The service ticket is encrypted with the server's long-term secret key and 
is encapsulated as part of the AP-REQ message. After the server receives this token, it is passed to the 
acceptSecContext() method which decrypts the service ticket and authenticates the client. If mutual authentication 
was not requested, both the client and server side contexts would be established, and the server side 
acceptSecContext() would generate no output.

However, if mutual authentication were enabled, then the server's acceptSecContext() would generate an output 
token containing the Kerberos AP-REP [2] message. This token would need to be sent back to the client for 
processing by its initSecContext(), before the client side context is established.

Message Protection

Once the security context is established, it can be used for message protection. Java GSS-API provides both message 
integrity and message confidentiality.

The wrap method is used to encapsulate a cleartext message in a token such that it is integrity protected. Optionally, 
the message can also be encrypted by requesting this through a properties object. The wrap method returns an opaque 
token that the caller sends to its peer. The original cleartext is returned by the peer's unwrap method when the 
token is passed to it. The properties object on the unwrap side returns information about whether the message was 
simply integrity protected or whether it was encrypted as well. It also contains sequencing and duplicate token warnings.

The mechanisms do not themselves perform a user login. Instead, the login is performed prior to using Java GSS-API and 
the credentials are assumed to be stored in some cache that the mechanism provider is aware of. The 
GSSManager.createCredential() method merely obtains references to those credentials and returns them in a GSS-centric 
container, the GSSCredential.

This model has the advantage that credential management is simple and predictable from the application's point of view. 
An application, given the right permissions, can purge the credentials in the Subject or renew them using standard Java 
API's. If it purged the credentials, it would be sure that the Java GSS-API mechanism would fail, or if it renewed a time 
based credential it would be sure that the mechanism would succeed.

Here is the sequence of events relevant to credential acquisition when the Kerberos V5 mechanism is used by the client 
application in Figures 3 and 6:

The application invokes a JAAS login, which in turn invokes the configured Krb5LoginModule

Krb5LoginModule obtains a TGT (KerberosTicket) for the user either from the KDC or from an existing ticket cache, 
and stores this TGT in the private credentials set of a Subject

The application retrieves the populated Subject, then calls Subject.doAs/doAsPrivileged which places this Subject on 
the access control context of the thread executing ClientAction

ClientAction calls the GSSManager.createCredential method, passing it the Kerberos V5 OID in desiredMechs.

GSSManager.createCredential invokes the Kerberos V5 GSS-API provider, asking for a Kerberos credential for initiating 
security contexts.

The Kerberos provider obtains the Subject from the current access control context, and searches through its private 
credential set for a valid KerberosTicket that represents the TGT for the user.

The KerberosTicket is returned to the GSSManager which stores it in a GSSCredential container instance to be returned 
to the caller.

On the server side, when the Kerberos login is successful in step 2, Krb5LoginModule stores the KerberosKey for the 
server in the Subject in addition to the KerberosTicket. Later on the KerberosKey is retrieved in steps 5 through 7 
and used to decrypt the service ticket that the client sends.

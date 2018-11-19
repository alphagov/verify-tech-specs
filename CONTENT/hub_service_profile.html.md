---
title: Hub Service Profile
weight: 01
---

# Hub Service Profile

##Abstract

> This specification defines a profile for the use of SAML assertions
> and request-response messages to be used between participants in the
> Identity Assurance federation architecture.


##Introduction

The Identity Assurance Hub Service SAML v2.0 Profile describes how
service providers offering online government services can use any number
of Hub Services for the brokering of a citizen authentication and
enrichment of citizen attributes. This profile describes the
interactions between the providers, the protocol semantics and
attributes required.

The subsequent sections describe how to interpret this profile.

## Notation

The keywords "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL
NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "MAY", and
"OPTIONAL" in this specification are to be interpreted as described in
IETF RFC 2119 \[RFC 2119\].

  ```
  Schema listings appear like this.
  ```

  ```
  Example code listings appear like this.
  ```

## Important Information: using this document

This document describes the full SAML profile for the Identity Assurance
Hub Service including identity provider, and service provider
interactions with the hub service. For specific documentation regarding
your implementation please refer to the following sections of the
document.
##   If you are an Identity Provider please refer to section 5, Identity
    Provider Interface Specification.
##   If you are a Service Provider please refer to section 6, Service
    Provider Interface Specification.
##   If you are implementing a Matching Service (for a service provider)
    please refer to section 7, Service Provider Matching Service
    Interface Specification

#Hub Service Profile of SAML

This hub service profile is defined to support federated authentication
to government services and the future support of single sign-on (SSO).
The current profile is based on the SAML Web Browser SSO Profile (see
section 2.1).

This version of the profile is a reflection of the current IDAP Hub
Service and is simplified from version 1.0 removing elements not
currently required for government services. Features that have been
removed from the profile may be reintroduced in future versions as
requirements evolve.

##Web Browser SSO Profile

In the scenario supported by the Hub Service profile a principal
attempts to access a resource at a service provider that requires a
security context. The principal is authenticated by an identity
provider, which provides an assertion to the Hub Service. The hub
service forwards the assertion to the service provider. The service
provider may then establish a security context for the principal

The Single Logout Profile is not supported by this profile. On
redirection to the hub service following a successful authentication
Identity Providers MUST close any authentication session that has been
created (see 2.1.3.8).

This profile is implemented using the SAML Authentication Request
protocol and the SAML Attribute Query protocol. It uses several of the
existing SAML profiles, namely the Web SSO Profile and Assertion
Query/Request Profile. It is assumed that the principal is using a
standard commercial browser and can authenticate to the identity
provider by some means outside the scope of SAML.

By default all user agent exchanges MUST utilise TLS 1.2 or higher.
Message integrity and confidentiality will be maintained through the use
of asymmetric key signing and encryption.

##Required Information

**Identification:**
`urn:uk:gov:cabinet-office:SAML:2.0.profiles:hubservice:sso`

**SAML Confirmation Method Identifiers:** The SAML V2.0 "bearer"
confirmation method identifier, `urn:oasis:names:tc:SAML:2.0:cm:bearer`,
is used by this profile.

**Description:** A profile in which a central Hub Service provides
brokering of authentication requests between Service Providers and
Identity Providers;.

##Profile Overview

Figure 1 below illustrates the authenticating of a principal using a hub
service. Each step in the figure is described by this profile.

![](media/image2.jpg){width="6.497222222222222in"
height="8.441666666666666in"}

Figure 1 - Authentication Flow

##Profile Description

In this profile the hub service has two distinct roles. When processing
authentication requests from a service provider the hub service acts as
an identity provider. When sending authentication requests to identity
providers the hub service acts as a relying party.

In the descriptions below the following are referred to:

**Single Sign-On Service**

> This is the authentication request protocol endpoint at the identity
> provider and at a hub service to which the `<AuthnRequest>` message is
> delivered by the user agent.

**Assertion Consumer Service**

> This is the authentication request protocol endpoint at the service
> provider and at a hub service to which the `<Response>` message is
> delivered by the user agent.

**Attribute Query Service**

> This is the attribute query protocol endpoint at the service provider
> to which the `<AttributeQuery>` message is sent by the hub service.

**Asserting Entity**

> This is a hub service (when acting as an IdP with respect to a SP), an
> identity provider, or a service provider that can issue a SAML
> assertion or an asserted attribute.

##HTTP Resource Request to Service Provider

In step 1, the principal, via a HTTP User Agent, makes a HTTP request
for a secured resource at service provider without a security context.

The service provider is free to use any means it wishes to associate the
subsequent interactions with the original request. SAML provides a
RelayState mechanism that a service provider MAY use to associate the
profile exchange with the original request. The service provider MUST
reveal as little of the request as possible in the RelayState value.

##Service Provider Determines Hub Service

In step 2, the service provider determines which hub service to use to
broker the authentication request.[^1]

This step is implementation-dependent. The hub service uri for
authentication requests will be supplied by the hub service itself.
There will only be a logical instance of the hub service.

##`<AuthnRequest>` issued by Service Provider to Hub Service

In step 3, an `<AuthnRequest>` message is delivered to the hub service's
single sign-on service by the user agent. See 2.1.3.2. above for
discovery of the hub service's single sign-on service.

The `<AuthnRequest>` message MUST be signed.

See section 4 for a list of SAML profiles and bindings that MUST be
supported.

##Hub Service presents Identity Provider choices to principal

    In step 4, the hub service selects identity providers to display to
    the principal based upon relying party \[supplied\] metadata and
    describes the requirements for IdPs for each relying party
    transaction. This step is necessary to make sure that the principal
    is presented with a user interface where all identity providers
    shown are able to satisfy the requirements of the service provide.
    Metadata defining the service provider's policy is used to provide a
    list of identity providers and their capabilities. This metadata
    will be provided out of band.

    The hub service MUST process the `<AuthnRequest>` message as
    described in \[SAMLCore\].

##Principal selects Identity Provider with which to authenticate

In step 5, the principal is presented with a list of identity providers
that can provide an asserted identity at the level required by the
service provider. The principal selects the identity provider they want
to use.

This step is implementation-dependent.[^2]

##2.1.3.5.1 Alternate Flow: Principal cancels Identity Provider Selection

At this point in the flow the principal MAY indicate (for example by
selecting a cancel button available on the Identity Provider selection
page) that they do not wish to proceed with the authentication
operation.

If this occurs then the hub service MUST generate a `<Response>`
containing a status code of `urn:oasis:names:tc:SAML:2.0:status:Responder`
with a sub-status code of
`urn:oasis:names:tc:SAML:2.0:status:NoAuthnContext`.

The hub service must then execute step 26 within the flow to issue this
response to the service provider, without executing any intermediary
steps.

##`<AuthnRequest>` issued by Hub Service to the Identity Provider

In step 6, the location of the identity provider\'s single sign-on
service is retrieved from the identity provider's metadata and a new
`<AuthnRequest>` message is produced and delivered to the identity
provider via the user agent using HTTP-POST.

The `<AuthnRequest>` message MUST be signed by the hub service and MUST
define any specific elements that were included in the `<AuthnRequest>`
it received from the service provider, such as ForceAuthn.

The value of `<ID>` within the `<AuthnRequest>` MUST be set to the same
value as the ID from the original `<AuthnRequest>` received from the
service provider. The value of `<ID>` MUST NOT reveal the source of the
request or the type of service operated by the requestor.

Within the `<AuthnRequest>`, the Format attribute within
`<NameIDPolicy>` MUST be set to
`urn:oasis:names:tc:SAML:2.0:nameid-format:persistent` and SPNameQualifier
MUST be set to a value representing the overall hub services.

The hub service MUST NOT pass the RelayState received from the service
provider to the identity provider.

Where the principal has explicitly selected to Register rather than
Sign-In with an Identity Provider the hub service SHOULD append an
additional parameter to the HTTP-POST binding of registration=true. This
parameter alerts the Identity Provider to the principal's intention
allowing for the optional delivery of a more appropriate user
experience.

##Identity Provider successfully identifies Principal

    In step 7, the identity provider identifies the principal by some
    means outside the scope of this profile. This may require a new act
    of authentication, or it may reuse an existing authenticated
    session.

The identity provider MUST establish the identity of the principal or
return an error to the hub service (see following sub-sections for
details of error types). The ForceAuthn attribute, if present with a
value of true, obligates the identity provider to freshly establish this
identity, rather than relying on an existing session it may have with
the principal. Otherwise the identity provider may use any means to
authenticate the user as dictated by standards (e.g. GPG 44 / 45),
subject to any requirements included in the `<AuthnRequest>` and
specifically the `<RequestedAuthnContext>` element[^3].

##Error Case: Principal fails authentication with Identity Provider

At this point in the flow, the principal may fail to successfully
authenticate to the identity provider. For example, if the principal
enters incorrect credentials beyond the maximum number of attempts
permitted.

If the principal fails to authenticate then the identity provider MUST
generate a `<Response>` containing a status code of
`urn:oasis:names:tc:SAML:2.0:status:Responder` with a sub-status code of
`urn:oasis:names:tc:SAML:2.0:status:AuthnFailed`.

It is recognised that additional error codes will be required as
dictated by user experience research. These additional error codes will
appear in future iterations of the SAML profile.

##Error Case: Principal fails authentication at the appropriate level with Identity Provider

At this point in the flow the identity provider may be unable to
authenticate the user to the level specified in the
`<RequestedAuthnContext>` within the `<AuthnRequest>`. For example, this
could be because the principal doesn\'t have an account with the
identity provider or that the principal doesn\'t have an account that
can authenticate to the required level.

If this occurs then the identity provider MUST generate a `<Response>`
containing a status code of `urn:oasis:names:tc:SAML:2.0:status:Responder`
with a sub-status code of
`urn:oasis:names:tc:SAML:2.0:status:NoAuthnContext`.

In the event of an error case, the identity provider MUST also display
an explanation message to the principal before issuing the response to
the hub service. The contents of this message is implementation
dependent but should explain to the principal, why they are being sent
back to the hub service.

##Alternate Flow: Principal cancels authentication attempt

At this point in the flow, the principal may indicate (for example by
selecting a cancel button available on the identity provider login page)
that they do not wish to proceed with the authentication operation.

If this occurs then the identity provider MUST generate a `<Response>`
containing a status code of `urn:oasis:names:tc:SAML:2.0:status:Responder`
with a sub-status code of
`urn:oasis:names:tc:SAML:2.0:status:NoAuthnContext` and MUST include a
`<StatusDetail>` element containing a `<StatusValue>` element with the
value authn-cancel.

##Alternate Flow: Principal unable to reach appropriate level at this time with Identity Provider -- Pending State[^4]

In this case the principal is able to authenticate with the identity
provider but not at the level of assurance requested by the hub service
due to a system failure out of control of the principal or due to a
step-out process during identity verification and proofing. Where this
occurs an identity provider MAY continue to issue a `<Response>` to the
hub service (as per step 8) at a lower level of assurance but that
`<Response>` MUST contain a status code of
`urn:oasis:names:tc:SAML:2.0:status:Success` and MUST include a
`<StatusDetail>` containing a `<StatusValue>` element with the value
loa-pending.

##Identity Provider issues `<Response>` to Hub Service

In step 8, the identity provider issues a `<Response>` message delivered
via the user agent to the hub service. The message MUST contain either
an error or an authentication assertion.

Regardless of the success or failure of the authentication process, the
identity provider MUST produce a HTTP response to the user agent
containing a `<Response>` message that is delivered to the hub service's
assertion consumer service.

The location of the assertion consumer service MUST be one of the
services registered in the metadata (as in \[SAMLMeta\]). If a specific
assertion consumer service index is specified by the hub service in the
`<AuthnRequest>` the identity provider MUST honour this.

The `<Response>` element and any `<Assertion>` element in the
`<Response>` MUST be signed. An assertion MUST be encrypted for the hub
service after it has been signed.

There will be 2 `<Assertion>` elements sent from the IDP to the hub
service via the user agent for a successful authentication event: one
assertion containing the Matching DataSet (MDS), and one containing
contextual information related to the authentication event. The
assertion containing the authentication event will also include the
`<AuthnContext>` element. The contextual information may include data
items such as level of authentication, authentication type, and IP
address. In version 1.2 this information will initially comprise of IP
Address and LoA[^5]. A full definition of SAML Attributes relating to
this SAML Profile can be found in *"Identity Assurance Hub Service
Profile - SAML Attributes v1.2"*.

In the case of a fraud event being identified the Identity Provider MUST
return a Fraud Event Response as described in 2.1.3.8.1 below.

On redirection to the hub service the Identity Provider MUST close any
authentication session that has been created.[^6]

##Fraud Event Response: Identity Provider identifies actual or potentially fraudulent activity

Notification of a fraud event to the hub service by an identity provider
MUST be via a SAML `<Response>` using the same basic pattern as for a
normal identity provider `<Response>` to an authentication request.

In the case of a fraud event notification the payload of the 2
`<Assertion>` elements required in an identity provider `<Response>`
will vary from the normal authentication `<Response>` message by
describing the fraud event rather than an assertion of identity[^7].

Where a fraud has been detected by the Identity Provider during the
registration process, the Identity Provider MUST issue a `<Response>` to
the hub service which includes a fraud event identity assertion and a
fraud event contextual information assertion. These assertions are
issued using the same `<Response>` pattern as for a normal
authentication response but MUST include a specific fraud event related
payload in the assertions.

The fraud event identity assertion MUST include the following elements:
##   The assertion MUST contain a `<NameID>` element. The Format MUST be
    set to `urn:oasis:names:tc:SAML:2.0:nameid-format:persistent`. The
    value of this element MUST be the persistent identifier (PID)
    associated with the principal.
##   A Matching Data Set attribute statement that MUST contain dummy or
    anonymous values as placeholders. This is to prevent statistical
    analysis of the assertion payload.

The fraud event contextual information assertion MUST include the
following elements:
##   An `<AttributeStatement>` for the fraud event:

    -   Where a contra-indicator has been identified according to GPG45
        the corresponding GPG45 status code MUST be included as an
        attribute value

    -   An attribute MUST be included denoting the unique IDP specific
        fraud event reference code. This attribute value MUST be derived
        from the IDP name, a date-time stamp, and a sequence number for
        the event.
##   An `<AuthnContext>` that MUST include an `<AuthnContextClassRef>`
    denoting a fraud event, and the fact that a level of assurance has
    not been achieved, with the value of
    `urn:uk:gov:cabinet-office:tc:saml:authn-context:levelX`

The `<Response>` MUST contain an InResponseTo attribute set to the value
contained in the original `<AuthnRequest>`.

The `<Response>` MUST contain a status code of value
`urn:oasis:names:tc:SAML:2.0:status:Success`[^8].

A full definition of SAML Attributes relating to this SAML Profile can
be found in *"Identity Assurance Hub Service Profile - SAML Attributes
v1.2"*.

**2.1.3.8.2 Error Case: Hub Service receives an error Response from
Identity Provider**

If the identity provider responds to the hub service with a `<Response>`
containing either status code defined in 2.1.3.7.1, 2.1.3.7.2 or
2.1.3.7.3, then the hub service MUST handle the error as follows:

For a status code `urn:oasis:names:tc:SAML:2.0:status:NoAuthnContext`,the
hub service MUST execute step 5 (2.1.3.5) in the SSO flow and re-present
the list of identity providers to the principal to allow them select a
new identity provider. The screen SHOULD contain a reason explaining why
the identity selector is being displayed again.[^9]

For a status code `urn:oasis:names:tc:SAML:2.0:status:AuthnFailed`, or for
any other non-success status codes (except NoAuthnContext, see above),
the hub service MUST execute step 26 in the SSO flow without executing
any of the intermediate steps. The status code from the identity
provider MUST be sent in the `<Response>` message to the service
provider.

**2.1.3.8.3 Error Case: Hub Service receives a fraud event response from
Identity Provider**

In the case of a Fraud Error Response (see 2.1.3.8.1) being received the
hub service MUST generate a `<Response>` containing a status code of
`urn:oasis:names:tc:SAML:2.0:status:Responder` with a sub-status code of
`urn:oasis:names:tc:SAML:2.0:status:AuthnFailed` and a `<StatusDetail>`
element containing a `<StatusValue>` element with a value equal to the
GPG45 status code as sent by the identity provider in the Fraud Error
Response.

##Principal provides user-entered attributes

In step 13, if the required attributes, as identified in 2.1.3.10 are
not available from the MatchingDataSet then the principal MAY be
requested to enter these attributes directly into a form presented by
the hub service.

If the user is prompted to enter attributes, then steps 14-16 MUST not
be executed during that particular attribute request iteration (steps
10-17).

The details on how the step of collecting user-entered attributes is
implemented are implementation dependent.

The hub service MUST create an `<Assertion>` containing all of the
user-entered attributes.

This `<Assertion>` MUST be signed by the hub service and MUST contain
the persistent identifier value contained in the identity provider's
assertion.

The value of the ID attribute within the `<Assertion>` MUST be the same
as the value of the ID attribute contained in the original
`<AuthnRequest>` from the service provider. Note: This is in addition to
setting the InResponseTo attribute when the hub service constructs a
`<Response>` element for return to the service provider (see section
2.1.4.2 for `<Response>` Usage).

##`<AttributeQuery>` issued by Hub Service to Matching Service

To enable a service provider to obtain a match to a local identifier the
`<AttributeQuery>` construct is used to initiate a local matching
process. In step 20, the location of the service provider\'s matching
service is determined via metadata and the hub service delivers an
`<AttributeQuery>` message to the matching service using the SAML SOAP
binding.

This step MUST include an `<AttributeQuery>` message sent to the
matching service of the original request\'s service provider to enable
the matching process to be executed.

The value of the ID attribute within the `<AttributeQuery>` MUST be the
same as the value of the ID attribute contained in the original
`<AuthnRequest>` from the service provider.

The `<AttributeQuery>` message MUST be signed.

The request will contain a single `<SubjectConfirmationData>` element
within `<SubjectConfirmation>`. This MUST contain one or more Assertions
for each assertion that the matching service needs.

At a minimum the `<AttributeQuery>` MUST contain the identity provider
assertion.

The value of NameID contained with the `<AttributeQuery>` MUST be the
PersistentID extracted from the identity provider assertion

The `<Assertion>` element containing the identity provider assertion for
the principal MUST be included in the attribute query and it MUST be
encrypted for the matching service. This identity provider assertion
MUST include the original signature from the identity provider.

The hub service MUST use the synchronous SAML SOAP binding and MUST
authenticate itself to the service provider by signing the message.

##Matching Service generates Persistent Identifier

In step 21, the matching service will hash the PersistentID in order to
generate a persistent identifier to optimise subsequent matching and
lookup. This identifier will be used to lookup the local identifier in
the local mapping service and will be used in the `<Response>` to the
hub service.

The non-hashed PersistentID SHOULD NOT be stored.

This locally generated PersistentID is mathematically derived from the
PersistentID contained in the identity provider assertion. The
PersistentID MUST be generated in accordance with the details provided
in section 3.1

##Matching Service matches Name Identifier

In step 22, the service provider matching service attempts to uniquely
match the principal contained in the identity provider assertion (and
optionally hub service assertions) sent from the hub service in the
`<AttributeQuery>` message, with a principal in the service provider.

Using the attributes provided in the identity provider assertion, the
service provider matching service MUST attempt to match the name
identifier against previously matched principals contained in its local
mapping service. If a previous match does not exist the service provider
matching service MUST attempt to match the principal to a principal for
which it holds attributes (i.e. a local identifier recognised by the
service provider).

The service provider matching service MAY decide whether to use any
user-entered attributes contained in the signed hub service assertion
and the level of trust it places on those values.

The details of the steps taken to perform the match against the local
identity repository are implementation dependent.

If a previous match exists (i.e. there is a match of principal to
persistent identifier a the matching service), then a `<Response>`
containing a status code of `urn:oasis:names:tc:SAML:2.0:status:Success`
and a sub-status code of
`urn:uk:gov:cabinet-office:tc:saml:statuscode:match` MUST be ret`urned`.

If a match to persistent identifier cannot be achieved the matching
service MUST attempt to match the principal to a local identifier using
the provided matching data set (MDS). Where a match is achieved a
correlation between the name identifier and a local identity for the
principal SHOULD be maintained (see 2.1.3.23).

The matching service MUST process the `<AttributeQuery>` message as
defined in \[SAMLCore\].

The details of the steps taken to perform the match against the local
identity repository are implementation dependent.

##2.1.3.22.1 Error Case: Matching Service Fails to Uniquely Match Principal

There are a number of status codes that MAY be generated during the
match process. The first failure scenario during the match is when the
matching service is unable to uniquely match the principal to a local
identity. In this scenario, the matching service may either have no
matches for the principal or multiple matches.

Where the matching service has found no matches for the principal, then
it MUST return a `<Response>` containing a status code
`urn:oasis:names:tc:SAML:2.0:status:Responder` and a sub-status code of
`urn:uk:gov:cabinet-office:tc:saml:statuscode:no-match`.

Where the matching service has found multiple matches for the principal,
then it MUST return a `<Response>` containing a status code
`urn:oasis:names:tc:SAML:2.0:status:Responder` and a sub-status code of
`urn:uk:gov:cabinet-office:tc:saml:statuscode:multiple-match`.

The second failure scenario during the match is when the matching
service is unable to uniquely match the name identifier to a local
identity but determines that no further matching is required.

Where the matching service has found no match for the principal but does
not require further matching, then it MUST return a `<Response>`
containing a status code `urn:oasis:names:tc:SAML:2.0:status:Success` and
a sub-status code of
`urn:uk:gov:cabinet-office:tc:saml:statuscode:no-match`.

##Matching Service updates local mapping service

In step 23, the matching service MUST update its local mapping service
to store the link between the locally generated PersistentID generated
in 2.1.3.21 and the local identifier for that principal.

If the matching service matches the principal contained in the
`<AttributeQuery>` name identifier to a local identity, then the mapping
service MUST store the link between the locally generated PersistentID
and the local identifier for that principal. The matching service MUST
NOT store any of the persistent identifiers contained in the inbound
`<AttributeQuery>`.

If the matching service is unable to match the name identifier to a
local identity, through any of the configured data match escalations
then an entry COULD be written into the mapping service containing a
link between the locally generated PersistentID generated in 2.1.3.21
and a local, temporary identifier. This is to enable local account
mapping within the service provider as well as avoid the need for the
matching service to perform a match each time a request is received for
a ret`urning` principal.

The details of how the matching service updates its local mapping
service is implemented are implementation dependent. However, the
recommended approach is that the matching service SHOULD maintain a
correlation between the name identifier (persistent identifier) and a
local identity (local identifier) as part of the matching process (i.e.
when a match is achieved), resulting in a mapping table that could be
used by the service provider during its principal lookup.

The details of how the local, temporary identifier are generated and
updated are outside the scope of this specification and are
implementation dependent.

##Matching Service extracts required attributes

In step 24, the matching service MUST extract any provided attribute
values from the assertions contained in the `<AttributeQuery>` from the
hub service.

##Matching Service issues `<Response>` message to the Hub Service

In step 25, the matching service issues a `<Response>` message to the
hub service.

The `<Response>` message must contain a name identifier of type
`urn:oasis:names:tc:SAML:2.0:nameid-format:persistent` and contain the
value for locally generated persistent identifier generated in step
2.1.3.21.

In addition the status code MUST contain one of the status codes and
sub-status codes defined in 2.1.3.22.1 or contain a status code of
`urn:oasis:names:tc:SAML:2.0:status:Success` and a sub-status code of
`urn:uk:gov:cabinet-office:tc:saml:statuscode:match`.

The `<Response>` MUST contain all attributes extracted in 2.1.3.24,
defined as standard SAML `<Attribute>`.

The `<Response>` MUST include a copy of the `<AuthnContext>` as provided
in the IDP authentication event assertion `<AuthnStatement>`. This
information will allow the service to act upon the level of assurance
reached by the principal during authentication if this has not met the
minimum required level.

The `<Response>` and `<Assertion>` must be signed. The `<Assertion>`
contained in the response MUST also be encrypted for the hub service
after it is signed.

The matching service MUST authenticate itself to the hub service by
signing the `<Response>`.

##Hub Service combines response and re-asserts

In step 26, the hub service MUST extract the `<Assertion>` ret`urned` in
2.1.3.25 and create a new `<Response>` to issue to the service provider.

This `<Response>` MUST be signed by the hub service.

##Hub Service issues `<Response>` to Service Provider

In step 26, the hub service issues a `<Response>` message delivered by
the user agent to the service provider. The response message MUST
contain an error in the form of a status code (and any relevant
sub-status code), OR contain an authentication assertion.

Regardless of the success or failure of the `<AuthnRequest>`, the hub
service MUST produce a HTTP response to the user agent containing a
`<Response>` message which is delivered to the service provider\'s
assertion consumer service.

The location of the assertion consumer service MAY be determined using
metadata (as in \[SAMLMeta\]). In its `<AuthnRequest>`, a service
provider MAY indicate the specific assertion consumer service to use and
the hub service SHOULD honour it if it can.

The `<Response>` element MUST be signed. The `<Assertion>` element will
already be signed by the service provider matching service. To ensure
that the assertion is for the specific target SP the `<Assertion>` must
also be encrypted by the hub service after it is signed using the
service provider's public key.

##Service Provider grants or denies access to Principal

In step 27, having received the response from the hub service, the
service provider processes the `<Response>` and `<Assertion>` and grants
or denies access to the resource. The service provider MAY establish a
security context with the user agent using any session mechanism it
chooses. Any subsequent use of the `<Assertion>` provided is at the
discretion of the service provider and other relying parties, subject to
restrictions on use contained within it.

The service provider MAY respond to the principal's user agent with its
own error if it fails to establish a security context for the principal.

The service provider MUST process the `<Response>` message and the
enclosed `<Assertion>` element as described in \[SAMLCore\].

##Federation Termination

In this scenario, the principal is provided with the ability to remove
the stored link between their identity at an identity provider and their
identity at a service provider. This would force matching to re-occur
the next time the principal attempted to access a protected service at
the service provider.

It should be noted that this scenario does not prevent the principal
from authenticating at an identity provider and accessing protected
services. Instead it is designed to remove the existing link between the
principal's identities at the two entities.

To simplify the design, a pragmatic approach was taken to implementing
federation termination. As a result the hub service profile does not
define a flow based on SAML 2.0 Name Identifier Management Profile.

Instead, the hub service profile RECOMMENDS that service providers
SHOULD provide an administrative function that allows an administrator
to remove the PersistentID\<-\>LocalID mapping within the local mapping
service in the service provider.

Furthermore, processes SHOULD be implemented at the service provider to
enable a principal to request that this mapping is removed from the
mapping service.

#IDP Specific Profile Steps

###Overview

Identity Providers (IDPs) interact with a single service provider, the
IDA hub service, which acts as a federation hub between the service
wishing to complete a transaction (the service provider, SP, in the
figure 2 below), and the identity provider itself.

Principals are directed to the identity provider (from the hub service)
via the user agent with an `<AuthnRequest>` describing the level of
assurance required by the relying party.

On receipt of the `<AuthnRequest>` the identity provider follows the
process steps described below in order to attempt authentication of the
principal at the requested level of assurance. Identity providers are
free to perform registration as part of this process if required but
this is not described in this profile.

![](media/image3.jpg){width="6.497222222222222in"
height="2.6736832895888014in"}

Figure 2 -- Identity Provider Authentication Flow

##Profile steps

The following profile steps are taken from the full authentication flow
described in section 2.1 of this document. Step numbers have been
retained to match the full process flow. The steps relating to an
identity provider are shown in Figure 2 above.

###`<AuthnRequest>` issued by Hub Service to the Identity Provider

In step 6, the location of the identity provider\'s single sign-on
service is retrieved from the identity provider's metadata and a new
`<AuthnRequest>` message is produced and delivered to the identity
provider via the user agent using HTTP-POST.

The `<AuthnRequest>` message MUST be signed by the hub service and MUST
define any specific elements that were included in the `<AuthnRequest>`
it received from the service provider, such as ForceAuthn.

The value of `<ID>` within the `<AuthnRequest>` MUST be set to the same
value as the ID from the original `<AuthnRequest>` received from the
service provider. The value of `<ID>` MUST NOT reveal the source of the
request or the type of service operated by the requestor.

Within the `<AuthnRequest>`, the Format attribute within
`<NameIDPolicy>` MUST be set to
`urn:oasis:names:tc:SAML:2.0:nameid-format:persistent` and SPNameQualifier
MUST be set to a value representing the overall hub services.

The hub service MUST NOT pass the RelayState received from the service
provider to the identity provider.

Where the principal has explicitly selected to Register rather than
Sign-In with an Identity Provider the hub service SHOULD append an
additional parameter to the HTTP-POST binding of registration=true. This
parameter alerts the Identity Provider to the principal's intention
allowing for the optional delivery of a more appropriate user
experience.

###Identity Provider successfully identifies Principal

    In step 7, the identity provider identifies the principal by some
    means outside the scope of this profile. This may require a new act
    of authentication, or it may reuse an existing authenticated
    session.

The identity provider MUST establish the identity of the principal or
return an error to the hub service (see following sub-sections for
details of error types). The ForceAuthn attribute, if present with a
value of true, obligates the identity provider to freshly establish this
identity, rather than relying on an existing session it may have with
the principal. Otherwise the identity provider may use any means to
authenticate the user as dictated by standards (e.g. GPG 44 / 45),
subject to any requirements included in the `<AuthnRequest>` and
specifically the `<RequestedAuthnContext>` element.

###Error Case: Principal fails authentication with Identity Provider

At this point in the flow, the principal may fail to successfully
authenticate to the identity provider. For example, if the principal
enters incorrect credentials beyond the maximum number of attempts
permitted.

If the principal fails to authenticate then the identity provider MUST
generate a `<Response>` containing a status code of
`urn:oasis:names:tc:SAML:2.0:status:Responder` with a sub-status code of
`urn:oasis:names:tc:SAML:2.0:status:AuthnFailed`.

It is recognised that additional error codes will be required as
dictated by user experience research. These additional error codes will
appear in future iterations of the SAML profile.

###Error Case: Principal fails authentication at the appropriate level with Identity Provider

At this point in the flow the identity provider may be unable to
authenticate the user to the level specified in the
`<RequestedAuthnContext>` within the `<AuthnRequest>`. For example, this
could be because the principal doesn\'t have an account with the
identity provider or that the principal doesn\'t have an account that
can authenticate to the required level.

If this occurs then the identity provider MUST generate a `<Response>`
containing a status code of `urn:oasis:names:tc:SAML:2.0:status:Responder`
with a sub-status code of
`urn:oasis:names:tc:SAML:2.0:status:NoAuthnContext`.

In the event of an error case, the identity provider MUST also display
an explanation message to the principal before issuing the response to
the hub service. The contents of this message is implementation
dependent but should explain to the principal, why they are being sent
back to the hub service.

###Alternate Flow: Principal cancels authentication attempt

At this point in the flow, the principal may indicate (for example by
selecting a cancel button available on the identity provider login page)
that they do not wish to proceed with the authentication operation.

If this occurs then the identity provider MUST generate a `<Response>`
containing a status code of `urn:oasis:names:tc:SAML:2.0:status:Responder`
with a sub-status code of
`urn:oasis:names:tc:SAML:2.0:status:NoAuthnContext` and MUST include a
`<StatusDetail>` element containing a `<StatusValue>` element with the
value authn-cancel.

###Alternate Flow: Principal unable to reach appropriate level at this time with Identity Provider -- Pending State

In this case the principal is able to authenticate with the identity
provider but not at the level of assurance requested by the hub service
due to a system failure out of control of the principal or due to a
step-out process during identity verification and proofing.

If this occurs an identity provider MUST generate a `<Response>`
containing a status code of `urn:oasis:names:tc:SAML:2.0:status:Responder`
with a sub-status code of
`urn:oasis:names:tc:SAML:2.0:status:NoAuthnContext` and MUST include a
`<StatusDetail>` element containing a `<StatusValue>` element with the
value loa-pending.

###Identity Provider issues `<Response>` to Hub Service

In step 8, the identity provider issues a `<Response>` message delivered
via the user agent to the hub service. The message MUST contain either
an error or an authentication assertion.

Regardless of the success or failure of the authentication process, the
identity provider MUST produce a HTTP response to the user agent
containing a `<Response>` message that is delivered to the hub service's
assertion consumer service.

The location of the assertion consumer service MUST be one of the
services registered in the metadata (as in \[SAMLMeta\]). A hub service
MAY indicate the specific assertion consumer service index to use in its
`<AuthnRequest>` and the identity provider MUST honour this if set and
valid.

The `<Response>` element and any `<Assertion>` element in the
`<Response>` MUST be signed. The assertion MUST be encrypted for the hub
service after it has been signed.

There will be 2 `<Assertion>` elements sent from the IDP to the hub
service via the user agent for a successful authentication event: one
assertion containing the Matching DataSet (MDS), and one containing
contextual information related to the authentication event. The
assertion containing the authentication event will also include the
`<AuthnContext>` element. The contextual information may include data
items such as level of authentication, authentication type, and IP
address. In version 1.2 this information will initially comprise of IP
Address and LoA[^14]. A full definition of SAML Attributes relating to
this SAML Profile can be found in *"Identity Assurance Hub Service
Profile - SAML Attributes v1.2"*.

In the case of a fraud event being identified the Identity Provider MUST
return a Fraud Event Response as described in 5.2.3.1 below.

On redirection to the hub service the Identity Provider MUST close any
authentication session that has been created.[^15]

###Fraud Event Response: Identity Provider identifies actual or potentially fraudulent activity

Notification of a fraud event to the hub service by an identity provider
MUST be via a SAML `<Response>` using the same basic pattern as for a
normal identity provider `<Response>` to an authentication request.

In the case of a fraud event notification the payload of the 2
`<Assertion>` elements required in an identity provider `<Response>`
will vary from the normal authentication `<Response>` message by
describing the fraud event rather than an assertion of identity[^16].

Where a fraud has been detected by the Identity Provider during the
registration process, the Identity Provider MUST issue a `<Response>` to
the hub service which includes a fraud event identity assertion and a
fraud event contextual information assertion. These assertions are
issued using the same `<Response>` pattern as for a normal
authentication response but MUST include a specific fraud event related
payload in the assertions.

The fraud event identity assertion MUST include the following elements:

-   The assertion MUST contain a `<NameID>` element. The Format MUST be
    set to `urn:oasis:names:tc:SAML:2.0:nameid-format:persistent`. The
    value of this element MUST be the persistent identifier (PID)
    associated with the principal.
-   A Matching Data Set attribute statement that MUST contain dummy or
    anonymous values as placeholders. This is to prevent statistical
    analysis of the assertion payload.

The fraud event contextual information assertion MUST include the
following elements:

-   An `<AttributeStatement>` for the fraud event:
  -  Where a contra-indicator has been identified according to GPG45
     the corresponding GPG45 status code MUST be included as an
     attribute value
  -  An attribute MUST be included denoting the unique IDP specific
     fraud event reference code. This attribute value MUST be derived
     from the IDP name, a date-time stamp, and a sequence number for
     the event.
-   An `<AuthnContext>` that MUST include an `<AuthnContextClassRef>`
    denoting a fraud event, and the fact that a level of assurance has
    not been achieved, with the value of
    `urn:uk:gov:cabinet-office:tc:saml:authn-context:levelX`

The `<Response>` MUST contain an InResponseTo attribute set to the value
contained in the original `<AuthnRequest>`.

The `<Response>` MUST contain a status code of value
`urn:oasis:names:tc:SAML:2.0:status:Success`[^17].

A full definition of SAML Attributes relating to this SAML Profile can
be found in *"Identity Assurance Hub Service Profile - SAML Attributes
v1.2"*.

#Service Provider Specific Profile Steps

###Overview

Service Providers will interact with a single logical identity provider
in the form of the hub service. When the service provider wishes to
authenticate an individual an `<AuthnRequest>` will be constructed by
the service provider and sent to the hub service's identity provider
interface.

The hub service will orchestrate the authentication process resulting in
a `<Response>` being sent to the requesting service provider.

Service providers will also need to specify a Service Provider Matching
Service (see section 7) to complete the identification of an individual.

![](media/image4.jpg){width="6.497222222222222in"
height="2.9684208223972in"}

Figure 3 -- Service Provider Authentication Flow

##Profile steps

The following profile steps are taken from the full authentication flow
described in section 2.1 of this document. Step numbers have been
retained to match the full process flow. The steps relating to a service
provider are shown in Figure 3 above.

##HTTP Resource Request to Service Provider

In step 1, the principal, via a HTTP User Agent, makes a HTTP request
for a secured resource at service provider without a security context.

The service provider is free to use any means it wishes to associate the
subsequent interactions with the original request. SAML provides a
RelayState mechanism that a service provider MAY use to associate the
profile exchange with the original request. The service provider MUST
reveal as little of the request as possible in the RelayState value.

##Service Provider Determines Hub Service

In step 2, the service provider determines which hub service to use to
broker the authentication request.[^18]

This step is implementation-dependent. The hub service uri for
authentication requests will be supplied by the hub service itself.
There will only be a logical instance of the hub service.

##`<AuthnRequest>` issued by Service Provider Hub Service

In step 3, an `<AuthnRequest>` message is delivered to the hub service's
single sign-on service by the user agent. See 2.1.3.2. above for
discovery of the hub service's single sign-on service.

The `<AuthnRequest>` message MUST be signed.

See section 4 for a list of SAML profiles and bindings that MUST be
supported.

##Hub Service issues `<Response>` to Service Provider

In step 26, the hub service issues a `<Response>` message delivered by
the user agent to the service provider. The response message MUST
contain an error in the form of a status code (and any relevant
sub-status code), OR contain an authentication assertion.

Regardless of the success or failure of the `<AuthnRequest>`, the hub
service MUST produce a HTTP response to the user agent containing a
`<Response>` message which is delivered to the service provider\'s
assertion consumer service.

The location of the assertion consumer service MAY be determined using
metadata (as in \[SAMLMeta\]). In its `<AuthnRequest>`, a service
provider MAY indicate the specific assertion consumer service to use and
the hub service SHOULD honour it if it can.

The `<Response>` element MUST be signed. The `<Assertion>` element will
already be signed by the service provider matching service. To ensure
that the assertion is for the specific target SP the `<Assertion>` must
also be encrypted by the hub service after it is signed using the
service provider's public key.

##Service Provider grants or denies access to Principal

In step 27, having received the response from the hub service, the
service provider processes the `<Response>` and `<Assertion>` and grants
or denies access to the resource. The service provider MAY establish a
security context with the user agent using any session mechanism it
chooses. Any subsequent use of the `<Assertion>` provided is at the
discretion of the service provider and other relying parties, subject to
restrictions on use contained within it.

The service provider MAY respond to the principal's user agent with its
own error if it fails to establish a security context for the principal.

The service provider MUST process the `<Response>` message and the
enclosed `<Assertion>` element as described in \[SAMLCore\].

#Service Provider Matching Service Specific Profile Steps

###Overview

Service Provider Matching Services respond to matching requests from the
hub service in the form of an `<AttributeQuery>`.

Matching services act on behalf of a service provider to obtain a match
to a local identifier relevant to the service provider and enabling it
to complete a transaction for the principal.

![](media/image5.jpg){width="6.497222222222222in"
height="3.6105260279965004in"}

Figure 4 -- Service Provider Matching Service Authentication Flow

##Profile steps

The following profile steps are taken from the full authentication flow
described in section 2.1 of this document. Step numbers have been
retained to match the full process flow. The steps relating to a service
provider matching service are shown in Figure 4 above.

##`<AttributeQuery>` issued by Hub Service to Matching Service

To enable a service provider to obtain a match to a local identifier the
`<AttributeQuery>` construct is used to initiate a local matching
process. In step 20, the location of the service provider\'s matching
service is determined via metadata and the hub service delivers an
`<AttributeQuery>` message to the matching service using the SAML SOAP
binding.

This step MUST include an `<AttributeQuery>` message sent to the
matching service of the original request\'s service provider to enable
the matching process to be executed.

The value of the ID attribute within the `<AttributeQuery>` MUST be the
same as the value of the ID attribute contained in the original
`<AuthnRequest>` from the service provider.

The `<AttributeQuery>` message MUST be signed.

The request will contain a single `<SubjectConfirmationData>` element
within `<SubjectConfirmation>`. This MUST contain one or more Assertions
for each assertion that the service provider needs.

At a minimum the `<AttributeQuery>` MUST contain the identity provider
assertion.

The value of NameID contained with the `<AttributeQuery>` MUST be the
PersistentID extracted from the identity provider assertion

The `<Assertion>` element containing the identity provider assertion for
the principal MUST be included in the attribute query and it MUST be
encrypted for the matching service. This identity provider assertion
MUST include the original signature from the identity provider.

The hub service MUST use the synchronous SAML SOAP binding and MUST
authenticate itself to the service provider by signing the message.

##Matching Service generates Persistent Identifier

In step 21, the matching service will hash the PersistentID in order to
generate a persistent identifier to optimise subsequent matching and
lookup. This identifier will be used to lookup the local identifier in
the local mapping service and will be used in the `<Response>` to the
hub service.

The non-hashed PersistentID SHOULD NOT be stored.

This locally generated PersistentID is mathematically derived from the
PersistentID contained in the identity provider assertion. The
PersistentID MUST be generated in accordance with the details provided
in section 3.1.

##Matching Service matches Name Identifier

In step 22, the service provider matching service attempts to uniquely
match the principal contained in the identity provider assertion (and
optionally hub service assertions) sent from the hub service in the
`<AttributeQuery>` message, with a principal in the service provider.

Using the attributes provided in the identity provider assertion, the
service provider matching service MUST attempt to match the name
identifier against previously matched principals contained in its local
mapping service. If a previous match does not exist the service provider
matching service MUST attempt to match the principal to a principal for
which it holds attributes (i.e. a local identifier recognised by the
service provider).

The service provider matching service MAY decide whether to use any
user-entered attributes contained in the signed hub service assertion
and the level of trust it places on those values.

The details of the steps taken to perform the match against the local
identity repository are implementation dependent.

If a previous match exists (i.e. there is a match of principal to
persistent identifier a the matching service), then a `<Response>`
containing a status code of `urn:oasis:names:tc:SAML:2.0:status:Success`
and a sub-status code of
`urn:uk:gov:cabinet-office:tc:saml:statuscode:match` MUST be ret`urned`.

If a match to persistent identifier cannot be achieved the matching
service MUST attempt to match the principal to a local identifier using
the provided matching data set (MDS). Where a match is achieved a
correlation between the name identifier and a local identity for the
principal SHOULD be maintained (see 7.2.4).

The matching service MUST process the `<AttributeQuery>` message as
defined in \[SAMLCore\].

The details of the steps taken to perform the match against the local
identity repository are implementation dependent.

##Error Case: Matching Service Fails to Uniquely Match Principal

There are a number of status codes that MAY be generated during the
match process. The first failure scenario during the match is when the
matching service is unable to uniquely match the principal to a local
identity. In this scenario, the matching service may either have no
matches for the principal or multiple matches.

Where the matching service has found no matches for the principal, then
it MUST return a `<Response>` containing a status code
`urn:oasis:names:tc:SAML:2.0:status:Responder` and a sub-status code of
`urn:uk:gov:cabinet-office:tc:saml:statuscode:no-match`.

Where the matching service has found multiple matches for the principal,
then it MUST return a `<Response>` containing a status code
`urn:oasis:names:tc:SAML:2.0:status:Responder` and a sub-status code of
`urn:uk:gov:cabinet-office:tc:saml:statuscode:multiple-match`.

The second failure scenario during the match is when the matching
service is unable to uniquely match the name identifier to a local
identity but determines that no further matching is required.

Where the matching service has found no match for the principal but does
not require further matching, then it MUST return a `<Response>`
containing a status code `urn:oasis:names:tc:SAML:2.0:status:Success` and
a sub-status code of
`urn:uk:gov:cabinet-office:tc:saml:statuscode:no-match`.

##Matching Service updates local mapping service

In step 23, the matching service MUST update its local mapping service
to store the link between the locally generated PersistentID generated
in 2.1.3.21 and the local identifier for that principal.

If the matching service matches the principal contained in the
`<AttributeQuery>` name identifier to a local identity, then the mapping
service MUST store the link between the locally generated PersistentID
and the local identifier for that principal. The matching service MUST
NOT store any of the persistent identifiers contained in the inbound
`<AttributeQuery>`.

If the matching service is unable to match the name identifier to a
local identity, through any of the configured data match escalations
then an entry COULD be written into the mapping service containing a
link between the locally generated PersistentID generated in 2.1.3.21
and a local, temporary identifier. This is to enable local account
mapping within the service provider as well as avoid the need for the
matching service to perform a match each time a request is received for
a ret`urning` principal.

The details of how the matching service updates its local mapping
service is implemented are implementation dependent. However, the
recommended approach is that the matching service SHOULD maintain a
correlation between the name identifier (persistent identifier) and a
local identity (local identifier) as part of the matching process (i.e.
when a match is achieved), resulting in a mapping table that could be
used by the service provider during its principal lookup.

The details of how the local, temporary identifier are generated and
updated are outside the scope of this specification and are
implementation dependent.

##Matching Service extracts required attributes

In step 24, the matching service MUST extract any provided attribute
values from the assertions contained in the `<AttributeQuery>` from the
hub service.

##Matching Service issues `<Response>` message to the Hub Service

In step 25, the matching service issues a `<Response>` message to the
hub service.

The `<Response>` message must contain a name identifier of type
`urn:oasis:names:tc:SAML:2.0:nameid-format:persistent` and contain the
value for locally generated persistent identifier generated in step
2.1.3.21.

In addition the status code MUST contain one of the status codes and
sub-status codes defined in 2.1.3.22.1 or contain a status code of
`urn:oasis:names:tc:SAML:2.0:status:Success` and a sub-status code of
`urn:uk:gov:cabinet-office:tc:saml:statuscode:match`.

The `<Response>` MUST contain all attributes extracted in 2.1.3.24,
defined as standard SAML `<Attribute>`.

The `<Response>` MUST include a copy of the `<AuthnContext>` as provided
in the IDP authentication event assertion `<AuthnStatement>`. This
information will allow the service to act upon the level of assurance
reached by the principal during authentication if this has not met the
minimum required level.

The `<Response>` and `<Assertion>` must be signed. The `<Assertion>`
contained in the response MUST also be encrypted for the hub service
after it is signed.

The matching service MUST authenticate itself to the requester by
signing the `<Response>`.


[^1]: In the case of the IDAP Hub Service there is only one hub service.
    This may be reviewed in future iterations of the SAML profile.

[^2]: User experience testing will determine the user interface design
    in the hub service. This is currently in process.

[^3]: In the IDAP Hub Service only the level of assurance will be
    included in `<RequestedAuthnContext>`

[^4]: Note that pending state is not currently implemented and will be
    subject to elaboration with identity providers and service providers
    during the lifespan of v1.3 of this profile.

[^5]: Additional attribute definitions will be added during the lifetime
    of this profile following elaboration with Identity Providers and
    Service Providers.

[^6]: Version 1.2 does not include support for a Single Logout Profile
    or the concept of single sign-on across HMG services.

[^7]: Additional information relating to the detailed fraud event for
    fraud reporting purposes will be sent via an out-of-band process
    e.g. secure email.

[^8]: For v1.3 the hub service will return an AuthnFailed response to
    the service provider (step 26 in the SSO flow) on receipt of a Fraud
    Event Response. This response will include a GPG45 status code as
    provided in the Fraud Event Response.

[^9]: User experience testing is currently exploring how this will be
    presented. This has not been implemented in the IDAP Hub Service.

[^10]: Session monitoring requirements will be elaborated during the
    lifetime of v1.3 to be included in the authentication event
    assertion. `<SubjectLocality>` is included for compatibility with
    COTS products.

[^11]: This is not implemented in the IDAP Hub Service.

[^12]: This is not implemented in the IDAP Hub Service.

[^13]: Security standards such as those specified in SAML2 Conformance
    are subject to GDS review and may be subject to incremental change
    to protect the integrity and security of user data and to protect
    HMG services from attack.

[^14]: Additional attribute definitions will be added during the
    lifetime of this profile following elaboration with Identity
    Providers and Service Providers.

[^15]: Version 1.3 does not include support for a Single Logout Profile
    or the concept of single sign-on across HMG services.

[^16]: Additional information relating to the detailed fraud event for
    fraud reporting purposes will be sent via an out-of-band process
    e.g. secure email.

[^17]: For v1.3 the hub service will return an AuthnFailed response to
    the service provider (step 26 in the SSO flow) on receipt of a Fraud
    Event Response. This response will include a GPG45 status code as
    provided in the Fraud Event Response.

[^18]: In the case of the reference architecture there is only one hub
    service. This may be reviewed in future iterations of the SAML
    profile.

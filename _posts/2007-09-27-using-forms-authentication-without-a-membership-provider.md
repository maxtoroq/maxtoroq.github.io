---
title: Using Forms Authentication without a Membership Provider
date: 2007-09-27 00:00:00 -0300
comments: off
---
<div class="note">This post was originally published at http://maxtoroq.wordpress.com/2007/09/27/using-forms-authentication-without-a-membership-provider/</div>

This might seem obvious to some, but surely wasn't to me. How to use Forms Authentication (that is, use the Login control, LoginStatus, etc) without a Membership provider?

ASP.NET comes with the built-in SqlMembershipProvider, which stores membership info in a SqlServer Express database (and saves it in ~/App_Data). The are a couple of reasons why you might not want to use it:

- You don’t have SqlServer installed in you production server.
- You only want to give access to a couple of trusting users, so a database is a bit too much.

So, how to prevent the usage of SqlMembershipProvider, or any configured provider? All we need to do is handle the `Login.Authenticate` event:

```csharp
<script runat="server">
   protected void Login1_Authenticate(object sender, AuthenticateEventArgs e) { 

      e.Authenticated = FormsAuthentication.Authenticate(Login1.UserName, Login1.Password);
   }
</script>

<asp:Login ID="Login1" runat="server" OnAuthenticate="Login1_Authenticate"/>
```

Since we are not using a Membership provider we can store our users credentials in the Web.config's `system.web/authentication/forms/credentials` section.

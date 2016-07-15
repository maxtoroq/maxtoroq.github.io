---
title: "Implementing a string.Format-like CreateCommand(string, params object[]) extension method"
date: 2007-10-29T21:21:18-04:00
tags: [ado.net]
originally_published_at: http://maxtoroq.wordpress.com/2007/10/29/implementing-a-stringformat-like-createcommandstring-params-object-extension-method/
comments: off
---
<div class="note">This extension is now included in the <a href="{{site.url}}/DbExtensions/">DbExtensions</a> library.</div>

When first trying out Linq to Sql I was very impressed with the simple and concise [ExecuteCommand][1] method. This method take a SQL string plus zero or more of objects that represent the values of the parameters you wish to use in the command. The cool thing is that instead of writing in the string the name of the parameters, you use `string.Format` syntax. Using this technique, a simple call for deleting the Product that has ProductID set to 5 would be:

```csharp
ExecuteCommand("DELETE FROM Products WHERE ProductID = {0}", 5);
```

One of the advantages for creating commands this way is that you can write provider-independent SQL, because you no longer need to use a marker like `@` or `?` in the command's text. Also, you don't need to assign the parameter names. Overall, it saves you a lot of repetitive code.

The only real problem for implementing this method is how to get the correct parameter marker for the provider being used. My solution depends on the specific ADO.NET provider implementations of the [GetParameterPlaceholder][2] and [GetParameterName][3] methods.

Here's the source code:

```csharp
public static DbCommand CreateCommand(this DbProviderFactory factory, string commandText, params object[] parameters) { 
   return factory.CreateCommand(null, commandText, parameters); 
}    

public static DbCommand CreateCommand(this DbProviderFactory factory, DbConnection connection, string commandText, params object[] parameters) {    

   if (commandText == null) throw new ArgumentNullException("commandText");    

   DbCommand cmd = factory.CreateCommand();    

   if (connection != null) 
      cmd.Connection = connection;    

   // No parameters passed 
   if (parameters == null || parameters.Length == 0) { 
      cmd.CommandText = commandText; 
      return cmd; 
   }    

   DbCommandBuilder builder = factory.CreateCommandBuilder(); 
   Type builderType = builder.GetType();    

   // These two lines are only to workaround some bad design in MySql Connector Net 
   builder.DataAdapter = factory.CreateDataAdapter(); 
   builder.DataAdapter.SelectCommand = cmd;    

   MethodInfo getParameterName = builderType.GetMethod("GetParameterName", BindingFlags.Instance | BindingFlags.NonPublic, Type.DefaultBinder, new Type[] { typeof(Int32) }, null); 
   MethodInfo getParameterPlaceholder = builderType.GetMethod("GetParameterPlaceholder", BindingFlags.Instance | BindingFlags.NonPublic, Type.DefaultBinder, new Type[] { typeof(Int32) }, null);    

   string[] paramPlaceholders = (string[])Array.CreateInstance(typeof(string), parameters.Length);    

   for (int i = 0; i < paramPlaceholders.Length; i++) {    

      DbParameter dbParam = cmd.CreateParameter(); 
      dbParam.ParameterName = (string)getParameterName.Invoke(builder, new object[] { i }); 
      dbParam.Value = parameters[i] ?? DBNull.Value; 
      cmd.Parameters.Add(dbParam);    

      paramPlaceholders[i] = (string)getParameterPlaceholder.Invoke(builder, new object[] { i }); 
   }    

   cmd.CommandText = string.Format(commandText, paramPlaceholders);    

   return cmd; 
}
```

[1]: http://msdn.microsoft.com/en-us/library/system.data.linq.datacontext.executecommand
[2]: http://msdn.microsoft.com/en-us/library/system.data.common.dbcommandbuilder.getparameterplaceholder
[3]: http://msdn.microsoft.com/en-us/library/eabya9tx

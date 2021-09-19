---
title: Changelog
---

## v6.x
See [Migrating to v6](migrating/to-v6.html) for more information about the changes in v6.

### v6.3.0 (planning)
- [x] Persistent complex properties
- [x] Debuggable binaries (SourceLink)
- [x] _ElseIf and _Else clause continuation methods

### v6.2.0
- Added: WITH and FROM overloads that accept SqlSet as subQuery
- Added: Treat SqlSet as subquery on SqlBuilder 
- Added #44: .NET Core 2.1 and .NET Standard 2.1 support
- Added: Database CRUD shortcuts

### v6.1.1
- Fixed: Contains and ContainsKey ignores current query

### v6.1.0
- Added #52: CommandTimeout setting
- Made Database.CreateCommand virtual
- Added Contains and ContainsKey to SqlSet
- Added #56: Support updates when using assigned keys

### v6.0.1
- Fixed wrong exception on Database.Execute when affected number was lower

### v6.0.0
- Added #48: SqlBuilder.CROSS_JOIN
- Added #46: Support explicit DbParameter on CreateCommand 
- Fixed #37: Cannot use multipart identifier in Table annotation
- Fixed #25: Setting container object when loading 1:n sometimes fails
- Added #24: Allow eager loading n:1 and 1:1 when loading 1:n

## v5.x

### v5.1.0
- Improved #30: Make SqlBuilder.cs a standalone file
- Fixed #31: SqlTable not handling array members properly
- Added #33: SqlServer 2008 support in SqlSet
- Fixed #35: SqlSet pagination fails against Oracle
- Moved documentation to source repository
- Moved samples databases to source repository

### v5.0.0
- Added #23: Support Select in SqlSet without specifying a result type
- Added #17: Support for Enum properties that map to text columns
- Added #15: SqlSet.Include function for query expansion (eager loading)
- Added SqlSet.Find extension method
- Fixed #18: Insert one-to-one associations (SqlTable.Add)
- Improved #6: SqlBuilder.Append(SqlBuilder) and SqlBuilder.JoinSql generate unnecessary extra whitespace

BREAKING CHANGES:

- Removed .NET 3.5 support
- Removed members deprecated in v4.x
- Removed DbConnection extension methods (use Database instead)
- Removed XML mapping
- Removed SqlSet constructors that take TextWriter (if you need profiling use Database)
- Removed SqlSet.Union
- Made all SqlSet's protected members internal
- Renamed SqlTable's Delete, DeleteKey and DeleteRange to Remove, RemoveKey and RemoveRange
- Removed Insert and InsertRange overloads with *deep* parameter, added DatabaseConfiguration.EnableInsertRecursion property to control recursion
- Renamed SqlTable's Insert and InsertRange to Add and AddRange

## v4.x

### v4.4.0
- Improved SqlTable, using subqueries only when necessary
- Added SQL.Param to workaround #10
- Deprecated SQL.ctor

### v4.3.0
- Implemented IDisposable on Database
- Convention-based DbConnection.GetProviderFactory fallback
- Removed AS keyword in FROM clause (to support Oracle)
- Deprecated SqlTable.Initialize
- SqlSet improvements:
  * Oracle support
  * Using subqueries only when necessary
  * Fixed #13: Skip().OrderBy() are applied in the same query instead of applying Skip() first
  * Deprecated DbConnection.Set and Database.Set, replaced by From
  * Can create set using table name only, e.g. From("Products")

### v4.2.0
- Mapping to dynamic objects, Map methods which do not need a Type argument, also supported by SqlSet. This feature requires .NET 4+
- New methods: SqlTable.ContainsKey, SqlCommandBuilder.UPDATE, SqlTable.DeleteRange, SqlTable.UpdateRange
- Deprecated SqlTable.InsertDeep, replaced by Insert(object, bool)
- Added SqlTable.InsertRange overloads with bool parameter
- Deprecated Database.InsertRange
- Deprecated SqlTable.DeleteById, replaced by DeleteKey

### v4.1.1
- Fixed #4: SqlSet&lt;T>.AsEnumerable() fails if T is a value type
- Fixed #2: Use parameter on SqlBuilder OFFSET(int) and LIMIT(int)
- Fixed #3: OleDbConnection and OdbcConnection do not override DbProviderFactory

### v4.1.0
- Mapping to constructor arguments
- Copied DbFactory methods to Database, marked DbFactory as obsolete
- Fixed #1: Skip Refresh after Insert on non-entity types

### v4.0.0
- New SqlSet API for making queries
- DataAccessObject split into Database, DatabaseConfiguration and SqlTable
- IDataRecord.Get{TypeName}(string) extension methods
- MapXml methods now return XmlReader, and take XmlMappingSettings parameter
- Unified extension methods class

<script>

   function textNodesUnder(el) {
      var n, a = [], walk = document.createTreeWalker(el, NodeFilter.SHOW_TEXT, null, false);
      while (n = walk.nextNode()) a.push(n);
      return a;
   }

   document.addEventListener('DOMContentLoaded', function () {

      var art = document.getElementsByTagName('article')[0];
      var textNodes = textNodesUnder(art);

      var notWsPattern = new RegExp("\\S");
      var issuePattern = new RegExp("#[0-9]+");

      Array.prototype.forEach.call(textNodes, function (node) {

         var text = node.textContent;
            
         if (notWsPattern.test(text)) {

            var matches = issuePattern.exec(text);

            if (matches) {

               Array.prototype.forEach.call(matches, function (s) {

                  var index = text.indexOf(s);
                  var beforeText = document.createTextNode(text.substr(0, index));
                  var newText = document.createTextNode(s);
                  var afterText = document.createTextNode(text.substr(index + s.length));

                  var anchorNode = document.createElement('a');
                  anchorNode.href = "{{ page.repository_url }}/issues/" + s.substr(1);
                  anchorNode.appendChild(newText);

                  var parentNode = node.parentNode;

                  parentNode.insertBefore(beforeText, node);
                  parentNode.insertBefore(anchorNode, node);
                  parentNode.insertBefore(afterText, node);
                  parentNode.removeChild(node);
               });
            }
         }
      });
   });
</script>

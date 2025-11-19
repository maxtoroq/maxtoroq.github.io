---
title: Changelog (v7)
---

### v7.0 (pre-release)
- Removed .NET Framework and .NET Standard targets
- String interpolation in all APIs that previously used composite formatting (SqlBuilder, SqlSet and others)
- Full Async APIs #51
- Full null reference type annotations #69
- Depending on System.Data.Common classes instead of System.Data interfaces
- Removed reflection based POCO mapping
- Removed Database's DefaultConnectionString and DefaultProviderInvariantName
- EnsureInTransaction is no longer System.Transactions aware
- EnsureInTransaction is now virtual
- Fixed #85: Database.Execute might start a transaction but not set it on the command
- Removed some CRUD shortcut methods from Database
- Using Microsoft.Data.SqlClient invariant name, and removed deprecated System.Data.SqlClient
- Using `SCOPE_IDENTITY()` in LastInsertIdCommand (SqlClient)
- Removed SQL Server CE defaults
- Changed parameters order on Database.Map(Type, SqlBuilder) to Map(SqlBuilder, Type)
- Renamed Database.From(SqlBuilder) to FromQuery
- Stopped escaping suffix on QuoteIdentifier
- QuoteIdentifier is no longer virtual
- SqlBuilder is now sealed
- Renamed SqlBuilder.Append(SqlBuilder) to AppendSql
- Renamed SqlBuilder.Insert(int, string) to InsertText
- Added AppendIf/AppendElseIf/AppendElse methods to SqlBuilder
- Fixed #87: VALUES clause should use comma as separator
- Changed parameters order on SqlSet.Select overloads
- Added SqlSet.Database property
- Fixed #88: Include uses wrong key column name when member name differs
- Include and IncludeMany methods, with typed lambda overloads
- IncludeMany must be used to load collections
- Return bool on SqlTable's Remove and RemoveKey
- Removed hiding Contains and ContainsKey methods from SqlTable and SqlTable&lt;T>
- Fixed #86: duplicate AddDescendants call for one-to-many associations
- Removed SqlCommandBuilder&lt;T>
- New DbExtensions-QE package


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

---
title: Changelog (v7)
---

### v7.0 (pre-release)
- Removed .NET Framework and .NET Standard targets
- String interpolation in all APIs that previously used composite formatting (SqlBuilder, SqlSet and others)
- Full Async APIs
- Full null reference type annotations
- Depending on System.Data.Common classes instead of System.Data interfaces
- Removed DefaultConnectionString and DefaultProviderInvariantName
- EnsureInTransaction is no longer System.Transactions aware
- Removed some CRUD shortcut methods (Database)
- Using Microsoft.Data.SqlClient invariant name, and removed deprecated System.Data.SqlClient
- Using `SCOPE_IDENTITY()` in LastInsertIdCommand (SqlClient)
- Removed SQL Server CE defaults
- Changed parameters order on Map(Type, SqlBuilder) to Map(SqlBuilder, Type)
- Renamed Append(SqlBuilder) to AppendSql
- Added AppendIf/AppendElseIf/AppendElse methods
- Changed parameters order on SqlSet.Select overloads
- Removed hiding Contains and ContainsKey methods from SqlTable and SqlTable&lt;T>


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

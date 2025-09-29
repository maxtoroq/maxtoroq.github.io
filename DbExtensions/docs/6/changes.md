---
title: Changelog (v6)
redirect_from: /DbExtensions/docs/changes.html
---

## v6.x
See [Migrating to v6](migrating-to-v6.md) for more information about the changes in v6.

### v6.4.0
- New cached compiled mapping implementation for POCO objects (to use set `Configuration.UseCompiledMapping` to `true`)
- Improved POCO mapping efficiency on property read/write/add and object instantiation
- New binaries for .NET Framework 4.7.2 and .NET 6.0

### v6.3.0
- Persistent complex properties
- Named arguments constructor mapping
- _ElseIf and _Else clause continuation methods
- SqlTable.Name property #82
- Debuggable binaries (SourceLink) and portable PDBs

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

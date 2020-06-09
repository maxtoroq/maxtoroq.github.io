document.addEventListener('DOMContentLoaded', function (event) {
   var pres = document.querySelectorAll('[data-highlight-lines]  code');
   pres.forEach(function(el) {
      var lines = el.innerHTML.split('\n');
      var nums = el.parentNode.getAttribute('data-highlight-lines')
         .split(' ')
         .map(function(n) { return Number.parseInt(n); });

      var hlLines = [];

      for (var n = 1; n <= lines.length; n++) {
         var l = lines[n - 1];
         if (nums.includes(n)) {
            hlLines.push('<mark>' + l + '</mark>');
         } else {
            hlLines.push(l);
         }
      }

      el.innerHTML = hlLines.join('\n');
   });
});

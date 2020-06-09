document.addEventListener('DOMContentLoaded', function (event) {
   var figs = document.querySelectorAll('[data-highlight-lines]');
   figs.forEach(function(el) {
      var code = el.querySelector('code');
      var lines = code.innerHTML.split('\n');
      var nums = el.getAttribute('data-highlight-lines')
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

      code.innerHTML = hlLines.join('\n');
   });
});

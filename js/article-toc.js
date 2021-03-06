document.addEventListener('DOMContentLoaded', function (event) {
   var headings = document.querySelectorAll('article h2');
   var items = [];
   var newItem;
   Array.prototype.forEach.call(headings, function (el, i) {
      if (el.offsetParent != null) {
         newItem = "<li>" + "<a href='#" + el.getAttribute('id') + "'>" + el.innerHTML + "</a>" + "</li>";
         items.push(newItem)
      }
   });
   if (items.length > 1) {
      var ToC = "<nav role='navigation' class='toc'><div><h3>In this article</h3><ul>";
      ToC += items.join('');
      ToC += "</ul></div></nav>";
      document.querySelector('article *[itemprop="articleBody"]').insertAdjacentHTML('afterbegin', ToC)
   }
});

---
title: Archive
feed: "/feed.xml"
---
<a href="{{ page.feed }}">feed</a>

{% for post in site.posts | reverse %}
   {% capture date %}{{ post.date }}{% endcapture %}
   {% capture this_year %}{{ date | date: "%Y" }}{% endcapture %}
   {% unless year == this_year %}
      {% assign year = this_year %}
         {% unless forloop.first %}
</ul>
	 {% endunless %}
<h2>{{ date | date: "%Y" }}</h2>
<ul>
   {% endunless %}
<li>
   <a href="{{ post.url }}">{{post.title}}</a>
</li>
{% endfor %}
</ul>

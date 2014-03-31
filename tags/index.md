---
layout: default
title: Tags
---

<h1>Tags</h1>

<ul>
{% for tag in site.tags %}
    <li style="font-size: {{ tag | last | size | times: 100 | divided_by: site.tags.size }}%">
        <a href="/{{ tag | first | slugize }}/">{{ tag | first }}</a>
    </li>
{% endfor %}
</ul>
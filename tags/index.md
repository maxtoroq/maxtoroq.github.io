---
layout: default
title: Tags
---

<h1>Tags</h1>

<ul>
{% for tag in site.tags.sort %}
    <li style="font-size: {{ tag | last | size | times: 100 | divided_by: site.tags.size | plus: 70 }}%">
        <a href="/{{ tag | first | slugize }}/">{{ tag | first }}</a>
    </li>
{% endfor %}
</ul>
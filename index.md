---
permalink: /
body_class: home
markdown_url: /profile.txt
---

{% assign portfolio = site.data.portfolio %}

<section class="hero home-hero" aria-labelledby="hero-title">
  <h1 id="hero-title">{{ site.title | escape }}</h1>
  <p class="hero-role">{{ portfolio.role | escape }}</p>
  <p class="hero-intro">{{ portfolio.intro | escape }}</p>
  <p class="hero-availability">{{ portfolio.availability | escape }}</p>
  <a class="contact-button" href="mailto:{{ site.email }}">Email me about a role</a>
  <section class="selected-work" id="work" aria-labelledby="work-title">
    <h2 class="section-title" id="work-title">Selected case studies</h2>
    <ul class="hero-outcomes" role="list">
      {% for item in portfolio.home.case_studies %}
      {% assign study = portfolio.work | where: 'id', item.study | first %}
      <li>
        <h3><a href="{{ study.url | relative_url }}">{{ item.title | default: study.title | escape }}</a></h3>
        <p class="case-result"><strong>{{ item.value | escape }}</strong> {{ item.label | escape }}</p>
        <p class="case-approach">{{ item.approach | escape }}</p>
      </li>
      {% endfor %}
    </ul>
    <a class="text-link" href="{{ '/work/' | relative_url }}">View all case studies</a>
  </section>
</section>

<section class="section" aria-labelledby="recognitions-title">
  <h2 class="section-title" id="recognitions-title">Open source &amp; recognitions</h2>
  <ul class="recognition-highlights" role="list">
    {% for entry in site.data.recognitions.entries %}
    {% if entry.highlight %}
    <li>
      <h3><a href="{{ '/recognitions/' | relative_url }}#{{ entry.id }}">{{ entry.title | escape }}</a></h3>
      <p>{{ entry.highlight | escape }}</p>
    </li>
    {% endif %}
    {% endfor %}
  </ul>
  <a class="text-link" href="{{ '/recognitions/' | relative_url }}">View all recognitions</a>
</section>

<section class="section leadership home-interests" id="leadership" aria-labelledby="leadership-title">
  <h2 class="section-title" id="leadership-title">How I lead engineering</h2>
  <p>{{ portfolio.home.leadership_intro | escape }}</p>
  <ul class="study-list" role="list">
    {% for study_id in portfolio.home.leadership %}
    {% assign study = portfolio.work | where: 'id', study_id | first %}
    <li>
      <h3><a href="{{ study.url | relative_url }}">{{ study.title | escape }}</a></h3>
      <p>{{ study.takeaway | escape }}</p>
    </li>
    {% endfor %}
  </ul>
</section>

<section class="section home-interests" id="ideas" aria-labelledby="ideas-title">
  <h2 class="section-title" id="ideas-title">Ideas I’d like to work on</h2>
  <ul class="study-list home-studies" role="list">
    {% for topic in portfolio.interests.topics %}
    <li>
      <h3>{{ topic.title | escape }}</h3>
      <div>
        <p>{{ topic.question | escape }}</p>
        {% if topic.example %}
        <p class="topic-example"><a href="{{ topic.example.url | relative_url }}">{{ topic.example.title | escape }}</a>. {{ topic.example.description | escape }}</p>
        {% endif %}
      </div>
    </li>
    {% endfor %}
  </ul>
</section>

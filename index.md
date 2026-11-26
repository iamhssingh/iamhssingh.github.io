---
description: Himanshu Shankar is a hands-on engineering leader building applied AI products, scaling production systems, and leading engineering teams.
permalink: /
body_class: home
markdown_url: /profile.txt
---

{% assign portfolio = site.data.portfolio %}
{% assign featured = portfolio.work | where: 'id', portfolio.home.featured | first %}

{% capture summary_prompt %}Read Himanshu Shankar’s portfolio starting at https://himanshus.com/llms.txt. Briefly summarize what he’s built, his strongest achievements, and what makes him stand out. Use concrete examples from his applied AI work and engineering leadership, and cite the case studies.

Then ask me: “What are you hiring for, building, or looking for help with?” Use my answer to assess where Himanshu fits and what I should ask him to clarify.{% endcapture %}
{% assign summary_query = summary_prompt | url_encode %}

<section class="hero home-hero" aria-labelledby="hero-title">
  <h1 id="hero-title">{{ site.title | escape }}</h1>
  <p class="hero-role">{{ portfolio.role | escape }}</p>
  <p class="hero-intro">{{ portfolio.intro | escape }}</p>
  <details class="quick-summary" data-quick-summary>
    <summary>Get a quick summary</summary>
    <div class="quick-summary-actions">
      <a href="https://chatgpt.com/?q={{ summary_query }}" rel="noopener noreferrer" target="_blank">Open in ChatGPT</a>
      <a href="https://claude.ai/new?q={{ summary_query }}" rel="noopener noreferrer" target="_blank">Open in Claude</a>
      <button type="button" data-copy-prompt hidden>Copy prompt</button>
    </div>
    <p class="quick-summary-status" role="status"></p>
    <textarea aria-label="Portfolio summary prompt" rows="6" readonly hidden>{{ summary_prompt | escape }}</textarea>
  </details>
</section>

<section class="section selected-work" id="work" aria-labelledby="work-title">
  <h2 class="section-title" id="work-title">Selected work</h2>
  <article class="featured-study">
    <div>
      <p class="eyebrow">{{ featured.title | escape }}</p>
      <h3><a href="{{ featured.url | relative_url }}">{{ featured.feature_title | escape }}</a></h3>
    </div>
    <p>{{ featured.summary | escape }}</p>
  </article>

  <ul class="study-list home-studies" aria-label="More selected work">
    {% for study_id in portfolio.home.supporting %}
    {% assign study = portfolio.work | where: 'id', study_id | first %}
    <li>
      <h3><a href="{{ study.url | relative_url }}">{{ study.title | escape }}</a></h3>
      <p>{{ study.result | escape }}</p>
    </li>
    {% endfor %}
  </ul>
  <a class="text-link" href="{{ '/work/' | relative_url }}">View all case studies</a>
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
  <p>{{ portfolio.interests.intro | escape }}</p>
  <ul class="study-list home-studies" role="list">
    {% for topic in portfolio.interests.topics %}
    <li>
      <h3>{{ topic.title | escape }}</h3>
      <p>{{ topic.question | escape }}</p>
    </li>
    {% endfor %}
  </ul>
  <div class="related-links">
    <a class="text-link" href="mailto:{{ site.email }}">Let’s talk</a>
    <a href="{{ '/projects/#offline-warranty' | relative_url }}">Read about offline warranty validation</a>
  </div>
</section>

# himanshus.com

The Jekyll source for Himanshu Shankar's personal portfolio, published through
GitHub Pages at [himanshus.com](https://himanshus.com).

The site is intentionally lightweight: Markdown, a custom Jekyll layout,
responsive CSS, and a small amount of progressive-enhancement JavaScript.

## Content architecture

- Jekyll and HTML are the website source. LaTeX is not used to render web pages.
- `himanshushankar/main.tex`, `himanshushankar/resume.cls`, and
  `himanshushankar/content/*.tex` are the editable résumé source and should be
  committed.
- `himanshushankar/main.pdf` is the published résumé linked from the website
  and should be committed because GitHub Pages does not compile LaTeX.
- LaTeX compiler output belongs in `himanshushankar/build/` and is ignored.

Build the résumé from the `himanshushankar` directory with:

```sh
latexmk -xelatex -outdir=build main.tex
```

After reviewing the result, copy the final PDF to `himanshushankar/main.pdf`
for publication.

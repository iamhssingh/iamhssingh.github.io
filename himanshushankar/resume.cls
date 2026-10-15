\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{resume}[2026/08/13 v1.4 DOCX-derived ATS resume class]

\LoadClass[10pt,letterpaper]{article}

\RequirePackage[
  letterpaper,
  top=0.50in,
  bottom=0.50in,
  left=0.60in,
  right=0.60in
]{geometry}
\RequirePackage{fontspec}
\RequirePackage{enumitem}
\RequirePackage{xcolor}
\RequirePackage{needspace}
\RequirePackage{xparse}
\RequirePackage[fixed]{fontawesome6}
\RequirePackage[unicode]{hyperref}

% ---------------------------------------------------------------------------
% Design tokens
% ---------------------------------------------------------------------------
\definecolor{resumeink}{HTML}{000000}
\definecolor{resumemuted}{HTML}{000000}
\definecolor{resumelink}{HTML}{0B57D0}

% Prefer Carlito (a metric-compatible, freely licensed Calibri substitute),
% and fall back to Arial when it is unavailable. Overleaf supplies Carlito;
% common desktop systems supply Arial, without hardcoded font-file paths.
\IfFontExistsTF{Carlito}
  {\setsansfont{Carlito}}
  {\setsansfont{Arial}}
\renewcommand{\familydefault}{\sfdefault}
\urlstyle{same}

\hypersetup{
  colorlinks=true,
  linkcolor=resumelink,
  urlcolor=resumelink
}

\newlength{\resumesectionbefore}
\newlength{\resumesectionafter}
\newlength{\resumeentrygap}
\newlength{\resumeskilllabelwidth}
\setlength{\resumesectionbefore}{1.28em plus 0.10em minus 0.06em}
\setlength{\resumesectionafter}{0.70em plus 0.06em minus 0.04em}
\setlength{\resumeentrygap}{0.68em plus 0.08em minus 0.04em}
\setlength{\resumeskilllabelwidth}{8.75em}

\pagestyle{empty}
\flushbottom
\setlength{\parindent}{0pt}
\setlength{\parskip}{0pt}
\setlength{\emergencystretch}{1.5em}
\clubpenalty=10000
\widowpenalty=10000
\displaywidowpenalty=10000
\hyphenpenalty=10000
\exhyphenpenalty=10000

\newlist{resumeitems}{itemize}{1}
\setlist[resumeitems]{
  leftmargin=1.18em,
  label=\textbullet,
  labelsep=0.42em,
  itemsep=0.14em plus 0.04em minus 0.02em,
  topsep=0.28em plus 0.06em minus 0.03em,
  parsep=0pt,
  partopsep=0pt
}

\NewDocumentEnvironment{cvitems}{}{%
  \begin{resumeitems}
}{%
  \end{resumeitems}
  \par\addvspace{\resumeentrygap}
}

% ---------------------------------------------------------------------------
% Named-key content API
%
% Every multi-field component uses descriptive keys rather than positional
% arguments. Content files therefore remain readable without remembering an
% argument index. Keys are documented again beside their values in content/.
% ---------------------------------------------------------------------------
\ExplSyntaxOn

% Allow annotated key blocks to contain blank lines for readability. LaTeX
% represents those blank lines as \par tokens; this helper normalizes them to
% spaces before the standard key parser sees the block.
\cs_generate_variant:Nn \keys_set:nn { nV }
\cs_new_protected:Npn \mahenresume_keys_set:nn #1#2
  {
    \tl_set:Nn \l_tmpa_tl { #2 }
    \tl_replace_all:Nnn \l_tmpa_tl { \par } { ~ }
    \keys_set:nV { #1 } \l_tmpa_tl
  }

% Identity keys: name, location, email, github-text, github-url,
% linkedin-text, linkedin-url.
\tl_new:N \g_mahenresume_name_tl
\tl_new:N \g_mahenresume_location_tl
\tl_new:N \g_mahenresume_email_tl
\tl_new:N \g_mahenresume_github_text_tl
\tl_new:N \g_mahenresume_github_url_tl
\tl_new:N \g_mahenresume_linkedin_text_tl
\tl_new:N \g_mahenresume_linkedin_url_tl
\keys_define:nn { mahenresume / identity }
  {
    name          .tl_gset:N = \g_mahenresume_name_tl,
    location      .tl_gset:N = \g_mahenresume_location_tl,
    email         .tl_gset:N = \g_mahenresume_email_tl,
    github-text   .tl_gset:N = \g_mahenresume_github_text_tl,
    github-url    .tl_gset:N = \g_mahenresume_github_url_tl,
    linkedin-text .tl_gset:N = \g_mahenresume_linkedin_text_tl,
    linkedin-url  .tl_gset:N = \g_mahenresume_linkedin_url_tl
  }
\NewDocumentCommand{\resumeidentity}{+m}
  { \mahenresume_keys_set:nn { mahenresume / identity } { #1 } }

% Metadata keys: title, author, subject, keywords.
\tl_new:N \l_mahenresume_metadata_title_tl
\tl_new:N \l_mahenresume_metadata_author_tl
\tl_new:N \l_mahenresume_metadata_subject_tl
\tl_new:N \l_mahenresume_metadata_keywords_tl
\keys_define:nn { mahenresume / metadata }
  {
    title    .tl_set:N = \l_mahenresume_metadata_title_tl,
    author   .tl_set:N = \l_mahenresume_metadata_author_tl,
    subject  .tl_set:N = \l_mahenresume_metadata_subject_tl,
    keywords .tl_set:N = \l_mahenresume_metadata_keywords_tl
  }
\NewDocumentCommand{\resumemetadata}{+m}
  {
    \mahenresume_keys_set:nn { mahenresume / metadata } { #1 }
    \hypersetup
      {
        pdftitle    = { \tl_use:N \l_mahenresume_metadata_title_tl },
        pdfauthor   = { \tl_use:N \l_mahenresume_metadata_author_tl },
        pdfsubject  = { \tl_use:N \l_mahenresume_metadata_subject_tl },
        pdfkeywords = { \tl_use:N \l_mahenresume_metadata_keywords_tl }
      }
  }

% Skill keys: label, items.
\tl_new:N \l_mahenresume_skill_label_tl
\tl_new:N \l_mahenresume_skill_items_tl
\keys_define:nn { mahenresume / skill }
  {
    label .tl_set:N = \l_mahenresume_skill_label_tl,
    items .tl_set:N = \l_mahenresume_skill_items_tl
  }
\NewDocumentCommand{\skillcategory}{+m}
  {
    \group_begin:
    \mahenresume_keys_set:nn { mahenresume / skill } { #1 }
    \noindent
    {\fontsize{10}{11.9}\selectfont
      \textbf{\tl_use:N \l_mahenresume_skill_label_tl\c_colon_str}\enspace
      \tl_use:N \l_mahenresume_skill_items_tl
    }\par
    \vspace{0.10em}
    \group_end:
  }

% Experience keys: company, dates, role, details.
\tl_new:N \l_mahenresume_experience_company_tl
\tl_new:N \l_mahenresume_experience_dates_tl
\tl_new:N \l_mahenresume_experience_role_tl
\tl_new:N \l_mahenresume_experience_details_tl
\keys_define:nn { mahenresume / experience }
  {
    company .tl_set:N = \l_mahenresume_experience_company_tl,
    dates   .tl_set:N = \l_mahenresume_experience_dates_tl,
    role    .tl_set:N = \l_mahenresume_experience_role_tl,
    details .tl_set:N = \l_mahenresume_experience_details_tl
  }
\NewDocumentCommand{\experience}{+m}
  {
    \group_begin:
    \tl_clear:N \l_mahenresume_experience_details_tl
    \mahenresume_keys_set:nn { mahenresume / experience } { #1 }
    \Needspace{5\baselineskip}
    {\fontsize{11}{12.8}\selectfont\bfseries\color{resumeink}
      \tl_use:N \l_mahenresume_experience_company_tl}
    \hfill
    {\fontsize{10}{11.8}\selectfont\itshape\color{resumemuted}
      \tl_use:N \l_mahenresume_experience_dates_tl}\par
    \nobreak\vspace{0.02em}
    {\fontsize{10}{11.8}\selectfont\itshape\color{resumemuted}
      \tl_use:N \l_mahenresume_experience_role_tl}
    \tl_if_blank:VF \l_mahenresume_experience_details_tl
      {
        \hfill
        {\fontsize{9.4}{11.1}\selectfont\upshape\color{resumeink}
          \mbox{\tl_use:N \l_mahenresume_experience_details_tl}}
      }
    \par
    \nobreak\vspace{0.12em}
    \group_end:
  }

% Inline detail keys: label, value.
\tl_new:N \l_mahenresume_detail_label_tl
\tl_new:N \l_mahenresume_detail_value_tl
\keys_define:nn { mahenresume / detail }
  {
    label .tl_set:N = \l_mahenresume_detail_label_tl,
    value .tl_set:N = \l_mahenresume_detail_value_tl
  }
\NewDocumentCommand{\cvdetail}{+m}
  {
    \group_begin:
    \mahenresume_keys_set:nn { mahenresume / detail } { #1 }
    \textbf{\tl_use:N \l_mahenresume_detail_label_tl\c_colon_str}
    \c_space_tl
    \tl_use:N \l_mahenresume_detail_value_tl
    \group_end:
  }
\NewDocumentCommand{\cvseparator}{}{\enspace\textbar\enspace}

% Publication keys: title, venue, url, link-text.
\tl_new:N \l_mahenresume_publication_title_tl
\tl_new:N \l_mahenresume_publication_venue_tl
\tl_new:N \l_mahenresume_publication_url_tl
\tl_new:N \l_mahenresume_publication_link_text_tl
\keys_define:nn { mahenresume / publication }
  {
    title     .tl_set:N = \l_mahenresume_publication_title_tl,
    venue     .tl_set:N = \l_mahenresume_publication_venue_tl,
    url       .tl_set:N = \l_mahenresume_publication_url_tl,
    link-text .tl_set:N = \l_mahenresume_publication_link_text_tl,
    link-text .initial:n = { Paper~Link }
  }
\NewDocumentCommand{\cvpublication}{+m}
  {
    \group_begin:
    \mahenresume_keys_set:nn { mahenresume / publication } { #1 }
    \Needspace{3\baselineskip}
    {\fontsize{11}{12.8}\selectfont\bfseries
      \tl_use:N \l_mahenresume_publication_title_tl}\par
    {\fontsize{10}{11.8}\selectfont\itshape
      \tl_use:N \l_mahenresume_publication_venue_tl}
    \hfill
    {\fontsize{10}{11.8}\selectfont\upshape
      \href{\tl_use:N \l_mahenresume_publication_url_tl}
        {\tl_use:N \l_mahenresume_publication_link_text_tl}}\par
    \addvspace{0.48em}
    \group_end:
  }

% Education keys: institution, location, degree, dates, details.
\tl_new:N \l_mahenresume_education_institution_tl
\tl_new:N \l_mahenresume_education_location_tl
\tl_new:N \l_mahenresume_education_degree_tl
\tl_new:N \l_mahenresume_education_dates_tl
\tl_new:N \l_mahenresume_education_details_tl
\keys_define:nn { mahenresume / education }
  {
    institution .tl_set:N = \l_mahenresume_education_institution_tl,
    location    .tl_set:N = \l_mahenresume_education_location_tl,
    degree      .tl_set:N = \l_mahenresume_education_degree_tl,
    dates       .tl_set:N = \l_mahenresume_education_dates_tl,
    details     .tl_set:N = \l_mahenresume_education_details_tl
  }
\NewDocumentCommand{\cveducation}{+m}
  {
    \group_begin:
    \mahenresume_keys_set:nn { mahenresume / education } { #1 }
    \Needspace{5\baselineskip}
    \textbf{\tl_use:N \l_mahenresume_education_institution_tl}
    \hfill\tl_use:N \l_mahenresume_education_location_tl\par
    \nobreak\vspace{0.02em}
    \textit{\tl_use:N \l_mahenresume_education_degree_tl}
    \hfill\textit{\tl_use:N \l_mahenresume_education_dates_tl}\par
    \nobreak\vspace{0.18em}
    \tl_use:N \l_mahenresume_education_details_tl\par
    \group_end:
  }

% Plain-Latex accessors used by the fixed-rendering header below.
\cs_new:Npn \resumenamevalue         { \tl_use:N \g_mahenresume_name_tl }
\cs_new:Npn \resumelocationvalue     { \tl_use:N \g_mahenresume_location_tl }
\cs_new:Npn \resumeemailvalue        { \tl_use:N \g_mahenresume_email_tl }
\cs_new:Npn \resumegithubtextvalue   { \tl_use:N \g_mahenresume_github_text_tl }
\cs_new:Npn \resumegithuburlvalue    { \tl_use:N \g_mahenresume_github_url_tl }
\cs_new:Npn \resumelinkedintextvalue { \tl_use:N \g_mahenresume_linkedin_text_tl }
\cs_new:Npn \resumelinkedinurlvalue  { \tl_use:N \g_mahenresume_linkedin_url_tl }

\ExplSyntaxOff

% ---------------------------------------------------------------------------
% Fixed-rendering components
% ---------------------------------------------------------------------------
\NewDocumentCommand{\makecvheader}{}{%
  \begin{center}
    {\fontsize{22}{24.5}\selectfont\bfseries\color{resumeink}
      \resumenamevalue}\par
    \vspace{0.18em}
    {\fontsize{10}{11.5}\selectfont\bfseries
      \resumelocationvalue
      \enspace\textcolor{resumemuted}{\textbullet}\enspace
      \href{mailto:\resumeemailvalue}{\resumeemailvalue}
      \enspace\textcolor{resumemuted}{\textbullet}\enspace
      \href{\resumegithuburlvalue}{\faGithub\hspace{0.28em}\resumegithubtextvalue}
      \enspace\textcolor{resumemuted}{\textbullet}\enspace
      \href{\resumelinkedinurlvalue}{\faLinkedin\hspace{0.28em}\resumelinkedintextvalue}}
  \end{center}
  \par\addvspace{0.04em}
}

\NewDocumentCommand{\cvsection}{m}{%
  \par\addvspace{\resumesectionbefore}
  \Needspace{3\baselineskip}
  {\centering
    \fontsize{12}{14}\selectfont\bfseries\color{resumeink}
    \MakeUppercase{#1}\par}
  \nobreak\vspace{\resumesectionafter}
}

\AtBeginDocument{%
  \fontsize{10}{13.0}\selectfont
  \raggedright
  \setlength{\parfillskip}{0pt plus 1fil}
}

\endinput

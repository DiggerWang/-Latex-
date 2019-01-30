%cls文档说明：
%在该文档中，设置了许多排版设置，大部分作者已经加了标注，如有需要可自行修改
%为了方便大家修改，这里简要说明一下有些函数的含义：
%（1）\newcommand：新生成命令，在cls文件中设置后，可在tex中直接使用
%（2）\renewcommand：重新修改命令，把latex原本存在的命令进行功能修改
%（3）\setallmainfonts：设置全文字体
%（4）\titleformat：设置标题格式
%了解上述基本命令后，就可以对一些主要的参数设置进行修改
%
%本文件重新定义过环境，如果begin{}的时候失败，可以对照cls文件中自定义的环境
%如有需要，也可以使用cls中自定义的方法



\ProvidesClass{xmuthesis}

\LoadClass[12pt, openany, twoside]{book}

\RequirePackage[usenames,dvipsnames,svgnames,table]{xcolor}
\RequirePackage{graphicx}
\RequirePackage[font={doublespacing, small}, labelsep=space, skip=6pt]{caption}

\RequirePackage{array}
\RequirePackage{setspace}
\RequirePackage{multirow}
\RequirePackage[tbtags]{amsmath}
\RequirePackage{amssymb}
\RequirePackage{amsthm}
\RequirePackage{lmodern}
\RequirePackage{mathspec}
\RequirePackage{fontspec}
\RequirePackage{bm}

\RequirePackage{xeCJK}
\RequirePackage{ifplatform}

%设置字体
\newcommand{\overallfont}{\fontsize{14pt}}
\ifwindows
  \setallmainfonts{Times New Roman}
  \setCJKmainfont{SimSun}
  \newCJKfontfamily{\heiti}{SimHei}
\else
\ifmacosx
  \setallmainfonts[BoldFont = SimHei]{SimSun}
  \setCJKmainfont[BoldFont = SimHei]{SimSun}
  \newCJKfontfamily{\heiti}{SimHei}
\else
  \setCJKmainfont{simsun.ttc}
  \newCJKfontfamily{\heiti}{simhei.ttf}
  \setallmainfonts[
    BoldFont=timesbd.ttf,
    ItalicFont=timesi.ttf,
    BoldItalicFont=timesbi.ttf,
  ]{times.ttf}
\fi
\fi

% value > 0
\def\xeCJKembold{0.4}

% hack into xeCJK, you don't need to understand it
\def\saveCJKnode{\dimen255\lastkern}
\def\restoreCJKnode{\kern-\dimen255\kern\dimen255}

% save old definition of \CJKsymbol and \CJKpunctsymbol for CJK output
\let\CJKoldsymbol\CJKsymbol
\let\CJKoldpunctsymbol\CJKpunctsymbol

% apply pdf literal fake bold
\def\CJKfakeboldsymbol#1{%
  \special{pdf:literal direct 2 Tr \xeCJKembold\space w}%
  \CJKoldsymbol{#1}%
  \saveCJKnode
  \special{pdf:literal direct 0 Tr}%
  \restoreCJKnode}
\def\CJKfakeboldpunctsymbol#1{%
  \special{pdf:literal direct 2 Tr \xeCJKembold\space w}%
  \CJKoldpunctsymbol{#1}%
  \saveCJKnode
  \special{pdf:literal direct 0 Tr}%
  \restoreCJKnode}
\newcommand\CJKfakebold[1]{%
  \let\CJKsymbol\CJKfakeboldsymbol
  \let\CJKpunctsymbol\CJKfakeboldpunctsymbol
  #1%
  \let\CJKsymbol\CJKoldsymbol
  \let\CJKpunctsymbol\CJKoldpunctsymbol}


\RequirePackage{zhnumber}
\RequirePackage{pifont}

\definecolor{darkblue}{rgb}{0.0, 0.0, 0.55}
\RequirePackage[hyperfootnotes=false, bookmarksdepth=4]{hyperref}
\hypersetup{
  colorlinks=true,
  citecolor=black,
  linkcolor=black,
  urlcolor=black
}

\makeatletter % undo the wrong changes made by mathspec
\let\RequirePackage\original@RequirePackage
\let\usepackage\RequirePackage
\makeatother
\RequirePackage[nopostdot]{glossaries}
\renewcommand*{\glossarypreamble}{\vspace{-9pt}}

\newacronymstyle{acronym-uestc}{
  \ifglshaslong{\glslabel}{\glsgenacfmt}{\glsgenentryfmt}
}{
  \renewcommand*{\GenericAcronymFields}{
    first={\the\glslongtok\space\protect\paren{\the\glsshorttok}},
    description={\the\glslongtok}}
  \renewcommand*{\genacrfullformat}[2]{%
    \glsentrydesc{##1}~(\glsentrylong{##1},\space%
    \glsentryshort{##1})%
  }
  \renewcommand*{\acronymentry}[1]{%
    \acronymfont{\glsentryshort{##1}}%
  }
}
\setacronymstyle{acronym-uestc}

\newglossarystyle{long-uestc}{
  \renewenvironment{theglossary}%
    {\begin{longtable}{lp{.7\textwidth}}}%
    {\end{longtable}}%

  \renewcommand*{\glossaryheader}{}%
  \renewcommand*{\glsgroupheading}[1]{}%
  \renewcommand{\glossentry}[2]{
    \glsentryitem{##1}\glstarget{##1}{\glossentryname{##1}} &
    \ifglshaslong{##1}{\glsentrylong{##1}\ifglshasdesc{##1}{, \glsentrydesc{##1}}{}}
    {\glsentrydesc{##1}} \\
  }
  \renewcommand*{\subglossentry}[3]{
  \glossentry{##2}{##3}}
}

\defglsentryfmt{%
  \ifglshaslong{\glslabel}{%
    \glsgenacfmt%
  }{%
    \ifglsused{\glslabel}{%
      \glsgenentryfmt%
    }{%
      \glsgenentryfmt%
    }%
  }%
}

\newcommand{\thesisglossarylist}{
  \newpage
  \fancyhf{}
  \fancyhead[C]{\fontsize{10.5pt}{12.6pt}\selectfont 缩略词表}
  \fancyfoot[CE,CO]{\fontsize{9pt}{10.8pt}\selectfont\arabic{pseudopage}}
  \setlength\glsdescwidth{.7\textwidth}
  \printglossary[style=long-uestc, title={\protect\centering 缩略词表}, nonumberlist, nogroupskip]
}
\makeglossaries

\RequirePackage{standalone}
\RequirePackage{indentfirst}
\RequirePackage{calc}
\RequirePackage{float}
\RequirePackage{fancyvrb}
\RequirePackage{fancyhdr}
\RequirePackage{titlesec}
\RequirePackage{setspace}
\RequirePackage{cite}
\RequirePackage{enumitem}
\RequirePackage{algorithm2e}
\RequirePackage{etoolbox}
\RequirePackage{newfloat}
\RequirePackage[resetlabels]{multibib}
\RequirePackage[nottoc]{tocbibind}
\RequirePackage{everypage}
\RequirePackage{ifoddpage}


%设置字体格式
\newcommand{\titleone}{
    \fontsize{16pt}{16pt}
    \heiti
    \renewcommand{\CJKglue}{\hskip 0.4cm}
}
\newcommand{\titletwo}{
    \fontsize{14pt}{14pt}
    \heiti
    \renewcommand{\CJKglue}{\hskip 0.0cm}
}

\let\algorithm\relax
\let\endalgorithm\relax
\expandafter\let\csname algorithm*\endcsname\relax
\expandafter\let\csname endalgorithm*\endcsname\relax
\let\listofalgorithms\relax

% Define the new algorithm environment
\DeclareFloatingEnvironment{algorithm}

\makeatletter
% Definition for the style ruled
% First add the rules enclosing the captiom
\DeclareCaptionFormat{algrule}{%
  {\@hangfrom{#1#2}%
     \doublespacing
     \small
     \advance\caption@parindent\hangindent
     \advance\caption@hangindent\hangindent
     \caption@@par#3\par}% 
}

% Apply the new format to the algorithm environment
\captionsetup[algorithm]{format=algrule}

\makeatletter

\renewcommand{\algorithmname}{算法}
\renewcommand{\thealgorithm}{\arabic{chapter}-\arabic{algorithm}}
\captionsetup[algorithm]{aboveskip=6pt}
\AtBeginEnvironment{algorithm}{\vspace{6pt}}

\graphicspath{{./pic/}}

\RequirePackage[titles, subfigure]{tocloft}
\RequirePackage{subfigure}


\urlstyle{rm}
\raggedbottom

\renewcommand{\contentsname}{目\hspace{6pt}录}
\renewcommand{\bibname}{参考文献}
\renewcommand{\figurename}{图}
\renewcommand{\tablename}{表}
\renewcommand{\listfigurename}{图目录}
\renewcommand{\listtablename}{表目录}

\newcommand{\thesisfigurelist}{
    \newpage
  \fancyhf{}
  \fancyhead[C]{\fontsize{10.5pt}{12.6pt}\selectfont 图目录}
  \fancyfoot[CE,CO]{\fontsize{9pt}{10.8pt}\selectfont\arabic{pseudopage}}
  \renewcommand{\cftfigpresnum}{图}
  \addtolength{\cftfignumwidth}{12pt}
  \addtocontents{toc}{\protect\setcounter{tocdepth}{-1}} 
  \listoffigures
}
\newcommand{\thesistablelist}{
    \newpage
  \fancyhf{}
  \fancyhead[C]{\fontsize{10.5pt}{12.6pt}\selectfont 表目录}
  \fancyfoot[CE,CO]{\fontsize{9pt}{10.8pt}\selectfont\arabic{pseudopage}}
  \renewcommand{\cfttabpresnum}{表}
  \addtolength{\cfttabnumwidth}{12pt}
  \addtocontents{toc}{\protect\setcounter{tocdepth}{-1}} 
  \listoftables
}

\RequirePackage[a4paper, inner=3cm, outer=3cm, top=3cm,
bottom=3cm, bindingoffset=0cm]{geometry}
\setlength{\headheight}{15pt}

\pagestyle{fancy}
\linespread{1.5} %1.5倍行距
\setlength\parindent{2em} %首行缩进2字符 
%标题间距
\titlespacing{\chapter}{0pt}{0pt}{18pt}
\titlespacing{\section}{0pt}{18pt}{6pt}
\titlespacing{\subsection}{0pt}{12pt}{6pt}
\titlespacing{\subsubsection}{0pt}{12pt}{6pt}

%图片、公式等编号格式
\renewcommand\thechapter{第\zhnumber{\arabic{chapter}}章}
\renewcommand\thesection{\arabic{chapter}.\arabic{section}}
\renewcommand{\theequation}{\arabic{chapter}-\arabic{equation}}
\renewcommand{\thetable}{\arabic{chapter}-\arabic{table}}
\renewcommand{\thefigure}{\arabic{chapter}-\arabic{figure}}


\captionsetup{format=hang}
\captionsetup{width=\textwidth - 42pt}
\captionsetup[figure]{aboveskip=6pt,belowskip=0pt}
\captionsetup[table]{belowskip=6pt}
\setlength{\extrarowheight}{5pt}
\setlength{\subfigcapskip}{0pt}
\setlength{\intextsep}{9pt}

\makeatletter
\AtBeginEnvironment{figure}{
  \def\@floatboxreset{\centering}
}
\makeatother

\makeatletter
\AtBeginEnvironment{table}{
  \def\@floatboxreset{\centering}
}
\makeatother
\AtBeginEnvironment{tabular}{\small}

\makeatletter
\renewcommand{\p@subfigure}{\arabic{chapter}-\arabic{figure}}
\makeatother

\newcommand{\chinesecolon}{\char"FF1A}
\newcommand{\chinesespace}{\char"3000}
\newcommand{\chineseperiod}{\char"3002}
\newcommand{\chinesequestion}{\char"FF1F}
\newcommand{\chineseexclamation}{\char"FF01}
\newcommand{\chineseecomma}{\char"FF0C}
\newcommand{\chinesesemicolon}{\char"FF1B}
\newcommand{\chineseleftparenthesis}{\char"FF08}
\newcommand{\chineserightparenthesis}{\char"FF09}

\setcounter{secnumdepth}{4}
\setcounter{tocdepth}{4}

%设置标题格式
\titleformat{\chapter}[block]
  {\centering\fontsize{15pt}{15pt}\selectfont\heiti\thispagestyle{fancy}}{\thechapter}{7.5pt}{}
  
\titleformat{\section}[block]
  {\fontsize{14pt}{14pt}\selectfont\heiti}
  {\thesection}{7pt}{}
  
\titleformat{\subsection}[block]
  {\fontsize{14pt}{14pt}\selectfont\heiti}
  {\thesubsection}{7pt}{}

\titleformat{\subsubsection}[block]
  {\fontsize{12pt}{12pt}\selectfont\heiti}
  {\thesubsubsection}{6pt}{}


\RequirePackage[hang]{footmisc}
\addtolength{\footnotesep}{0pt}
\setlength{\footnotemargin}{13.5pt}

\renewcommand{\footnotesize}{\fontsize{9pt}{10.8pt}\selectfont}
\renewcommand{\small}{\fontsize{10.5pt}{12.6pt}\selectfont}
\renewcommand\footnotelayout{\fontsize{9}{11.7}\selectfont}

\renewcommand{\thefootnote}{\ifcase\value{footnote}\or\ding{172}\or
\ding{173}\or\ding{174}\or\ding{175}\or\ding{176}\or\ding{177}\or
\ding{178}\or\ding{179}\or\ding{180\or\ding{181}}\fi}

\renewcommand{\footnoterule}{\vfill\noindent\vspace{0.9mm}\hspace{27pt}\rule{5.05cm}{0.02cm}\vspace*{2.6pt}}

\makeatletter
\def\@makefntext #1{
  \ifFN@hangfoot 
      \bgroup \setbox \@tempboxa \hbox {
          \ifdim
        \footnotemargin >0pt \hb@xt@ 
                \footnotemargin {\hbox { \normalfont \@thefnmark}\hss }
            \else 
              \hbox { \normalfont \@thefnmark} 
      \fi 
    }
        \leftmargin \wd \@tempboxa 
        \rightmargin \z@ \linewidth \columnwidth 
          \advance \linewidth -\leftmargin\parshape \@ne 
    \leftmargin \linewidth \footnotesize \@setpar {{\@@par }}
    \leavevmode \llap {\box \@tempboxa }\parskip 
        \hangfootparskip \relax \parindent
    \hangfootparindent \relax 
        \else 
          \parindent 1em \noindent 
            \ifdim 
                \footnotemargin >\z@ \hb@xt@ 
                \footnotemargin {\hss \hbox { \normalfont \@thefnmark} }
            \else
        \ifdim \footnotemargin =\z@ 
                    \llap {\hbox { \normalfont \@thefnmark} }
                \else
          \llap {\hb@xt@ -\footnotemargin {\hbox { \normalfont \@thefnmark} \hss }}
        \fi 
            \fi
    \fi 
        \footnotelayout #1\ifFN@hangfoot \par \egroup 
  \fi
}
\makeatother

%页码计数器
\newcounter{pseudopage}
\setcounter{pseudopage}{-1}
\AddEverypageHook{\stepcounter{pseudopage}}


\newcommand\blankpage{%
  \newpage
  \null
  \thispagestyle{empty}%
  \addtocounter{pseudopage}{-1}%
  \newpage
}

%中文摘要
\newenvironment{chineseabstract}{
    \chapter*{摘\chinesespace 要}
    \thispagestyle{fancy}
    \fancyhead[C]{\fontsize{10.5pt}{12.6pt}\selectfont 摘要}
    \fancyfoot[CE,CO]{\fontsize{9pt}{10.8pt}\selectfont }
}{
  \checkoddpage
  \ifoddpage
      \newpage
    \fi
}

%中文关键词
\newcommand{\chinesekeyword}[1]{
  \vspace{\baselineskip}
  \noindent
    \begin{minipage}[t]{48pt}
      \noindent\CJKfakebold{关键词\chinesecolon}
    \end{minipage}
    \begin{minipage}[t]{\linewidth - 48pt}
      #1
    \end{minipage}
}
  
\newenvironment{englishabstract}{
  \chapter*{\bfseries ABSTRACT}
    \thispagestyle{fancy}
    \fancyhead[C]{\fontsize{10.5pt}{12.6pt}\selectfont ABSTRACT}
}{
  \checkoddpage
  \ifoddpage
      \blankpage
    \else
      \newpage
    \fi
}
  
\newcommand{\englishkeyword}[1]{
  \vspace{\baselineskip}
  \noindent\begin{minipage}[t]{2.1cm}
      \noindent\textbf{Keywords:}
    \end{minipage}
    \begin{minipage}[t]{
      \linewidth - 2.1cm}
        #1
    \end{minipage}
}


\AddEverypageHook{\addtocontents{toc}{
  \protect\cftsetpnumwidth{\widthof{\thepage}-1pt}
}}

\AddEverypageHook{\addtocontents{lof}{
  \protect\cftsetpnumwidth{\widthof{\thepage}-1pt}
}}

\AddEverypageHook{\addtocontents{lot}{
  \protect\cftsetpnumwidth{\widthof{\thepage}-1pt}
}}

\tocloftpagestyle{fancy}
\renewcommand{\cftchappagefont}{\normalfont}
\renewcommand\cftchapleader{\cftdotfill{\cftdotsep}}

\renewcommand{\cftdotsep}{0.4}

\setlength{\cftbeforetoctitleskip}{0pt}
\setlength{\cftaftertoctitleskip}{18pt}
\setlength{\cftbeforechapskip}{0pt}

\addtolength{\cftchapnumwidth}{25pt}

\cftsetindents{section}{21pt}{22pt}
\cftsetindents{subsection}{44pt}{31pt}
\cftsetindents{subsubsection}{76pt}{41pt}

\renewcommand{\cfttoctitlefont}{\fontsize{15pt}{15pt}\selectfont\heiti}
\renewcommand\cftchapfont{\heiti}

\newcommand{\chinesedegreename}{本科}
\DeclareOption{bachelor}{
  \renewcommand{\chinesedegreename}{本科}
}

\DeclareOption{master}{
  \renewcommand{\chinesedegreename}{硕士}
}

\DeclareOption{doctor}{
  \renewcommand{\chinesedegreename}{博士}
}

\ProcessOptions\relax

\newcommand{\standardhead}{
  \fancyhf{}
  \fancyhead[CO]{\fontsize{10.5pt}{12.6pt}\selectfont\leftmark}
  \fancyhead[CE]{\fontsize{10.5pt}{12.6pt}\selectfont \chinesedegreename{}毕业论文（设计）}
  \fancyfoot[CE,CO]{\fontsize{9pt}{10.8pt}\selectfont\thepage}
}

%正文页眉页脚格式
\pretocmd{\tableofcontents}{
  \fancyhf{}
  \fancyhead[C]{\fontsize{10.5pt}{12.6pt}\selectfont 面向非结构化企业指标信息的智能处理和可视分析}
  \fancyfoot[CE,CO]{\fontsize{9pt}{10.8pt}\selectfont\arabic{pseudopage}}
}{}{}

\newcommand{\thesistableofcontents}{
    \tableofcontents
}

\renewcommand{\chaptermark}[1]{\markboth{第\zhnumber{\arabic{chapter}}章 \hspace{5.25pt}#1}{}}

\newcommand{\thesisacknowledgement}{
  \renewcommand\thesection{\arabic{section}}
  \addtocontents{toc}{\protect\setcounter{tocdepth}{0}} 
  \setcounter{section}{0}
  \chapter*{致\hspace{12pt}谢}
  \addcontentsline{toc}{chapter}{致\hspace{12pt}谢}
  \markboth{致谢}{致谢}
  \thispagestyle{fancy}
}

\newcommand{\thesischapterexordium}{
  \checkoddpage
  \ifoddpage
      \blankpage
    \else
      \newpage
  \fi
    \newpage
  \addtocontents{toc}{\protect\setcounter{tocdepth}{4}} 
  \standardhead
  \pagenumbering{arabic}
  \setcounter{page}{1}
  \chapter{绪\hspace{6pt}论}
    \chaptermark{绪论}
}

%附录命令
\newcommand{\thesisappendix}{
  \chapter*{附\chinesespace 录}
    \setcounter{section}{0}
    \addcontentsline{toc}{chapter}{附录}
    \markboth{附录}{附录}
    \thispagestyle{fancy}
    \renewcommand{\theequation}{a-\arabic{equation}}
    \renewcommand{\thetable}{a-\arabic{table}}
    \renewcommand{\thefigure}{a-\arabic{figure}}
    \fancyhead[C]{\fontsize{10.5pt}{12.6pt}\selectfont 附录}
}


%引用命令
\newcommand{\thesistranslationoriginal}{
  \chapter*{外文资料原文}
    \setcounter{section}{0}
    \addcontentsline{toc}{chapter}{外文资料原文}
    \markboth{外文资料原文}{外文资料原文}
    \thispagestyle{fancy}
    \renewcommand{\theequation}{\arabic{equation}}
    \renewcommand{\thetable}{\arabic{table}}
    \renewcommand{\thefigure}{\arabic{figure}}
    \renewcommand{\figurename}{Figure}
    \renewcommand{\tablename}{Table}
}

\newcommand{\thesistranslationchinese}{
  \chapter*{外文资料译文}
    \setcounter{section}{0}
    \addcontentsline{toc}{chapter}{外文资料译文}
    \markboth{外文资料译文}{外文资料译文}
    \thispagestyle{fancy}
    \renewcommand{\theequation}{\arabic{equation}}
    \renewcommand{\thetable}{\arabic{table}}
    \renewcommand{\thefigure}{\arabic{figure}}
    \renewcommand{\figurename}{图}
    \renewcommand{\tablename}{表}
}

\makeatletter
\renewcommand{\@biblabel}[1]{[#1]\hfill}
\makeatother

\patchcmd\thebibliography
    {\labelsep}
    {\labelsep\itemsep=0pt\parsep=0pt\relax}
    {}
    {\typeout{Couldn't patch the command}}

\newenvironment{thesisbibliography}{
  \begin{thebibliography}{lo}
    \interlinepenalty=10000
    \begin{spacing}{1.667}
    \thispagestyle{fancy}
    \fancyhead[C]{\fontsize{10.5pt}{12.6pt}\selectfont 参考文献}
    \small
}{
    \end{spacing}
  \end{thebibliography}
}

\pretocmd{\bibliography}{
  \thispagestyle{fancy}
  \interlinepenalty=10000
  \begin{spacing}{1.667}
}{}{}

\apptocmd{\bibliography}{
  \end{spacing}
}{}{}

\newcommand{\thesisloadbibliography}[2][]{
  \ifthenelse{
      \equal{#1}{nocite}
    }{
      \nocite{*}
    }{}
  \bibliographystyle{thesis-uestc}
  \bibliography{#2}
}

\newcites{achievement}{攻读\chinesedegreename{}学位期间取得的成果}

\newenvironment{thesisachievement}{
  \renewcommand{\bibname}{攻读\chinesedegreename{}学位期间取得的成果}
  \begin{thebibliography}{lo}
  \interlinepenalty=10000
  \begin{spacing}{1.667}
  \thispagestyle{fancy}
  \small
}{
  \end{spacing}\end{thebibliography}
  \renewcommand{\bibname}{参考文献}
}

%取得成果命令
\newcommand{\thesisloadachievement}[1]{
  \nociteachievement{*}
  \renewcommand{\bibname}{攻读\chinesedegreename{}学位期间取得的成果}
  \thispagestyle{fancy}
  \begin{spacing}{1.667}
  \bibliographystyleachievement{thesis-uestc}
  \bibliographyachievement{#1}
  \end{spacing}
  \renewcommand{\bibname}{参考文献}
}

%将一些命令输出为中文
\newtheoremstyle{dotless}{0pt}{0pt}{\normalfont}{24pt}{\heiti}{}{ }{}
\theoremstyle{dotless}
\newtheorem{theorem}{定理}
\newtheorem{axiom}[theorem]{公理}
\newtheorem{corollary}[theorem]{推论}
\newtheorem{lemma}[theorem]{引理}
\newtheorem{definition}[theorem]{定义}
\newtheorem{example}[theorem]{例子}


\renewcommand{\thetheorem}{\arabic{chapter}.\arabic{theorem}}
\renewcommand{\theaxiom}{\arabic{chapter}.\arabic{axiom}}
\renewcommand{\thecorollary}{\arabic{chapter}.\arabic{corollary}}
\renewcommand{\thelemma}{\arabic{chapter}.\arabic{lemma}}
\renewcommand{\thedefinition}{\arabic{chapter}.\arabic{definition}}
\renewcommand{\theexample}{\arabic{chapter}.\arabic{example}}
\renewcommand{\qedsymbol}{$\blacksquare$}
\renewcommand{\proofname}{证明}

\makeatletter
\renewenvironment{proof}[1][\proofname]{\par
  \pushQED{\qed}
  \normalfont
  \topsep0pt \partopsep0pt
  \trivlist
  \item[\hskip5\labelsep
        \heiti
    #1\@addpunct{:}]\ignorespaces
}{
  \popQED\endtrivlist\@endpefalse
}
\makeatother

%引用命令
\newcommand{\citing}[1]{\textsuperscript{\cite{#1}}}
\setlist{noitemsep}
\setlist{nolistsep}

\AtBeginDocument{
  \setlength{\abovedisplayskip}{8pt}
  \setlength{\belowdisplayskip}{8pt}
  \setlength{\belowdisplayshortskip}{8pt}
  \setlength{\abovedisplayshortskip}{8pt}
}


\endinput
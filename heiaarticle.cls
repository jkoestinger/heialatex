\ProvidesClass{heiaarticle}[2015/11/17 version 1.00]
\NeedsTeXFormat{LaTeX2e}

\ProcessOptions \relax

\LoadClass{article}

% Packages loading
\RequirePackage[utf8]{inputenc}
\RequirePackage[T1]{fontenc}
\RequirePackage[francais]{babel}
\RequirePackage[left=2cm,right=2cm,top=2cm,bottom=2cm]{geometry}
\RequirePackage{lastpage}
\RequirePackage{pgfkeys}
\RequirePackage{fancyhdr}
\RequirePackage{titlesec}
\RequirePackage{xcolor}
\RequirePackage{listings}
\RequirePackage{enumerate}
% Karnaugh-ish stuff
\RequirePackage{tikz}
\usetikzlibrary{matrix,calc}
\shorthandon{;} 

\RequirePackage{hyperref}
\hypersetup{
    colorlinks,
    citecolor=blue,
    filecolor=blue,
    linkcolor=blue,
    urlcolor=blue
}


% Commands for the key/value variables system
\newcommand{\setvalue}[1]{\pgfkeys{/variables/#1}}
\newcommand{\getvalue}[1]{\pgfkeysvalueof{/variables/#1}}
\newcommand{\declare}[1]{%
	\pgfkeys{
		/variables/#1.is family,
		/variables/#1.unknown/.style = {\pgfkeyscurrentpath/\pgfkeyscurrentname/.initial = ##1}
	}%
}

% Initialization of several defaults variables
\declare{}
\declare{meta/}
\declare{formatting/}
\declare{formatting/listings/}
\setvalue{meta/author = Unknown Author} % author name
\setvalue{meta/class = Unknown Class} % author's classroom
\setvalue{meta/date = \today} % date to display
\setvalue{meta/title = Unknown Title} % title of the document
\setvalue{meta/course = }
\setvalue{formatting/section = \Large\raggedright}
\setvalue{formatting/subsection = \large\raggedright}
\setvalue{formatting/subsubsection = \raggedright}
\setvalue{formatting/listings/defaultlanguage=Java}

% Settings for page layouts
\fancypagestyle{nostyle}{%
	\fancyhf{}
	\renewcommand{\headrulewidth}{0pt}
	\renewcommand{\footrulewidth}{0pt}
}
\fancypagestyle{standardstyle}{%
	\fancyhf{}
	
	\fancyhead[C]{\getvalue{meta/class}}
	\fancyhead[L]{\getvalue{meta/author}}
	\fancyhead[R]{\getvalue{meta/date}}
	
	\fancyfoot[C]{\getvalue{meta/course}}
	\fancyfoot[R]{\thepage / \pageref{LastPage}}
	\fancyfoot[L]{\getvalue{meta/title}}
	
	\renewcommand{\headrulewidth}{0pt}
	\renewcommand{\footrulewidth}{0.7pt}
}

\pagestyle{standardstyle}

% Title data filled with provided values
\title{\getvalue{meta/title}}
\author{\getvalue{meta/author}\\\emph{\getvalue{meta/class}}}
\date{\getvalue{meta/date}}


% builds the document's beginning stuff
\newcommand{\buildtitle}{%
	\maketitle
	\pagestyle{nostyle}
	\thispagestyle{nostyle}
	\newpage
	\newpage
	\tableofcontents
	\newpage
	\setcounter{page}{1}
	\pagestyle{standardstyle}
}

\titleformat{\section}{%
	\getvalue{formatting/section}
}{\textnormal{\thesection .}}{0.5em}{}[\titlerule]

\titleformat{\subsection}{%
	\getvalue{formatting/subsection}
}{\textnormal{\thesubsection .}}{0.5em}{}[]

\titleformat{\subsubsection}{%
	\getvalue{formatting/subsubsection}
}{\textnormal{\thesubsubsection .}}{0.5em}{}[]


% Lstlistings styles

\definecolor{codegreen}{rgb}{0,0.75,0}
\definecolor{codegray}{rgb}{0.5,0.5,0.5}
\definecolor{codepurple}{rgb}{0.38,0,0.62}
\definecolor{codewhite}{rgb}{1,1,1}
\definecolor{codeblack}{rgb}{0,0,0}
\definecolor{codeblue}{rgb}{0,0,0.8}
 
\lstdefinestyle{code}{ % Style for coding template, default style
    backgroundcolor=\color{codewhite},   
    commentstyle=\color{codegreen},
    keywordstyle=\color{codeblue},
    numberstyle=\color{black},
    stringstyle=\color{codepurple},
    basicstyle=\footnotesize\ttfamily,
    breakatwhitespace=false,         
    breaklines=true,                 
    captionpos=b,                    
    keepspaces=true,                 
    numbers=left,                    
    numbersep=5pt,                  
    showspaces=false,                
    showstringspaces=false,
    showtabs=false,                  
    tabsize=2,
    frame=lrbt,
    %language=\getvalue{formatting/listings/defaultlanguage}
}

\lstdefinestyle{console}{ % Style for console commands
    backgroundcolor=\color{codeblack},
    basicstyle=\footnotesize\ttfamily\color{codewhite},
    breakatwhitespace=false,         
    breaklines=true,                 
    captionpos=b,                    
    keepspaces=true,           
    showspaces=false,                
    showstringspaces=false,
    showtabs=false,                  
    tabsize=2,
    numbers=none,
}

\lstdefinestyle{console_inverse}{ % Style for console commands, alternative version
    backgroundcolor=\color{codewhite},
    basicstyle=\footnotesize\ttfamily\color{codeblack},
    breakatwhitespace=false,         
    breaklines=true,                 
    captionpos=b,                    
    keepspaces=true,           
    showspaces=false,                
    showstringspaces=false,
    showtabs=false,                  
    tabsize=2,
    numbers=none,
    frame=bt
}

\setvalue{formatting/listings/defaultstyle = code}

% listing environments
\lstnewenvironment{listing}
	{		
		\lstset{style=\getvalue{formatting/listings/defaultstyle}}
	}
	{}

\newif\ifconsoleinverse
\consoleinversetrue

\newcommand{\switchconsolestyle}{%
	\ifconsoleinverse
		\consoleinversefalse
	\else
		\consoleinversetrue
	\fi
}

\lstnewenvironment{console}
	{
		\ifconsoleinverse
			\lstset{style=console_inverse}
		\else
			\lstset{style=console}
		\fi
	}
	{
		\lstset{style=\getvalue{formatting/listings/defaultstyle}}
	}

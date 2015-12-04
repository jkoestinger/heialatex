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
\setvalue{formatting/section = \large\scshape\raggedright}
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

%--------------------------------------------------------------------------
%----------------------------BEGIN KARNAUGH--------------------------------
%--------------------------------------------------------------------------
%isolated term
%#1 - Optional. Space between node and grouping line. Default=0
%#2 - node
%#3 - filling color
\newcommand{\implicantsol}[3][0]{
    \draw[rounded corners=3pt, fill=#3, opacity=0.3] ($(#2.north west)+(135:#1)$) rectangle ($(#2.south east)+(-45:#1)$);
    }


%internal group
%#1 - Optional. Space between node and grouping line. Default=0
%#2 - top left node
%#3 - bottom right node
%#4 - filling color
\newcommand{\implicant}[4][0]{
    \draw[rounded corners=3pt, fill=#4, opacity=0.3] ($(#2.north west)+(135:#1)$) rectangle ($(#3.south east)+(-45:#1)$);
    }

%group lateral borders
%#1 - Optional. Space between node and grouping line. Default=0
%#2 - top left node
%#3 - bottom right node
%#4 - filling color
\newcommand{\implicanth}[4][0]{
    \draw[rounded corners=3pt, fill=#4, opacity=0.3] ($(rf.east |- #2.north)+(90:#1)$)-| ($(#2.east)+(0:#1)$) |- ($(rf.east |- #3.south)+(-90:#1)$);
    \draw[rounded corners=3pt, fill=#4, opacity=0.3] ($(cf.west |- #2.north)+(90:#1)$) -| ($(#3.west)+(180:#1)$) |- ($(cf.west |- #3.south)+(-90:#1)$);
}

%group top-bottom borders
%#1 - Optional. Space between node and grouping line. Default=0
%#2 - top left node
%#3 - bottom right node
%#4 - filling color
\newcommand{\implicantv}[4][0]{
    \draw[rounded corners=3pt, fill=#4, opacity=0.3] ($(cf.south -| #2.west)+(180:#1)$) |- ($(#2.south)+(-90:#1)$) -| ($(cf.south -| #3.east)+(0:#1)$);
    \draw[rounded corners=3pt, fill=#4, opacity=0.3] ($(rf.north -| #2.west)+(180:#1)$) |- ($(#3.north)+(90:#1)$) -| ($(rf.north -| #3.east)+(0:#1)$);
}

%group corners
%#1 - Optional. Space between node and grouping line. Default=0
%#2 - filling color
\newcommand{\implicanthv}[2][0]{
    \draw[rounded corners=3pt, opacity=.3] ($(rf.east |- 0.south)+(-90:#1)$) -| ($(0.east |- cf.south)+(0:#1)$);
    \draw[rounded corners=3pt, opacity=.3] ($(rf.east |- 8.north)+(90:#1)$) -| ($(8.east |- rf.north)+(0:#1)$);
    \draw[rounded corners=3pt, opacity=.3] ($(cf.west |- 2.south)+(-90:#1)$) -| ($(2.west |- cf.south)+(180:#1)$);
    \draw[rounded corners=3pt, opacity=.3] ($(cf.west |- 10.north)+(90:#1)$) -| ($(10.west |- rf.north)+(180:#1)$);
    \fill[rounded corners=3pt, fill=#2, opacity=.3] ($(rf.east |- 0.south)+(-90:#1)$) -|  ($(0.east |- cf.south)+(0:#1)$) [sharp corners] ($(rf.east |- 0.south)+(-90:#1)$) |-  ($(0.east |- cf.south)+(0:#1)$) ;
    \fill[rounded corners=3pt, fill=#2, opacity=.3] ($(rf.east |- 8.north)+(90:#1)$) -| ($(8.east |- rf.north)+(0:#1)$) [sharp corners] ($(rf.east |- 8.north)+(90:#1)$) |- ($(8.east |- rf.north)+(0:#1)$) ;
    \fill[rounded corners=3pt, fill=#2, opacity=.3] ($(cf.west |- 2.south)+(-90:#1)$) -| ($(2.west |- cf.south)+(180:#1)$) [sharp corners]($(cf.west |- 2.south)+(-90:#1)$) |- ($(2.west |- cf.south)+(180:#1)$) ;
    \fill[rounded corners=3pt, fill=#2, opacity=.3] ($(cf.west |- 10.north)+(90:#1)$) -| ($(10.west |- rf.north)+(180:#1)$) [sharp corners] ($(cf.west |- 10.north)+(90:#1)$) |- ($(10.west |- rf.north)+(180:#1)$) ;
}

%Empty Karnaugh map 4x4
\newenvironment{Karnaugh4x4}%
{
\begin{tikzpicture}[baseline=(current bounding box.north),scale=0.8]
\draw (0,0) grid (4,4);
\draw (0,4) -- node [pos=0.7,above right,anchor=south west] {cd} node [pos=0.7,below left,anchor=north east] {ab} ++(135:1);
%
\matrix (mapa) [matrix of nodes,
        column sep={0.8cm,between origins},
        row sep={0.8cm,between origins},
        every node/.style={minimum size=0.3mm},
        anchor=8.center,
        ampersand replacement=\&] at (0.5,0.5)
{
                       \& |(c00)| 00         \& |(c01)| 01         \& |(c11)| 11         \& |(c10)| 10         \& |(cf)| \phantom{00} \\
|(r00)| 00             \& |(0)|  \phantom{0} \& |(1)|  \phantom{0} \& |(3)|  \phantom{0} \& |(2)|  \phantom{0} \&                     \\
|(r01)| 01             \& |(4)|  \phantom{0} \& |(5)|  \phantom{0} \& |(7)|  \phantom{0} \& |(6)|  \phantom{0} \&                     \\
|(r11)| 11             \& |(12)| \phantom{0} \& |(13)| \phantom{0} \& |(15)| \phantom{0} \& |(14)| \phantom{0} \&                     \\
|(r10)| 10             \& |(8)|  \phantom{0} \& |(9)|  \phantom{0} \& |(11)| \phantom{0} \& |(10)| \phantom{0} \&                     \\
|(rf) | \phantom{00}   \&                    \&                    \&                    \&                    \&                     \\
};
}%
{
\end{tikzpicture}
}

%Empty Karnaugh map 2x4
\newenvironment{Karnaugh2x4}%
{
\begin{tikzpicture}[baseline=(current bounding box.north),scale=0.8]
\draw (0,0) grid (4,2);
\draw (0,2) -- node [pos=0.7,above right,anchor=south west] {ab} node [pos=0.7,below left,anchor=north east] {c} ++(135:1);
%
\matrix (mapa) [matrix of nodes,
        column sep={0.8cm,between origins},
        row sep={0.8cm,between origins},
        every node/.style={minimum size=0.3mm},
        anchor=4.center,
        ampersand replacement=\&] at (0.5,0.5)
{
                      \& |(c00)| 00         \& |(c01)| 01         \& |(c11)| 11         \& |(c10)| 10         \& |(cf)| \phantom{00} \\
|(r00)| 0             \& |(0)|  \phantom{0} \& |(1)|  \phantom{0} \& |(3)|  \phantom{0} \& |(2)|  \phantom{0} \&                     \\
|(r01)| 1             \& |(4)|  \phantom{0} \& |(5)|  \phantom{0} \& |(7)|  \phantom{0} \& |(6)|  \phantom{0} \&                     \\
|(rf) | \phantom{00}  \&                    \&                    \&                    \&                    \&                     \\
};
}%
{
\end{tikzpicture}
}


%Empty Karnaugh map 4x2
\newenvironment{Karnaugh4x2}%
{
\begin{tikzpicture}[baseline=(current bounding box.north),scale=0.8]
\draw (0,0) grid (2,4);
\draw (0,2) -- node [pos=0.7,above right,anchor=south west] {ab} node [pos=0.7,below left,anchor=north east] {c} ++(135:1);
%
\matrix (mapa) [matrix of nodes,
        column sep={0.8cm,between origins},
        row sep={0.8cm,between origins},
        every node/.style={minimum size=0.3mm},
        anchor=4.center,
        ampersand replacement=\&] at (0.5,0.5)
{
                      \& |(c00)| 00         \& |(c01)| 01         \& |(c11)| 11         \& |(c10)| 10         \& |(cf)| \phantom{00} \\
|(r00)| 0             \& |(0)|  \phantom{0} \& |(1)|  \phantom{0} \& |(3)|  \phantom{0} \& |(2)|  \phantom{0} \&                     \\
|(r01)| 1             \& |(4)|  \phantom{0} \& |(5)|  \phantom{0} \& |(7)|  \phantom{0} \& |(6)|  \phantom{0} \&                     \\
|(rf) | \phantom{00}  \&                    \&                    \&                    \&                    \&                     \\
};
}%
{
\end{tikzpicture}
}



%Empty Karnaugh map 2x2
\newenvironment{Karnaugh2x2}%
{
\begin{tikzpicture}[baseline=(current bounding box.north),scale=0.8]
\draw (0,0) grid (2,2);
\draw (0,2) -- node [pos=0.7,above right,anchor=south west] {b} node [pos=0.7,below left,anchor=north east] {a} ++(135:1);
%
\matrix (mapa) [matrix of nodes,
        column sep={0.8cm,between origins},
        row sep={0.8cm,between origins},
        every node/.style={minimum size=0.3mm},
        anchor=2.center,
        ampersand replacement=\&] at (0.5,0.5)
{
          \& |(c00)| 0          \& |(c01)| 1  \\
|(r00)| 0 \& |(0)|  \phantom{0} \& |(1)|  \phantom{0} \\
|(r01)| 1 \& |(2)|  \phantom{0} \& |(3)|  \phantom{0} \\
};
}%
{
\end{tikzpicture}
}

%Defines 8 or 16 values (0,1,X)
\newcommand{\setKarnaughValues}[1]{%
\foreach \x [count=\xi from 0]  in {#1}
     \path (\xi) node {\x};
}

%Places 1 in listed positions
\newcommand{\minterms}[1]{%
    \foreach \x in {#1}
        \path (\x) node {1};
}

%Places 0 in listed positions
\newcommand{\maxterms}[1]{%
    \foreach \x in {#1}
        \path (\x) node {0};
}

%Places X in listed positions
\newcommand{\indeterminates}[1]{%
    \foreach \x in {#1}
        \path (\x) node {X};
}

%--------------------------------------------------------------------------
%----------------------------END KARNAUGH----------------------------------
%--------------------------------------------------------------------------
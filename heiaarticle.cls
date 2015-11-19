\ProvidesClass{heiaarticle}[2015/11/17 version 1.00]
\NeedsTeXFormat{LaTeX2e}

\ProcessOptions \relax

\LoadClass{article}

% Packages loading
\RequirePackage[left=2cm,right=2cm,top=2cm,bottom=2cm]{geometry}
\RequirePackage{lastpage}
\RequirePackage{pgfkeys}
\RequirePackage{fancyhdr}
\RequirePackage{titlesec}


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
\setvalue{meta/author = Unknown Author} % author name
\setvalue{meta/class = Unknown Class} % author's classroom
\setvalue{meta/date = \today} % date to display
\setvalue{meta/title = Unknown Title} % title of the document
\setvalue{meta/course = }
\setvalue{meta/sectionformat = \large\scshape\raggedright}

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
	\getvalue{meta/sectionformat}
}{\textnormal{\thesection .}}{0.5em}{}[\titlerule]
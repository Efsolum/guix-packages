(use-package-modules emacs guile version-control
				 package-management autotools
				 m4 ghostscript fonts databases
				 man less python file curl)

(packages->manifest (list autoconf
				automake
				binutils
				coreutils
				diffutils
				emacs-no-x
				file
				font-dejavu
				font-gnu-freefont-ttf
				git
				curl
				glibc-locales
				gnu-make
				gs-fonts
				guile-2.0
				guix
				less
				m4
				man-db
				python-2
				recutils
				stow))

(define-module (gnu packages emacs-birds-of-paradise-plus-theme)
	#:use-module (gnu packages emacs)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix gexp)
  #:use-module (guix monads)
  #:use-module (guix store)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system emacs)
  #:use-module (guix build-system glib-or-gtk)
  #:use-module (guix build-system trivial)
  #:use-module (gnu packages)
  #:use-module (gnu packages guile)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages ncurses)
  #:use-module (gnu packages texinfo)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages xorg)
  #:use-module (gnu packages lesstif)
  #:use-module (gnu packages image)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages version-control)
  #:use-module (gnu packages imagemagick)
  #:use-module (gnu packages w3m)
  #:use-module (gnu packages wget)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages base)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages xml)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages acl)
  #:use-module (gnu packages package-management)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages pdf)
  #:use-module (gnu packages scheme)
  #:use-module (gnu packages xiph)
  #:use-module (gnu packages mp3)
  #:use-module (guix utils)
  #:use-module (srfi srfi-1))

(define-public emacs-birds-of-paradise-plus-theme
  (package
    (name "emacs-birds-of-paradise-plus-theme")
    (version "0.1.1")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://github.com/jimeh/birds-of-paradise-plus-theme.el/archive/v"
             version ".tar.gz"))
       (sha256
        (base32
         "0yzzcbwwjmmn5x6iiz07rxh1a4wq76s2zlqaxlcvpx50dman8i08"))))
    (build-system emacs-build-system)
    (home-page "https://github.com/jimeh/birds-of-paradise-plus-theme.el")
    (synopsis "Emacs port of Joseph Bergantine's light-on-dark theme by the
same name")
    (description "A Emacs port of Joseph Bergantine's light-on-dark theme by
the same name.")
    (license
     (license:non-copyleft
      "https://raw.githubusercontent.com/jimeh/birds-of-paradise-plus-theme.el/master/birds-of-paradise-plus-theme.el"))))

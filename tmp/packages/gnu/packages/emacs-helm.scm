;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2016 Matthew Jordan <matthewjordandevops@yandex.com>
;;;
;;; This file is part of GNU Guix.
;;;
;;; GNU Guix is free software; you can redistribute it and/or modify it
;;; under the terms of the GNU General Public License as published by
;;; the Free Software Foundation; either version 3 of the License, or (at
;;; your option) any later version.
;;;
;;; GNU Guix is distributed in the hope that it will be useful, but
;;; WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;; GNU General Public License for more details.
;;;
;;; You should have received a copy of the GNU General Public License
;;; along with GNU Guix.  If not, see <http://www.gnu.org/licenses/>.

(define-module (gnu packages emacs-helm)
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
  #:use-module (gnu packages version-control)
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

(define-public emacs-helm-temp
  (package
    (name "emacs-helm")
    (version "1.9.4")
    (source (origin
              (method url-fetch)
              (uri (string-append
                    "https://github.com/" name "/helm/archive/v"
                    version ".tar.gz"))
              (sha256
               (base32 "1fjgmjxjwqp55gh4z9jxh28gzbdixkdkg9869dn3c4g8qzy2hg35"))))
    (inputs `(("git" ,git)))
    (propagated-inputs
     `(("dash" ,emacs-dash)
       ("texinfo" ,texinfo)))
    (build-system emacs-build-system)
    (home-page "https://emacs-helm.github.io/helm/")
    (synopsis "Helm is incremental completion and selection narrowing
framework for Emacs.")
    (description "Helm is incremental completion and selection narrowing
framework for Emacs. It will help steer you in the right direction
when you're looking for stuff in Emacs (like buffers, files, etc).
Helm is a fork of anything.el originally written by Tamas Patrovic and
can be considered to be its successor. Helm sets out to clean up the
legacy code in anything.el and provide a cleaner, leaner and more
modular tool, that's not tied in the trap of backward compatibility.")
    (license license:gpl3+)))

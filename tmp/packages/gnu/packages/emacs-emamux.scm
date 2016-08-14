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

(define-module (gnu packages emacs-emamux)
  #:use-module (guix licenses)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system emacs)
  #:use-module (gnu packages)
  #:use-module (gnu packages libevent)
  #:use-module (gnu packages ncurses))

(define-public emacs-emamux
  (package
    (name "emacs-emamux")
    (version "20160602.653")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "http://melpa.org/packages/emamux-"
             version ".el"))
       (sha256
        (base32
         "0ky987850bxjw057kjlf4f24dhwa648kbdkys71qhcspsdj94yrk"))))
    (build-system emacs-build-system)
    (home-page "https://github.com/syohex/emacs-emamux")
    (synopsis "Interact with tmux")
    (description
     "Emamux makes you interact emacs and tmux.  emamux is inspired by `vimux'
and `tslime.vim'.")
    (license gpl3+)))

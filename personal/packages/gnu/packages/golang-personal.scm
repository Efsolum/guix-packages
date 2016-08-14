;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2015, 2016 Efraim Flashner <efraim@flashner.co.il>
;;; Copyright © 2016 Matthew Jordan <matthewjordandevops@yandex.com>
;;; Copyright © 2016 Andy Wingo <wingo@igalia.com>
;;;
;;; This file is an addendum GNU Guix.
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

(define-module (gnu packages golang-personal)
	#:use-module (gnu packages golang)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix utils)
  #:use-module (guix download)
  #:use-module (guix packages)
  #:use-module (guix build-system gnu)
  #:use-module (gnu packages admin)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages base)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages pcre)
  #:use-module (ice-9 match)
  #:use-module (srfi srfi-1))

(define-public go-1.5-personal
  (package
    (inherit go-1.4)
    (name "go")
    (version "1.5.4")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://storage.googleapis.com/golang/"
                           name version ".src.tar.gz"))
       (sha256
        (base32
         "14xwn2pr3g4i1h8qpyrjjdmq1pgvzkagk4aqsp841hfxwyyclah0"))))
    (arguments
     `(#:modules ((ice-9 match)
                  (guix build gnu-build-system)
                  (guix build utils))
       #:tests? #f ; Tests are run by all.bash script
       #:phases
       (modify-phases %standard-phases
         (delete 'configure)
         (add-after 'patch-generated-file-shebangs 'chdir
           (lambda _ (chdir "src")))
         (add-before 'build 'prebuild
           (lambda* (#:key inputs outputs #:allow-other-keys)
             (let* ((gcclib (string-append (assoc-ref inputs "gcc:lib") "/lib"))
                    (ld (string-append
                         (assoc-ref inputs "glibc") "/lib"))
                    (loader (car (find-files ld "^ld-linux.+")))
                    (net-base (assoc-ref inputs "net-base"))
                    (tzdata-path
                     (string-append (assoc-ref inputs "tzdata") "/share/zoneinfo"))
                    (output (assoc-ref outputs "out")))

               ;; Removing net/ tests, which fail when attempting to access
               ;; network resources not present in the build container.
               (for-each
                (lambda (srcfile)
                  (let ((srcfile (string-append "net/" srcfile)))
                    (delete-file srcfile)))
                '("parse_test.go" "port_test.go"))

               ;; Add libgcc to runpath
               (substitute* "cmd/link/internal/ld/lib.go"
                 (("!rpath.set") "true"))
               (substitute* "cmd/go/build.go"
                 (("cgoldflags := \\[\\]string\\{\\}")
                  (string-append "cgoldflags := []string{"
                                 "\"-rpath=" gcclib "\""
                                 "}"))
                 (("ldflags = setextld\\(ldflags, compiler\\)")
                  (string-append
                   "ldflags = setextld(ldflags, compiler)\n"
                   "ldflags = append(ldflags, \"-r\")\n"
                   "ldflags = append(ldflags, \"" gcclib "\")\n"))
                 (("\"-lgcc_s\", ")
                  (string-append
                   "\"-Wl,-rpath=" gcclib "\", \"-lgcc_s\", ")))

               (substitute* "os/os_test.go"
                 (("/usr/bin") (getcwd))
                 (("/bin/pwd") (which "pwd")))

               ;; Disable failing tests: these tests attempt to access
               ;; commands or network resources which are neither available or
               ;; necessary for the build to succeed.
               (map
                (match-lambda
                  ((file regex)
                   (substitute* file
                     ((regex all before test_name)
                      (string-append before "Disabled" test_name)))))
                '(("net/net_test.go" "(.+)(TestShutdownUnix.+)")
                  ("net/dial_test.go" "(.+)(TestDialTimeout.+)")
                  ("os/os_test.go" "(.+)(TestHostname.+)")
                  ("time/format_test.go" "(.+)(TestParseInSydney.+)")
                  ("os/exec/exec_test.go" "(.+)(TestEcho.+)")
                  ("os/exec/exec_test.go" "(.+)(TestCommandRelativeName.+)")
                  ("os/exec/exec_test.go" "(.+)(TestCatStdin.+)")
                  ("os/exec/exec_test.go" "(.+)(TestCatGoodAndBadFile.+)")
                  ("os/exec/exec_test.go" "(.+)(TestExitStatus.+)")
                  ("os/exec/exec_test.go" "(.+)(TestPipes.+)")
                  ("os/exec/exec_test.go" "(.+)(TestStdinClose.+)")
                  ("os/exec/exec_test.go" "(.+)(TestIgnorePipeErrorOnSuccess.+)")
                  ("syscall/syscall_unix_test.go" "(.+)(TestPassFD\\(.+)")
                  ("os/exec/exec_test.go" "(.+)(TestExtraFiles.+)")
                  ("net/listen_test.go" "(.+)(TestIPv4MulticastListener\\(.+)")
                  ("syscall/exec_linux_test.go"
                   "(.+)(TestCloneNEWUSERAndRemapNoRootDisableSetgroups.+)")))

               (substitute* "net/lookup_unix.go"
                 (("/etc/protocols") (string-append net-base "/etc/protocols")))
               (substitute* "time/zoneinfo_unix.go"
                 (("/usr/share/zoneinfo/") tzdata-path))
               (substitute*
                   (find-files "cmd" "asm.c")
                 (("/lib/ld-linux.*\\.so\\.[0-9]") loader)))))
         (replace 'build
           (lambda* (#:key inputs outputs #:allow-other-keys)
             (let* ((go  (assoc-ref inputs "go"))
                    (output (assoc-ref outputs "out")))
               (setenv "CC" (which "gcc"))
               (setenv "GOOS" "linux")
               (setenv "GOROOT" (dirname (getcwd)))
               (setenv "GOROOT_BOOTSTRAP" go)
               (setenv "GOROOT_FINAL" output)
               (setenv "GOGC" "400")
               (setenv "CGO_ENABLED" "1")
               (zero? (system* "sh" "all.bash")))))
         (replace 'install
           (lambda* (#:key inputs outputs #:allow-other-keys)
             (let* ((output (assoc-ref outputs "out"))
                    (doc_out (assoc-ref outputs "doc"))
                    (docs (string-append doc_out "/share/doc/" ,name "-" ,version))
                    (src (string-append
                          (assoc-ref outputs "tests") "/share/" ,name "-" ,version)))
               (mkdir-p src)
               (copy-recursively "../test" (string-append src "/test"))
               (delete-file-recursively "../test")
               (mkdir-p docs)
               (copy-recursively "../api" (string-append docs "/api"))
               (delete-file-recursively "../api")
               (copy-recursively "../doc" (string-append docs "/doc"))
               (delete-file-recursively "../doc")

               (for-each
                (lambda (file)
                  (let* ((filein (string-append "../" file))
                         (fileout (string-append docs "/" file)))
										(copy-file filein fileout)
										(delete-file filein)))
                '("README.md" "CONTRIBUTORS" "AUTHORS" "PATENTS"
                  "LICENSE" "VERSION" "CONTRIBUTING.md" "robots.txt"))

               (copy-recursively "../" output)))))))
    (inputs
     `(,@(package-inputs go-1.4)))
    (native-inputs
     `(("go" ,go-1.4)
       ("glibc" ,glibc)
       ,@(package-native-inputs go-1.4)))
    (propagated-inputs
     `(,@(package-propagated-inputs go-1.4)))))

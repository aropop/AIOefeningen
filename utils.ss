#!r6rs

(library
 (utils)
 (export read-csv-line)
 (import (rnrs base (6))
         (rnrs io simple (6))
         (rnrs io ports (6))
         (only (srfi :13 strings) string-tokenize)
         (only (srfi :14 char-sets) char-set-delete! char-set:graphic))
 
 (define (read-csv-line port)
   ; Reads a line from a comma-separated-values file and returns the 
   ; fields as a list of strings, or '() in case of end-of-file.
   (assert (input-port? port))
   (let ([line (get-line port)])
     (if (eof-object? line)
         '()
         (string-tokenize line (char-set-delete! char-set:graphic #\,)))))
 )

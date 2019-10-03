(import (rnrs (6)))

(load "test.scm")

(define (clean-phone-number S)
  (let ((good-char? (lambda (x)
                      (or (char-numeric? x)
                          (memq x (string->list "()+-. "))))))
    (let-values (((goods bads)
                  (partition good-char? (string->list S))))
      (if (not (null? bads))
          (error 'clean "phone number has junk chars" bads)
          (list->string
           (filter char-numeric? goods))))))

(define (split-phone-number S)
  (let* ((S (clean-phone-number S))
         (digits (string-length S)))
    (cond ((= 10 digits) S)
          ((and (= 11 digits) (char=? #\1 (string-ref S 0)))
           (substring S 1 11))
          (else (error 'clean "bad phone number" S)))))

(define (clean phone-number)
  (let ((cleaned (split-phone-number phone-number)))
    (when (or (char=? #\0 (string-ref cleaned 3))
              (char=? #\1 (string-ref cleaned 3))
              (char=? #\0 (string-ref cleaned 0))
              (char=? #\1 (string-ref cleaned 0)))
      (error 'clean "exchange code begins with 0" phone-number))
    cleaned))


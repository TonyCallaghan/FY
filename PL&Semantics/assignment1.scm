; CS424 -> Assignment 1
; Tony Callaghan - 20739321

; ###############

; Question 1:
; Write a scheme function that takes in two integers and returns their greatest common divisor

(define (gcd a b)
    (if (= b 0)
        a
        (gcd b (modulo a b))
    )
)
  
; Test Case 1:
(display (gcd 24 36))
(newline)

; Test Case 2:
(display (gcd 90 299))
(newline)

; ###############

; Question 2:
; Write a scheme function that takes an integer and checks whether it is a power of two.

(define (isPowTwo n)
    (cond                               ; Switch
        ((<= n 0) #f)                   ; If n is 0 or negative -> not a power of two
        ((= n 1) #t)                    ; 1 -> is a power of two
        ((odd? n) #f)                   ; If n is odd -> not a power of two
        (else (isPowTwo (/ n 2)))       ; Divide by 2 and check again
    )
)


; Test Case 1:
(display (isPowTwo 128))
(newline)

; Test Case 2:
(display (isPowTwo 23))
(newline)

; ###############

; Question 3:
; Write a scheme function that takes in two numbers as the real and imaginary
; parts of a complex number and returns a function which takes in a single input.

; Needed for test case 4 & 7:
(define (modulus real imag)
  (sqrt (+ (* real real) (* imag imag))))

; Needed for test case 9:
(define (roundTwo num)
  (/ (round (* num 100)) 100.0))

(define (complex-num real imaginary)
    (lambda (func)                                                          ; define all functions
        (cond
            ; Operation 1: (eq? predicate logic)
            ((eq? func 'value) (list real '+ imaginary 'i))                 ; return -> '3 + 4i'
      
            ; Operation 2: Real number
            ((eq? func 'real) real)                                         ; return -> '3'
            
            ; Operation 3: Imaginary number
            ((eq? func 'imaginary) imaginary)                               ; return -> '4'
            
            ; Operation 4: Calculate mod
            ((eq? func 'modulus) (modulus real imaginary))                  ; return -> '5'
            
            ; Operation 5: Argument or angle in radians
            ((eq? func 'argument) (roundTwo (atan imaginary real)))         ; return -> '0.93'
    
            ; Operation 6: Represent as "a - bi"
            ((eq? func 'conjugate) (list real '- imaginary 'i))             ; return -> '(3 − 4i)'
            
            ; Operation 7: ; a/(a^2+b^2) - (b/(a^2+b^2))i
            ((eq? func 'inverse) 
                (let ((mod (modulus real imaginary)))
                    (list (/ real mod) '- (/ imaginary mod) 'i)))           ; return -> '(3/5 - 4/5 i)'
            
            ; Operation 8: (a^2 - b^2) + 2ab * i
            ((eq? func 'square) 
                (let ((new-real (- (* real real) (* imaginary imaginary)))
                    (new-im (* 2 real imaginary)))
                (list new-real '+ new-im 'i)))                              ; return -> '(- 7 + 24i)'
            
            ; Operation 9: (modulus (cos num + i sin num))
            ((eq? func 'polar)
                (let* ((modulus (sqrt (+ (* real real) (* imaginary imaginary))))
                    (num (roundTwo (atan imaginary real))))
                (list modulus (list 'cos num '+ 'i 'sin num))))             ; return -> '(5 (cos 0.93 + i sin 0.93))'
            
            ; Operation 10: Default case
            (else 'error)                                                   ; return -> 'error'
        )
    )
)           

(define mynum (complex-num 3 4))

; Test Case 1:
(display (mynum 'value))
(newline)

; Test Case 2:
(display (mynum 'real))
(newline)

; Test Case 3:
(display (mynum 'imaginary))
(newline)

; Test Case 4:
(display (mynum 'modulus))
(newline)

; Test Case 5:
(display (mynum 'argument))
(newline)

; Test Case 6:
(display (mynum 'conjugate))
(newline)

; Test Case 7:
(display (mynum 'inverse))
(newline)

; Test Case 8:
(display (mynum 'square))
(newline)

; Test Case 9:
(display (mynum 'polar))
(newline)

; Test Case 10:
(display (mynum 'other))
(newline)

; ###############

; Question 4:
; Write a scheme function that takes in an expression made up of maths operators
; and evaluates the expression.

; Example: (my-eval ’(cos (/ (- (* 1 (* 2 3)) (+ 1 (+ 2 3))) (exp 1)))) Returns: 1

; Addition
(define (add expr)
  (if (null? expr)
      0
      (+ (my-eval (car expr)) (add (cdr expr)))))

; Subtraction
(define (subtract expr)
  (if (null? (cdr expr))
      (my-eval (car expr))
      (- (my-eval (car expr)) (add (cdr expr)))))

; Multiplication
(define (multiply expr)
  (if (null? expr)
      1
      (* (my-eval (car expr)) (multiply (cdr expr)))))

; Division
(define (divide expr)
  (if (null? (cdr expr))
      (my-eval (car expr))
      (/ (my-eval (car expr)) (multiply (cdr expr)))))

; Cosine
(define (cosine expr)
  (cos (my-eval (car expr))))

; Exponential
(define (exponent expr)
  (exp (my-eval (car expr))))


(define (my-eval expr)
    (cond
        ((number? expr) expr) ;  number -> return
        ((list? expr)
            (let ((func (car expr)) ; 1st -> func
                (operator (cdr expr))) ; rest -> operator
                (case func
                    ((+) (add operator))
                    ((-) (subtract operator))
                    ((*) (multiply operator))
                    ((/) (divide operator))
                    ((cos) (cosine operator))
                    ((exp) (exponent operator))
                    (else (error "Unkown?" func)) ; Error handle
                )
            )
        )
    )
)

; test case 1:
(display (my-eval '(cos (/ (- (* 1 (* 2 3)) (+ 1 (+ 2 3))) (exp 1)))) )
(newline)

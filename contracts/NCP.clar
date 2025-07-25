;; NCP.clar
;; A contract for making and viewing public pledges.

;; --- Constants and Errors ---
(define-constant ERR-EMPTY-PLEDGE (err u100))

;; --- Data Storage ---

;; A map to store a pledge for each principal (user).
;; The key is the user's principal, and the value is their pledge message.
(define-map pledges principal (string-utf8 280))

;; A variable to keep track of the total number of unique pledgers.
(define-data-var total-pledges uint u0)


;; --- Public Functions ---

;; @desc Makes a public pledge. Each user can only have one active pledge.
;;       Making a new pledge will overwrite the old one.
;; @param pledge-text: The pledge message, up to 280 characters.
;; @returns (ok true) on success, or an error if the pledge is empty.
(define-public (make-pledge (pledge-text (string-utf8 280)))
  (begin ;; A begin block is used to execute multiple expressions sequentially.
    (asserts! (> (len pledge-text) u0) ERR-EMPTY-PLEDGE)

    ;; If this is the user's first pledge, increment the total pledge count.
    ;; The 'else' branch must return a boolean to match the type of (var-set).
    (if (is-none (map-get? pledges tx-sender))
        (var-set total-pledges (+ (var-get total-pledges) u1))
        true)

    ;; Set or update the user's pledge.
    (map-set pledges tx-sender pledge-text)

    (ok true)))


;; --- Read-Only Functions ---

;; @desc Retrieves the pledge for a given principal.
;; @param who: The principal of the user whose pledge you want to see.
;; @returns (some "pledge message") if a pledge exists, otherwise none.
(define-read-only (get-pledge (who principal))
  (map-get? pledges who))

;; @desc Gets the total number of unique pledgers.
;; @returns The total count of pledges made.
(define-read-only (get-total-pledges)
  (ok (var-get total-pledges)))
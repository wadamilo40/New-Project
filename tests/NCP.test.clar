;; NCP_test.clar
;; Tests for the NCP contract.

;; --- Constants ---
(define-constant ERR-EMPTY-PLEDGE (err u100))

;; --- Test Cases ---

;; Test that a user can make a pledge and the count increments.
(define-test (test-make-pledge-success)
  (let ((user1 tx-sender)
        (pledge-text "I pledge to reduce my plastic waste."))
    ;; Initial state: no pledges
    (expect-eq (ok u0) (contract-call? .NCP get-total-pledges))
    (expect-none (contract-call? .NCP get-pledge user1))

    ;; Action: user1 makes a pledge
    (let ((response (contract-call? .NCP make-pledge pledge-text)))
      ;; Assert: the call was successful
      (expect-ok response)
      (expect-eq (ok true) response)

      ;; Assert: the pledge is stored correctly
      (expect-eq (some pledge-text) (contract-call? .NCP get-pledge user1))

      ;; Assert: the total pledge count is now 1
      (expect-eq (ok u1) (contract-call? .NCP get-total-pledges)))))

;; Test that making an empty pledge fails.
(define-test (test-make-pledge-empty-fails)
  (let ((user1 tx-sender))
    ;; Action: user1 tries to make an empty pledge
    (let ((response (contract-call? .NCP make-pledge "")))
      ;; Assert: the call fails with the correct error
      (expect-err response)
      (expect-eq ERR-EMPTY-PLEDGE response)

      ;; Assert: state has not changed
      (expect-eq (ok u0) (contract-call? .NCP get-total-pledges))
      (expect-none (contract-call? .NCP get-pledge user1)))))

;; Test that a user can update their pledge and the count does not change.
(define-test (test-update-pledge)
  (let ((user1 tx-sender)
        (initial-pledge "I will plant a tree.")
        (updated-pledge "I will plant ten trees!"))
    ;; Action: Make the first pledge
    (expect-ok (contract-call? .NCP make-pledge initial-pledge))

    ;; Assert: Initial state is correct
    (expect-eq (some initial-pledge) (contract-call? .NCP get-pledge user1))
    (expect-eq (ok u1) (contract-call? .NCP get-total-pledges))

    ;; Action: Update the pledge
    (expect-ok (contract-call? .NCP make-pledge updated-pledge))

    ;; Assert: The pledge is updated
    (expect-eq (some updated-pledge) (contract-call? .NCP get-pledge user1))

    ;; Assert: The total pledge count remains 1
    (expect-eq (ok u1) (contract-call? .NCP get-total-pledges))))

;; Test with multiple users.
(define-test (test-multiple-users)
  (let ((user1 tx-sender)
        (user2 .wallet_1)
        (pledge1 "I pledge to volunteer weekly.")
        (pledge2 "I pledge to donate to charity."))
    ;; Action: user1 makes a pledge
    (as-contract (tx-sender user1) (expect-ok (contract-call? .NCP make-pledge pledge1)))
    (expect-eq (ok u1) (contract-call? .NCP get-total-pledges))

    ;; Action: user2 makes a pledge
    (as-contract (tx-sender user2) (expect-ok (contract-call? .NCP make-pledge pledge2)))
    (expect-eq (some pledge1) (contract-call? .NCP get-pledge user1))
    (expect-eq (some pledge2) (contract-call? .NCP get-pledge user2))
    (expect-eq (ok u2) (contract-call? .NCP get-total-pledges))))
;; Payment Contract
(define-fungible-token storage-credits)

(define-constant credits-per-byte u1)
(define-constant err-insufficient-credits (err u401))

(define-public (verify-payment (size uint))
  (let
    (
      (required-credits (* size credits-per-byte))
      (user-balance (ft-get-balance storage-credits tx-sender))
    )
    (asserts! (>= user-balance required-credits) err-insufficient-credits)
    (try! (ft-burn? storage-credits required-credits tx-sender))
    (ok true)
  )
)

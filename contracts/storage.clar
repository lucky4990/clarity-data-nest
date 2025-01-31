;; Storage Contract
(define-map data-entries 
  { id: uint }
  { 
    owner: principal,
    data-hash: (buff 32),
    size: uint,
    created-at: uint,
    updated-at: uint
  }
)

(define-data-var entry-counter uint u0)

(define-public (store-data (data-hash (buff 32)) (size uint))
  (let
    (
      (entry-id (var-get entry-counter))
    )
    (try! (verify-payment size))
    (map-set data-entries
      { id: entry-id }
      {
        owner: tx-sender,
        data-hash: data-hash,
        size: size,
        created-at: block-height,
        updated-at: block-height
      }
    )
    (var-set entry-counter (+ entry-id u1))
    (ok entry-id)
  )
)

(define-read-only (get-data-entry (id uint))
  (ok (map-get? data-entries {id: id}))
)

;; Access Control Contract
(define-map access-rights
  { entry-id: uint, user: principal }
  { can-read: bool, can-write: bool }
)

(define-public (grant-access 
  (entry-id uint) 
  (user principal) 
  (read-access bool) 
  (write-access bool)
)
  (let
    (
      (entry (try! (contract-call? .storage get-data-entry entry-id)))
    )
    (asserts! (is-eq tx-sender (get owner entry)) (err u403))
    (ok (map-set access-rights
      { entry-id: entry-id, user: user }
      { can-read: read-access, can-write: write-access }
    ))
  )
)

;; Access Control Contract
(define-map access-rights
  { entry-id: uint, user: principal }
  { can-read: bool, can-write: bool }
)

;; Track all users with access to an entry
(define-map entry-users
  { entry-id: uint }
  { users: (list 50 principal) }
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
    
    ;; Update access rights
    (try! (map-set access-rights
      { entry-id: entry-id, user: user }
      { can-read: read-access, can-write: write-access }
    ))

    ;; Add user to entry's user list if not already present
    (match (map-get? entry-users {entry-id: entry-id})
      existing-users (map-set entry-users
        { entry-id: entry-id }
        { users: (unwrap-panic (as-max-len? 
          (append (get users existing-users) user) u50)) }
      )
      (map-set entry-users
        { entry-id: entry-id }
        { users: (list user) }
      )
    )
    (ok true)
  )
)

(define-read-only (get-entry-users (entry-id uint))
  (ok (map-get? entry-users {entry-id: entry-id}))
)

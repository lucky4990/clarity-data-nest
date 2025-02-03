import { Clarinet, Tx, Chain, Account, types } from 'https://deno.land/x/clarinet@v1.0.0/index.ts';
import { assertEquals } from 'https://deno.land/std@0.90.0/testing/asserts.ts';

Clarinet.test({
  name: "Owner can grant access to other users",
  async fn(chain: Chain, accounts: Map<string, Account>) {
    const wallet_1 = accounts.get("wallet_1")!;
    const wallet_2 = accounts.get("wallet_2")!;
    
    let block = chain.mineBlock([
      Tx.contractCall("access-control", "grant-access",
        [types.uint(0), types.principal(wallet_2.address), types.bool(true), types.bool(false)],
        wallet_1.address
      )
    ]);
    
    assertEquals(block.receipts[0].result.expectOk(), true);
  }
});

Clarinet.test({
  name: "Can retrieve users with access to an entry",
  async fn(chain: Chain, accounts: Map<string, Account>) {
    const wallet_1 = accounts.get("wallet_1")!;
    const wallet_2 = accounts.get("wallet_2")!;
    
    // Grant access
    let block = chain.mineBlock([
      Tx.contractCall("access-control", "grant-access",
        [types.uint(0), types.principal(wallet_2.address), types.bool(true), types.bool(false)],
        wallet_1.address
      )
    ]);
    
    // Get users
    block = chain.mineBlock([
      Tx.contractCall("access-control", "get-entry-users",
        [types.uint(0)],
        wallet_1.address
      )
    ]);
    
    const result = block.receipts[0].result.expectOk().expectSome();
    assertEquals(result['users'].length, 1);
  }
});

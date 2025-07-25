import { Cl } from "@stacks/transactions";
import { describe, expect, it } from "vitest";

const accounts = simnet.getAccounts();
const deployer = accounts.get("deployer")!;
const wallet1 = accounts.get("wallet_1")!;

describe("NCP contract tests", () => {
  it("allows a user to make a pledge and increments count", () => {
    const pledgeText = "I pledge to use less water.";

    // Call the make-pledge public function
    const makePledgeResult = simnet.callPublicFn(
      "NCP",
      "make-pledge",
      [Cl.stringUtf8(pledgeText)],
      wallet1
    );

    // Check that the transaction was a success
    expect(makePledgeResult.result).toBeOk(Cl.bool(true));

    // Check that the pledge was stored correctly by calling the read-only function
    const pledge = simnet.callReadOnlyFn(
      "NCP",
      "get-pledge",
      [Cl.principal(wallet1)],
      deployer
    );
    expect(pledge.result).toStrictEqual(Cl.some(Cl.stringUtf8(pledgeText)));

    // Check that the total pledge count is now 1
    const totalPledges = simnet.callReadOnlyFn(
      "NCP",
      "get-total-pledges",
      [],
      deployer
    );
    expect(totalPledges.result).toBeOk(Cl.uint(1));
  });

  it("returns an error for an empty pledge", () => {
    // Attempt to make an empty pledge
    const makePledgeResult = simnet.callPublicFn(
      "NCP",
      "make-pledge",
      [Cl.stringUtf8("")],
      wallet1
    );

    // Expect an error (err u100)
    expect(makePledgeResult.result).toBeErr(Cl.uint(100));
  });
});

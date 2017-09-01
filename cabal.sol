{
  auth jump                               // Member list is kept at the end
main:
  calldatasize 0 0 calldatacopy           // Copy all calldata into memory
  32 calldatasize gt           fire jumpi // Trigger if given full action
  0 calldataload                          // Otherwise, confirm action hash
  dup1 sload                              // Read action state from storage
  dup3 2 exp                              // Bit mask of confirmation flag
  dup1 dup3 and                exit jumpi // Abort if confirmation flag set
  dup2 or 255 not and                     // Set confirmation flag of caller
  swap1 255 and 1 add                     // Increment confirmation counter
  or swap1 sstore              note jump  // Write action state into storage
fire:
  calldatasize 0 keccak256                // Compute hash of the full action
  2 dup2 sload 255 and lt      exit jumpi // Abort if too few confirmations
  0 calldataload timestamp gt  exit jumpi // Abort if past action deadline
  255 not swap1 sstore                    // Write action state into storage
  0 0 96 calldatasize sub 96              // No output, input from calldata
  64 calldataload 32 calldataload         // Value and target from calldata
  gaslimit call iszero         fail jumpi // Make call, reverting on failure
note:
  calldatasize 0                          // Log data is all of the calldata
  timestamp callvalue caller              // Use last topic for the timestamp
  32 calldataload log4                    // First topic is target, if any
exit:
  stop                                    // Just stop to avoid wasting gas
fail:
  invalid                                 // Revert only if really necessary
auth:
  247 0x4f26ffbe5f04ed43630fdc30a87638d53d0b0876 caller eq confirm jumpi
  246 0xdb33dfd3d61308c33c63209845dad3e6bfb2c674 caller eq confirm jumpi
  245 0xc9107bd75a6971d9beaba390a28ab9bb30adc9bc caller eq confirm jumpi
  244 0x61bf84d5ab026f58c873f86ff0dfca82b55733ae caller eq confirm jumpi
  243 0x855be87fe5ddea2761dbd97f1a4e857aa00a15fd caller eq confirm jumpi
  242 0x6ea073f4de9cd42955539033091ae587c06a882c caller eq confirm jumpi
}

#compile circuit
circom multiplier2.circom --r1cs --wasm --sym --c

# add input in input.json
#computing the witness with WebAssembly
cd circuit_js
node generate_witness.js circuit.wasm input.json witness.wtns

#Proving circuits
#start Powers of Tau ceremony
snarkjs powersoftau new bn128 12 pot12_0000.ptau -v

#contribute to ceremony
snarkjs powersoftau contribute pot12_0000.ptau pot12_0001.ptau --name="First contribution" -v

#Phase 2
snarkjs powersoftau prepare phase2 pot12_0001.ptau pot12_final.ptau -v

#generate .zkey file
snarkjs groth16 setup circuit.r1cs pot12_final.ptau circuit_0000.zkey

#contribute to phase 2 of ceremony
snarkjs zkey contribute circuit_0000.zkey circuit_0001.zkey --name="1st Contributor Name" -v

#Export verification key
snarkjs zkey export verificationkey circuit_0001.zkey verification_key.json

#generate zk-proof
snarkjs groth16 prove circuit_0001.zkey witness.wtns proof.json public.json

#verify the proof
snarkjs groth16 verify verification_key.json public.json proof.json

#generate Solidity code
snarkjs zkey export solidityverifier circuit_0001.zkey verifier.sol

#facilitate call
snarkjs generatecall

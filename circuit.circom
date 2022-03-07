// SPDX-License-Identifier: MIT

pragma circom 2.0.0;

include "./mimcsponge.circom";

template merkle_root(n) {
    signal input leaves[n];
    signal output root;

    component memory_components = MiMCSponge(2, 220, 1);
    memory_components.k <== 0;
    memory_components.ins[0] <== leaves[0];
    memory_components.ins[1] <== leaves[1];

    root <== memory_components.outs[0];
}

component main {public [leaves]} = merkle_root(8);
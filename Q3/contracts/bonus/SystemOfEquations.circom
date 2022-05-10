pragma circom 2.0.0;

include "../../node_modules/circomlib/circuits/comparators.circom";
include "../../node_modules/circomlib-matrix/circuits/matMul.circom"; // hint: you can use more than one templates in circomlib-matrix to help you


template SystemOfEquations(n) { // n is the number of variables in the system of equations
    signal input x[n]; // this is the solution to the system of equations
    signal input A[n][n]; // this is the coefficient matrix
    signal input b[n]; // this are the constants in the system of equations
    signal output out; // 1 for correct solution, 0 for incorrect solution

    // [bonus] insert your code here
    component lhs = matMul (n,n,1);
    signal sum[n+1];
    component equal[n];
    component equalFIN = IsEqual();
    sum[0] <-- 0;

    for (var i=0; i<n; i++) {
        lhs.b[i][0] <==  x[i];

        for (var j=0; j<n; j++) {
            lhs.a[i][j] <== A[i][j];
        }
    }

    for (var k=0; k<n; k++) {
        equal[k] = IsEqual();
        equal[k].in[0] <== b[k];
        equal[k].in[1] <== lhs.out[k][0];
        sum[k+1] <== sum[k] + equal[k].out;
    }

    equalFIN.in[0] <== n;
    equalFIN.in[1] <== sum[n];

    out <== equalFIN.out;
}

component main {public [A, b]} = SystemOfEquations(3);
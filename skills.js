function add(a, b) {
    return a + b;
}

function subtract(a, b) {
    return a - b;
}

function multiply(a, b) {
    return a * b;
}

function divide(a, b) {
    if (b === 0) {
        throw new Error("Division by zero is not allowed.");
    }
    return a / b;
}
function modulus(a, b) {
    return a % b;
}

function power(a, b) {
    return Math.pow(a, b);
}

function squareRoot(a) {
    return Math.sqrt(a);
}

function absolute(a) {
    return Math.abs(a);
}

function factorial(a) {
    if (a < 0) return undefined;
    if (a === 0 || a === 1) return 1;
    let result = 1;
    for (let i = a; i > 1; i--) {
        result *= i;
    }
    return result;
}

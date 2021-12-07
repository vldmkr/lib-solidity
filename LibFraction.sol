// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./SafeMath.sol";

library LibFraction {
    using SafeMath for uint256;

    struct Fraction {
        uint256 numerator;
        uint256 denominator;
    }

    modifier isValidDenominator(Fraction memory fraction) {
        require(fraction.denominator != 0, "denominator cannot be zero");
        _;
    }

    function _sort(uint256 a, uint256 b)
        internal
        pure
        returns (uint256, uint256)
    {
        return (a > b) ? (a, b) : (b, a);
    }

    /**
     * @dev The function of calculating the greatest common divisor using the Euclidean algorithm
     */
    function _gcd(uint256 a, uint256 b)
        internal
        pure
        returns (uint256)
    {
        (a, b) = _sort(a, b);
        while (b != 0) {
            (a, b) = (b, a.mod(b));
        }
        return a;
    }

    /**
     * @dev The function of calculating the least common multiplier
     */
    function _lcm(uint256 a, uint256 b)
        internal
        pure
        returns (uint256)
    {
        return a.div(_gcd(a, b)).mul(b);
    }

    function reduceToCommonDenominator(Fraction memory a, Fraction memory b)
        internal
        pure
        isValidDenominator(a)
        isValidDenominator(b)
        returns (Fraction memory, Fraction memory)
    {
        uint256 lcm = _lcm(a.denominator, b.denominator);
        uint256 aNumerator = lcm.div(a.denominator).mul(a.numerator);
        uint256 bNumerator = lcm.div(b.denominator).mul(b.numerator);

        return (Fraction(aNumerator, lcm), Fraction(bNumerator, lcm));
    }

    function isGreaterThan(Fraction memory a, Fraction memory b)
        internal
        pure
        isValidDenominator(a)
        isValidDenominator(b)
        returns (bool)
    {
        (a, b) = reduceToCommonDenominator(a, b);
        return a.numerator > b.numerator;
    }

    function mulByNumber(Fraction memory a, uint256 b)
        internal
        pure
        isValidDenominator(a)
        returns (Fraction memory)
    {
        return Fraction(a.numerator.mul(b), a.denominator);
    }

    function reduceToNumber(Fraction memory a)
        internal
        pure
        isValidDenominator(a)
        returns (uint256)
    {
        return a.numerator.div(a.denominator);
    }
}

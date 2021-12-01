// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./LibFraction.sol";

contract ExampleFraction {
    using LibFraction for LibFraction.Fraction;

    LibFraction.Fraction public subject;

    function setSubject(uint256 numerator, uint256 denominator)
        external
    {
        subject = LibFraction.Fraction(numerator, denominator);
    }

    function isGreaterThanSubject(uint256 numerator, uint256 denominator)
        external
        view
        returns (bool)
    {
        LibFraction.Fraction memory interest = LibFraction.Fraction(numerator, denominator);
        return interest.isGreaterThan(subject);
    }

    function mulSubjectByNumberAndReduce(uint256 multiplier)
        external
        view
        returns (uint256)
    {
        return subject.mulByNumber(multiplier).reduceToNumber();
    }
}

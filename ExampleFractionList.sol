// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./LibFraction.sol";
import "./LibFractionList.sol";

contract ExampleFractionList {
    using LibFraction for LibFraction.Fraction;
    using LibFractionList for LibFractionList.List;

    LibFractionList.List public list;

    constructor() {
        list.construct(); // NOTE: VERY IMPORTANT TO CONSTRUCT A LIST BEFORE USING
    }

    function insert(uint256 numerator, uint256 denominator)
        external
    {
        list.insert(LibFraction.Fraction(numerator, denominator));
    }

    function iterate(uint256 multiplier) 
        external
        view
        returns (uint256[] memory values)
    {
        if (list.root == LibFractionList.INVALID) {
            return values;
        }

        values = new uint256[](list.nodes.length);
        uint64 i = 0;
        
        LibFractionList.Node memory head;
        for (uint64 next = list.root; next != LibFractionList.INVALID; next = head.next) {
            head = list.nodes[next];
            values[i++] = head.value.mulByNumber(multiplier).reduceToNumber();
        }
    }

    function debug(uint256 multiplier)
        external
        view
        returns (uint256[] memory values, uint64[] memory ids)
    {
        if (list.root == LibFractionList.INVALID) {
            return (values, ids);
        }

        values = new uint256[](list.nodes.length);
        ids = new uint64[](list.nodes.length);    

        LibFractionList.Node memory head = list.nodes[list.root];
        uint64 prev = list.root;

        for (uint64 i = 0; i < list.nodes.length; i++) {
            values[i] = head.value.mulByNumber(multiplier).reduceToNumber();
            ids[i] = prev;

            if (head.next != LibFractionList.INVALID) {
                prev = head.next;
                head = list.nodes[head.next];
            }
        }
    }

}

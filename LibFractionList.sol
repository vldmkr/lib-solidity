// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./LibFraction.sol";

library LibFractionList {
    using LibFraction for LibFraction.Fraction;

    uint64 internal constant INVALID = 2**64 - 1;
    
    struct Node {
        LibFraction.Fraction value;
        uint64 next;
    }

    struct List {
        Node[] nodes;
        uint64 root;
    }

    modifier isValidNodeId (List storage list, uint64 id) {
        require(id < list.nodes.length, "node id is invalid");
        _;
    }

    function _push(List storage list, LibFraction.Fraction memory value, uint64 next)
        internal
        returns (uint64)
    {
        list.nodes.push(Node(value, next));
        return uint64(list.nodes.length - 1); 
    }

    function _insertFirst(List storage list, LibFraction.Fraction memory value)
        internal
    {
        list.root = _push(list, value, list.root);
    }

    function _insertAfter(List storage list, uint64 prev, LibFraction.Fraction memory value)
        internal
        isValidNodeId(list, prev)
    {
        Node storage node = list.nodes[prev];
        node.next = _push(list, value, node.next);
    }

    function construct(List storage list)
        internal
    {
        list.root = INVALID;
    }

    function insert(List storage list, LibFraction.Fraction memory value)
        internal
    {
        if (list.root == INVALID) {
            _insertFirst(list, value);
            return;
        }
        
        Node memory head = list.nodes[list.root];
        if (value.isGreaterThan(head.value)) {
            _insertFirst(list, value);
            return;
        }
        
        uint64 prev = list.root;
        for (uint64 next = head.next; next != INVALID; next = head.next) {
            head = list.nodes[next];
            if (value.isGreaterThan(head.value)) {
                _insertAfter(list, prev, value);
                return;
            }
            prev = next;
        }

        _insertAfter(list, prev, value);
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title ENSPublicResolver
 * @dev A simplified version of the official ENS Public Resolver contract supporting `addr` and `setAddr`.
 */
contract ENSPublicResolver  {
    // Mapping from node to address
    mapping(bytes32 => address) private addresses;

    // Event emitted when an address is set
    event AddrChanged(bytes32 indexed node, address addr);
    /**
     * @dev Sets the address associated with an ENS node.
     * @param node The node to update.
     * @param addr The address to set.
     */
    function setAddr(bytes32 node, address addr) external {
        require(addr != address(0), "Address cannot be the zero address");

        addresses[node] = addr;
        emit AddrChanged(node, addr);
    }

    /**
     * @dev Returns the address associated with an ENS node.
     * @param node The ENS node to query.
     * @return The associated address.
     */
    function addr(bytes32 node) external view returns (address) {
        return addresses[node];
    }
}

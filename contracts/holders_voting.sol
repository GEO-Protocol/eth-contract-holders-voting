pragma solidity >=0.5.11 <0.6.0;

/// @title GEO Protocol holders voting contract.
///
/// This contract implements simple voting mechanics,
/// that allows ANY ethereum address to DECLARE
/// promoting of some other ethereum address with corresponding weight
/// (please, see docs for the "vote" method for more details).
///
/// This contract does not implement any checks or validation:
/// all the validation is expected to be done on the observers chain.
/// This contract is used only as a publicly available storage for some kind of declarations/requests.
contract HoldersVoting {

    event HolderVoted(
        address holder,
        address[] observers,
        uint256[] weights
    );

    // Votes are stored in the next format:
    // Holder
    //   + Observer -> tokens delegated.
    //   + Observer -> tokens delegated.
    // ...
    mapping(address => mapping(address => uint256)) public votes;

    /// @notice REWRITES votes configuration of holder, that calls the method.
    /// @param observers represents set of addresses that should be promoted.
    /// @param weights represents corresponding token amount, that holder delegates to the observer.
    ///
    /// WARN: This method does not perform any validation.
    ///       From the contract's perspective of view,
    ///       1) this method could be called by any eth. address,
    ///       as well as 2) any eth. address could be promoted.
    ///
    /// Validation checks like
    ///   * "which addresses are allowed to vote for observers",
    ///   * "does current holder really owns declared amount of tokens",
    ///   * "is this distribution correct, and total amount of tokens do not exceeds 100%"
    ///   * etc
    ///
    /// are expected to be done on the observers chain itself.
    /// This method only allows to collect declarations/requests from holders, no more.
    function rewriteVotes(address[] memory observers, uint256[] memory weights) public {
        require(observers.length <= 64);
        require(observers.length == weights.length);

        for (uint i=0; i<observers.length; i++) {
            votes[msg.sender][observers[i]] = weights[i];
        }

        emit HolderVoted(msg.sender, observers, weights);
    }
}


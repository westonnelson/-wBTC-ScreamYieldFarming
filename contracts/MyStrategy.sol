// SPDX-License-Identifier: MIT

pragma solidity 0.6.12;
pragma experimental ABIEncoderV2;

import {BaseStrategy} from "@badger-finance/BaseStrategy.sol";

contract MyStrategy is BaseStrategy {

    using SafeERC20Upgradeable for IERC20Upgradeable;
    using AddressUpgradeable for address;
    using SafeMathUpgradeable for uint256;
    
    // $scWBTC Token;
    address public constant scToken = 0x4565DC3Ef685E4775cdF920129111DdF43B9d882;
    // $SCREAM Token
    address public constant reward = 0xe0654C8e6fd4D733349ac7E09f6f23DA256bF475;

    address public scToken; // Token we provide liquidity with
    address public reward; // Token we farm and swap to want / scToken
    address constant BADGER = 0x753fbc5800a8C8e3Fb6DC6415810d627A387Dfc9;

        function initialize(address _vault, address[1] memory _wantConfig)
        __BaseStrategy_init(_vault) ;
    
        want = _wantConfig[0]; 
        scToken = _wantConfig[1];
        reward = _wantConfig[2];
        
        // If you need to set new values that are not constants, set them like so
        // stakingContract = 0x79ba8b76F61Db3e7D994f7E384ba8f7870A043b7;

        // If you need to do one-off approvals do them here like so
        // IERC20Upgradeable(reward).safeApprove(
        //     address(DX_SWAP_ROUTER),
        //     type(uint256).max
        // );
    }
    
    /// @dev Return the name of the strategy
    function getName() external pure override returns (string memory) {
        return "$wBTCYieldFarmingScream";
    }

    /// @dev Return a list of protected tokens
    /// @notice It's very important all tokens that are meant to be in the strategy to be marked as protected
    /// @notice this provides security guarantees to the depositors they can't be sweeped away
    function getProtectedTokens() public view virtual override returns (address[] memory) {
        address[] memory protectedTokens = new address[](2);
        protectedTokens[0] = want;
        protectedTokens[1] = scToken;
        protectedTokens[2] = reward;
        protectedTokens[3] = BADGER;
        return protectedTokens;
    }

    /// @dev Deposit `_amount` of want, investing it to earn yield
  function mint(uint256 mintAmount) internal override { 

    }

    /// @dev Withdraw all funds, this is used for migrations, most of the time for emergency reasons
    function _redeemUnderlying(uint256 redeemAmount) internal override {
        // Add code here to unlock all available funds
    }

    /// @dev Withdraw `_amount` of want, so that it can be sent to the vault / depositor
    /// @notice just unlock the funds and return the amount you could unlock
     function repayBorrow(uint256 repayAmount) internal override returns (uint256) {
        // Add code here to unlock / withdraw `_amount` of tokens to the withdrawer
        // If there's a loss, make sure to have the withdrawer pay the loss to avoid exploits
        // Socializing loss is always a bad idea
        return _amount;
    }


    /// @dev Does this function require `tend` to be called?
    function _isTendable() internal override pure returns (bool) {
        return false; // Change to true if the strategy should be tended
    }

   function _claimComp() internal override returns (TokenAmount[] memory harvested) {
        // No-op as we don't do anything with funds
        // use autoCompoundRatio here to convert rewards to want ...

        // keep this to get paid!
        _reportToVault(0);..

        // Nothing harvested, we have 2 tokens, return both 0s
        harvested = new TokenAmount[](2);
        harvested[0] = TokenAmount(want, 0);
        harvested[1] = TokenAmount(BADGER, 0);
        
        // Use this if your strategy doesn't sell the extra tokens
        // This will take fees and send the token to the badgerTree
        _processExtraToken(token, amount);

        return harvested;
    }


    // Example tend is a no-op which returns the values, could also just revert
    function _tend() internal override returns (TokenAmount[] memory tended){
        // Nothing tended
        tended = new TokenAmount[](2);
        tended[0] = TokenAmount(want, 0);
        tended[1] = TokenAmount(BADGER, 0); 
        return tended;
    }

    /// @dev Return the balance (in want) that the strategy has invested somewhere
    function balanceOfUnderlying(address owner) public view override returns (uint256) {
        // Change this to return the amount of want invested in another protocol
        return 0;
    }

    /// @dev Return the balance of rewards that the strategy has accrued
    /// @notice Used for offChain APY and Harvest Health monitoring
    function balanceOfRewards() external view override returns (TokenAmount[] memory rewards) {
        // Rewards are 0
        rewards = new TokenAmount[](2);
        rewards[0] = TokenAmount(want, 0);
        rewards[1] = TokenAmount(scToken, 1);
        rewards[2] = TokenAmount(reward, 2);
        rewards[3] = TokenAmount(BADGER, 3); 
        return rewards;
    }
}
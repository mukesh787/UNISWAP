// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./IERC20.sol";
import "./uniswap.sol";

contract TestUniswap{
    address private constant UNISWAP_V2_ROUTER=0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    address private constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address private constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address constant USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    IUniswapV2Router private router = IUniswapV2Router(UNISWAP_V2_ROUTER);
    IERC20 private weth = IERC20(WETH);
    IERC20 private dai = IERC20(DAI);

    function swap(
    address _tokenIn,
    address _tokenOut,
    uint256 _amountIn,
    uint256 _amountOutMin,
    address _to
    ) external{
        IERC20(_tokenIn).transferFrom(msg.sender,address(this),_amountIn);
        IERC20(_tokenIn).approve(UNISWAP_V2_ROUTER,_amountIn);

        address[] memory path;
        path=new address[](3);
        path[0]=_tokenIn;
        path[1]=WETH;
        path[2]=_tokenOut;

        router.swapExactTokensForTokens(_amountIn, _amountOutMin, path, _to, block.timestamp);
    }
}
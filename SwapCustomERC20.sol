// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity =0.7.6;

// pragma solidity >=0.7.6 <=0.8.19;
pragma abicoder v2;
import '@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol';


interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
}

contract SwapCustomERC20 {
    mapping(string => uint256) public tokenBucket;
    
    //It's same for testnet and mainnet so hardcoded it
    address public routerAddress;
    ISwapRouter public  swapRouter;
    address public  DAI ;
    address public  WETH9 ;
    address public  USDC;
    address public LINK;
    address public TOKEN0;
    // For this example, we will set the pool fee to 0.3%.
    uint24 public constant poolFee = 3000;

           
    /*
    initVars: It is used as a function to be called to initialize variables while calling 'deployProxy'
    */
   function initVars(address routerAddr,address dai,address weth,address usdc, address link, address erc20 ,
                        uint256 daipercent, uint256 wethpercent, uint256 usdcpercent) public {
             //It's same for testnet and mainnet so hardcoded it
            routerAddress = routerAddr;
            swapRouter = ISwapRouter(routerAddress); //IMulticall(routerAddress);// ISwapRouter(routerAddress);
            DAI = dai;
            WETH9 = weth;
            USDC = usdc;
            LINK=link;
            TOKEN0 = erc20;

            tokenBucket["DAI"] = daipercent;
            tokenBucket["WETH"] = wethpercent;
            tokenBucket["USDC"] = usdcpercent;
             
    }

    //to find token amount to be swapped for a percent specified, for a specific token
    function fetchPercentSwap(string memory tokenid, uint256 amoountIn) public view returns(uint256) {
       
       uint256 percent = tokenBucket[tokenid];
       return  (amoountIn * percent) / 100;

    }
    
    //to swap erc20 with dai
    function swapWithDai(uint256 amountIn,bool isSwappedValue) public   {
     
        if(isSwappedValue == true) {

            IERC20(DAI).transferFrom(msg.sender, address(this), amountIn);
            IERC20(DAI).approve(address(swapRouter), amountIn);

            ISwapRouter.ExactInputSingleParams memory params =
            ISwapRouter.ExactInputSingleParams({
                tokenIn: DAI,
                tokenOut: TOKEN0,//WETH9,
                fee: poolFee,
                recipient: msg.sender,
                deadline: block.timestamp,
                amountIn: amountIn,
                amountOutMinimum: 0,
                sqrtPriceLimitX96: 0
            });
            swapRouter.exactInputSingle(params);

        } else {

            uint256 swapAmt = fetchPercentSwap("DAI",amountIn);
            IERC20(DAI).transferFrom(msg.sender, address(this), swapAmt);
            IERC20(DAI).approve(address(swapRouter), swapAmt);

            ISwapRouter.ExactInputSingleParams memory params =
            ISwapRouter.ExactInputSingleParams({
                tokenIn: DAI,
                tokenOut: TOKEN0,//WETH9,
                fee: poolFee,
                recipient: msg.sender,
                deadline: block.timestamp,
                amountIn: swapAmt,
                amountOutMinimum: 0,
                sqrtPriceLimitX96: 0
            });
            swapRouter.exactInputSingle(params);

        }
     

    }

    // to swap erc20 with weth
    function swapWithWETH9(uint256 amountIn, bool isSwappedValue) public   {
      

        if(isSwappedValue == true) {

            IERC20(WETH9).transferFrom(msg.sender, address(this), amountIn);
            IERC20(WETH9).approve(address(swapRouter), amountIn);

            ISwapRouter.ExactInputSingleParams memory params =
            ISwapRouter.ExactInputSingleParams({
                tokenIn: WETH9,
                tokenOut: TOKEN0,
                fee: poolFee,
                recipient: msg.sender,
                deadline: block.timestamp,
                amountIn: amountIn,
                amountOutMinimum: 0,
                sqrtPriceLimitX96: 0
            });
            swapRouter.exactInputSingle(params);

        } else {
            uint256 swapAmt = fetchPercentSwap("WETH",amountIn);
            IERC20(WETH9).transferFrom(msg.sender, address(this), swapAmt);
            IERC20(WETH9).approve(address(swapRouter), swapAmt);

            ISwapRouter.ExactInputSingleParams memory params =
            ISwapRouter.ExactInputSingleParams({
                tokenIn: WETH9,
                tokenOut: TOKEN0,
                fee: poolFee,
                recipient: msg.sender,
                deadline: block.timestamp,
                amountIn: swapAmt,
                amountOutMinimum: 0,
                sqrtPriceLimitX96: 0
            });
            swapRouter.exactInputSingle(params);
        }
        

    }

    // to swap erc20 with usdc
    function swapWithUSDC(uint amountIn, bool isSwappedValue) public {
       

         if(isSwappedValue == true) {

            IERC20(USDC).transferFrom(msg.sender, address(this), amountIn);
            IERC20(USDC).approve(address(swapRouter), amountIn);

            ISwapRouter.ExactInputSingleParams memory params =
            ISwapRouter.ExactInputSingleParams({
                tokenIn: USDC,
                tokenOut: TOKEN0,
                fee: poolFee,
                recipient: msg.sender,
                deadline: block.timestamp,
                amountIn: amountIn,
                amountOutMinimum: 0,
                sqrtPriceLimitX96: 0
            });
            swapRouter.exactInputSingle(params);

         } else {

            uint256 swapAmt = fetchPercentSwap("USDC",amountIn);
            IERC20(USDC).transferFrom(msg.sender, address(this), swapAmt);
            IERC20(USDC).approve(address(swapRouter), swapAmt);

            ISwapRouter.ExactInputSingleParams memory params =
            ISwapRouter.ExactInputSingleParams({
                tokenIn: USDC,
                tokenOut: TOKEN0,
                fee: poolFee,
                recipient: msg.sender,
                deadline: block.timestamp,
                amountIn: swapAmt,
                amountOutMinimum: 0,
                sqrtPriceLimitX96: 0
            });
            swapRouter.exactInputSingle(params);

         }
    }


    // to bundle all swap transactions and submit as one.
    function swap(uint256 usdcamt, uint256 wethamt, uint256 daiamt) public payable  returns (bytes[] memory results) {

        bytes[] memory callData = new bytes[](3);
        callData[0] = abi.encodeWithSelector(this.swapWithDai.selector,fetchPercentSwap("DAI",daiamt), true);
        callData[1] = abi.encodeWithSelector(this.swapWithWETH9.selector,fetchPercentSwap("WETH",wethamt), true);
        callData[2] = abi.encodeWithSelector(this.swapWithUSDC.selector,fetchPercentSwap("USDC",usdcamt), true);

        results = new bytes[](callData.length);
        for (uint256 i = 0; i < callData.length; i++) {
            (bool success, bytes memory result) = address(this).delegatecall(callData[i]);

            if (!success) {
                if (result.length < 68) revert();
                assembly {
                    result := add(result, 0x04)
                }
                revert(abi.decode(result, (string)));
            }
            results[i] = result;
        }

       

    }

}



Basic ERC20 Token Example:

```
import "@cryptolink/contracts/bridge/MessageV3Client.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract MyToken is ERC20, ERC20Burnable, MessageV3Client {
    constructor() ERC20("My Token", "MYTOKEN") {
        _mint(msg.sender, 100_000_000 ether);
    }
    
    function bridge(
        address _to, 
        uint _chainId, 
        uint _amount
    ) external onlyActiveBridge(_chainId) returns (uint _txId) {
        // burn tokens
        _burn(msg.sender, _amount);

        // data package to send across chain
        bytes memory _data = abi.encode(_to, _amount);

        // send bridge message
        return _sendMessage(
            _chainId,   // destination chain id
            address(0), // optional, for referral tracking
            _data       // encoded data to send across chain
        );
    }

    function messageProcess(
        uint, 
        uint _sourceChainId, 
        address _sender, 
        address, 
        uint, 
        bytes calldata _data
    ) external override onlySelfBridge (_sender, _sourceChainId) {
        // process data package
        (address _to, uint _amount) = abi.decode(_data, (address, uint));

        // mint tokens
        _mint(_to, _amount);        
    }
}
```

Example initialization:

```
// chain ids to enable
const chains = [
    1,  // Ethereum
    56, // Binance
    137 // Polygon
];

// contract addresses of the deployment of the contract on each chain
const endpoints = [
    "0x0000000000000000000000000000000000", // address of MyToken contract on Ethereum
    "0x0000000000000000000000000000000000", // address of MyToken contract on Binance
    "0x0000000000000000000000000000000000"  // address of MyToken contract on Polygon
];

// storage for fees to be charged by calling contract - if you wish to charge your
// users fees, you may store the fee per chain to charge in this location. this is
// in whichever token you wish to take from the users of your contract - taking of
// the fees must be implemented in your contract if desired
const fees = [
    ethers.parseEther("5"), 
    ethers.parseEther("1"), 
    ethers.parseEther("1")
]

// source chain block confirmations requested for transactions to be considered valid
const confirmations = [
    6, 
    6,
    4
];

const myToken = ethers.getContract("MyToken");
await myToken.configureBridge(
    ethers.ZeroAddress, // pass address(0) to use default
    chains,
    prices,
    endpoints,
    confirmations
);
```

Bridge Addresses:
```
avalanche   
binance     
celo        
cronos      
ethereum    
fantom      
gauss       
harmony     
metis       
oasis       
polygon     
pulse       
```

Testnet Bridge Addresses:
```
avalanche-testnet   
binance-testnet     
celo-testnet        
cronos-testnet      
ethereum-testnet    
fantom-testnet      
gauss-testnet       
harmony-testnet     
metis-testnet       
oasis-testnet       
polygon-testnet     
pulse-testnet       
```

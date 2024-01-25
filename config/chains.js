const chainsConfig = {
    "42161": { // Arbitrum Mainnet
      message: "0x15AC559DA4951c796DB6620fAb286B96840D039A",
      feeToken: "0xaf88d065e77c8cC2239327C5EDb3A432268e5831",
      weth: "0x82aF49447D8a07e3bd95BD0d56f35241523fBab1"
    },
    "1313161554": { // Auroura Mainnet
      message: "0x15AC559DA4951c796DB6620fAb286B96840D039A",
      feeToken: "0xB12BFcA5A55806AaF64E99521918A4bf0fC40802",
      weth: "0xC9BdeEd33CD01541e1eeD10f90519d2C06Fe3feB"
    },
    "43114": { // Avalanche Mainnet
      message: "0x15AC559DA4951c796DB6620fAb286B96840D039A",
      feeToken: "0xB97EF9Ef8734C71904D8002F8b6Bc66Dd9c48a6E",
      weth: "0xB31f66AA3C1e785363F0875A1B74E27b85FD66c7"
    },
    "8453": { // Base Mainnet
      message: "0xf8B8656Ce65Ecf334AcCe299e24E97fB5069c2C8",
      feeToken: "0x833589fCD6eDb6E08f4c7C32D4f71b54bdA02913",
      weth: "0x4200000000000000000000000000000000000006"
    },
    "56": { // Binance Mainnet
      message: "0x15AC559DA4951c796DB6620fAb286B96840D039A",
      feeToken: "0x8ac76a51cc950d9822d68b83fe1ad97b32cd580d",
      weth: "0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c"
    },
    "288": { // Boba Mainnet
      message: "",
      feeToken: "0x66a2A913e447d6b4BF33EFbec43aAeF87890FBbc",
      weth: "0xDeadDeAddeAddEAddeadDEaDDEAdDeaDDeAD0000"
    },
    "7700": { // Canto Mainnet
      message: "",
      feeToken: "0x80b5a32E4F032B2a058b4F29EC95EEfEEB87aDcd",
      weth: "0x5FD55A1B9FC24967C4dB09C513C3BA0DFa7FF687"
    },
    "42220": { // Celo Mainnet
      message: "0x15AC559DA4951c796DB6620fAb286B96840D039A",
      feeToken: "0x37f750B7cC259A2f741AF45294f6a16572CF5cAd",
      weth: "0x471EcE3750Da237f93B8E339c536989b8978a438"
    },
    "25": { // Cronos Mainnet
      message: "0x4f3ad39a5dfe09ef9d95cc546a60ee5ad2c75eec",
      feeToken: "0xc21223249CA28397B4B6541dfFaEcC539BfF0c59",
      weth: "0x5C7F8A570d578ED84E63fdFA7b1eE72dEae1AE23"
    },
    "1": { // Ethereum Mainnet
      message: "0x15AC559DA4951c796DB6620fAb286B96840D039A",
      feeToken: "0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48",
      weth: "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2"
    },
    "250": { // Fantom Mainnet
      message: "0x15AC559DA4951c796DB6620fAb286B96840D039A",
      feeToken: "0x04068DA6C83AFCFA0e13ba15A6696662335D5B75",
      weth: "0x21be370D5312f44cB42ce377BC9b8a0cEF1A4C83"
    },
    "14": { // Flare Mainnet 
      message: "",
      feeToken: "0x8eB8435456d5187796eF00e9ab94544F9666D82A",
      weth: "0x135cB19AcdE9fFB4654caCE4189A0E0Fb4B6954e"
    },
    "1777": { // Gauss Mainnet
      message: "0x15AC559DA4951c796DB6620fAb286B96840D039A",
      weth: "0xb45fC65405B1a28Bb24AF49fe2caa278525Fe977",
      feeToken: "0x26497607aAC75F1fFD7372FEDf6dBE5CFD8Ad92b" // no stablecoin on network ..
    },
    "100": { // Gnosis Mainnet
      message: "0x15AC559DA4951c796DB6620fAb286B96840D039A",
      feeToken: "0x0000000000000000000000000000000000000000",
      weth: "0x6A023CCd1ff6F2045C3309768eAd9E68F978f6e1"
    },    
    "1666600000": { // Harmony Mainnet
      message: "0x15AC559DA4951c796DB6620fAb286B96840D039A",
      feeToken: "0x985458E523dB3d53125813eD68c274899e9DfAb4",
      weth: "0xcF664087a5bB0237a0BAd6742852ec6c8d69A27a"
    },
    "13371": { // Immutable Mainnet
      message: "",
      feeToken: "0x6de8aCC0D406837030CE4dd28e7c08C5a96a30d2",
      weth: "0x52A6c53869Ce09a731CD772f245b97A4401d3348"
    },
    "2222": { // Kava Mainnet
      message: "0x15AC559DA4951c796DB6620fAb286B96840D039A",
      feeToken: "0x0000000000000000000000000000000000000000",
      weth: "0xc86c7C0eFbd6A49B35E8714C5f59D99De09A225b"
    },
    "59144": { // Linea Mainnet
      message: "0x15AC559DA4951c796DB6620fAb286B96840D039A",
      feeToken: "0x0000000000000000000000000000000000000000",
      weth: "0xe5D7C2a44FfDDf6b295A15c148167daaAf5Cf34f"
    },
    "1088": { // Metis Mainnet
      message: "0x15AC559DA4951c796DB6620fAb286B96840D039A",
      feeToken: "0xEA32A96608495e54156Ae48931A7c20f0dcc1a21",
      weth: "0xDeadDeAddeAddEAddeadDEaDDEAdDeaDDeAD0000"
    },
    "42262": { // Oasis Emerald Mainnet
      message: "0x15AC559DA4951c796DB6620fAb286B96840D039A",
      feeToken: "0x81ECac0D6Be0550A00FF064a4f9dd2400585FE9c",
      weth: "0x21C718C22D52d0F3a789b752D4c2fD5908a8A733"
    },
    "137": { // Polygon Mainnet
      message: "0x916d26564fe2b96a063cfae5f5768274b1334b27",
      feeToken: "0x3c499c542cEF5E3811e1192ce70d8cC03d5c3359",
      weth: "0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270"
    },
    "1101": { // PolygonZK Mainnet
      message: "0x15AC559DA4951c796DB6620fAb286B96840D039A",
      feeToken: "0x0000000000000000000000000000000000000000",
      weth: "0x4F9A0e7FD2Bf6067db6994CF12E4495Df938E6e9"
    },
    "369": { // Pulse Mainnet
      message: "0x15AC559DA4951c796DB6620fAb286B96840D039A",
      feeToken: "0x15d38573d2feeb82e7ad5187ab8c1d52810b1f07",
      weth: "0xa1077a294dde1b09bb078844df40758a5d0f9a27"
    },
    "570": { // Rollux Mainnet
      message: "0x15AC559DA4951c796DB6620fAb286B96840D039A",
      feeToken: "0x0000000000000000000000000000000000000000",
      weth: "0x4200000000000000000000000000000000000006"
    },


    "421614": { // Arbitrum Testnet (Sepolia)
      message: "0x207CbCa48258591CD1e953739c663184A02bB320"
    },
    "1313161555": { // Aurora Testnet
      message: "0x3B5b764229b2EdE0162220aF51ab6bf7f8527a4F"
    },
    "65010001": { // Autonity Testnet
      message: "0x3B5b764229b2EdE0162220aF51ab6bf7f8527a4F"
    },
    "43113": { // Avalanche Testnet
      message: "0x24BEFF24327C8E956d5FC74a5C502038683cDc0A"
    },
    "84532": { // Base Testnet (Sepolia)
      message: "0x18716F6E46a66919deacD3c6fd4fa6Da02fa30b2"
    },
    "2888": { // Boba Testnet
      message: "0xe20B995917eb334093EA1974CDa9971B102C5aff"
    },
    "97": { // Binance Testnet
      message: "0x535CCeD6C471eE907eEB3bBECf1C8223208Ca5e0"
    },
    "7701": { // Canto Testnet
      message: "0x3B5b764229b2EdE0162220aF51ab6bf7f8527a4F"
    },
    "44787": { // Celo Testnet
      message: "0x6e658066340C7cae09dB68F5339Ddc4b806d3598"
    },
    "338": { // Cronos Testnet
      message: "0x8eb10FC1793094113E7f52bA159A6AeB54CaB92c"
    },
    "5": { // Ethereum Goerli
      message: "0x566B40Dd59A868c244E1353368e08ddaD1C1d74f"
    },
    "17000": { // Ethereum Holesky
      message: "0x9d75f706b986F0075b3778a12153390273dE95eC"
    },
    "11155111": { // Ethereum Sepolia
      message: "0x8DE416ABd87307f966a5655701F2f78012585225"
    },
    "4002": { // Fantom Testnet
      message: "0x7d474aA4DbDBc276b67abcc5f54262978b369cEC"
    },
    "377": { // Forest Testnet
      message: "0x3B5b764229b2EdE0162220aF51ab6bf7f8527a4F"
    },
    "68840142": { // Frame Testnet
      message: "0x3B5b764229b2EdE0162220aF51ab6bf7f8527a4F"
    },
    "1452": { // Gauss Testnet
      message: "0x6c83DC6C5128ff3E073E737523D2176aAeB08525"
    },
    "10200": { // Gnosis Testnet
      message: "0x146449fb27e4A4B4721a9c5742f3baB1e34eb31f"
    },
    "1666700000": { // Harmony Testnet
      message: "0xE0a5cBb1f15a84C4a4A0f7E98F9721997182deD6"
    },
    "1663": { // Horizen Testnet
      message: "0x3B5b764229b2EdE0162220aF51ab6bf7f8527a4F"
    },
    "13473": { // Immutable Testnet
      message: ""
    },
    "167008": { // Katla Testnet
      message: "0x3B5b764229b2EdE0162220aF51ab6bf7f8527a4F"
    },
    "2221": { // Kava Testnet
      message: "0x3B5b764229b2EdE0162220aF51ab6bf7f8527a4F"
    },
    "1001": { // Klaytn Testnet
      message: "0x3B5b764229b2EdE0162220aF51ab6bf7f8527a4F"
    },
    "59140": { // Linea Testnet
      message: "0x3B5b764229b2EdE0162220aF51ab6bf7f8527a4F"
    },
    "9768": { // Mainnetz Testnet
      message: "0x3B5b764229b2EdE0162220aF51ab6bf7f8527a4F"
    },
    "5001": { // Mantle Testnet
      message: "0x3B5b764229b2EdE0162220aF51ab6bf7f8527a4F"
    },
    "599": { // Metis Testnet
      message: "0x4f313cB864BD7138Fdb35337182D5b0E78d9fB33"
    },
    "42261": { // Oasis Emerald Testnet
      message: "0x566B40Dd59A868c244E1353368e08ddaD1C1d74f"
    },
    "23295": { // Oasis Sapphire Testnet
      message: "0x566B40Dd59A868c244E1353368e08ddaD1C1d74f"
    },
    "65": { // OKEx Testnet
      message: "0xF1FBB3E9977dAcF3909Ab541792cB2Bba10FFD5E"
    },
    "1945": { // Onus Testnet
      message: "0x3B5b764229b2EdE0162220aF51ab6bf7f8527a4F"
    },
    "5611": { // opBNB Testnet
      message: "0x3B5b764229b2EdE0162220aF51ab6bf7f8527a4F"
    },
    "11155420": { // Optimism Testnet
      message: "0xB4245BFEA4AfE63c7F7863D090166890e9FEf1b2"
    },
    "80001": { // Polygon Testnet
      message: "0x08A2d304547A4B93B254d906502A3fc778D78412"
    },
    "1442": { // Polygon zkEVM Testnet
      message: "0xcA877c797D599bE2Bf8C897a3B9eba6bA4113332"
    },
    "943": { // Pulse Testnet
      message: "0x4f313cB864BD7138Fdb35337182D5b0E78d9fB33"
    },
    "17001": { // Redstone Testnet
      message: "0x9d75f706b986F0075b3778a12153390273dE95eC"
    },
    "57000": { // Rollux Testnet
      message: "0x3B5b764229b2EdE0162220aF51ab6bf7f8527a4F"
    },
    "534351": { // Scroll Testnet (Sepolia)
      message: "0x23E2CE1fF48cF21239f8c5eb783CE89df02B6f35"
    },
    "64165": { // Sonic Testnet
      message: "0x3B5b764229b2EdE0162220aF51ab6bf7f8527a4F"
    },
    "41": { // Telos Testnet
      message: "0x3B5b764229b2EdE0162220aF51ab6bf7f8527a4F"
    },
    "195": { // X1 Testnet
      message: "0x4f313cB864BD7138Fdb35337182D5b0E78d9fB33"
    },
    "51": { // XDC Testnet
      message: "0x0EFafca24E5BbC1C01587B659226B9d600fd671f"
    },
    "7001": { // ZetaChain Testnet
      message: "0x3B5b764229b2EdE0162220aF51ab6bf7f8527a4F"
    },    
  };
  
  module.exports = chainsConfig;
  

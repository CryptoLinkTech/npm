const chainsConfig = {
    "42161": { // Arbitrum Mainnet
      message: "0x15AC559DA4951c796DB6620fAb286B96840D039A",
      feeToken: "0xaf88d065e77c8cC2239327C5EDb3A432268e5831",
      weth: "0x82aF49447D8a07e3bd95BD0d56f35241523fBab1",
      rpc: "https://42161.rpc.cryptolink.tech/"
    },
    "1313161554": { // Auroura Mainnet
      message: "0x15AC559DA4951c796DB6620fAb286B96840D039A",
      feeToken: "0xB12BFcA5A55806AaF64E99521918A4bf0fC40802",
      weth: "0xC9BdeEd33CD01541e1eeD10f90519d2C06Fe3feB",
      rpc: "https://1313161554.rpc.cryptolink.tech/"
    },
    "43114": { // Avalanche Mainnet
      message: "0x15AC559DA4951c796DB6620fAb286B96840D039A",
      feeToken: "0xB97EF9Ef8734C71904D8002F8b6Bc66Dd9c48a6E",
      weth: "0xB31f66AA3C1e785363F0875A1B74E27b85FD66c7",
      rpc: "https://43114.rpc.cryptolink.tech/"
    },
    "8453": { // Base Mainnet
      message: "0xf8B8656Ce65Ecf334AcCe299e24E97fB5069c2C8",
      feeToken: "0x833589fCD6eDb6E08f4c7C32D4f71b54bdA02913",
      weth: "0x4200000000000000000000000000000000000006",
      rpc: "https://8453.rpc.cryptolink.tech/"
    },
    "56": { // Binance Mainnet
      message: "0x15AC559DA4951c796DB6620fAb286B96840D039A",
      feeToken: "0x8ac76a51cc950d9822d68b83fe1ad97b32cd580d",
      weth: "0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c",
      rpc: "https://56.rpc.cryptolink.tech/"      
    },
    "288": { // Boba Mainnet
      message: "",
      feeToken: "0x66a2A913e447d6b4BF33EFbec43aAeF87890FBbc",
      weth: "0xDeadDeAddeAddEAddeadDEaDDEAdDeaDDeAD0000",
      rpc: "https://288.rpc.cryptolink.tech/"
    },
    "7700": { // Canto Mainnet
      message: "",
      feeToken: "0x80b5a32E4F032B2a058b4F29EC95EEfEEB87aDcd",
      weth: "0x5FD55A1B9FC24967C4dB09C513C3BA0DFa7FF687",
      rpc: "https://7700.rpc.cryptolink.tech/"
    },
    "42220": { // Celo Mainnet
      message: "0x15AC559DA4951c796DB6620fAb286B96840D039A",
      feeToken: "0x37f750B7cC259A2f741AF45294f6a16572CF5cAd",
      weth: "0x471EcE3750Da237f93B8E339c536989b8978a438",
      rpc: "https://42220.rpc.cryptolink.tech/"
    },
    "25": { // Cronos Mainnet
      message: "0x4f3ad39a5dfe09ef9d95cc546a60ee5ad2c75eec",
      feeToken: "0xc21223249CA28397B4B6541dfFaEcC539BfF0c59",
      weth: "0x5C7F8A570d578ED84E63fdFA7b1eE72dEae1AE23",
      rpc: "https://25.rpc.cryptolink.tech/"
    },
    "1": { // Ethereum Mainnet
      message: "0x15AC559DA4951c796DB6620fAb286B96840D039A",
      feeToken: "0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48",
      weth: "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2",
      rpc: "https://1.rpc.cryptolink.tech/"
    },
    "250": { // Fantom Mainnet
      message: "0x15AC559DA4951c796DB6620fAb286B96840D039A",
      feeToken: "0x04068DA6C83AFCFA0e13ba15A6696662335D5B75",
      weth: "0x21be370D5312f44cB42ce377BC9b8a0cEF1A4C83",
      rpc: "https://250.rpc.cryptolink.tech/"
    },
    "14": { // Flare Mainnet 
      message: "",
      feeToken: "0x8eB8435456d5187796eF00e9ab94544F9666D82A",
      weth: "0x135cB19AcdE9fFB4654caCE4189A0E0Fb4B6954e",
      rpc: "https://14.rpc.cryptolink.tech/"
    },
    "1777": { // Gauss Mainnet
      message: "0x15AC559DA4951c796DB6620fAb286B96840D039A",
      weth: "0xb45fC65405B1a28Bb24AF49fe2caa278525Fe977",
      feeToken: "0x26497607aAC75F1fFD7372FEDf6dBE5CFD8Ad92b", // no stablecoin on network ..
      rpc: "https://1777.rpc.cryptolink.tech/",
    },
    "100": { // Gnosis Mainnet
      message: "0x15AC559DA4951c796DB6620fAb286B96840D039A",
      feeToken: "0x0000000000000000000000000000000000000000",
      weth: "0x6A023CCd1ff6F2045C3309768eAd9E68F978f6e1",
      rpc: "https://100.rpc.cryptolink.tech/",
    },    
    "1666600000": { // Harmony Mainnet
      message: "0x15AC559DA4951c796DB6620fAb286B96840D039A",
      feeToken: "0x985458E523dB3d53125813eD68c274899e9DfAb4",
      weth: "0xcF664087a5bB0237a0BAd6742852ec6c8d69A27a",
      rpc: "https://1666600000.rpc.cryptolink.tech/",
    },
    "13371": { // Immutable Mainnet
      message: "",
      feeToken: "0x6de8aCC0D406837030CE4dd28e7c08C5a96a30d2",
      weth: "0x52A6c53869Ce09a731CD772f245b97A4401d3348",
      rpc: "https://13371.rpc.cryptolink.tech/"
    },
    "2222": { // Kava Mainnet
      message: "0x15AC559DA4951c796DB6620fAb286B96840D039A",
      feeToken: "0x0000000000000000000000000000000000000000",
      weth: "0xc86c7C0eFbd6A49B35E8714C5f59D99De09A225b",
      rpc: "https://2222.rpc.cryptolink.tech/"
    },
    "59144": { // Linea Mainnet
      message: "0x15AC559DA4951c796DB6620fAb286B96840D039A",
      feeToken: "0x0000000000000000000000000000000000000000",
      weth: "0xe5D7C2a44FfDDf6b295A15c148167daaAf5Cf34f",
      rpc: "https://59144.rpc.cryptolink.tech/"
    },
    "1088": { // Metis Mainnet
      message: "0x15AC559DA4951c796DB6620fAb286B96840D039A",
      feeToken: "0xEA32A96608495e54156Ae48931A7c20f0dcc1a21",
      weth: "0xDeadDeAddeAddEAddeadDEaDDEAdDeaDDeAD0000",
      rpc: "https://1088.rpc.cryptolink.tech/",
    },
    "42262": { // Oasis Emerald Mainnet
      message: "0x15AC559DA4951c796DB6620fAb286B96840D039A",
      feeToken: "0x81ECac0D6Be0550A00FF064a4f9dd2400585FE9c",
      weth: "0x21C718C22D52d0F3a789b752D4c2fD5908a8A733",
      rpc: "https://42262.rpc.cryptolink.tech/"
    },
    "137": { // Polygon Mainnet
      message: "0x916d26564fe2b96a063cfae5f5768274b1334b27",
      feeToken: "0x3c499c542cEF5E3811e1192ce70d8cC03d5c3359",
      weth: "0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270",
      rpc: "https://137.rpc.cryptolink.tech/"
    },
    "1101": { // PolygonZK Mainnet
      message: "0x15AC559DA4951c796DB6620fAb286B96840D039A",
      feeToken: "0x0000000000000000000000000000000000000000",
      weth: "0x4F9A0e7FD2Bf6067db6994CF12E4495Df938E6e9",
      rpc: "https://1101.rpc.cryptolink.tech/"
    },
    "369": { // Pulse Mainnet
      message: "0x15AC559DA4951c796DB6620fAb286B96840D039A",
      feeToken: "0x15d38573d2feeb82e7ad5187ab8c1d52810b1f07",
      weth: "0xa1077a294dde1b09bb078844df40758a5d0f9a27",
      rpc: "https://369.rpc.cryptolink.tech/"
    },
    "570": { // Rollux Mainnet
      message: "0x15AC559DA4951c796DB6620fAb286B96840D039A",
      feeToken: "0x0000000000000000000000000000000000000000",
      weth: "0x4200000000000000000000000000000000000006",
      rpc: "https://570.rpc.cryptolink.tech/"
    },
    "99999999991": { // Solana Mainnet
      message: "",
      feeToken: "",
      weth: "",
      rpc: ""
    },

    "421614": { // Arbitrum Testnet (Sepolia)
      message: "0x207CbCa48258591CD1e953739c663184A02bB320",
      feeToken: "0x6dc9C1599C52e8EC4f1389Cb466Df7A799E85136",
      weth: "",
      rpc: "https://421614.rpc.cryptolink.tech/",
    },
    "1313161555": { // Aurora Testnet
      message: "0x3B5b764229b2EdE0162220aF51ab6bf7f8527a4F",
      feeToken: "0x1D006355e6778d06a40296eE510bbc09f60c9e1c",
      weth: "",
      rpc: "https://1313161555.rpc.cryptolink.tech/",      
    },
    "65010001": { // Autonity Testnet
      message: "0x3B5b764229b2EdE0162220aF51ab6bf7f8527a4F",
      feeToken: "0x17C84459367f9787356b01d7f624Ef0e7E6cA11F",
      weth: "",
      rpc: "https://65010001.rpc.cryptolink.tech/",
    },
    "43113": { // Avalanche Testnet
      message: "0x24BEFF24327C8E956d5FC74a5C502038683cDc0A",
      feeToken: "0x3E445B8fB6ef183Eb32bc1492f379afDAf2b7209",
      weth: "",
      rpc: "https://43113.rpc.cryptolink.tech/",
    },
    "84532": { // Base Testnet (Sepolia)
      message: "0x18716F6E46a66919deacD3c6fd4fa6Da02fa30b2",
      feeToken: "0x8dF0A6d3826B9D99c9694c079A10dBb333a9Bb6C",
      weth: "",
      rpc: "https://84532.rpc.cryptolink.tech/",
    },
    "97": { // Binance Testnet
      message: "0x535CCeD6C471eE907eEB3bBECf1C8223208Ca5e0",
      feeToken: "0xD430d3cDFb411810f5E1355C1Be41CF8CCA7e428",
      weth: "",
      rpc: "https://97.rpc.cryptolink.tech/",
    },
    "168587773": { // Blast Testnet
      message: "0x3B5b764229b2EdE0162220aF51ab6bf7f8527a4F",
      feeToken: "0x566B40Dd59A868c244E1353368e08ddaD1C1d74f",
      weth: "",
      rpc: "https://168587773.rpc.cryptolink.tech/",
    },
    "2888": { // Boba Testnet
      message: "0xe20B995917eb334093EA1974CDa9971B102C5aff",
      feeToken: "0x8cd2556e02f5A136167aE123e313a17481f51904",
      weth: "",
      rpc: "https://2888.rpc.cryptolink.tech/",
    },
    "7701": { // Canto Testnet
      message: "0x3B5b764229b2EdE0162220aF51ab6bf7f8527a4F",
      feeToken: "0xeDCfb3038d4a262Aef3735CFa64146C35196CC51",
      weth: "",
      rpc: "https://7701.rpc.cryptolink.tech/",
    },
    "44787": { // Celo Testnet
      message: "0x6e658066340C7cae09dB68F5339Ddc4b806d3598",
      feeToken: "0x2A07454Bc8177b944fBdB4575a4b0bd040a70e95",
      weth: "",
      rpc: "https://44787.rpc.cryptolink.tech/",
    },
    "338": { // Cronos Testnet
      message: "0x8eb10FC1793094113E7f52bA159A6AeB54CaB92c",
      feeToken: "0xa7fBeDA5DF050bC6c0518A13BE6A2e3A4A2c2175",
      weth: "",
      rpc: "https://338.rpc.cryptolink.tech/",
    },
    "282": { // CronosZK Testnet
      message: "0xB0A4e1Cb4009292Bde2F3282A242FE0eF5C99f03",
      feeToken: "0xf6799eCdeCD7F96EA13bc3259852a3a4C47d859E",
      weth: "",
      rpc: "https://282.rpc.cryptolink.tech/",
    },
    "5": { // Ethereum Goerli
      message: "0x566B40Dd59A868c244E1353368e08ddaD1C1d74f",
      feeToken: "0x2f3bc26eFE51bBe209E0afD2Da29616cF3755E03",
      weth: "",
      rpc: "https://5.rpc.cryptolink.tech/",
    },
    "17000": { // Ethereum Holesky
      message: "0x9d75f706b986F0075b3778a12153390273dE95eC",
      feeToken: "0x6900384BA33f8C635DeE2C3BD7d46A0626FfB096",
      weth: "",
      rpc: "https://17000.rpc.cryptolink.tech/",
    },
    "11155111": { // Ethereum Sepolia
      message: "0x8DE416ABd87307f966a5655701F2f78012585225",
      feeToken: "0x4B5b1163525A6Cebd9a06F4C386976F2B41A4Bdf",
      weth: "",
      rpc: "https://11155111.rpc.cryptolink.tech/",
    },
    "4002": { // Fantom Testnet
      message: "0x7d474aA4DbDBc276b67abcc5f54262978b369cEC",
      feeToken: "0xAC78952AD62A468ac21f43DfA8B14f2c8Be87582",
      weth: "",
      rpc: "https://4002.rpc.cryptolink.tech/",
    },
    "377": { // Forest Testnet
      message: "0x3B5b764229b2EdE0162220aF51ab6bf7f8527a4F",
      feeToken: "",
      weth: "",
      rpc: "https://377.rpc.cryptolink.tech/",
    },
    "68840142": { // Frame Testnet
      message: "0x3B5b764229b2EdE0162220aF51ab6bf7f8527a4F",
      feeToken: "0x71311899492757cD512a11855C150EA219bB3A42",
      weth: "",
      rpc: "https://68840142.rpc.cryptolink.tech/",
    },
    "1452": { // Gauss Testnet
      message: "0x6c83DC6C5128ff3E073E737523D2176aAeB08525",
      feeToken: "0x5C3293Ff66E77F6FCEefAC24c4766BDcE060B260",
      weth: "",
      rpc: "https://1452.rpc.cryptolink.tech/",
    },
    "123420111": { // Gelato OP Celestia Testnet
      message: "0x3B5b764229b2EdE0162220aF51ab6bf7f8527a4F",
      feeToken: "0xc45c3cEc0C800fCB95636D1FB6ec0AE3d42b58e2",
      weth: "",
      rpc: "https://123420111.rpc.cryptolink.tech/",
    },
    "42069": { // Gelato OP Testnet 
      message: "0x3B5b764229b2EdE0162220aF51ab6bf7f8527a4F",
      feeToken: "0xc45c3cEc0C800fCB95636D1FB6ec0AE3d42b58e2",
      weth: "",
      rpc: "https://42069.rpc.cryptolink.tech/",
    },
    "1261120": { // Gelato ZKatana Testnet
      message: "0x3B5b764229b2EdE0162220aF51ab6bf7f8527a4F",
      feeToken: "0xc45c3cEc0C800fCB95636D1FB6ec0AE3d42b58e2",
      weth: "",
      rpc: "https://1261120.rpc.cryptolink.tech/",
    },
    "10200": { // Gnosis Testnet
      message: "0x146449fb27e4A4B4721a9c5742f3baB1e34eb31f",
      feeToken: "0x3ecDbd62D72917b4D22b638E0a550cA516cfe139",
      weth: "",
      rpc: "https://10200.rpc.cryptolink.tech/",
    },
    "1666700000": { // Harmony Testnet
      message: "0xE0a5cBb1f15a84C4a4A0f7E98F9721997182deD6",
      feeToken: "0x3574311D950E04A48289DA64759016c26725B180",
      weth: "",
      rpc: "https://1666700000.rpc.cryptolink.tech/",
    },
    "1663": { // Horizen Testnet
      message: "0x3B5b764229b2EdE0162220aF51ab6bf7f8527a4F",
      feeToken: "0x17C84459367f9787356b01d7f624Ef0e7E6cA11F",
      weth: "",
      rpc: "https://1663.rpc.cryptolink.tech/",
    },
    "13473": { // Immutable Testnet
      message: "0x3B5b764229b2EdE0162220aF51ab6bf7f8527a4F",
      feeToken: "0xDb126ef7666c97db7D9F70FFbCfFdC567b3B25A5",
      weth: "",
      rpc: "https://13473.rpc.cryptolink.tech/",
    },
    "167008": { // Katla Testnet
      message: "0x3B5b764229b2EdE0162220aF51ab6bf7f8527a4F",
      feeToken: "0x17C84459367f9787356b01d7f624Ef0e7E6cA11F",
      weth: "",
      rpc: "https://167008.rpc.cryptolink.tech/",
    },
    "2221": { // Kava Testnet
      message: "0x3B5b764229b2EdE0162220aF51ab6bf7f8527a4F",
      feeToken: "0x1Ec7Dfbc9e310768A17145f03f3451f562cEc773",
      weth: "",
      rpc: "https://2221.rpc.cryptolink.tech/",
    },
    "1001": { // Klaytn Testnet
      message: "0x3B5b764229b2EdE0162220aF51ab6bf7f8527a4F",
      weth: "",
      rpc: "https://1001.rpc.cryptolink.tech/",
    },
    "59140": { // Linea Testnet
      message: "0x3B5b764229b2EdE0162220aF51ab6bf7f8527a4F",
      weth: "",
      rpc: "https://59140.rpc.cryptolink.tech/",
    },
    "9768": { // Mainnetz Testnet
      message: "0x3B5b764229b2EdE0162220aF51ab6bf7f8527a4F",
      feeToken: "0x714853D6197e560013ee161fC259b87E8B3cA7E9",
      weth: "",
      rpc: "https://9768.rpc.cryptolink.tech/",
    },
    "5001": { // Mantle Testnet
      message: "0x3B5b764229b2EdE0162220aF51ab6bf7f8527a4F",
      feeToken: "0x0135c25Bd3e88b1aac5FDC6f16FEe2C63d967f9d",
      weth: "",
      rpc: "https://5001.rpc.cryptolink.tech/",
    },
    "599": { // Metis Testnet
      message: "0x4f313cB864BD7138Fdb35337182D5b0E78d9fB33",
      feeToken: "0xd4Bb993ec7c9beE84930064C691cFd8603138551",
      weth: "",
      rpc: "https://599.rpc.cryptolink.tech/",
    },
    "42261": { // Oasis Emerald Testnet
      message: "0x566B40Dd59A868c244E1353368e08ddaD1C1d74f",
      feeToken: "0x73Db0a9a3aB2098B57E6A0f1F8Ff497e4adaa412",
      weth: "",
      rpc: "https://42261.rpc.cryptolink.tech/",
    },
    "23295": { // Oasis Sapphire Testnet
      message: "0x566B40Dd59A868c244E1353368e08ddaD1C1d74f",
      feeToken: "0x4B5b1163525A6Cebd9a06F4C386976F2B41A4Bdf",
      weth: "",
      rpc: "https://23295.rpc.cryptolink.tech/",
    },
    "65": { // OKEx Testnet
      message: "0xF1FBB3E9977dAcF3909Ab541792cB2Bba10FFD5E",
      feeToken: "0x2a91b800903BDcC230312C7F96ACF089e6592cBA",
      weth: "",
      rpc: "https://65.rpc.cryptolink.tech/",
    },
    "1945": { // Onus Testnet
      message: "0x3B5b764229b2EdE0162220aF51ab6bf7f8527a4F",
      feeToken: "0x5f4d59B985959b1dd5da23C574228e9161D34845",
      weth: "",
      rpc: "https://1945.rpc.cryptolink.tech/",
    },
    "5611": { // opBNB Testnet
      message: "0x3B5b764229b2EdE0162220aF51ab6bf7f8527a4F",
      feeToken: "0x17C84459367f9787356b01d7f624Ef0e7E6cA11F",
      weth: "",
      rpc: "https://5611.rpc.cryptolink.tech/",
    },
    "11155420": { // Optimism Testnet
      message: "0xB4245BFEA4AfE63c7F7863D090166890e9FEf1b2",
      feeToken: "0x3aBc0c7aC53935025d40F60e4235BB6Bd83B78f0",
      weth: "",
      rpc: "https://11155420.rpc.cryptolink.tech/",
    },
    "80001": { // Polygon Testnet
      message: "0x08A2d304547A4B93B254d906502A3fc778D78412",
      feeToken: "0x489B21556865712b1AaCF04Df8197488d940aB18",
      weth: "",
      rpc: "https://80001.rpc.cryptolink.tech/",
    },
    "1442": { // Polygon zkEVM Testnet
      message: "0xcA877c797D599bE2Bf8C897a3B9eba6bA4113332",
      feeToken: "0x9B14EA7C553F92cfC782951d06Cf1d48fF33E429",
      weth: "",
      rpc: "https://1442.rpc.cryptolink.tech/",
    },
    "943": { // Pulse Testnet
      message: "0x4f313cB864BD7138Fdb35337182D5b0E78d9fB33",
      feeToken: "0xa0179a4Aa2818ff63Ee6e40b5C27A33BD59e4815",
      weth: "",
      rpc: "https://943.rpc.cryptolink.tech/",
    },
    "17001": { // Redstone Testnet
      message: "0x9d75f706b986F0075b3778a12153390273dE95eC",
      feeToken: "0xA95c0BC77Ab8a8EfA3dF00366FFAe5CB1A2cba15",
      weth: "",
      rpc: "https://17001.rpc.cryptolink.tech/",
    },
    "57000": { // Rollux Testnet
      message: "0x3B5b764229b2EdE0162220aF51ab6bf7f8527a4F",
      feeToken: "0x17C84459367f9787356b01d7f624Ef0e7E6cA11F",
      weth: "",
      rpc: "https://57000.rpc.cryptolink.tech/",
    },
    "534351": { // Scroll Testnet (Sepolia)
      message: "0x23E2CE1fF48cF21239f8c5eb783CE89df02B6f35",
      feeToken: "0x08f0A528dC83f4Db2C7B05478ED3B098eCE94fCB",
      weth: "",
      rpc: "https://534351.rpc.cryptolink.tech/",
    },
    "19999999991": { // Solana Testnet
      message: "",
      feeToken: "",
      weth: "",
      rpc: ""
    },
    "64165": { // Sonic Testnet
      message: "0x3B5b764229b2EdE0162220aF51ab6bf7f8527a4F",
      feeToken: "0x566B40Dd59A868c244E1353368e08ddaD1C1d74f",
      weth: "",
      rpc: "https://64165.rpc.cryptolink.tech/",
    },
    "41": { // Telos Testnet
      message: "0x3B5b764229b2EdE0162220aF51ab6bf7f8527a4F",
      feeToken: "0x5f4d59B985959b1dd5da23C574228e9161D34845",
      weth: "",
      rpc: "https://41.rpc.cryptolink.tech/",
    },
    "195": { // X1 Testnet
      message: "0x4f313cB864BD7138Fdb35337182D5b0E78d9fB33",
      feeToken: "0xD07129F94934757A1653de9cb076910de39Fba6F",
      weth: "",
      rpc: "https://195.rpc.cryptolink.tech/",
    },
    "51": { // XDC Testnet
      message: "0x0EFafca24E5BbC1C01587B659226B9d600fd671f",
      feeToken: "0x743E00433c33fec5DCF6B9f2cF72d471cd0AB027",
      weth: "",
      rpc: "https://51.rpc.cryptolink.tech/",
    },
    "7001": { // ZetaChain Testnet
      message: "0xeFaDc14c2DD95D0E6969d0B25EA6e4F830150493",
      weth: "",
      rpc: "https://7001.rpc.cryptolink.tech/",
    },    
    "280": { // zkSync Testnet
      message: "0xB0A4e1Cb4009292Bde2F3282A242FE0eF5C99f03",
      "weth": "",
      rpc: "https://280.rpc.cryptolink.tech/",
    }
  };
  
  module.exports = chainsConfig;
  

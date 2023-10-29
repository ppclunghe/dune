--Name: ETH depositors labels
--Description: 
--Parameters: []
/* 
This query returns list of depositors addresses by name (namespace), defining their category AND type (Liquid/ Illiquid)
This query is used to built mat veiw dune.lido.result_eth_depositors_labels

 */
        -- This CTE identifies Coinbase transactions
        with coinbase_main_addresses AS --ADDRESSES WE IDENTIFIED EARLIER AS COINBASE
            (
        SELECT 
        "from" address
        FROM  ethereum.traces
        WHERE to = 0x00000000219ab540356cbb839cbe05303d7705fa
        AND block_number >= 11182202
        AND call_type = 'call'
        AND success = True 
        AND "from" in (
                        SELECT --distinct 
                        "from" project
            FROM ethereum.transactions
            WHERE to in ( 
                            0x71660c4005ba85c37ccec55d0c4493e66fe775d3 --	Coinbase 1
                            , 0x503828976d22510aad0201ac7ec88293211d23da --	Coinbase 2	
                            , 0xddfabcdc4d8ffc6d5beaf154f18b778f892a0740 --	Coinbase 3	
                            , 0x3cd751e6b0078be393132286c442345e5dc49699 --	Coinbase 4	
                            , 0xb5d85cbf7cb3ee0d56b3bb207d5fc4b82f43f511 --	Coinbase 5
                            , 0xeb2629a2734e272bcc07bda959863f316f4bd4cf --	Coinbase 6
                            , 0xD688AEA8f7d450909AdE10C47FaA95707b0682d9 --	Coinbase 7
                            , 0x02466E547BFDAb679fC49e96bBfc62B9747D997C --	Coinbase 8	
                            , 0x6b76F8B1e9E59913BfE758821887311bA1805cAB --	Coinbase 9	
                            , 0xA9D1e08C7793af67e9d92fe308d5697FB81d3E43 --	Coinbase 10	
                            , 0x77696bb39917C91A0c3908D577d5e322095425cA --	Coinbase 11
                            , 0xf6874c88757721a02f47592140905c4336DfBc61 --	Coinbase: Coinbase Commerce
                            , 0x881D4032abe4188e2237eFCD27aB435E81FC6bb1 -- Coinbase Commerce
                            , 0xd2276aF80582CAc230EDC4c42e9a9C096F3C09AA -- Coinbase: Deposit 1
                            , 0xa090e606e30bd747d4e6245a1517ebe430f0057e --  Coinbase: Miscellaneous
                            ) 
                            AND DATE_TRUNC('day',block_time)  >= cast('2020-11-03' AS DATE)
                            AND success = True
        )
        GROUP BY 1
)        

-- This CTE collects withdrawal credentials used by addresses identified as Coinbase earlier
, coinbase_WC AS (--WC USED BY ADDRESSES WE IDENTIFIED EARLIER AS COINBASE
    SELECT 
    withdrawal_credentials 
    FROM  ethereum.traces et
    LEFT JOIN eth2_ethereum.DepositContract_evt_DepositEvent dpst_evt ON dpst_evt.evt_tx_hash = et.tx_hash
    WHERE et.to = 0x00000000219ab540356cbb839cbe05303d7705fa
    AND et."from" in (SELECT * FROM coinbase_main_addresses)
    AND et.block_number >= 11182202
    AND et.call_type = 'call'
    AND et.success = True 
)

-- This CTE collects all addresses that made deposits with withdrawal credentials (WC) used by Coinbase
, coinbase_addresses AS --ALL ADDRESSES THAT MADE DEPOSITS WITH WC USED BY COINBASE
(
SELECT distinct "from", 'Coinbase' AS name,
'Centralized' AS category, 'Illiquid' AS liquidity
FROM ethereum.traces
        WHERE to = 0x00000000219ab540356cbb839cbe05303d7705fa
        AND tx_hash in 
            ( --ALL DEPOSITS MADE WITH THE WC THAT COINBASE USED. CHECKED LAST 25 OR SO ON JAN 12, THE VAST MAJORITY OF THEM ARE OBVIOUSLY COINBASE AND SHOW SIMILAR PATTERNS
            SELECT evt_tx_hash FROM eth2_ethereum.DepositContract_evt_DepositEvent
            WHERE withdrawal_credentials in (SELECT withdrawal_credentials FROM coinbase_WC)
            )
        AND block_number >= 11182202
        AND call_type = 'call'
        AND success = True 
)

-- This CTE  associates addresses with names AND labels them based on their category and type
,list as
(
SELECT *
    FROM (
        values (0xae7ab96520de3a18e5e111b5eaab095312d7fe84, 'Lido', 'Decentralized', 'Liquid') --staking contract
        ,(0xB9D7934878B5FB9610B3fE8A5e441e8fad7E293f, 'Lido', 'Decentralized', 'Liquid') --withdrawals contract
        ,(0xFdDf38947aFB03C621C71b06C9C70bce73f12999, 'Lido', 'Decentralized', 'Liquid') --v2 staking router
        ,(0xa76a7d0d06754e4fc4941519d1f9d56fd9f8d53b, 'Lido', 'Decentralized', 'Liquid')
        ,(0x4ca21e4d3a86e7399698f88686f5596dbe74adeb, 'P2P', 'Decentralized', 'Illiquid')
        ,(0x8e76a33f1aFf7EB15DE832810506814aF4789536, 'P2P', 'Decentralized', 'Illiquid')
        , (0x39dc6a99209b5e6b81dc8540c86ff10981ebda29, 'Staked.us', 'Hybrid', 'Illiquid')
        , (0x0194512e77d798e4871973d9cb9d7ddfc0ffd801, 'stakefish', 'Hybrid', 'Illiquid')
        , (0xd4039ecc40aeda0582036437cf3ec02845da4c13, 'Kraken', 'Centralized', 'Illiquid')
        , (0xa40dfee99e1c85dc97fdc594b16a460717838703, 'Kraken', 'Centralized', 'Illiquid')
        , (0x4befa2aa9c305238aa3e0b5d17eb20c045269e9d, 'RockX', 'Hybrid', 'Liquid') --uniETH token, contract 0xF1376bceF0f78459C0Ed0ba5ddce976F1ddF51F4 
        , (0xe8239b17034c372cdf8a5f8d3ccb7cf1795c4572, 'RockX', 'Hybrid', 'Liquid') 
        , (0x622de9bb9ff8907414785a633097db438f9a2d86, 'Bitcoin Suisse', 'Centralized', 'Illiquid')
        , (0xdd9663bd979f1ab1bada85e1bc7d7f13cafe71f8, 'Bitcoin Suisse', 'Centralized', 'Illiquid')
        , (0xec70e3c8afe212039c3f6a2df1c798003bf7cfe9, 'Bitcoin Suisse', 'Centralized', 'Illiquid')
        , (0x3837eA2279b8E5c260A78F5F4181B783BbE76a8B, 'Bitcoin Suisse', 'Centralized', 'Illiquid')
        , (0x2a7077399b3e90f5392d55a1dc7046ad8d152348, 'Bitcoin Suisse', 'Centralized', 'Illiquid')
        , (0xc2288b408dc872a1546f13e6ebfa9c94998316a2, 'Bitcoin Suisse', 'Centralized', 'Illiquid')
        , (0x51656396e883c1e398ccec721a8c2af5a98beb01, 'Bitcoin Suisse', 'Centralized', 'Illiquid')
        , (0x06051f7af88694201f74c71c4e25f7f4e35a9779, 'Bitcoin Suisse', 'Centralized', 'Illiquid')
        , (0x8004b4a5795899e4c25c598fbf7d0e7f737ce15a, 'Bitcoin Suisse', 'Centralized', 'Illiquid')
        , (0x4ebf51689228236ec55bcafef9d79663992a7fb6, 'Bitcoin Suisse', 'Centralized', 'Illiquid')
        , (0x8e3776993f3ec045863ec9e40b511aba867c5d0e, 'Bitcoin Suisse', 'Centralized', 'Illiquid')
        , (0xE900B070b6BEF5EF6b3A94332d613F39206Aa5e1, 'Bitcoin Suisse', 'Centralized', 'Illiquid')
        , (0x848fa46e10fdaff959f7d57983a50b80ae396b7b, 'Bitcoin Suisse', 'Centralized', 'Illiquid')
        , (0x38248fa3e404a81d732d09a9cce8c3eb3b8532df, 'Bitcoin Suisse', 'Centralized', 'Illiquid')
        , (0xe94144f5672f48d0d8365bb54bb394d283f87caf, 'Bitcoin Suisse', 'Centralized', 'Illiquid')
        , (0x08e0c5474d12d886f6e50949e7baf944365a21f6, 'Bitcoin Suisse', 'Centralized', 'Illiquid')
        , (0xeae76e9aa6657ca208a1e12cf318d77f2ea7a063, 'Bitcoin Suisse', 'Centralized', 'Illiquid')
        , (0x5af2a94139e3ac7337528cd5e4adff9f8264ea8c, 'Bitcoin Suisse', 'Centralized', 'Illiquid')
        , (0x7ee20059de93811fa038d4650cd29e77de98b8c3, 'Bitcoin Suisse', 'Centralized', 'Illiquid')
        , (0x2f1a2382a4541cd31e83b905c0b29ebd91fc28d1, 'Bitcoin Suisse', 'Centralized', 'Illiquid')
        , (0xb6d77f9dcb27a25be5ae629029c30797b7df9f3e, 'Bitcoin Suisse', 'Centralized', 'Illiquid')
        , (0x576196815fb79dee2988d6bdd1ba1472e42f65d3, 'Bitcoin Suisse', 'Centralized', 'Illiquid')
        , (0x7b37f253b72a4192e1e36e25bbc0aae85766be6b, 'Bitcoin Suisse', 'Centralized', 'Illiquid')
        , (0x90610d86f277dc3f5326408b9080e6c5e0bf6bbe, 'Bitcoin Suisse', 'Centralized', 'Illiquid')
        , (0xe7b8f929e62f5e363a3dbb806339cabc79822de6, 'Bitcoin Suisse', 'Centralized', 'Illiquid')
        , (0xeccb04eb0d6e67e244e32e7e1ace0362ca0b3aeb, 'Bitcoin Suisse', 'Centralized', 'Illiquid')
        , (0x028a07979d3fed8e9459d0a84d8814087fe36a74, 'Bitcoin Suisse', 'Centralized', 'Illiquid')
        , (0x7f22215c9354fa44a5334786fd0756e3d0746aac, 'Bitcoin Suisse', 'Centralized', 'Illiquid')
        --, (0xf2be95116845252a28bd43661651917dc183dab1, 'Consensys', 'Decentralized', 'Illiquid') --false
        , (0xf2be95116845252a28bd43661651917dc183dab1, 'Figment', 'Centralized', 'Illiquid')
        , (0x37ab162ab59e106d6072eb7a7bd4c4c2973455a7, 'Figment', 'Centralized', 'Illiquid')
        , (0xb4E2e925d75793c33F5F94Cd652F6C464665c76b, 'Figment', 'Centralized', 'Illiquid')
        , (0xf0075b3cf8953d3e23b0ef65960913fd97eb5227, 'Figment', 'Centralized', 'Illiquid')
        , (0xc874b064f465bdd6411d45734b56fac750cda29a, 'Stakewise', 'Decentralized', 'Liquid')
        , (0x84db6ee82b7cf3b47e8f19270abde5718b936670, 'Stkr (Ankr)', 'Decentralized', 'Liquid')
        , (0xd1a72bd052e0d65b7c26d3dd97a98b74acbbb6c5, 'Stader', 'Decentralized', 'Liquid')
        , (0x09134C643A6B95D342BdAf081Fa473338F066572, 'Stader', 'Decentralized', 'Liquid')
        , (0x8103151e2377e78c04a3d2564e20542680ed3096, 'Node DAO', 'Decentralized', 'Liquid')
        , (0xa86341e5c278443c8648be44110167e1bbd9cba6, 'Node DAO', 'Decentralized', 'Liquid') --https://doc.nodedao.com/deployed-contracts/mainnet-ethereum, https://docs.xhash.com/introduction/what-is-xhash
        , (0x194bd70b59491ce1310ea0bceabdb6c23ac9d5b2, 'HTX', 'Centralized', 'Illiquid')--exHuobi
        , (0xb73f4d4e99f65ec4b16b684e44f81aeca5ba2b7c, 'HTX', 'Centralized', 'Illiquid') --exHuobi
        , (0x39FD78FE6A72FaaE2aB5f1f053c253B2e3685C15, 'HTX', 'Centralized', 'Illiquid') 
        , (0xbf1556a7d625654e3d64d1f0466a60a697fac178, 'InfStones','Centralized', 'Illiquid') -- BatchDeposit
        , (0xbca3b7b87dcb15f0efa66136bc0e4684a3e5da4d, 'SharedStake','Decentralized', 'Liquid')
        , (0xeadcba8bf9aca93f627f31fb05470f5a0686ceca, 'StakeWise Solos','Decentralized', 'Illiquid')
        , (0xfa5f9eaa65ffb2a75de092eb7f3fc84fc86b5b18, 'Abyss Finance','Hybrid', 'Illiquid')  --IS IT REALLY DECENRALIZED?
        , (0x66827bcd635f2bb1779d68c46aeb16541bca6ba8, 'Auxo','Decentralized', 'Illiquid') -- ex PieDAO
        , (0xd6216fc19db775df9774a6e33526131da7d19a2c, 'KuCoin', 'Centralized', 'Illiquid')
        , (0x1692e170361cefd1eb7240ec13d048fd9af6d667, 'KuCoin', 'Centralized', 'Illiquid')
        , (0x7b915c27a0Ed48E2Ce726Ee40F20B2bF8a88a1b3, 'KuCoin', 'Centralized', 'Illiquid')
        , (0xcbc1065255cbc3ab41a6868c22d1f1c573ab89fd, 'CREAM','Decentralized', 'Liquid') --pseudo liquid
        , (0x808e7133C700cF3a66E6A25AAdB1fBEF6be468b4, 'Bitstamp', 'Centralized', 'Illiquid')
        , (0xb506ea683F358dAfb35f854EB52e1506937fFeC6, 'Bitstamp', 'Centralized', 'Illiquid')
        , (0x3965c5f4bf942eccf88bd8b3926456b16479e3e8, 'Bitstamp', 'Centralized', 'Illiquid')
        , (0x12ec5befa9166fa327d4c345a93f0ac99dd2a7d8, 'Blox Staking','Decentralized', 'Illiquid')
        , (0x24B2F1AECED4B34133152Bb20cFd6a206A0EA33C, 'staked.finance', 'Centralized', 'Illiquid')
        , (0x0CA7b4b87fEB2c0BDa9CB37B6cd0de22B816Cd04, 'MyColdWallet', 'Others', 'Illiquid') --old project, insufficient docs
        , (0x1270a0aad453a315c5ab99397d88121c34453eb4, 'TideBit', 'Others', 'Illiquid') --old project, insufficient docs
        , (0x0038598EcB3B308EBc6c6e2c635BaCaA3c5298a3, 'Poloniex', 'Centralized', 'Illiquid')
        , (0xcfec2842900cfa687e2c60581574b206b9e69ff5 , 'Poloniex',  'Centralized', 'Illiquid') --ex Whale 33
        , (0xD39aEeb73983e5fbc52B77A3957a48c1EeAC8eD7, 'MintDice.com', 'Centralized', 'Illiquid')
        , (0x7ebf05749faf7eb78eff153e40c15890bb4578a4, 'neukind.com','Decentralized', 'Illiquid')
        , (0xa54be2edaa143e969a63fc744bbd2d511b50cbc3, 'neukind.com','Decentralized', 'Illiquid')
        , (0xac29ef7a7f4325ffa564de9abf67e5ace46c88f8, 'neukind.com','Decentralized', 'Illiquid')
        , (0xc3003f8b89f35a7bf3cb3a6ec3d8e4c3c8ce7cce, 'neukind.com','Decentralized', 'Illiquid')
        , (0x06521aF7183a4A61D067016fC3bC0500DA1567c1, 'ptxptx', 'Others', 'Illiquid')
        , (0x8E1D8B147cC4C939a597dC501C47cC8B4ab26BD5, 'Tetranode', 'Others', 'Illiquid')
        , (0x1db3439a222c519ab44bb1144fc28167b4fa6ee6, 'Vitalik Buterin', 'Whale', 'Individual')
        , (0x49df3cca2670eb0d591146b16359fe336e476f29, 'stereum.net','Decentralized', 'Illiquid')
        , (0x62dfeb55fcbdcb921446168eecfd1406379a1ee1, 'stereum.net','Decentralized', 'Illiquid')
        , (0x2bE0282532AD9FA7cc4C45aeAA1707d2E93357C2, 'Blockdaemon.com', 'Centralized', 'Illiquid') --pseudo liquid AS they have a token called "Portara" ON their website, but it's difficult to find anything about it
        --, (0x3F124C700fb5E741F128e28985267D44f56B242F, 'Blockdaemon.com', 'Centralized', 'Illiquid') --Celsius?
        , (0x5e59aaB1F114234F003008300C3D7593c6cEEa26, 'boxfish.studio', 'Others', 'Illiquid')
        , (0xd1933DF1c223ad7CB5716B066cA26BC24569e622, 'Ethereum ON ARM', 'Centralized', 'Illiquid')
        , (0x5a0036bcab4501e70f086c634e2958a8beae3a11, 'OKX', 'Centralized', 'Illiquid')
        , (0x2e2f4dfa542d6d8b4817ce45614016f452647439, 'OKX', 'Centralized', 'Illiquid')
        , (0x2c59ace01aef3f6143c61372afb225d81b786e79, 'OKX', 'Centralized', 'Illiquid')
        , (0x14f911dda85ec705a96f0e5ce10ab17897018226, 'OKX', 'Centralized', 'Illiquid')
        , (0x9772abd9469ad597961166ed3220720afdd51912, 'OKX', 'Centralized', 'Illiquid') --new address, Feb 23. Looks a lot like OKX
        , (0xa2d6a09448819f4c89df2885ab652afa31d55341, 'OKX', 'Centralized', 'Illiquid') --new address, Feb 23. Looks a lot like OKX
        , (0xb158126c22ad89ddd7c5af0df1221e5baa629dac, 'OKX', 'Centralized', 'Illiquid') --new address, Mar 3. Looks a lot like OKX
        , (0x54b0f363e88a05cefdeb5f8c810286b439140a94, 'OKX', 'Centralized', 'Illiquid')
        , (0x383d920628e14ea701953ce0bfcb7049528fbae1, 'OKX', 'Centralized', 'Illiquid')
        , (0x131208062acf0e41c8fec274b8f90b29e29b4ec6, 'OKX', 'Centralized', 'Illiquid')
        
        
        , (0xeFE9a82d56cd965D7B332c7aC1feB15c53Cd4340, 'Coinbase', 'Centralized', 'Illiquid')
        , (0xeEE27662c2B8EBa3CD936A23F039F3189633e4C8, 'Celsius', 'Centralized', 'Illiquid')
        , (0x3F124C700fb5E741F128e28985267D44f56B242F, 'Celsius', 'Centralized', 'Illiquid')
        , (0xbd9d540f6a671d4280d81127de555a7d8ce7e204, 'Celsius', 'Centralized', 'Illiquid') --10/2023
        , (0x607ebc82329d0cac3027b83d15e4b4e816f131b7, 'Stakehound', 'Centralized', 'Liquid')
        ,(0x234EE9e35f8e9749A002fc42970D570DB716453B, 'Gate.io', 'Centralized', 'Illiquid')
        ,(0xd87c8e083aecc5405b0107c90d8e0c7f70996b84, 'Gate.io', 'Centralized', 'Illiquid') --used by gate.io for rotation
        ,(0xa1619Fb8CcC03Ee3c8D543fB8be993764030e028, 'Ebunker','Decentralized', 'Illiquid')
        ,(0xA8582b5A0f615bc21d7780618557042bE60B32ed, 'Bitpie', 'Others', 'Illiquid')
        ,(0x8c1BEd5b9a0928467c9B1341Da1D7BD5e10b6549, 'Liquid Collective', 'Centralized', 'Liquid')
        ,(0x24D729AAE93A05A729e68504E5cCdfA3bB876491, 'Gemini', 'Centralized', 'Illiquid')
        ,(0x82Ce843130FF0AE069C54118dfbfA6a5eA17158E, 'Gemini', 'Centralized', 'Illiquid')
        ,(0x4c2F150Fc90fed3d8281114c2349f1906cdE5346, 'Gemini', 'Centralized', 'Illiquid')
        ,(0xec1d6163e05b3f5d0fb8f354881f6c8b793ad612, 'Bifrost', 'Decentralized', 'Liquid')
        ,(0xbb84d966c09264ce9a2104a4a20bb378369986db, 'Wex Exchange', 'Centralized', 'Illiquid')
        ,(0xc236c3ec83351b07f148afbadc252cce2c07972e, 'Bitfinex', 'Centralized', 'Illiquid')
        ,(0xe733455faddf4999176e99a0ec084e978f5552ed, 'Bitfinex', 'Centralized', 'Illiquid')
        ,(0x588e859cb38fecf2d56925c0512471ab47aa9ff1, 'StaFi', 'Decentralized', 'Liquid') --their token https://etherscan.io/token/0x9559aaa82d9649c7a7b220e7c461d2e74c9a3593
        ,(0x1c906685384df71e3fafa6f3b21bd884e9d44f4b, 'StaFi', 'Decentralized', 'Liquid')
        ,(0x3ccc0b321ec18997490c8bfc2c882ef83d546ddd, 'Bake', 'Centralized', 'Illiquid') --ex Cake DeFi
        ,(0xea6b7151b138c274ed8d4d61328352545ef2d4b7, 'Harbour', 'Centralized', 'Liquid') --institutional stuff that requires KYC
       
        ,(0xC63d9F0040d35F328274312fc8771a986fc4bA86, 'Kiln', 'Centralized', 'Illiquid')
        ,(0x746d8A8FCAB7f829Fa500504f60D89C5CC1EA973, 'Kiln', 'Centralized', 'Illiquid') --Kiln+Ledger https://ledger-enterprise-api-portal.redoc.ly/developer-portal/docs/eth/ethereum_staking_kiln/
        ,(0x2915f91dcff0be7b60df411f164827d517caca67, 'TokenPocket', 'Others', 'Illiquid')
        ,(0xcf07df57a6b338a20d50114a79fee09d28b13d72, 'cryptostake.com', 'Centralized', 'Illiquid') 
        ,(0xf79caa45612fb183c4e258ed449bfa632d7400b9, 'Everstake Pool', 'Centralized', 'Illiquid')
        ,(0x447c3ee829a3b506ad0a66ff1089f30181c42637, 'HashKing', 'Others', 'Liquid') --promise transition in the future, say in their FAQ they deposit ETH through Lido but they don't
        ,(0xa8f50a6c41d67685b820b4fe6bed7e549e54a949, 'Eth2Stake.com', 'Others', 'Illiquid') --website is dead, contract inactive since Jan 2021
        ,(0xe0c8df4270f4342132ec333f6048cb703e7a9c77, 'Swell', 'Decentralized', 'Liquid')
        ,(0xb3D9cf8E163bbc840195a97E81F8A34E295B8f39, 'Swell', 'Decentralized', 'Liquid')
        ,(0x66453f68d6dbcf7859e08f0c43df74e6da06ef8c, 'Tranchess', 'Decentralized', 'Liquid')
        ,(0x96f4489fe75d0494bd5088b0d80b17a5759dac37, 'Tranchess', 'Decentralized', 'Liquid')
        ,(0xbafa44efe7901e04e39dad13167d089c559c1138, 'Frax Finance','Decentralized', 'Liquid')
        ,(0x5180db0237291a6449dda9ed33ad90a38787621c, 'Frax Finance','Decentralized', 'Liquid')
        ,(0x06a26f6bd71e7b66d0a4f1fd490792fea8ab6556, 'Upbit', 'Centralized', 'Illiquid')
        ,(0x4d623ddd9b11f7054c711295c5dc4c4eb12ee7d4, 'Upbit', 'Centralized', 'Illiquid')
        ,(0x44894aeee56c2dd589c1d5c8cb04b87576967f97, 'Upbit', 'Centralized', 'Illiquid')
        ,(0x3085140568d02b7dca5db4070375040a6b2ece5b, 'Upbit', 'Centralized', 'Illiquid')
        ,(0xcf95237ce34d4b5bf1e7de4474ee1dcc01f24ca9, 'Upbit', 'Centralized', 'Illiquid')
        , (0xC0Cdd1f2B682b06B8451d106C614dBbC92E1caBb, 'Upbit', 'Centralized', 'Illiquid')
        , (0xbDB640AB9D4870Baf24Fbe562CC3Ab83CE212887, 'Upbit', 'Centralized', 'Illiquid')
        , (0xbd2e7492e7A7afcFBacBe072E353E871caB391f7, 'Upbit', 'Centralized', 'Illiquid')
        , (0x20312e96b1a0568ac31c6630844a962383cc66c2, 'CoinSpot', 'Centralized', 'Illiquid')
        , (0x02cEe8dD7581946beF23102e69869F8dA96ee502, 'CoinSpot', 'Centralized', 'Illiquid')
        , (0x01b92134c905aa3a9a8a97f3ea464f768f340301, 'CoinSpot', 'Centralized', 'Illiquid')
        , (0x6e16cbd8bed3d6577487a1376d8aa94fba5a09f0, 'BTC-e', 'Centralized', 'Illiquid')
        , (0x1d5ba5414f2983212e03bf7725add9eb4cdb00dc, 'Bitget', 'Centralized', 'Illiquid')
        , (0xefb2e870b14d7e555a31b392541acf002dae6ae9, 'Bithumb', 'Centralized', 'Illiquid')
        , (0x00ecC96508d299Fa8d228d569d8582980C1bc75e, 'Uphold', 'Centralized', 'Illiquid')
        , (0x307048Ad5Ab7279D34e5358331B0d48050ADa274, 'CoinCDX', 'Centralized', 'Illiquid')
        , (0x2d4F5E4982F980BC61aA571AE63f66bF3577618C, 'BlockFi', 'Centralized', 'Illiquid')
        , (0xB61428Db947a9eE049B966fb0536CB00579753eD, 'Korbit', 'Centralized', 'Illiquid')
        , (0x8d874F5A07dF691bC8e56818Ca1eBc6027B60d51, 'Paxos', 'Centralized', 'Illiquid')
        , (0x806710b651599de9838eb8b2083fec33faaaea5d, 'Unknown whale (FROM Gemini)', 'Whale','Individual')
        , (0x3dcf4d079b723a1f18f25c32db4fa9bba4d6caae, 'Unknown whale (FROM Gemini)', 'Whale','Individual')
        , (0x2a3d6d825fe851b60cef54fdcaa7ce2c5a0fda02, 'Unknown whale 10 (FROM Gemini)', 'Whale','Individual')
        --, (0x2d4f5e4982f980bc61aa571ae63f66bf3577618c, 'Unknown whale 2 (interacted with 3AC)', 'Whale', 'Individual')
        , (0x1C3842F90aC744CfCc3820307929Bb77a15eECCE, 'Unknown whale 3 (EthDev?)', 'Whale', 'Individual')
        , (0xc0fd67ef6b02b9d79a36da4af5c1e7603ad6e1d0, 'Unknown whale 4 (FROM Coinbase)', 'Whale', 'Individual')
        , (0xCBe4347ceFBf18C0E4fEC08A23Cd197d0e7a7aAE, 'coffeeme.eth', 'Whale', 'Individual')
        , (0x22a4761d4500ce4f09a6cb34584f43e112c9b5bc, 'Unknown whale 5', 'Whale', 'Individual')
        --, (0xeFE9a82d56cd965D7B332c7aC1feB15c53Cd4340, 'Unknown 4') --used WC that Coinbase uses so this address is identified AS Coinbase
        , (0xa7f7b0c21af95d03871e4089e28772a402c99e6c, 'Unknown whale 6 (FROM Gemini)', 'Whale', 'Individual')
        --, (0x1e68238cE926DEC62b3FBC99AB06eB1D85CE0270, 'Unknown pool', 'Others','Illiquid') Identified AS Kiln
        , (0x0816DF553a89c4bFF7eBfD778A9706a989Dd3Ce3, 'Unknown pool', 'Others','Illiquid') --created FROM the same deployer address AS the previous one
        , (0xbdb640ab9d4870baf24fbe562cc3ab83ce212887, 'Unknown pool 2', 'Others','Illiquid') --a lot of funds came FROM Mexc.com
        , (0xe3233c1b566c15ad154111df78d34f72d6f95f40, 'Unknown whale 7 (FROM Kraken)', 'Whale', 'Individual')  --MEV bot runner
        , (0x7c2fc96f8703aca920949b2a0372816801298868, 'Unknown whale 8 (FROM Binance', 'Whale', 'Individual')
        , (0xeb8c83edd6fbb256b99355cf61eba1bbb9d5cab5, 'Unknown whale 8 (FROM Binance', 'Whale', 'Individual')
        , (0x37f6ebc87b0fa975c5b250cf4294c7e7afff2f2a, 'Unknown whale 11 (FROM different CEX)', 'Whale', 'Individual')
        , (0xa43188eF55Dd9bB5c6Cb54C01366BE7FB49E126D, 'Unknown whale 20 (FROM Poloniex)', 'Whale', 'Individual')
        , (0xC4cD87b6Dc3afD114c55D83a4E54F895F738d27E, 'Unknown whale 20 (FROM Poloniex)', 'Whale', 'Individual')
        , (0xc44b7316936e2f004e688fd53a95e060df1811c3, 'Unknown whale 21 (FROM Coinbase)', 'Whale', 'Individual') --suspicious, mb Coinbase itself
        , (0xFD6705C7ac83f8AAc6c171E542445ba87C19D8D8 , 'Unknown whale 18 (FROM different CEX)', 'Whale', 'Individual')
        , (0x2b1df729083f6416861445d8aaac04ebdcd4a848 , 'Unknown whale 16 (FROM Bitfinex)', 'Whale', 'Individual')
        , (0x3b436fb33b79a3a754b0242a48a3b3aec1e35ad2 , 'Unknown whale 16 (FROM Binance & Bitfinex)', 'Whale', 'Individual')
        
        , (0x6357e4bdaff733dfe8f50d12d07c03b3bed0884b , 'Unknown whale 16 (FROM Binance & Bitfinex)', 'Whale', 'Individual')
        , (0xeab8f76c098d2c2262a46dd3fb85e9340081a0dc , 'Unknown whale 16 (FROM Binance & Bitfinex)', 'Whale', 'Individual')
        , (0xcbfa884044546d5569e2abff3fb429301b61562a , 'Unknown whale 16 (FROM Binance & Bitfinex)', 'Whale', 'Individual')
        , (0x0F5D76d07Ed8443352126c4c507E289F81d6D319 , 'Unknown whale 12 (FROM Poloniex)', 'Whale', 'Individual')
        , (0xb081972459fd730f83BB611C524b6f2978d5C304 , 'Unknown whale 12 (FROM Poloniex)', 'Whale', 'Individual')
        , (0x891404Dd46a473584f5510d5ecBFd8D83794428f , 'Unknown whale 19 (FROM Binance & Bitfinex)', 'Whale', 'Individual')
        , (0x6ddb0a6c999330f44506dd7414e835ac6ed44dfa , 'Unknown whale 19 (FROM Binance & Bitfinex)', 'Whale', 'Individual')
        , (0x85109c5fcFcD213b4fa1F004F777C477de1b648b , 'Unknown whale 23 (FROM Binance)', 'Whale', 'Individual')
        , (0xf463e250dac44bdf9da083b9f3cdfed6a2aca4d3 , 'Unknown whale 24 (FROM different CEXes)', 'Whale', 'Individual')
        , (0x6062c890c39630c84e1a591782244c1e167aa279 , 'Unknown whale 25 (FROM Binance)', 'Whale', 'Individual')
        , (0xcc93ba0fab8edbb6779892f3b3bec7bb9f6b074e , 'Unknown whale 25 (FROM Binance)', 'Whale', 'Individual')
        , (0x82926E563743d6B109dD514A0CdD5a2BC96EfD8c , 'Unknown whale 26 (FROM Kraken)', 'Whale', 'Individual')
        , (0xb83e08be94353c42a745d9234962a48b6e0e1873 , 'Unknown whale 27 (FROM Kraken)', 'Whale', 'Individual')
        , (0x60618b3c6e3164c4a72d352bde263a5d15f9f7ee , 'Unknown whale 28 (FROM Binance & Gate.io)', 'Whale', 'Individual')
        , (0xf195d7EBE04C0b883aCB82D59ecCb852E61b3588 , 'Unknown whale 29 (FROM Rhino Bridge)', 'Whale', 'Individual')
        , (0xa280561b996580cfb92aa5511413a543ecf15a34 , 'Unknown whale 29 (FROM Rhino Bridge)', 'Whale', 'Individual')
        , (0xc6108744c9d5db8b30f8004053a16d5683cd3489 , 'Unknown whale 30 (FROM Binance)', 'Whale', 'Individual')
        , (0x68bd0309ba98d65285a290c923ed6830ceaf2666 , 'Unknown whale 31', 'Whale', 'Individual')
        , (0xdcc6cf0847799027848b57607498665e4690e42b , 'Unknown whale 32', 'Whale', 'Individual') --0x7DbFa10e97Ce7b4dDa9E933Bff3a1aD7803B995a is behind it
        , (0x1630871d7a80d8e4f44433b87b05fc29720a5df6 , 'Unknown whale 32', 'Whale', 'Individual') -- affiliated
        , (0x421B329234f6868b6b726cF0Dd59d5D432cCb8Df , 'Unknown whale 33 (FROM Binance)', 'Whale', 'Individual') 
        , (0xee6d073d0c8cb54b5800af5b3c0479c416e1175d , 'Unknown whale 34', 'Whale', 'Individual')
        , (0x4fd797f0cC7C87B1b48b0A0db6b66DB63780717d, 'Unknown whale 35 (FROM Bitrue)', 'Whale', 'Individual')
        --, (0x307048ad5ab7279d34e5358331b0d48050ada274, 'Unknown whale 36 (FROM CoinDCX)', 'Whale', 'Individual')
        , (0x80c83c8463501A9fefFfda1013d688aacc418900, 'Unknown whale 37 (FROM Luno)', 'Whale', 'Individual')
        , (0x4319859681be12b36f4420F4A26FD67429306cD1, 'Unknown whale 38 (old money FROM Kraken)', 'Whale', 'Individual') --bought tons of ETH ON Kraken back in 2015, 2016 AND then held, used AS collateral in Maker. Initial account in the chain seems to be - 0x4319859681be12b36f4420F4A26FD67429306cD1
        , (0x4e0ce9d0f0f4e5438a4ce110a6f64db655fe4edf, 'Unknown whale 38 (old money FROM Kraken)', 'Whale', 'Individual')
        , (0x21e6ed571226168ec87ef964c33053ce8237d812, 'Unknown whale 38 (old money FROM Kraken)', 'Whale', 'Individual')
        , (0xee25d3e2bf2ce279eb725d7f9b4b4505bbbe9276, 'Unknown whale 38 (old money FROM Kraken)', 'Whale', 'Individual')
        , (0x2b982DD19aF6aB6d342eB065d5fbe9F97C5872C5, 'Unknown whale 39 (FROM Binance)', 'Whale', 'Individual')
        , (0xeabb4d333a5b2202619842bcfb13324d0eb29fdd, 'Unknown whale 40 (FROM Binance)', 'Whale', 'Individual')
        , (0x4f9aa4052932947bce8105f0d0613751d152f304, 'Unknown whale 41 (FROM Kraken)', 'Whale', 'Individual')
        , (0x31844dc946fb42a29e26396b31b4db04913888ed, 'Unknown whale 42', 'Whale', 'Individual') --funds withdrawn FROM RocketPool
        , (0xd7840a134d662256612dcd12930da7652b84320f, 'Unknown whale 43', 'Whale', 'Individual')--2,5k withdrawn FROM Lido (100ETH was staked with L) https://etherscan.io/tx/0x6f4cba6cfc6e30702e78736435a5c42c8d535b30b09595fe59fe3c1fdf820929
        , (0x0ce2765b3adcf1bc7d5a12eb05e50eccf2d896c2, 'Unknown whale 44', 'Whale', 'Individual')--1,7k withdrawn FROM Lido https://etherscan.io/token/0xae7ab96520de3a18e5e111b5eaab095312d7fe84?a=0x9c094c30a7d75346ff1c61c4f494a54fd2556793
        , (0xcb8c5823b3148cae7e93a25c3b29e3bc737db19c, 'Unknown whale 45(FROM Kraken)', 'Whale', 'Individual')
        , (0xcCBd830139Db4cC69818FBBe210B43D758394f62, 'Unknown whale 46', 'Whale', 'Individual') --ETH withdrawn FROM 0x6B8Dc709D1A2231f2889b461A9EC605B16EBfB31 AND deposited with 0xcCBd830139Db4cC69818FBBe210B43D758394f62
        , (0xa5ae684d38bd5ce0d02fb82d093699037f074fdc, 'Unknown whale 47', 'Whale(FROM Binance)', 'Individual')
        , (0x20c0b79571aabd309d1c2672aca0e1a76817bc2a, 'Unknown whale 48', 'Whale', 'Individual') --funds withdrawn FROM Lido
        , (0x07dd3b840a88be510b04c5f3705131410bb23452, 'Unknown whale 49(FROM Coinbase Prime)', 'Whale', 'Individual') 
        , (0x5a436013386f7d60b965e8ece3113036aa3cf212, 'Unknown whale 50(FROM MaiCoin)', 'Whale', 'Individual') 
        , (0xa1ed962Fce30844d261884262b175EF0715C5711, 'Unknown whale 51(FROM MaskEX)', 'Whale', 'Individual') 
        , (0xdaee4fcd61530275772cc7b7b57b6a281ab3be61, 'Unknown whale 52(FROM Binance)', 'Whale', 'Individual') 
        , (0x7f034b710feb8b54d687b33cb318398cdd787c6f, 'Unknown whale 53(FROM Binance)', 'Whale', 'Individual') 
        , (0x4ff58c49ae050fb690ee42c01c14fa73f6286ccc, 'Unknown whale 54(FROM Coinbase)', 'Whale', 'Individual') 
        , (0x7f034b710feb8b54d687b33cb318398cdd787c6f, 'Unknown whale 55(FROM Binance)', 'Whale', 'Individual') 
        , (0x9f1daa35a4ef099c03744dfe3e67a39c4697ebe5, 'Unknown whale 56', 'Whale', 'Individual') --ETH withdrawn FROM Lido + Binance 
        , (0xa1f80aa4b7070638b25d10d2237fcc9a3a0c0cd5, 'Unknown whale 57(FROM Kraken)', 'Whale', 'Individual') --ETH mostly FROM Kraken (+Binance)
        , (0xa4b89b3d07ab87a700742a766a54e5663a16374d, 'Unknown whale 58(FROM Bitfinex)', 'Whale', 'Individual')
        , (0x9b006c7d58cc2fd2c51c9904da25ecd413024e9d, 'Unknown whale 59(FROM Binance)', 'Whale', 'Individual')
        , (0x1b63142628311395ceafeea5667e7c9026c862ca, 'Taylor Gerring', 'Whale', 'Individual')
        , (0x2ed8eb76c91fa25b21d588128569dbc2f885e511, 'Linke Yang', 'Whale', 'Individual')
        , (0xf637b10647e2d0fd00c6a0b70d9e85bf6ea0327f, 'Ripio Credit Network', 'Whale', 'Individual') --depositor addres funded FROM multisig belonging to the p2p lending protocol - 0x16A0772b17AE004E6645E0e95BF50aD69498a34e . Doesn't seems to provide staking services to users
        , (0x25e821b7197B146F7713C3b89B6A4D83516B912d, 'ether.fi' , 'Decentralized', 'Liquid')
        , (0x1bdc639eabf1c5ebc020bb79e2dd069a8b6fe865, 'Octant', 'Decentralized', 'Illiquid') --https://www.golem.network --0x8731EF92831dF93383f3053B96a7919F14839c1D might belong to them too, same deployed within several days
        , (0xba1951dF0C0A52af23857c5ab48B4C43A57E7ed1, 'Octant', 'Decentralized', 'Illiquid')
        , (0x4f80ce44afab1e5e940574f135802e12ad2a5ef0, 'Octant', 'Decentralized', 'Illiquid')
        , (0xF17ACEd3c7A8DAA29ebb90Db8D1b6efD8C364a18, 'Binance', 'Centralized', 'Illiquid') 
        , (0x2f47a1c2db4a3b78cda44eade915c3b19107ddcc, 'Binance', 'Centralized', 'Illiquid')
        , (0x19184aB45C40c2920B0E0e31413b9434ABD243eD, 'Binance', 'Centralized', 'Illiquid')
        , (0xa2E3356610840701BDf5611a53974510Ae27E2e1, 'Binance', 'Centralized', 'Illiquid') --wBETH contract
        , (0x70D5cCC14a1a264c05Ff48B3ec6751b0959541aA, 'Binance', 'Centralized', 'Illiquid') --Binance US
        , (0x6bf05f66ee2cdaf19811be8ee9dbe2bee7c06555, 'Binance', 'Centralized', 'Illiquid')
        , (0xd897df5690a186F92970d5e42d16599136308257, 'Binance', 'Centralized', 'Illiquid')
        , (0x6c7c332a090c8d2085857cf3220ea01c6d45a723, 'Unagii', 'Decentralized', 'Illiquid')
        , (0x663d3947f03ef5b387992b880ac85940057c13e3, 'WeekInEth', 'Others', 'Illiquid')
        , (0x31e180e06d771dbafa3d6eea452195ad1020fbdb, 'Ethereum Hive', 'Hybrid', 'Illiquid')
        , (0xea674fdde714fd979de3edf0f56aa9716b898ec8, 'Ethermine', 'Hybrid', 'Illiquid')
        , (0x6b523cd4fcdf3332bcb3177050e22cf7272b4c3a, 'Consensus Cell Network', 'Others', 'Illiquid')
        , (0xd3b16f647ad234f8b5bb2bdbe8e919daa5268681, 'FOAM Signal', 'Others', 'Illiquid')
        , (0x3187a42658417a4d60866163a4534ce00d40c0c8, 'ssv.network', 'Decentralized', 'Illiquid')
        , (0xaab27b150451726ec7738aa1d0a94505c8729bd1, 'Eden Network', 'Others', 'Illiquid')
        , (0x75160f5cc50f57e16d6d18336c44c331f03794a2, 'EPotter', 'Centralized', 'Liquid')
        , (0x19cf8408fc0087a3c5d35b53211ff8d36fe5d49d, 'Bake.io', 'Centralized', 'Illiquid')
        , (0x5efaefd5f8a42723bb095194c9202bf2b83d8eb6, 'Nimbus Team', 'Whale', 'Individual')
        , (0x7badde47f41ceb2c0889091c8fc69e4d9059fb19, 'Prysm Team', 'Whale', 'Individual')
        , (0xfcd50905214325355a57ae9df084c5dd40d5d478, 'Sigma Prime Team', 'Whale', 'Individual')
        , (0x43a0927a6361258e6cbaed415df275a412c543b5, 'Teku Team', 'Whale', 'Individual')
        , (0xd55ed6867988bf3e36dae5da6e809536e2f26ac2, 'Unknown whale 22 (FROM Kraken)', 'Whale', 'Individual')
        --, (0x3085140568D02b7dcA5DB4070375040A6B2eCE5B, 'Unknown 11', 'Others', 'Illiquid') idenified AS Upbit
        , (0xdb1715712d08e0bd1a6a0c8a4c0c1c78f2bced17, 'Unknown 12', 'Others', 'Illiquid')
        , (0x5e6d4795b56a63385e5ac5da1b68d9f738a9a46b, 'Unknown 12', 'Others', 'Illiquid')
        --, (0x44894aeee56c2dd589c1d5c8cb04b87576967f97, 'Unknown 13', 'Others', 'Illiquid') idenified AS Upbit
        --, (0x3f124c700fb5e741f128e28985267d44f56b242f, 'Unknown 14', 'Others', 'Illiquid')  identified AS Blockdaemon
        , (0xA8C62111e4652b07110A0FC81816303c42632f64, 'Unknown 15', 'Others', 'Illiquid')
        , (0xd1007c077e75d72b6ff046fa1abf415bf8feb36f, 'Unknown 15', 'Others', 'Illiquid')
        , (0xcb72ba0a2ee7d10582ebc8f120435e77399f653f, 'Unknown 16', 'Others', 'Illiquid')
        , (0x3154dc53292cd3aa592775f7be6607f76f873506, 'Unknown 17', 'Others', 'Illiquid')
        , (0x276142c6358ccb8d90d35d7710789059d7dc56b3, 'Unknown 18', 'Others', 'Illiquid') --a large net of addresses connected with each other, mostly "walletsimple" AND "forwarder". Might be an investment fund of some kind?
        , (0x275a81e1848d176d6eb9c3f5d12c920f234408a6, 'Unknown 18', 'Others', 'Illiquid') --Central addresses of the net - 0x5a8f2aff4910cA61f706b45e1b78c593A7088ab0 that receives ETH FROM different DEXes & 0x3d019Cfecd722b76807dD2fad24376306D179277 that spreads these tokens 
        , (0xa9d9366f97cc1727ead2f6115c0f446a977b0219, 'Unknown 18', 'Others', 'Illiquid') 
        , (0xe187d594402c8f6b147f22d443406d1b1edebdc7, 'Unknown 18', 'Others', 'Illiquid')
        , (0x8396ba1231715086F26D9D9CED84A25cA8FEc21d, 'Unknown 18', 'Others', 'Illiquid')
        , (0x7ef5d450be41fcbc6191cb09789c5783da53f3fc, 'Unknown 19', 'Others', 'Illiquid')
        , (0x9351628900df0f0cf7d8864bc035f292d48db001, 'Unknown 20', 'Others', 'Illiquid') --might be connected with Loopring, same wallet interacted with this address AND Loopring deployer
        --, (0xcf95237ce34d4b5bf1e7de4474ee1dcc01f24ca9, 'Unknown 20', 'Others', 'Illiquid') idenified AS Upbit
        , (0xd523794c879d9ec028960a231f866758e405be34, 'Unknown 21', 'Others', 'Illiquid') -- unknown contract, can be also BatchDeposit, "TFI" 
        , (0x1a0ffc5d6a8f14bacfb21056355394128fa6b955, 'DxPool', 'Hybrid', 'Illiquid')
        , (0x617c8de5bde54ffbb8d92716cc947858ca38f582, 'Manifold Finance',  'Decentralized', 'Illiquid')
        , (0xcDBF58a9A9b54a2C43800c50C7192946dE858321, 'Bitpanda',  'Centralized', 'Illiquid') 
       
        , (0x110aDDE3c0F34861742Ae6a8b0B108119B356e5B, 'Stake.com', 'Others', 'Illiquid') 
        , (0xe3cBd06D7dadB3F4e6557bAb7EdD924CD1489E8f, 'Mirror (mETH)', 'Decentralized', 'Liquid') 
        
        ) 
        x (address, name, category, liquidity)
        
        UNION
         --this part gathers data for 'Binance'
        SELECT 
        "from" address, 'Binance' AS name
        , 'Centralized' AS category, 'Illiquid' AS liquidity
        FROM  ethereum.traces
        WHERE to = 0x00000000219ab540356cbb839cbe05303d7705fa
        AND block_number >= 11182202
        AND call_type = 'call'
        AND success = True 
        AND "from" in (
                        SELECT to AS project
                        FROM ethereum.transactions
                        WHERE "from" in (0xF17ACEd3c7A8DAA29ebb90Db8D1b6efD8C364a18, 0x19184aB45C40c2920B0E0e31413b9434ABD243eD)
                                AND to != 0x00000000219ab540356cbb839cbe05303d7705fa
                                AND "from" != 0x20312e96b1a0568ac31c6630844a962383cc66c2
                        GROUP BY 1
                        
            
            )
            GROUP BY 1
        
        UNION
         --this part gathers data from 'coinbase_addresses' CTE
        SELECT * FROM coinbase_addresses
                
        UNION
        --this part gathers data for 'Rocketpool'
        SELECT 
        "from" address, 'Rocketpool' AS name
        , 'Decentralized' AS category, 'Liquid' AS liquidity
        FROM  ethereum.traces
        WHERE to = 0x00000000219ab540356cbb839cbe05303d7705fa
        AND block_number >= 11182202
        AND call_type = 'call'
        AND success = True 
        /*
        AND "from" in (
                        SELECT  
                        to project
                        FROM ethereum.traces
                        WHERE "from" in (0x2cac916b2A963Bf162f076C0a8a4a8200BCFBfb4, 0x4D05E3d48a938db4b7a9A59A802D5b45011BDe58, 0xDD3f50F8A6CafbE9b31a427582963f465E745AF8) AND success = TRUE AND call_type = 'call'
                           AND to not in (0x3bdc69c4e5e13e52a65f5583c23efb9636b469d6, 0xae78736cd615f374d3085123a210448e74fc6393)
        )
        */
        AND "from" in (SELECT minipool FROM rocketpool_ethereum.RocketMinipoolManager_evt_MinipoolCreated)
        GROUP BY 1
        
        UNION
        --this part gathers data for 'Genesis accounts'
        SELECT 
        "from" address, 'Genesis accounts' AS name
        , 'Whale' AS category, 'Individual' AS liquidity
        FROM  ethereum.traces
        WHERE to = 0x00000000219ab540356cbb839cbe05303d7705fa
        AND block_number >= 11182202
        AND call_type = 'call'
        AND success = True 
        AND "from" in (
                        SELECT to AS project
                        FROM ethereum.transactions
                        WHERE "from"in (0x78A5E89900bD3F81DD71ba869D25FEc65261dF15, 
                        0x5657e633BE5912C6BAB132315609B51aADd01f95,
                        0xd964a23cf2c7a38107e9d8d487ffee76186bacd7) --newly added ON 2023-01-30
                                AND to != 0x00000000219ab540356cbb839cbe05303d7705fa
        GROUP BY 1
        
            )
        GROUP BY 1
        
        UNION
        -- This CTE  associates addresses with names and labels them based on their category and type
        SELECT * FROM (values 
                (0xA12BaEb64D4dE260ed48A3AB5De8D5CBeA1aCDbD, 'Daniel Wang','Whale', 'Individual' ) 
                ,(0x0C3441aAa2a51AdD5C35f9E6Bb47FD6fd273cFE1, 'Daniel Wang','Whale', 'Individual' )--
                ,(0x69AA0361Dbb0527d4F1e5312403Bd41788fe61Fe, 'Daniel Wang','Whale', 'Individual' )
                ,(0xE50Ce83e4A929Da0a6BF27249A235c1c4937094e, 'Daniel Wang','Whale' , 'Individual' )--
                ,(0x76782fBf7aE7367804656b6BefAeb04c97A784Bd, 'Daniel Wang','Whale' , 'Individual')--
                ,(0x52Fa4FC3c3100c0FFE3630d53a4fE10e73363c08, 'Daniel Wang','Whale' , 'Individual')--
                , (0xa3ae668b6239fa3eb1dc26daabb03f244d0259f0, 'Daniel Wang', 'Whale', 'Individual')
                , (0x4757d97449aca795510b9f3152c6a9019a3545c3, 'Daniel Wang', 'Whale', 'Individual')
                , (0x282a9e13ced2e838ac3b423995a9b174a54d6a4b, 'Daniel Wang', 'Whale', 'Individual')
                )x(project, name,category,liquidity)

        UNION
        --this part gathers data for 'Unknown1 from Binance & Huobi' address
        SELECT 
            "from" address, 'Unknown 1 (from Binance & Huobi)' AS name --some feats of a pool
            ,'Others' AS category, 'Illiquid' AS liquidity
        FROM  ethereum.traces
        WHERE to = 0x00000000219ab540356cbb839cbe05303d7705fa
        AND block_number >= 11182202
        AND call_type = 'call'
        AND success = True 
        AND "from" in (
                    SELECT to AS project
                    FROM ethereum.transactions
                    WHERE "from"= 0xa3792Cff5a1da84e9e5C4158C09377006E236A08
                            AND to != 0x00000000219ab540356cbb839cbe05303d7705fa
                    GROUP BY 1
        
        )
        GROUP BY 1   
        
        UNION
        --this part gathers data for 'Unknown2 from Binance' address 
        SELECT 
            "from" address, 'Unknown 2 (from Binance)' AS name --some feats of a pool
            ,'Others' AS category, 'Illiquid' AS liquidity 
        FROM  ethereum.traces
        WHERE to = 0x00000000219ab540356cbb839cbe05303d7705fa
        AND block_number >= 11182202
        AND call_type = 'call'
        AND success = True 
        AND "from" in (
                    SELECT to AS project
                    FROM ethereum.transactions
                    WHERE "from"= 0x7C1E5d7E13F906982A15Cbdfab86B5B454bD49b4
                            AND to != 0x00000000219ab540356cbb839cbe05303d7705fa
                    GROUP BY 1
        
        )
        GROUP BY 1
        
        UNION
         --this part gathers data for 'Unknown3 from Kraken' address 
        SELECT 
            "from" address, 'Unknown 3 (from Kraken)' AS name --some feats of a pool
            ,'Others' AS category, 'Illiquid' AS liquidity
        FROM  ethereum.traces
        WHERE to = 0x00000000219ab540356cbb839cbe05303d7705fa
        AND block_number >= 11182202
        AND call_type = 'call'
        AND success = True 
        AND "from" in (
                    SELECT to AS project
                    FROM ethereum.transactions
                    WHERE "from"= 0x907C61186cE5b8e9454500E1cbE2142d7e9ad93C
                            AND to != 0x00000000219ab540356cbb839cbe05303d7705fa
                    GROUP BY 1
        
        )
        GROUP BY 1
        
        UNION
        --this part gathers data for 'Kiln'
        SELECT 
            "from" address, 'Kiln' AS name
            , 'Centralized', 'Illiquid'
        FROM  ethereum.traces
        WHERE to = 0x00000000219ab540356cbb839cbe05303d7705fa
        AND block_number >= 11182202
        AND call_type = 'call'
        AND success = True 
        AND "from" in (
                    SELECT to AS project
                    FROM ethereum.transactions
                    WHERE "from"= 0x81F5f7bf0AFE2aFb9D7d6a21F4FeA1FB888E79CF
                            AND to != 0x00000000219ab540356cbb839cbe05303d7705fa
                    GROUP BY 1
                    
                   -- UNION
                  --    SELECT 0x1e68238ce926dec62b3fbc99ab06eb1d85ce0270 AS project --BatchDeposit Contract
        
        )
        GROUP BY 1
        ---------till here query runs
        
        UNION
        --this part gathers data for 'Unknown4 from Binance & mining' address
        SELECT 
            "from" address, 'Unknown 4 (from Binance & mining)' AS name
            ,'Others' AS category, 'Illiquid' AS liquidity
        FROM  ethereum.traces
        WHERE to = 0x00000000219ab540356cbb839cbe05303d7705fa
        AND block_number >= 11182202
        AND call_type = 'call'
        AND success = True 
        AND "from" in (
                    SELECT to AS project
                    FROM ethereum.transactions
                    WHERE "from" in (0xbec870d4a7e8b2308c852fe7a65e4e84ae2b4e52, 0x43DfBf46011808242288e70a79405Ce5d1B13264)
                            AND to != 0x00000000219ab540356cbb839cbe05303d7705fa
                    GROUP BY 1
        )
        GROUP BY 1
        
        UNION
        --this part gathers data for 'Unknown5 from Binance & FTX' address 
        SELECT 
            "from" address, 'Unknown 5 (from FTX & Binance)' AS name
            ,'Others' AS category, 'Illiquid' AS liquidity 
        FROM  ethereum.traces
        WHERE to = 0x00000000219ab540356cbb839cbe05303d7705fa
        AND block_number >= 11182202
        AND call_type = 'call'
        AND success = True 
        AND "from" in (
                    SELECT to AS project
                    FROM ethereum.transactions
                    WHERE "from" in (0x5c134a50c9cad0531caea982cb4426a632a2c528, 0xfa8c56fd100c7c55ef39e0af075c618b59714f91)
                            AND to not in (0x00000000219ab540356cbb839cbe05303d7705fa , 0xae7ab96520de3a18e5e111b5eaab095312d7fe84)
                            AND "from" != 0xae7ab96520de3a18e5e111b5eaab095312d7fe84
                    GROUP BY 1
        )
        --and "from" != 0xae7ab96520de3a18e5e111b5eaab095312d7fe84'
        GROUP BY 1
        
        UNION
        --this part gathers data for 'Unknown5 from Kraken' address 
        SELECT 
            "from" address, 'Unknown 6 (from Kraken)' AS name
            ,'Others' AS category, 'Illiquid' AS liquidity
        FROM  ethereum.traces
        WHERE to = 0x00000000219ab540356cbb839cbe05303d7705fa
        AND block_number >= 11182202
        AND call_type = 'call'
        AND success = True 
        AND "from" in (
                    SELECT to AS project
                    FROM ethereum.transactions
                    WHERE "from" = 0xbd2db078d02ad98c8f6387cd48b9267f0998143e
                            AND to != 0x00000000219ab540356cbb839cbe05303d7705fa
                    GROUP BY 1
                    
                    UNION (SELECT 0xbd2Db078d02aD98c8F6387Cd48B9267f0998143e AS project)
        )
        GROUP BY 1
        
       UNION
        --this part gathers data for 'Unknown5 from Poloniex' address     
       SELECT 
        "from" address, 'Unknown whale 13 (from Poloniex)' AS name
        ,'Whale' AS category, 'Individual' AS liquidity
        FROM  ethereum.traces
        WHERE to = 0x00000000219ab540356cbb839cbe05303d7705fa
        AND block_number >= 11182202
        AND call_type = 'call'
        AND success = True 
        AND "from" in (
                    SELECT to AS project
                    FROM ethereum.transactions
                    WHERE "from" = 0xfaCFdaDbdeBDcB5fc17FFbBBFe8bCcE3FCB5F8cB
                    --in (0x718dd2cbc7860d9512ff25111fad525f4117ca57 , 0xfaCFdaDbdeBDcB5fc17FFbBBFe8bCcE3FCB5F8cB)
                            AND to != 0x00000000219ab540356cbb839cbe05303d7705fa
                    GROUP BY 1
        )
        GROUP BY 1
        
        UNION 
        ---this part gathers data for 'Unknown14' that has funds since 2017 
        SELECT 
        "from" AS address, 'Unknown whale 14 (old money FROM 2017)' AS name
        ,'Whale' AS category, 'Individual' AS liquidity
        FROM  ethereum.traces
        WHERE to = 0x00000000219ab540356cbb839cbe05303d7705fa
        AND block_number >= 11182202
        AND call_type = 'call'
        AND success = True 
        AND "from" in (
                    SELECT to AS project
                    FROM ethereum.transactions
                    WHERE "from" in (0x7fCfD9cb0CBBe6AFA5E9eA0BFC8FFbBafBCEcdfF , 
                    0xfB11ab07cFC6cADFafFebb54AfEeBccEA3CeFaFF,
                    0xFB5Eec3eC3C5DafebDfBE5DDda6dBDBfbcACE7F3,
                    0xfBCabFA1eAaBCFcA22AEAB7dc4e13cDACD5DdfCD, 
                    0x5bccdaBCdcC8dbC3DaEebdBC8f2FEA3Cec8d3cdc,
                    0xaacE72eBd84dBaB2CAAdfDED0bb2e7fAeEAfaBdC 
                    )
                            AND to != 0x00000000219ab540356cbb839cbe05303d7705fa
                    GROUP BY 1
        )
        GROUP BY 1
        
        UNION 
        --this part gathers data for 'Unknown7 MEV bot' address 
        SELECT 
        "from" address, 'Unknown 7 (MEV bot)' AS name
            ,'Others' AS category, 'Illiquid' AS liquidity 
        --main depositing wallet is 0xE2C29d3f014001B1895bB4dE2fBA08e053491b45
        FROM  ethereum.traces
        WHERE to = 0x00000000219ab540356cbb839cbe05303d7705fa
        AND block_number >= 11182202
        AND call_type = 'call'
        AND success = True 
        AND "from" in (
                    SELECT to AS project
                    FROM ethereum.traces
                    WHERE "from" in (0x5AA3393e361C2EB342408559309b3e873CD876d6 , 
                    0x9129497fd16e5810E5F6b71df1da71E3f109c2d3,
                    0xbc7c714fb8e2134dC657E0a7C1eF0AEAf929CF23,
                    0xe523AE1936c070B095e92ba871FB263b2f61e67B, 
                    0xD530d401D03348E2b1364A4D586B75dCb2eD53FC
                    )
                            AND to != 0x00000000219ab540356cbb839cbe05303d7705fa
                    GROUP BY 1
        )
        GROUP BY 1
        
        UNION
        --this part gathers data for 'Unknown5 from Kraken' address 
        SELECT 
            "from" address, 'Unknown whale 15 (from Kraken)' AS name
            ,'Whale' AS category, 'Individual' AS liquidity
        FROM  ethereum.traces
        WHERE to = 0x00000000219ab540356cbb839cbe05303d7705fa
        AND block_number >= 11182202
        AND call_type = 'call'
        AND success = True 
        AND "from" in (
                    SELECT to AS project
                    FROM ethereum.transactions
                    WHERE "from" = 0x71354e9293a0c3fb956a3153852c642933fd6c26
                    --in (0x71354e9293a0c3fb956a3153852c642933fd6c26, 0x2fA2CC1c0bA877290Cc46299b4Cf364Fcd8d5b99)
                    AND to != 0x00000000219ab540356cbb839cbe05303d7705fa
                    GROUP BY 1
                    
                    UNION (SELECT 0x71354e9293a0c3fb956a3153852c642933fd6c26 AS project)
        )
        GROUP BY 1
        
        UNION
        --this part gathers data for 'MyEtherWallet' 
        SELECT 
            "from" address, 'MyEtherWallet' AS name
            ,'Others' AS category, 'Illiquid' AS liquidity
        FROM  ethereum.traces
        WHERE to = 0x00000000219ab540356cbb839cbe05303d7705fa
        AND block_number >= 11182202
        AND call_type = 'call'
        AND success = True 
        AND "from" in (
                    SELECT to AS project
                    FROM ethereum.transactions
                    WHERE "from" in (0xe5dc07bdcdb8c98850050c7f67de7e164b1ea391) --kvhnuke.eth, CEO of MyEtherWallet. Same nickname ON Twitter
                            AND to != 0x00000000219ab540356cbb839cbe05303d7705fa
                    GROUP BY 1
                    
                    UNION 
                    SELECT 0xe5dc07bdcdb8c98850050c7f67de7e164b1ea391 AS project
                    
                    UNION
                    SELECT 0xf243a92eb7d4b4f6a00a57888b887bd01ec6fd12 AS project
                    
                    UNION
                    SELECT 0x73Fd39BA4FB23C9B080fca0Fcbe4C8C7a2D630D0 AS project
        )
        GROUP BY 1   
        
        UNION
        --this part gathers data for 'DARMA Capital' 
        SELECT 
            "from" address, 
            --'Unknown 8' AS name
            'DARMA Capital' AS name,
            'Centralized' AS category, 'Illiquid' AS liquidity  
        FROM  ethereum.traces
        WHERE to = 0x00000000219ab540356cbb839cbe05303d7705fa
        AND block_number >= 11182202
        AND call_type = 'call'
        AND success = True 
        AND "from" in (
                    SELECT to AS project
                    FROM ethereum.transactions
                    WHERE "from" in (0x7BF6583EC7f7B507e6d0d439901c4a0047936fD7,
                    0x5d76a92b7cb9e1a81b8eb8c16468f1155b2f64f4) 
                            AND to != 0x00000000219ab540356cbb839cbe05303d7705fa
                    GROUP BY 1

                    UNION
                    SELECT 0x7BF6583EC7f7B507e6d0d439901c4a0047936fD7 AS project
                    
                    UNION
                    SELECT 0x5d76a92b7cb9e1a81b8eb8c16468f1155b2f64f4 AS project
        )
        GROUP BY 1
        
        
        UNION
        --this part gathers data for 'Unknown9' address
        SELECT 
            "from" address, 'Unknown 9' AS name
            ,'Others' AS category, 'Illiquid' AS liquidity  
        FROM  ethereum.traces
        WHERE to = 0x00000000219ab540356cbb839cbe05303d7705fa
        AND block_number >= 11182202
        AND call_type = 'call'
        AND success = True 
        AND "from" in (
                    SELECT to AS project
                    FROM ethereum.transactions
                    WHERE "from" in (0xc372d454835ac654d43b99c7789cc1c32f364237,
                    0x955a27306f1eb21757ccbd8daa2de82675aabc36,
                    0x5560248bd6436da52791bf4cb358c5b441f7f52e
                    ) 
                            AND to != 0x00000000219ab540356cbb839cbe05303d7705fa
                    GROUP BY 1

                    UNION
                    SELECT 0xc372d454835ac654d43b99c7789cc1c32f364237 AS project
                    
                    UNION
                    SELECT 0x955a27306f1eb21757ccbd8daa2de82675aabc36 AS project
                    
                    UNION
                    SELECT 0x5560248bd6436da52791bf4cb358c5b441f7f52e AS project
        )
        GROUP BY 1 

        UNION
        --this part gathers data for 'Unknown9 from different CEXes' address
        SELECT 
            "from" address, 'Unknown 10 (different CEXes)' AS name
            ,'Others' AS category, 'Illiquid' AS liquidity  
        FROM  ethereum.traces
        WHERE to = 0x00000000219ab540356cbb839cbe05303d7705fa
        AND block_number >= 11182202
        AND call_type = 'call'
        AND success = True 
        AND "from" in (
                    SELECT to AS project
                    FROM ethereum.transactions
                    WHERE "from" = 0x78381101cdf77126c07f4fb6e9811c24ec94cef0
                            AND to != 0x00000000219ab540356cbb839cbe05303d7705fa
                    GROUP BY 1

                    UNION
                    SELECT 0x78381101cdf77126c07f4fb6e9811c24ec94cef0 AS project

        )
        GROUP BY 1 

        UNION
        --this part gathers data for 'Unknown21' address         
        SELECT 
            "from" address, 'Unknown 21' AS name
            ,'Others' AS category, 'Illiquid' AS liquidity  
        FROM  ethereum.traces
        WHERE to = 0x00000000219ab540356cbb839cbe05303d7705fa
        AND block_number >= 11182202
        AND call_type = 'call'
        AND success = True 
        AND "from" in (
                    SELECT to AS project
                    FROM ethereum.transactions
                    WHERE "from" =  0x23f32171ed7419ee52206e11485d9f4c7f40f525
                            AND to != 0x00000000219ab540356cbb839cbe05303d7705fa
                    GROUP BY 1

                    UNION
                    SELECT  0x23f32171ed7419ee52206e11485d9f4c7f40f525 AS project

        )
        GROUP BY 1  

        UNION
        --this part gathers data for 'Unknown42 from Binance' address 
        SELECT 
            "from" address, 'Unknown whale 42 (from Binance)' AS name
            ,'Whale' AS category, 'Individual' AS liquidity  
        FROM  ethereum.traces
        WHERE to = 0x00000000219ab540356cbb839cbe05303d7705fa
        AND block_number >= 11182202
        AND call_type = 'call'
        AND success = True 
        AND "from" in (
                    SELECT to AS project
                    FROM ethereum.transactions
                    WHERE "from" =  0x5b3ECaD8ca171cd3123cC295E28cfE51F4Ad4Abb
                            AND to != 0x00000000219ab540356cbb839cbe05303d7705fa
                    GROUP BY 1

                    UNION
                    SELECT  0x5b3ECaD8ca171cd3123cC295E28cfE51F4Ad4Abb AS project
                    )
    
        UNION
        --this part gathers data for 'Chorus One' 
        SELECT * FROM query_3088763
)

 -- final query retrieves AND combines data to identify addresses AND associate them to names, category AND type
SELECT * FROM list

UNION 
SELECT depositor_address AS address,
'Coinbase' AS name,
'Centralized' AS category, 
'Illiquid' AS liquidity
FROM staking_ethereum.entities
WHERE depositor_address not in (SELECT address FROM dune.lido.result_eth_depositors_labels)
and entity = 'Coinbase'

UNION 
SELECT depositor_address AS address,
'Rocketpool' AS name,
'Decentralized' AS category, 
'Liquid' AS liquidity
FROM staking_ethereum.entities
WHERE depositor_address not in (SELECT address FROM dune.lido.result_eth_depositors_labels)
and entity = 'Rocket Pool'

UNION all 
--Diva https://twitter.com/hildobby_/status/1714247479406047703    
SELECT address AS address,
'Diva' AS name,
'Decentralized' AS category, 
'Liquid' AS liquidity
FROM (
    SELECT distinct "from" AS address
    FROM ethereum.transactions
    CROSS JOIN UNNEST(split(REPLACE(REPLACE(from_utf8(data), '{keys:[', ''), ']}', ''), ',')) AS t(pubkey)
    WHERE "to" = 0x93f3d5bb7901a00c88703cf78fa27bb6647774e9
)
 
UNION 

SELECT  depositor_address AS address,
        'Solo Staker' AS name,
        'Solo Staker' AS category,
        'Individual'  AS liquidity
FROM staking_ethereum.entities
WHERE category = 'Solo Staker'
  AND depositor_address not in (SELECT address FROM list)--dune.lido.result_eth_depositors_labels)

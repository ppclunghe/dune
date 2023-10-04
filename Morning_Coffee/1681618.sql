--Name: (w)stETH locked by protocol, Ethereum
--Description: 
--Parameters: []
-- last update 2023-09-15

 with not_address_list AS ( --from query steth holders without curve
SELECT
    0x0000000000000000000000000000000000000000 AS address
union 
SELECT
     0xD15a672319Cf0352560eE76d9e89eAB0889046D3 -- Burner  
)

,contract_address AS (
SELECT
    0xae7ab96520de3a18e5e111b5eaab095312d7fe84 AS address --stETH 
)

,
transfers AS (
SELECT
    DATE_TRUNC('day', evt_block_time) AS time,
    evt_tx_hash AS tx_hash,
    tr."from"  AS address,
    0 AS amount_in,
    -cast(tr.value as double) AS amount_out
FROM lido_ethereum.steth_evt_Transfer tr
WHERE contract_address IN (SELECT address FROM contract_address) 
AND  "from"  NOT IN (SELECT address FROM not_address_list)

UNION ALL

SELECT
    DATE_TRUNC('day', evt_block_time) AS time,
    evt_tx_hash AS tx_hash,
    tr.to  AS address,
    cast(tr.value as double) AS amount_in,
    0 AS amount_out
FROM lido_ethereum.steth_evt_Transfer tr 
WHERE contract_address IN (SELECT address FROM contract_address) 
AND  to  NOT IN (SELECT address FROM not_address_list)
)


, namespace AS (

    SELECT DISTINCT
        a.address
        , COALESCE(b.namespace, c.namespace) as namespace
        , COALESCE(NULLIF(b.namespace,''),'depositor')
    FROM (SELECT DISTINCT(address) AS address FROM transfers) a
    LEFT JOIN (select * from query_2415558 where blockchain = 'ethereum') b ON a.address = b.address
    LEFT JOIN ethereum.contracts c ON a.address = c.address 


)

, steth_table AS (
    SELECT 
       distinct tr.address,
       namespace,
       sum(amount_in) / 1e18 as amount_in,
       sum(amount_out) / 1e18 as amount_out,
       sum(amount_in) / 1e18 + sum(amount_out) / 1e18 as balance 
    FROM transfers tr
    LEFT JOIN namespace n ON n.address = tr.address
    where namespace not in  ('depositor', 'gnosis_multisig', 'gnosis_safe', 'proxy_multisig', 'argent', 'lido:withdrawal_queue')
        
    GROUP BY 1,2
    HAVING (sum(amount_in) / 1e18 + sum(amount_out) / 1e18) > 100
    ORDER BY balance DESC

)

,wsteth_rate as
(
    SELECT
      SUM(steth) / CAST(SUM(wsteth) AS DOUBLE) AS price
    FROM 
    (
    SELECT
      DATE_TRUNC('day', call_block_time) AS time,
      output_0 AS steth,
      _wstETHAmount AS wsteth
    FROM
      lido_ethereum.WstETH_call_unwrap
    WHERE
      call_success = TRUE
      and call_block_time >= CAST(now() as timestamp) - interval '24' hour
      
    UNION ALL
    SELECT
      DATE_TRUNC('day', call_block_time) AS time,
      _stETHAmount AS steth,
      output_0 AS wsteth
    FROM
      lido_ethereum.WstETH_call_wrap
    WHERE
      call_success = TRUE
      and call_block_time >= CAST(now() as timestamp) - interval '24' hour
  )
)

, combined AS (
    SELECT
        *
    FROM steth_table
    WHERE address <> 0x7f39c581f595b53c5cb19bd0b3f8da6c935e2ca0
    
    UNION ALL
    
    SELECT
        address,
        namespace,
        amount_in * (select price from wsteth_rate ) as amount_in,
        amount_out * (select price from wsteth_rate ) as amount_out,
        balance * (select price from wsteth_rate ) as balance
    FROM query_1974110
)

SELECT
    address
    , namespace
    , SUM(amount_in) + SUM(amount_out) AS balance
FROM combined where address not in (0x1982b2f5814301d4e9a8b0201555376e62f82428, 0xdc24316b9ae028f1497c275eb9192a3ea0f67022)
GROUP BY 1, 2

union all
SELECT
    0x1982b2f5814301d4e9a8b0201555376e62f82428 as address,
    'aave_v2' as namespace,
    "cumulative balance, stETH" as balance
from query_459431
where day = (select max(day) from query_459431)

union all
SELECT
    0xdc24316b9ae028f1497c275eb9192a3ea0f67022 as address,
    'curve' as namespace,
    steth_pool as balance
from query_374112
where time = (select max(time) from query_374112)


ORDER BY balance DESC


/*
with not_address_list AS (
SELECT
    0x0000000000000000000000000000000000000000 AS address
-- union 
-- SELECT
--      0xdc24316b9ae028f1497c275eb9192a3ea0f67022
)

,contract_address AS (
SELECT
    0xae7ab96520de3a18e5e111b5eaab095312d7fe84 AS address --stETH 
)

,
transfers AS (
SELECT
    DATE_TRUNC('day', evt_block_time) AS time,
    evt_tx_hash AS tx_hash,
    tr."from"  AS address,
    0 AS amount_in,
    -cast(tr.value as double) AS amount_out
FROM lido_ethereum.steth_evt_Transfer tr
WHERE contract_address IN (SELECT address FROM contract_address) 
AND  "from"  NOT IN (SELECT address FROM not_address_list)

UNION ALL

SELECT
    DATE_TRUNC('day', evt_block_time) AS time,
    evt_tx_hash AS tx_hash,
    tr.to  AS address,
    cast(tr.value as double) AS amount_in,
    0 AS amount_out
FROM lido_ethereum.steth_evt_Transfer tr 
WHERE contract_address IN (SELECT address FROM contract_address) 
AND  to  NOT IN (SELECT address FROM not_address_list)
)


, namespace AS (--UPDATED 2023/02/07 15:40 CET

    SELECT DISTINCT
        a.address, 
        case
        WHEN a.address IN (0x1f629794b34ffb3b29ff206be5478a52678b47ae                
								 						) THEN 'oneinch_lp'
        WHEN a.address IN (0x120FA5738751b275aed7F7b46B98beB38679e093                
								 						) THEN 'yearn_strategy'
		WHEN a.address IN (0x4d9629e80118082B939e3D59E69c82A2ec08b4d5                
								 						) THEN 'tribe_redeemer'	
		WHEN a.address IN (0x86FB84E92c1EEDc245987D28a42E123202bd6701
		                    , 0x23d3285bfE4Fd42965A821f3aECf084F5Bd40Ef4
								 						) THEN 'enzyme_finance'
	    WHEN a.address IN (0x8B3f33234ABD88493c0Cd28De33D583B70beDe35                
								 						) THEN 'insurance_fund'	
		WHEN a.address IN (0xE134e3FBe36c2D3F7cDd26265DD497F3586B2825                
								 						) THEN 'stardy'	
		WHEN a.address IN (0x3e40D73EB977Dc6a537aF587D48316feE66E9C8c                
								 						) THEN 'lido_treasury'
		WHEN a.address IN (0xB3DFe140A77eC43006499CB8c2E5e31975caD909                
								 						) THEN 'lido_vesting_recipient3'						 						
		WHEN a.address IN (0xA2F987A546D4CD1c607Ee8141276876C26b72Bdf                
								 						) THEN 'anchor'	
		WHEN a.address IN (0x28eC41B848c4A62A37A3054a69D2F76cC8E9677b                
								 						) THEN 'instaDApp'
		WHEN a.address IN (0xD94631E93a3c0046C433a88d8fC5BeC64Ea9066c
		                    , 0x6C7855A6a7A97f746E2B9E24b856A789Ae0A67AC
		                    , 0x56AD039E01863566a91113fF0Dc3F9288322D6Fd
		                    , 0x13C8eB0DCCa7117D72731A6F16A32bA96b9F0913
		                    , 0xbc70f52206C48F9B23cF280E341820ec7E45f6E5
		                    , 0x71780DC93D482809593E881F78ebBb409963e373
		                    , 0x24Ed6EB99C9AA7229336aaA05b4f3B07827404eA
		                    , 0xCa3280d18993ECC04a14d031ccc0A58A6D4f8A92
		                    , 0x57ed1ED84461bb2079f8575d06A6feC07F0a13B1
		                    , 0x51afdbA5596474C3a0aF60f5Fb091226Ac111e0c
		                    , 0x4BC42e9470199d8Fdb831FDCb4Db37c393A7B043
		                    , 0xe66Cb3a0Ccee18Ef61C61B99FC943C2B3035036e
		                    , 0xC8122db95bCFB10E87FD326dAb1693A1B2C00158
		                    , 0xE7fcb650ed4265680300C52326BC5057730C5ff0
		                    , 0x7139ce2c735fEd1576Dee7149ca8F84C6A15462D
		                    , 0xd6A68F540A7Afc36a93a5D6Adf14BC8D18d7c5C7
		                    , 0xa39b956210116E6EBcA0716235520342c260246B
		                    , 0xDf66B439dbf1bd3a92Ad89b7aA008c48DF9CF370
		                    , 0x67ff882071A0054f58A387F770cD09e13889de73
								 						) THEN 'gearbox'	
		WHEN a.address IN (0xB61953961b63182E9b724D0a45178af0cc99176f                
								 						) THEN 'gammaxExchangeTreasury'	
		WHEN a.address IN (0x78e3984e1Ab1c3EB560cbd5b42b635E1cD341Bc2                
							, 0xa2E3A2ca689c00F08F34b62cCC73B1477eF1f658
		                    , 0x70a613eA53b71abcBd9b32eAFB86362a31D5164C
		                    , 0x7a75E85d6d3F0B6D7363a5d7F23aDc25101131E7
		                    , 0x25eFA336886C74eA8E282ac466BdCd0199f85BB9
		                    , 0x0EFcCBb9E2C09Ea29551879bd9Da32362b32fc89
		                    , 0x4e7e7fCf2e0D25E4a4F008D0184Ef614F1803227
		                    , 0xc7599b60f05639f93D26e58d56D90C526A6e7575
		                    , 0xB671e841a8e6DB528358Ed385983892552EF422f
		                    , 0xc393fa98109b91fb8c5043d36abaad061e68a4f2
		                    , 0x570154c8c9f8cb35dc454f1cde33dc8fe30ecd63
		                    , 0xfdd86a96f47015d9c457c841e1d52d06ede16a92
		                    , 0xe8bfdf8f47b35418c73af2a2bc4d0d12488e93c5
		                    , 0x75a03ec24bf95f68a749d833a2efde50db7a6192
		                    , 0xac665a44d46194eb9826d6f93fb5cc93bc2654b4
		                    , 0x1ca861c023b09efa4932d96f1b09de906ebbc4cd
		                    , 0x5add8a02141bf53a7c5bc6ad5483ca17552e9c52
		                    , 0x849d52316331967b6ff1198e5e32a0eb168d039d
		                    , 0xb67a9bf270fb32a8706cfc826a884f174c18cfe1
		                    , 0xe094a22330b1eb7d69bb6342a63c59c07c1a5b4c
		                    , 0xb577cc8aa76d3607067934fd6477f0a392194a83
		                    , 0x488fb8371ad8b20e39e3ce99d267e26c171b7d10
		                    , 0x46e4f1ec613faa131722fe26234b892f0a7e81fc
		                    , 0x76D9a4076C086f77f4CdDEd72674D4b153cB4569
		                    , 0xdc7b28976d6eb13082a5be7c66f9dcfe0115738f
		                    , 0xbba4c8eb57df16c4cfabe4e9a3ab697a3e0c65d8
		                    , 0x0b70a2653b6e7bf44a3c80683e9bd9b90489f92a
		                    , 0x8ef64a3a445bb76cd4a7a49f8aed463a0e6046e7
		                    , 0x7b7f0e4ed559b2394ea8265ec1fc2f1f8112945a
		                    , 0x00e286b5256aa6cf252d5a8a5a7b8c20ec3bc4d5
		                    , 0x4039e1c58b27298d92e69d5bf215378e4f8544a5
		                    , 0x9b3c97db5538dd62c4e3f8f41f1277505fbb9e76
		                    , 0x27f0e8beccfa594f4b08c24226ce75c535b900ea
		                    , 0x10124bda2119db4802905a889c0d46a0c4af26ea
		                    , 0x5f411b4485741e5a437fcc1ef103fbeb461158ca
		                    , 0x7eaafd601977d0f1aae82e05461d23c0701bb6a5
		                    , 0x798576f0b501a8eb61d914249676e3878584b2ee
		                    , 0xf1104ef28d611fcca6ccb2a91c411ea0671b317b
		                    , 0x4afe1df6cc422b2da695a69da888c685704a975d
		                    , 0xf0f266f7a481a15607b11d171760d96dcc16e4ed
		                    , 0x6215daea5b3e266f841fad9b2566c5d00a6d2dcc
		                    , 0x43c50d3ef219d319a0b4373575d87eda744cd2c4
		                    , 0xab4c505e70b9abed3527911b42d72611a604abb5
		                    , 0x0cf9652b7f00b4032e8ea4627cdf792cc37c72d7
		                    , 0x07a04253e22b919f0d540fa505bcd9fcc0ee6d20
		                    , 0xf825f87546424656444506bdde3ae5554e4be933
		                    , 0x8ef11fa9d66b1ad1c75a2d1b746358c3780e34f3
		                    , 0x69881012ed610df5be5711edd70b50eb1ed2b8f2
		                    , 0x7be29fddb841584468fd5dc15bb7ab0b45a2bf4f
		                    , 0x9f03bfbdf1e026cedb7f606e740a0b3aa16044e8
		                    , 0xcae5ff0581228b460256987043d1ad9e570dfb28
		                    , 0x1da05bce1edd2369cddcb35e747859ef6a675010
		                    , 0xfb47b2ca7df248d36cf0e4f63bfd0503c25debd4
		                    , 0x9b33dd59fa401374f9213d591d0319a9d7e9d2cb
		                    , 0x27b04a92e2436ff81f074ceb0996bac8dff42d0d
		                    , 0xab6375d9d5b45f376e4a458bae39299f3e37c02a
		                    , 0x2ecc4af585516b41a23e0068ac88674563561027
		                    , 0xe5bb0e559a74739ea2d8f8be2c3fae45159b0e68
		                    , 0x3050620423f4db43e1904815e898c466526387b8
		                    , 0x1d778d3c6cb658c56be571425f69eff809fdc1eb
		                    , 0x3a24fea1509e1baeb2d2a7c819a191aa441825ea
		                    , 0xad920e4870b3ff09d56261f571955990200b863e
		                    , 0x86eab3469a94b2cffafa8b6d384504c6c8dbe00f
		                    , 0x7cb62f8bed0f163e84b85ad5f924dcd82504226b
		                    , 0x3b640748d96c6ec3e0148d41a25a311042e5cd73
		                    , 0xa6347afc86abf77bb4c79ef56deb7cf2892566f3
		                    , 0x237a314d53e9aa126b215169eb1283a48953f315
		                    , 0x3058b6269968bbd196072dfc0907c7b3baa2a36a
		                    , 0x613145675395c63863a52fe0c8cf141c0f07a8a1
		                    , 0xf603393a1df6e7d8f0ed2a009832387055437b34
		                    , 0x88b9a85cb72b654289d3653321ee8089b087dedc
		                    , 0xb871b4dcea2ffd77d77f13d1bede09868546e23b
		                    , 0xc7a1fcde0b80c89b9b270cf9c87e9c6753f30d0b
		                    , 0x09883a34ed3bd28a25a59f9b8e0f7c605aeb716f
		                    , 0x120fff50e09b522bdd696bc18edc5cac56af70c4
		                    , 0x8b90ac446d4360332129e92f857a9d536db9d7c2
		                    , 0xd0895493c347f163bdb67c310af477db1d03f547
		                    , 0x63c1cfbbc2b5f1d54636520b9ef484afc3b1f912
		                    ,  0x60cf9d61370d44ccf55289aebea33a072d9f93bd
								 						) THEN 'gnosis_multisig'
		WHEN a.address IN (0xF938a9eD2Fc7E4E03216Ca210d8750506D743b5C                
								 						) THEN 'unknown'	
		WHEN a.address IN (0xEbC498895382ddcBd247b2945BA116157D361134
		                    , 0x3e0433cde2c58f5c07d22ed506e72ae8c7a97b34
		                    , 0xb6804dac8541c585f029f0bbddd6fe1bb2f4b51a
		                    , 0x3f3a4f13a0c1390d018e75032f9e12dbe2b27412
		                    , 0x27c115f0d823973743a5046139806adce5e9cfd5
								 						) THEN 'argent'	
		WHEN a.address IN (0x0697B0a2cBb1F947f51a9845b715E9eAb3f89B4F                
								 						) THEN 'tempus_sers'
		WHEN a.address IN (0xcafea35ce5a2fc4ced4464da4349f81a122fd12b                
								 						) THEN 'nexus_mutual'
		WHEN a.address IN (0x0bc3807ec262cb779b38d65b38158acc3bfede10                
								 						) THEN 'nouns'
		WHEN a.address IN (0x27182842e098f60e3d576794a5bffb0777e025d3                
								 						) THEN 'euler'		
		WHEN a.address IN (0x0632dcc37b1fabf2cad20538a5390d23c830962e                
								 						) THEN 'request_network'
		WHEN a.address IN (0xce5513474e077f5336cf1b33c1347fdd8d48ae8c                
								 						) THEN 'ribbon_earn'
		WHEN a.address IN (0x11986f428b22c011082820825ca29b21a3c11295                
								 						) THEN 'sipher'
		WHEN a.address IN (0x439cac149b935ae1d726569800972e1669d17094                
								 						) THEN 'idol'	
		WHEN a.address IN (0x3eb01b3391ea15ce752d01cf3d3f09dec596f650                
								 						) THEN 'kyber_multisig'	
		WHEN a.address IN (0x8b4334d4812c530574bd4f2763fcd22de94a969b                
								 						) THEN 'tokemak'	
		WHEN a.address IN (0x9a67f1940164d0318612b497e8e6038f902a00a4                
								 						) THEN 'keeperDAO'
		WHEN a.address IN (0x4028daac072e492d34a3afdbef0ba7e35d8b55c4                
								 						) THEN 'uniswap_v2'	
		WHEN a.address IN (0x6abfd6139c7c3cc270ee2ce132e309f59caaf6a2                
								 						) THEN 'morpho'
		WHEN a.address IN (0x463f9ed5e11764eb9029762011a03643603ad879                
								 						) THEN 'pods_yield'	
		WHEN a.address IN (0x519b70055af55a007110b4ff99b0ea33071c720a                
								 						) THEN 'dxDAO'
		WHEN a.address IN (0x7aD2c85E3092A3876a0b4b345dF8C72FC6c9636f                
								 						) THEN 'unknown2'	
		WHEN a.address IN (0xa978d807614c3bfb0f90bc282019b2898c617880                
								 						) THEN 'inverse_finance'
        WHEN a.address IN (0x7f39c581f595b53c5cb19bd0b3f8da6c935e2ca0								 						
	 				                                    ) THEN 'lido:wsteth'
	    WHEN a.address IN (0xefd8a0b5e0e01a95fcc15656dad61d5b5436b2b4								 						
	 				                                    ) THEN 'Agility' 
    else COALESCE(NULLIF(namespace,''),'depositor')
    end AS namespace
FROM (SELECT DISTINCT(address) AS address FROM transfers) a
LEFT JOIN ethereum.contracts c ON a.address = c.address 
)

SELECT 
   --distinct tr.address,
   namespace,
   sum(amount_in) / 1e18 as amount_in,
   sum(amount_out) / 1e18 as amount_out,
   sum(amount_in) / 1e18 + sum(amount_out) / 1e18 as balance 
FROM transfers tr
LEFT JOIN namespace n ON n.address = tr.address
where namespace != 'depositor' and namespace != 'gnosis_multisig' and namespace != 'gnosis_safe'
    
GROUP BY 1--,2
HAVING (sum(amount_in) / 1e18 + sum(amount_out) / 1e18) > 100
ORDER BY balance DESC

*/
   
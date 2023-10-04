--Name: LSTs Holders
--Description: 
--Parameters: []
-- last update 2023-09-20
     SELECT * 
     FROM (
            values (0x1982b2F5814301d4e9a8b0201555376e62F82428, 'aave_v2', 'lending', 'ethereum')
            , (0x828b154032950c8ff7cf8085d841723db2696056, 'curve_concentrated_pool', 'liquidity_pool','ethereum')
            , (0x1f629794b34ffb3b29ff206be5478a52678b47ae, 'oneinch_lp', 'liquidity_pool','ethereum')
            , (0x120FA5738751b275aed7F7b46B98beB38679e093, 'yearn', 'yield', 'ethereum')
    		, (0x4d9629e80118082B939e3D59E69c82A2ec08b4d5, 'tribe_redeemer', '?yield', 'ethereum')	-- FEI Protocol? contract creator-tomwaite.eth
    		, (0x86FB84E92c1EEDc245987D28a42E123202bd6701, 'enzyme_finance', 'defi_aggr', 'ethereum')
    		, (0x23d3285bfE4Fd42965A821f3aECf084F5Bd40Ef4, 'enzyme_finance', 'defi_aggr', 'ethereum')
    		, (0xfa61d61db727573c9bd8e447122b2350ccef9d61, 'enzyme_finance', 'defi_aggr', 'ethereum')
    	    , (0x8B3f33234ABD88493c0Cd28De33D583B70beDe35, 'lido_dao_insurance_fund', 'lido', 'ethereum')	
    		, (0xE134e3FBe36c2D3F7cDd26265DD497F3586B2825, 'stardy', 'lending', 'ethereum')	
    		, (0x3e40D73EB977Dc6a537aF587D48316feE66E9C8c, 'lido_treasury', 'lido', 'ethereum')
    		, (0xB3DFe140A77eC43006499CB8c2E5e31975caD909, 'lido_vesting_recipient3', 'lido', 'ethereum') --multisig						 						
    		, (0xA2F987A546D4CD1c607Ee8141276876C26b72Bdf, 'anchor', 'lending', 'ethereum') --? doesn't show in query 
    		, (0x28eC41B848c4A62A37A3054a69D2F76cC8E9677b, 'instadapp', 'defi_aggr', 'ethereum') --!!! not a wallet
    		, (0x74B3691EbC3Fb083E36065A1986d6C490B13E95a, 'instadapp', 'defi_aggr', 'ethereum')
    		, (0xa0d3707c569ff8c87fa923d3823ec5d81c98be78, 'instadapp_v2', 'defi_aggr', 'ethereum')
    		, (0xD94631E93a3c0046C433a88d8fC5BeC64Ea9066c, 'gearbox', 'lending', 'ethereum')
		    , (0x6C7855A6a7A97f746E2B9E24b856A789Ae0A67AC, 'gearbox', 'lending', 'ethereum')
		    , (0x56AD039E01863566a91113fF0Dc3F9288322D6Fd, 'gearbox', 'lending', 'ethereum')
		    , (0x13C8eB0DCCa7117D72731A6F16A32bA96b9F0913, 'gearbox', 'lending', 'ethereum')
		    , (0xbc70f52206C48F9B23cF280E341820ec7E45f6E5, 'gearbox', 'lending', 'ethereum')
		    , (0x71780DC93D482809593E881F78ebBb409963e373, 'gearbox', 'lending', 'ethereum')
		    , (0x24Ed6EB99C9AA7229336aaA05b4f3B07827404eA, 'gearbox', 'lending', 'ethereum')
		    , (0xCa3280d18993ECC04a14d031ccc0A58A6D4f8A92, 'gearbox', 'lending', 'ethereum')
		    , (0x57ed1ED84461bb2079f8575d06A6feC07F0a13B1, 'gearbox', 'lending', 'ethereum')
		    , (0x51afdbA5596474C3a0aF60f5Fb091226Ac111e0c, 'gearbox', 'lending', 'ethereum')
		    , (0x4BC42e9470199d8Fdb831FDCb4Db37c393A7B043, 'gearbox', 'lending', 'ethereum')
		    , (0xe66Cb3a0Ccee18Ef61C61B99FC943C2B3035036e, 'gearbox', 'lending', 'ethereum')
		    , (0xC8122db95bCFB10E87FD326dAb1693A1B2C00158, 'gearbox', 'lending', 'ethereum')
		    , (0xE7fcb650ed4265680300C52326BC5057730C5ff0, 'gearbox', 'lending', 'ethereum')
		    , (0x7139ce2c735fEd1576Dee7149ca8F84C6A15462D, 'gearbox', 'lending', 'ethereum')
		    , (0xd6A68F540A7Afc36a93a5D6Adf14BC8D18d7c5C7, 'gearbox', 'lending', 'ethereum')
		    , (0xa39b956210116E6EBcA0716235520342c260246B, 'gearbox', 'lending', 'ethereum')
		    , (0xDf66B439dbf1bd3a92Ad89b7aA008c48DF9CF370, 'gearbox', 'lending', 'ethereum')
		    , (0x67ff882071A0054f58A387F770cD09e13889de73, 'gearbox', 'lending', 'ethereum')
		    , (0xC240Cb2DF5a2ccAC50f66D4389570D648566eA7D, 'gearbox', 'lending', 'ethereum') --tiagoacn.eth
		    , (0x411eD4BD1918E60db5a1143d23aD7c1781Fe9Aac, 'gearbox', 'lending', 'ethereum')
		    , (0x1CAd285860f36E1B72E52718755048ad5C458a1f, 'gearbox', 'lending', 'ethereum')
		    , (0xCa3280d18993ECC04a14d031ccc0A58A6D4f8A92, 'gearbox', 'lending', 'ethereum')
		    , (0xB61953961b63182E9b724D0a45178af0cc99176f, 'gammax_exchange_treasury', 'treasury', 'ethereum')	
		    , (0x78e3984e1Ab1c3EB560cbd5b42b635E1cD341Bc2, 'gnosis_safe', 'multisig', 'ethereum')                
			, (0xa2E3A2ca689c00F08F34b62cCC73B1477eF1f658, 'gnosis_safe', 'multisig', 'ethereum')
		    , (0x70a613eA53b71abcBd9b32eAFB86362a31D5164C, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0x7a75E85d6d3F0B6D7363a5d7F23aDc25101131E7, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0x25eFA336886C74eA8E282ac466BdCd0199f85BB9, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0x0EFcCBb9E2C09Ea29551879bd9Da32362b32fc89, 'balancer_v2', 'treasury', 'ethereum') 
		    , (0x4e7e7fCf2e0D25E4a4F008D0184Ef614F1803227, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0xc7599b60f05639f93D26e58d56D90C526A6e7575, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0xB671e841a8e6DB528358Ed385983892552EF422f, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0xc393fa98109b91fb8c5043d36abaad061e68a4f2, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0x570154c8c9f8cb35dc454f1cde33dc8fe30ecd63, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0x6da86bf835124c5b7665d1010da47ab5ae564e34, 'gnosis_safe', 'multisig', 'ethereum')  --multisig
		    , (0x0034e8411d397c7377c06995565e61846d9af957, 'gnosis_safe', 'multisig', 'ethereum')  --multisig
		    , (0x4bfb33d65f4167ebe190145939479227e7bf2cb0, 'gnosis_safe', 'multisig', 'ethereum')  --multisig
		    , (0xb140c83796795709b63b958924b17054dc2b8b0b, 'gnosis_safe', 'multisig', 'ethereum') --multisig
		    , (0x3bd1b0fb2f0cb666faccdd0afb1f20e4b91ea660, 'gnosis_safe', 'multisig', 'ethereum')  --multisig
		    , (0x1ca861c023b09efa4932d96f1b09de906ebbc4cd, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0x5add8a02141bf53a7c5bc6ad5483ca17552e9c52, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0x849d52316331967b6ff1198e5e32a0eb168d039d, 'gnosis_safe', 'multisig', 'ethereum') --multisig
		    , (0x27be856e8b8d24220e53b933e29d46a477858ce7, 'gnosis_safe', 'multisig', 'ethereum')  --multisig
		    , (0xe094a22330b1eb7d69bb6342a63c59c07c1a5b4c, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0xb577cc8aa76d3607067934fd6477f0a392194a83, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0x488fb8371ad8b20e39e3ce99d267e26c171b7d10, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0x67959227cd09d25fa4e43baff0dca9e36e028cfc, 'gnosis_safe', 'multisig', 'ethereum')  --multisig
		    , (0x76D9a4076C086f77f4CdDEd72674D4b153cB4569, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0x0451b41ec78f80b7c89f7a9d63446a3b31376a67, 'gnosis_safe', 'multisig', 'ethereum')  --multisig
		    , (0x54cc80cc99fb7946e492cd8c306b645488e54905, 'gnosis_safe', 'multisig', 'ethereum')  --multisig
		    , (0x0b70a2653b6e7bf44a3c80683e9bd9b90489f92a, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0x8ef64a3a445bb76cd4a7a49f8aed463a0e6046e7, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0x7b7f0e4ed559b2394ea8265ec1fc2f1f8112945a, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0x00e286b5256aa6cf252d5a8a5a7b8c20ec3bc4d5, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0x0fa3433cd67b1c3d024d67c61aaa018b46456fe6, 'gnosis_safe', 'multisig', 'ethereum')  --multisig
		    , (0x9b3c97db5538dd62c4e3f8f41f1277505fbb9e76, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0x27f0e8beccfa594f4b08c24226ce75c535b900ea, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0x10124bda2119db4802905a889c0d46a0c4af26ea, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0x5f411b4485741e5a437fcc1ef103fbeb461158ca, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0x7eaafd601977d0f1aae82e05461d23c0701bb6a5, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0xedf9e7dd50eac44000d0768de934b5c14962402a, 'gnosis_safe', 'multisig', 'ethereum') --multisig
		    , (0xf1104ef28d611fcca6ccb2a91c411ea0671b317b, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0x4afe1df6cc422b2da695a69da888c685704a975d, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0xf0f266f7a481a15607b11d171760d96dcc16e4ed, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0xefd92ea2fbce879b9d097928b70d9b1416853048, 'gnosis_safe', 'multisig', 'ethereum')  --multisig
		    , (0xb567fc49a209c8c892dbd6d5c118f0e25c96fcc1, 'gnosis_safe', 'multisig', 'ethereum')  --multisig
		    , (0xab4c505e70b9abed3527911b42d72611a604abb5, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0x0cf9652b7f00b4032e8ea4627cdf792cc37c72d7, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0x07a04253e22b919f0d540fa505bcd9fcc0ee6d20, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0x77Fe0c0Caf38E39e49644170fa55274Dfbb183A5, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0x8ef11fa9d66b1ad1c75a2d1b746358c3780e34f3, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0x69881012ed610df5be5711edd70b50eb1ed2b8f2, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0xc0eea24d1bee9a053946da071b33cbea761acaa9, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0x9f03bfbdf1e026cedb7f606e740a0b3aa16044e8, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0xcae5ff0581228b460256987043d1ad9e570dfb28, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0x1da05bce1edd2369cddcb35e747859ef6a675010, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0xfb47b2ca7df248d36cf0e4f63bfd0503c25debd4, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0x9b33dd59fa401374f9213d591d0319a9d7e9d2cb, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0x27b04a92e2436ff81f074ceb0996bac8dff42d0d, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0x57823baebaa86724839902e0d8efab7e0cfb31b0, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0x2ecc4af585516b41a23e0068ac88674563561027, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0xe5bb0e559a74739ea2d8f8be2c3fae45159b0e68, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0x3050620423f4db43e1904815e898c466526387b8, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0x1d778d3c6cb658c56be571425f69eff809fdc1eb, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0x3a24fea1509e1baeb2d2a7c819a191aa441825ea, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0xad920e4870b3ff09d56261f571955990200b863e, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0x86eab3469a94b2cffafa8b6d384504c6c8dbe00f, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0x93c4b944d05dfe6df7645a86cd2206016c51564d, 'eigenlayer', 'restaking', 'ethereum')
		    , (0x3b640748d96c6ec3e0148d41a25a311042e5cd73, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0xa6347afc86abf77bb4c79ef56deb7cf2892566f3, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0x237a314d53e9aa126b215169eb1283a48953f315, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0x3058b6269968bbd196072dfc0907c7b3baa2a36a, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0x613145675395c63863a52fe0c8cf141c0f07a8a1, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0xf603393a1df6e7d8f0ed2a009832387055437b34, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0x88b9a85cb72b654289d3653321ee8089b087dedc, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0xb871b4dcea2ffd77d77f13d1bede09868546e23b, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0xc7a1fcde0b80c89b9b270cf9c87e9c6753f30d0b, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0x09883a34ed3bd28a25a59f9b8e0f7c605aeb716f, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0x120fff50e09b522bdd696bc18edc5cac56af70c4, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0x8b90ac446d4360332129e92f857a9d536db9d7c2, 'anyblock_analytics', 'multisig', 'ethereum') --lido Node operator multisig 
		    , (0xd0895493c347f163bdb67c310af477db1d03f547, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0x63c1cfbbc2b5f1d54636520b9ef484afc3b1f912, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0x60cf9d61370d44ccf55289aebea33a072d9f93bd, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0xB671e841a8e6DB528358Ed385983892552EF422f, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0x570154C8C9F8Cb35dc454f1CdE33DC8Fe30ecd63, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0x0B70A2653B6E7BF44A3c80683E9bD9B90489F92A, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0x1cA861C023b09efA4932D96F1B09De906EBbc4cd, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0xE094a22330b1EB7d69BB6342A63c59C07c1A5B4c, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0x45050d6661b53f3cc97011c6beb60d8b158e8959, 'gnosis_safe', 'multisig', 'ethereum') --czsamsunsb.eth
		    , (0x488fB8371Ad8b20E39E3CE99D267e26C171B7D10, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0x73Fd92237dD006057A6E4cD81A98628069BaeDb5, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0x10124BDa2119db4802905a889c0D46A0c4af26eA, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0xd037Ba33f15D4B50a9A471E5576709aa716A9378, 'kyber_multisig', 'multisig', 'ethereum')  --MultiSigWalletWithDailyLimit
		    , (0x8eF64a3a445BB76Cd4a7a49F8AEd463A0E6046e7, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0x7B7F0e4Ed559B2394ea8265EC1fc2f1f8112945A, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0x4F2083f5fBede34C2714aFfb3105539775f7FE64, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0x9b3C97db5538DD62c4e3f8f41F1277505FBb9E76, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0x5F411B4485741E5a437FCc1EF103FBEb461158cA, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0xF1104Ef28D611fCcA6CCB2a91C411Ea0671B317B, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0x27f0E8BecCfa594f4b08c24226cE75c535B900Ea, 'gnosis_safe', 'multisig', 'ethereum')  --Safe: Relay service
		    , (0x4AFe1dF6cC422B2dA695a69Da888c685704a975d, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0x86F30Bc33C0DdA4dd5f48158ed8023Aa371f833d, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0xE09b7fC43b3De7dba9CF634489D092FF0C99b753, 'gnosis_safe', 'multisig', 'ethereum') --CoW protocol
		    , (0x0cf9652B7f00b4032e8eA4627CdF792Cc37c72D7, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0xDdfC583F4B73960FfD43cE66BBE0d543466c47A1, 'gnosis_safe', 'multisig', 'ethereum') --Cow Protocol
		    , (0xc037AF4cC87A7F736F3E05c5B8347576C8ebB79a, 'gnosis_safe', 'multisig', 'ethereum') --1inch v5
		    , (0x07A04253E22b919F0D540Fa505bCd9fCc0eE6d20, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0xeaf047aDfF888526210B95e2F1F9D10f5053574C, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0x8Ef11fa9d66B1Ad1C75a2D1B746358c3780E34F3, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0x5F41FfF9d70c734eB012F1A0A322980C1863aba4, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0x69881012Ed610DF5bE5711eDd70B50EB1Ed2b8F2, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0x9f03bfbDf1E026ceDb7f606E740A0B3aa16044e8, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0xCae5FF0581228b460256987043D1Ad9e570DFb28, 'gnosis_safe', 'multisig', 'ethereum') --curve liquidity farm
		    , (0xF397935A5Ea8CfbCAD18856eBb43A6eDce79826c, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0xFb47b2Ca7df248D36cf0E4f63bfD0503C25deBD4, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0xE5bb0E559a74739eA2d8f8Be2C3FAe45159b0e68, 'gnosis_safe', 'multisig', 'ethereum')  --yanxin.eth, 1inch
		    , (0xEAA7723633cf598E872D611f5EC50a45b65CBc72, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0x8a0e4afa935d795d5c537e4614976d1acbd4faa8, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0xab502a6fb9b9984341e77716b36484ac13dddc62, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0xcd51df5142156BD92E7A9494Dd2b9362f5078D64, 'attestant (bvi) limited', 'multisig', 'ethereum')  -- lido Node Operator
		    , (0x83462a462596ff1b1ba5bf76df4025e01b327f5f, 'gnosis_safe', 'multisig', 'ethereum') --curve liquidity farm
		    , (0x8ee03eea321b87d7ee8e9e25220ab056afe3cd6a, 'guildFi', 'multisig', 'ethereum')  --multisig
		    , (0x4fabff46addbef0d25002a6681ba54c3b973d463, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0x4353e2df4e3444e97e20b2bda165bdd9a23913ab, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0x08df64083cb978c8c1aa3c8772c600f9a6ee243d, 'gnosis_safe', 'multisig', 'ethereum') --curve liquidity farm
		    , (0xc3e925b3614e9714b75a67801edbe4603a54bd3e, 'gnosis_safe', 'multisig', 'ethereum') --Cow protocol
		    , (0xeb37e481050c18a9c86e669cd23cf672e4594339, 'gnosis_safe', 'multisig', 'ethereum') --curve liquidity farm
		    , (0x8ce9df09496999016a3620b9c992706d7b0b345e, 'gnosis_safe', 'multisig', 'ethereum')  --holds wsteth
		    , (0x371889b65337a0992fd5a03494fff2d73359a8f6, 'gnosis_safe', 'multisig', 'ethereum')  --holds wsteth
		    , (0x0dd3e7764081c3c0cd2d72cc09410c655cf7ff85, 'gnosis_safe', 'multisig', 'ethereum')  --holds wsteth, 1inch?
		    , (0x79dbb72e18be3aaed8ea7f7f0a0fe7a132c2a047, 'gnosis_safe', 'multisig', 'ethereum')  --holds wsteth, curve liquidity farm
		    , (0x049f9e332164bc3d46f27ebd8b505b899b49d041, 'gnosis_safe', 'multisig', 'ethereum')  --holds wsteth
		    , (0x79c482d94475c3fba518905eed80f1982c6e1442, 'gnosis_safe', 'multisig', 'ethereum')  -- misterpugi.eth holds wsteth
		    , (0x95e409e87ac875d595e6de6da6eb37f1bf22f50c, 'gnosis_safe', 'multisig', 'ethereum')  --holds wsteth
		    , (0xda495f89606d907c20a5b3e64c1b29093bdc7041, 'gnosis_safe', 'multisig', 'ethereum')  --holds wsteth
		    , (0x1390047a78a029383d0adcc1adb5053b8fa3243f, 'gnosis_safe', 'multisig', 'ethereum')  --holds wsteth
		    , (0x4305bafe9ff70a0b1661605acc8c1b166ca06504, 'gnosis_safe', 'multisig', 'ethereum')  --holds wsteth
		    , (0x7f9d680b91c82ce9a47bae8ec81ac41533a6c24e, 'gnosis_safe', 'multisig', 'ethereum')  --holds wsteth, coinbase
		    , (0x91636fe0e0df10c8fc0f442957b763548d415ee7, 'gnosis_safe', 'multisig', 'ethereum')  --holds wsteth
		    , (0x320bb75737cb8542667eff69e9cbfff9bd8969d6, 'gnosis_safe', 'multisig', 'ethereum')  --holds wsteth
		    , (0x680becbf3ae0a18a0fbcdbf4b7e60cf4560ad578, 'gnosis_safe', 'multisig', 'ethereum')  --holds wsteth
		    , (0x7a3569bA5b0d3cD81D17E8eB246505bF0A6cbA10, 'gnosis_safe', 'multisig', 'ethereum')  -- whale 0x3f3429d28438cc14133966820b8a9ea61cf1d4f0
		    , (0xF938a9eD2Fc7E4E03216Ca210d8750506D743b5C, 'argent', 'proxy', 'ethereum')	
		    , (0xEbC498895382ddcBd247b2945BA116157D361134, 'argent', 'proxy', 'ethereum')
		    , (0x3e0433cde2c58f5c07d22ed506e72ae8c7a97b34, 'argent', 'proxy', 'ethereum')
		    , (0xb6804dac8541c585f029f0bbddd6fe1bb2f4b51a, 'argent', 'proxy', 'ethereum')
		    , (0x3f3a4f13a0c1390d018e75032f9e12dbe2b27412, 'argent', 'proxy', 'ethereum')
		    , (0x27c115f0d823973743a5046139806adce5e9cfd5, 'argent', 'proxy', 'ethereum')
		    , (0xe93a4d8ede42557acb11fad16fda1edb14bf4ebc, 'argent', 'proxy', 'ethereum')
		    , (0xd39b35cf662721104ed1e7935c35e744a6ae9af1, 'argent', 'proxy', 'ethereum')
		    , (0xbc282a7ee8008346d499fddc150f5e9529e40050, 'argent', 'proxy', 'ethereum')
		    , (0xb45cd57648fcc6eb1f18c5e22d30e19e70117ae9, 'argent', 'proxy', 'ethereum')
		    , (0x852f3dfc3ab2dbf5984443dc780e174b31dfb184, 'argent', 'proxy', 'ethereum') --holds wsteth
		    , (0x1888fa9d58d19d1fe5532b63e5b3cef08158334e, 'argent', 'proxy', 'ethereum')
		    , (0x0697B0a2cBb1F947f51a9845b715E9eAb3f89B4F, 'tempus', 'yield', 'ethereum')
		    , (0xcafea35ce5a2fc4ced4464da4349f81a122fd12b, 'nexus_mutual','insurance', 'ethereum')
		    , (0x0bc3807ec262cb779b38d65b38158acc3bfede10, 'nouns', 'treasury', 'ethereum')
		    , (0x27182842e098f60e3d576794a5bffb0777e025d3, 'euler', 'lending', 'ethereum')		
		    , (0x0632dcc37b1fabf2cad20538a5390d23c830962e, 'request_network', 'multisig', 'ethereum') --ex gnosis_safe
		    , (0xce5513474e077f5336cf1b33c1347fdd8d48ae8c, 'ribbon_earn', 'yield', 'ethereum')
		    , (0x11986f428b22c011082820825ca29b21a3c11295, 'sipher', 'multisig', 'ethereum')
		    , (0x439cac149b935ae1d726569800972e1669d17094, 'idol', '?yield', 'ethereum') --NFTs	
		    , (0x3eb01b3391ea15ce752d01cf3d3f09dec596f650, 'kyber_multisig', 'multisig', 'ethereum') --contract MultiSigWalletWithDailyLimit	
		    , (0x8b4334d4812c530574bd4f2763fcd22de94a969b, 'tokemak', 'treasury', 'ethereum')	
		    , (0x9a67f1940164d0318612b497e8e6038f902a00a4, 'keeperdao', 'treasury', 'ethereum')
		    , (0x4028daac072e492d34a3afdbef0ba7e35d8b55c4, 'uniswap_v2', 'liquidity_pool', 'ethereum')	
		    , (0x6abfd6139c7c3cc270ee2ce132e309f59caaf6a2, 'morpho', 'yield', 'ethereum') --lending pool optimazer
		    , (0x463f9ed5e11764eb9029762011a03643603ad879, 'pods_finance', 'yield', 'ethereum') 	
		    , (0x519b70055af55a007110b4ff99b0ea33071c720a, 'dxDAO', '?strategy', 'ethereum') --https://daotimes.com/what-is-dxdao-and-how-does-it-work/
		    , (0x7aD2c85E3092A3876a0b4b345dF8C72FC6c9636f, 'argent', 'proxy', 'ethereum')	
		    , (0xa978d807614c3bfb0f90bc282019b2898c617880, 'inverse_finance(Anchor)', 'lending', 'ethereum')
            , (0x7f39c581f595b53c5cb19bd0b3f8da6c935e2ca0, 'lido:wsteth', 'lido:token', 'ethereum')
            , (0xcafea112db32436c2390f5ec988f3adb96870627, 'nexus_mutual', 'insurance', 'ethereum') --nexus mutual pool3
	 	    , (0xfdd86a96f47015d9c457c841e1D52D06EDe16A92, 'proxy', 'multisig', 'ethereum')
	 	    , (0xE8bFDf8F47B35418c73af2A2Bc4D0D12488E93C5, 'proxy', 'multisig', 'ethereum')
	 	    , (0x75a03Ec24BF95f68A749D833A2EfdE50db7A6192, 'proxy', 'multisig', 'ethereum')
	 	    , (0xAC665A44d46194EB9826D6F93Fb5Cc93bC2654b4, 'proxy', 'multisig', 'ethereum') --fee_recipient
	 	 --   , (0x5ADD8A02141Bf53a7C5Bc6Ad5483cA17552E9c52, 'proxy', 'multisig', 'ethereum')
	 	    , (0x7be29FDdB841584468FD5dC15Bb7Ab0B45A2bf4F, 'proxy', 'multisig', 'ethereum')
	 	    , (0xB67A9bF270Fb32A8706CFC826A884F174C18CFe1, 'proxy', 'multisig', 'ethereum')
	 	    , (0x46e4f1EC613faA131722Fe26234b892f0a7E81Fc, 'proxy', 'multisig', 'ethereum')
	 	    , (0xdC7b28976d6eb13082a5Be7C66f9dCFE0115738f, 'proxy', 'multisig', 'ethereum')
	 	    , (0xBbA4C8eB57DF16c4CfAbe4e9A3Ab697A3e0C65D8, 'proxy', 'multisig', 'ethereum')
	 	    , (0x4039e1c58b27298D92E69d5Bf215378e4F8544a5, 'proxy', 'multisig', 'ethereum')
	 	    , (0x798576F0B501A8Eb61D914249676E3878584B2EE, 'proxy', 'multisig', 'ethereum')
	 	 --   , (0xF0F266F7a481a15607B11d171760D96DCC16E4Ed, 'proxy', 'multisig', 'ethereum')
	 	    , (0x6215dAea5B3e266F841fAd9b2566c5d00a6D2DcC, 'proxy', 'multisig', 'ethereum')
	 	    , (0x43C50D3ef219D319a0b4373575D87edA744Cd2c4, 'proxy', 'multisig', 'ethereum')--curve?
	 	    , (0xf825f87546424656444506bdde3Ae5554E4Be933, 'proxy', 'multisig', 'ethereum')
	 	    , (0xab6375D9D5b45F376e4A458bAe39299F3E37C02a, 'proxy', 'multisig', 'ethereum')--Cow Protocol
	 	    , (0x7CB62f8BED0F163E84b85aD5f924DCD82504226b, 'proxy', 'multisig', 'ethereum')
	 	    , (0x7A2d1950ae28f067f688f7e8298F1443F50c0C18, 'proxy', 'multisig', 'ethereum')--shattrath.eth
	 	    , (0x9d94ef33e7f8087117f85b3ff7b1d8f27e4053d5, 'proxy', 'multisig', 'ethereum') --created by uramp.eth
	 	    , (0x270f6ef8d01e80725e5d32589178b8a041021a45, 'proxy', 'multisig', 'ethereum') -- CoW protocol, holds wsteth
	 	    , (0x044b48e46b0b7b8b639364cc90875a0f7d4537ec, 'proxy', 'multisig', 'ethereum') -- CoW protocol
	 	    , (0x91d65caf4b9562779e39a30ea492bd4b02a9acbb, 'proxy', 'multisig', 'ethereum') --holds wsteth
	 	    , (0x5ee5ce2c352884aa7cc5bd6b5a1c1c9053a51c60, 'argent', 'proxy', 'ethereum')
	 	    , (0x78789651b58179b2d90af90c8e5b4f5e4a4182ce, 'argent', 'proxy', 'ethereum')
	 	    , (0xa66c4e1d716d4d5ee554d162a3d3e67bb4cec06c, 'argent', 'proxy', 'ethereum')
	 	    , (0x957b39cc8e93243985f505df8b61d83570bfe04f, 'argent', 'proxy', 'ethereum')
	 	    , (0xeeb66a6fa8699051155462aeebfcc0e32094a649, 'argent', 'proxy', 'ethereum')
	 	    , (0xd8cbfb514d0a3d09b8423477e5627bc78589abd4, 'argent', 'proxy', 'ethereum')
	 	    , (0xfb2cb5570cb0e1305d01269cf7e1036c3a601a85, 'argent', 'proxy', 'ethereum')
	 	    , (0xc6aae788dd7b178c34bc0eb7eec12760e6528c3c, 'argent', 'proxy', 'ethereum')
	 	    , (0x96698bc70f11bb14544802346edee4477d6606e5, 'argent', 'proxy', 'ethereum')
	 	    , (0x1bd9f918e38239e8454ee647e552862ec8e6f57d, 'argent', 'proxy', 'ethereum')
	 	    , (0x7b0Eff0C991F0AA880481FdFa5624Cb0BC9b10e1, 'lsdx_finance', 'liquidity_pool', 'ethereum')
	 	    , (0x5937f58c2BE65E95b5519f126a79a4CA4F281f10, 'lsdx_finance', 'liquidity_pool', 'ethereum')
	 	    , (0xa2f987a546d4cd1c607ee8141276876c26b72bdf, 'anchor', 'lending', 'ethereum')
	 	    , (0xBB00101b19c0b1511730aCa582fBCC3c25fE9e9e, 'para_space', 'lending', 'ethereum')
	 	    , (0x21E27a5E5513D6e65C4f830167390997aA84843a, 'curve_steth_ng_f', 'liquidity_pool', 'ethereum')
	 	    , (0x4d9f9D15101EEC665F77210cB999639f760F831E, 'curve_st_frxETH_f', 'liquidity_pool', 'ethereum')
		    , (0xDC24316b9AE028F1497c275EB9192a3Ea0f67022, 'curve', 'liquidity_pool', 'ethereum') --liq.ty farming
 		    , (0x43c4fb1cdd45a96395996c10473d7f4e6a7831d3, 'others', 'others', 'ethereum') -- frst steth came from curve?
		    , (0xEFd8a0b5e0e01A95fCc15656DAd61D5B5436B2b4, 'agility', 'liquidity_pool', 'ethereum')
		    , (0x97de57ec338ab5d51557da3434828c5dbfada371, 'lybra_eusd', 'lending', 'ethereum')
		    , (0x7f0A0C7149a46Bf943cCd412da687144b49C6014, 'catinaboxcdp', 'lending', 'ethereum')
		    , (0x6ffd098e92b606b2947b89a08911c00ca06890fa, 'catinaboxcdp', 'lending', 'ethereum')
		    , (0x02c6d994e13f71dc6d9b367e002a04f78d05a9ad, 'slsd_finance', 'yield', 'ethereum')
		    , (0x82D24dD5041A3Eb942ccA68B319F1fDa9EB0c604, 'asymetrix', 'yield', 'ethereum')
		    ----------------------------2023-07-07
		    , (0xf525da0b267550e9912968732dccec188dc81b90, 'district0x', 'multisig', 'ethereum')
		    , (0x109830a1aaad605bbf02a9dfa7b0b92ec2fb7daa, 'uniswap_v3', 'liquidity_pool', 'ethereum')
		    , (0x989aeb4d175e16225e39e87d0d97a3360524ad80, 'convex', 'yield', 'ethereum')
		    , (0x43dffbf34c06eaf9cd1f9b4c6848b0f1891434b3, 'nexo', 'treasury', 'ethereum')
		    , (0x3bdd85F4907B377F4Ff107C46ad52bd106768974, 'unknown16', 'unknown', 'ethereum') --recieved steth from Nexo?
		    , (0x51C2cEF9efa48e08557A361B52DB34061c025a1B, 'jpegd:multisig', 'multisig', 'ethereum')
		    , (0xfd527d8afbd049b3e307e27eeebb135552b2d81b, 'instadapp', 'defi_aggr', 'ethereum')
		    , (0x47b0d34bc548d5eaae8676086a71f42c1dfbba7c, 'argent', 'proxy', 'ethereum')
		    --, (0x8ce2f11c7dfae77db396405417f7fc6a5bf971f6, 'maker', 'lending', 'ethereum')
		    , (0x63f760734b6f6be77bbc82b723e56f85820df671, 'instadapp', 'defi_aggr', 'ethereum')
		    --, (0xd74c796a46c3541392747974a2843795e54402a4, 'maker', 'lending', 'ethereum')
		    , (0xf668e6d326945d499e5b35e7cd2e82acfbcfe6f0, 'curve_stetheth_c_f_gauge', 'gauge', 'ethereum')--?
		    --, (0x1182cb8f6f83b76109cca9a2ed0748390d7fb508, 'maker', 'lending', 'ethereum')
		    , (0x0d459a3287afec25c0580691e9944d65feabb155, 'pendle', 'yield', 'ethereum')
		    , (0x56e974feff7959f2759b8e18c629d88c9d75f64f, 'instadapp', 'defi_aggr', 'ethereum')--??
		    , (0x44e569787ac2789867c775690a10307a3ce21839, 'others', 'others', 'ethereum')--?frst steth came from curve
		    , (0x623f3dbc761b46f64ae7951700dd7724cb7d6075, 'balancer_v2', 'gauge', 'ethereum')
		    , (0x3bbdca01f54aada872216e2e5b3172f8bed0f755, 'others', 'others', 'ethereum')
		    --, (0x94da5d8d94d45dcd9a8f5b50eb8c3e7246d9c620, 'maker', 'lending', 'ethereum')
		    , (0xfbf3fee8a50886498ff14ca42044f2374759a265, 'others', 'others', 'ethereum') --created by 0xwald.eth
		    , (0xfea5e213bbd81a8a94d0e1edb09dbd7ceab61e1c, 'stakeDAO', 'yield', 'ethereum')
		    , (0xdab7bf309c630b6fe0206cb46729ecf6b116736d, 'argent', 'proxy', 'ethereum')
		    , (0xc5d2fcd426a648b2cabf14aabafc9a87801d4b40, 'kyberswap', 'liquidity_pool', 'ethereum')
		    , (0x963c94e660acc8fb3d4314b95003450426b903da, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0x0d152ff760c1eae784972b31f01bcd92f5818f5c, 'others', 'others', 'ethereum')--?compound
		    --, (0xd732837b561a40d28ea74970558bc73cc9c13e0c, 'maker', 'lending', 'ethereum')
		    , (0x2ca76db46b0c42d3abe17b259cb90c693d1b9986, 'instadapp', 'defi_aggr', 'ethereum')
		    , (0x1a8c730c2ad5faab9fe0d7ee5bfd750e044a111d, 'instadapp', 'defi_aggr', 'ethereum')
		    , (0x6451878ebd7dd53250c800bba2edfe6941e81d29, 'instadapp', 'defi_aggr', 'ethereum')
		  --  , (0x438857166f250b92541b2695ff1d787a6850d2d3, 'maker', 'lending', 'ethereum')
		    , (0xb3d8cca14f249cf68e5272c1e7623bfecc705591, 'instadapp', 'defi_aggr', 'ethereum')
		    , (0x6967c9a1a6e7057cefb79cbb5bc23b234ae6cf3a, 'others', 'others', 'ethereum')
		    , (0xfa8e3886920548dfa541709597083e30af7e1045, 'gnosis_safe', 'multisig', 'ethereum')
		    --, (0x9ca173d2e4b4246b8cc9d7ee331678e638c386b4, 'maker', 'lending', 'ethereum')
		    --, (0x9b10a954b7a14ae7e12e472036e545f8576b7531, 'maker', 'lending', 'ethereum')
		   -- , (0x47e1a7079ca2c1056536c60fd1d4f19638e712db, 'maker', 'lending', 'ethereum')
		    , (0x164819903ba357dce46a4fd514485b9d5dd42e00, 'uniswap_v2', 'liquidity_pool', 'ethereum')
		    , (0x130b261da8c75ed5103625577abdef1d0421a161, 'instadapp', 'defi_aggr', 'ethereum')
		    , (0x15e27d72a6e95318e6b0e5e4a42b3b6ca22f09a7, 'euler', 'lending', 'ethereum')
		    , (0x2756bb9746af8355f85394c5d034897ba2635e0c, 'instadapp', 'defi_aggr', 'ethereum')
		    , (0x2751c7e2ccfe054228027662bd64f33434c7ba53, 'instadapp', 'defi_aggr', 'ethereum')
		    , (0x12df0c95d2c549bbbc96cf8fba02ca4bc541afd9, 'others', 'others', 'ethereum')--?
		    , (0xf48aeffdb19be3753c3185088c869a95db5a3edc, 'others', 'others', 'ethereum')
		    --, (0xc2cce95593546a2e8a1ad2c2a0e4f046d5ceb5ab, 'maker', 'lending', 'ethereum')
		    , (0xc3863cccd012f8e45d72ec87c5a9c4f77e1c7549, 'pendle', 'yield', 'ethereum')
		    , (0x0cd420966fce68bad79cd82c9a360636cf898c1e, 'instadapp', 'defi_aggr', 'ethereum')
		    --, (0xadcefc0a2b2b480adff7f9ec11443792c31ebb29, 'maker', 'lending', 'ethereum')
		    , (0x74b8c7680502931c33d9446e26592b8318eb7248, 'instadapp', 'defi_aggr', 'ethereum')
		    --, (0x310a2c115d3d45a89b59640fff859be0f54a08e2, 'maker', 'lending', 'ethereum')
		    , (0xd19e46692b687ff54c941cd0e0e2883259c7e01e, 'instadapp', 'defi_aggr', 'ethereum')
		    , (0xef0881ec094552b2e128cf945ef17a6752b4ec5d, 'sushiSwap', 'liquidity_pool', 'ethereum')
		    , (0x82e90eb7034c1df646bd06afb9e67281aab5ed28, 'mai_finance', 'strategy', 'ethereum' )--nft
		    --, (0xc38d57e5e4e74ea1cb8b6cd93791ddd5493affe5, 'maker', 'lending', 'ethereum')
		    , (0x60ee8465dc43245c6c2989b1089e476d3a0a717d, 'instadapp', 'defi_aggr', 'ethereum')
		    , (0x651361a042e0573295dd7f6a84dbd1da56dac9d5, 'balancer_v2', 'gauge', 'ethereum')
		    , (0xc4f1e164713aed18546fdde94c04712de3bce690, 'others', 'others', 'ethereum')
		    , (0x789268fa8b0704aff44ace685703ad81759030b3, 'gnosis_safe', 'multisig', 'ethereum')
		    , (0xeda61b1e9f414889dde0dbe83b3bacf814a98e87, 'proxy', 'multisig', 'ethereum')
		    , (0xd04d6040caaae35fcb30ffa91f9d89751e078c4f, 'instadapp', 'defi_aggr', 'ethereum')
		    , (0x8e884c724edded0bb4fc659b96511a48d8f1c39d, 'instadapp', 'defi_aggr', 'ethereum')
		    , (0x398b545fb12916c1d04a62ce5689be69fa38f228, 'instadapp', 'defi_aggr', 'ethereum')
		   -- , (0x2b1f4a047c9771c80284be3c2e063f5586018490, 'maker', 'lending', 'ethereum')
		    --, (0xaa2781c77246875b9bf40315bbef62da49f83250, 'maker', 'lending', 'ethereum')
		    , (0xe154df81ab93103bc0544581f925b53c997c7d9c, 'gnosis_safe', 'multisig', 'ethereum')
		    , (0xb8ec7c6483444572a486e22dd8f875bb26e14472, 'instadapp', 'defi_aggr', 'ethereum')
		    , (0xa45420a6f2bb98406b6c6a5cc1670b7c92407e2b, 'instadapp', 'defi_aggr', 'ethereum')
		    , (0x33181b519cd503db862ab291fbe89e9f01083490, 'others', 'others', 'ethereum')
		    , (0xd7c1b48877a7dfa7d51cf1144c89c0a3f134f935, 'idle', 'yield', 'ethereum')
		    , (0xd96f48665a1410c0cd669a88898eca36b9fc2cce, 'abracadabra', 'lending', 'ethereum')
		    , (0x79c0230b1772ac789cb443e1a23cd725b31bad42, 'gnosis_safe', 'multisig', 'ethereum')
		    --, (0x008f9cf207a5b0f69c759f5eb0548db102a8cdac, 'maker', 'lending', 'ethereum')
		    , (0xcf05eadfdb008c106a56680aa3cf656801972401, 'unknown9', 'unknown', 'ethereum') --created by 0xF7B75183A2829843dB06266c114297dfbFaeE2b6
		    , (0x65736a137cd4629454bb0226704deec0aef5aded, 'proxy', 'multisig', 'ethereum')
		    , (0xcd60478d36b6b60dda524c4c67a68e8896882b38, 'instadapp', 'defi_aggr', 'ethereum')
		    --, (0x927f1ed8d3c6183d468e5324a38a9d7f52f15b9c, 'maker', 'lending', 'ethereum')
		    , (0x1ee962529de8a386e5cc188fbbad9e0453edcfa0, 'argent', 'proxy', 'ethereum')
		    --, (0x72146a3ead3a256e8a2189e3cedc0b7bd61991ed, 'maker', 'lending', 'ethereum')
		    , (0x43dffbf34c06eaf9cd1f9b4c6848b0f1891434b3, 'nexo', 'treasury', 'ethereum')
		    , (0x21fb757c2d3a5c574e8721027c3d7a506d77b6b3, 'element finance', 'yield', 'ethereum')
		    , (0xcb84be8e49db5e35d1da62a1070847b914f4cd68, 'gnosis_safe', 'multisig', 'ethereum')
		    , (0x37fec7b2f36f3bbae956262f46ddf21830fa68ef, 'pendle', 'yield', 'ethereum')
		    , (0x1ed5b46a8c708425308bcf3239ff1a57e7cacd09, 'gnosis_safe', 'multisig', 'ethereum')
		    , (0xcd4722b7c24c29e0413bdcd9e51404b4539d14ae, 'balancer_v2', 'gauge', 'ethereum')
		    , (0x64a53b849072a4d778cec579396e279f299b0bec, 'cian', 'strategy', 'ethereum')-- frst txn came from 0xec55E7cfebBE4f878E9dD998d3a038458AC3197D cian strategy pool
		    --, (0x2f606b9562e313f93891956b08be8aca3a750d9d, 'maker', 'lending', 'ethereum')
		    , (0x989aeb4d175e16225e39e87d0d97a3360524ad80, 'convex', 'yield', 'ethereum')
		    , (0xf3abc972a0f537c1119c990d422463b93227cd83, 'pendle', 'yield', 'ethereum')
		    , (0x2a8b9ebc6b62e09f3b2b896bb004533bb4bfcb40, 'unknown10', 'unknown', 'ethereum') --created by 0xF7B75183A2829843dB06266c114297dfbFaeE2b6
		    , (0x8cc2af700d686e7e21135681511992c972dbd8ea, 'instadapp', 'defi_aggr', 'ethereum')
		   -- , (0xcdb238d68d8da74487711bc1f8f13f3d00667d1a, 'maker', 'lending', 'ethereum')
		    , (0xd09f16830172e6073e8e5ee5053f35010f1c7d7a, 'proxy', 'multisig', 'ethereum')
		    , (0xf6539bb5e98ff9c5fca222225263a883d709cdd4, 'instadapp', 'defi_aggr', 'ethereum')
		    , (0x94269a09c5fcbd5e88f9df13741997bc11735a9c, 'instadapp', 'defi_aggr', 'ethereum')
		    , (0x60ee8465dc43245c6c2989b1089e476d3a0a717d, 'instadapp', 'defi_aggr', 'ethereum')
		    , (0x98bbd32a65693356f95d777080fb8eb830389288, 'gnosis_safe', 'multisig', 'ethereum')
		    , (0x84273bba41cd0ec99f59b5b4c85783cf514e4e1a, 'euler', 'lending', 'ethereum')
		    , (0x71ea128E53FAcEbF20D927161E0e9c39d4A29713, 'gearbox', 'lending', 'ethereum')
		    , (0x1e899d5e09e4dcbc037718046214b4745cec99a8, 'argent', 'proxy', 'ethereum')
		    , (0x45533541aac25030b5d438e37cec18e73b545310, 'unknown11', 'unknown', 'ethereum') -- --created by 0xF7B75183A2829843dB06266c114297dfbFaeE2b6
		    , (0x5f34c530ffcc091bfb7228b20892612f79361c34, 'nexo','treasury', 'ethereum')
		    , (0x93a62da5a14c80f265dabc077fcee437b1a0efde, 'yearn', 'treasury', 'ethereum') --treasury Vault
		    , (0x8137351530f9CD81C87EAe9457A6CAF9f910f000, 'gearbox', 'lending', 'ethereum')
		    , (0xe6bcb55f45af6a2895fadbd644ced981bfa825cb, 'kyberswap', 'liquidity_pool', 'ethereum')
		    , (0x34280882267ffa6383b363e278b027be083bbe3b, 'pendle', 'yield', 'ethereum')
            , (0xef001a0d62d43ccab7ac9c461f538e707a9edbf2, 'instadapp', 'defi_aggr', 'ethereum')
            --, (0xe6c2ebad69b325be894f768972dc8f896994e6ce, 'maker', 'lending', 'ethereum')
            , (0x7c07f7abe10ce8e33dc6c5ad68fe033085256a84, 'index_protocol', 'yield', 'ethereum')--iceth holds asteth
            , (0xd973e86547e810117db131b94708f429a463535e, 'balancer_v2', 'gauge', 'ethereum')
            , (0x8e884c724edded0bb4fc659b96511a48d8f1c39d, 'instadapp', 'defi_aggr', 'ethereum')
            , (0xd0bf01f01eda5de2f90d3927796c31c7cf9db809, 'instadapp', 'defi_aggr', 'ethereum')
            , (0xf9fdc2b5f60355a237deb8bd62cc117b1c907f7b, 'yearn', 'yield', 'ethereum') --ssc_eth_steth token 
            , (0xcc61ee649a95f2e2f0830838681f839bdb7cb823, 'stakedao', 'yield', 'ethereum')
            , (0x9600a48ed0f931d0c422d574e3275a90d8b22745, 'instadapp', 'defi_aggr', 'ethereum')
            , (0xcec2981d8047c401f2a4e972a7e5ada3f5ecf838, 'euler', 'lending', 'ethereum')
            , (0xb5b29320d2dde5ba5bafa1ebcd270052070483ec, 'real_yield', 'yield', 'ethereum')
            , (0x19157d43d5f8d6b6c5082be53f05fb35f390a3dd, 'gnosis_safe', 'multisig', 'ethereum')
            , (0xd2dc4192737340b4f773ca60771b2b70c032c674, 'gnosis_safe', 'multisig', 'ethereum')
            , (0x6e799758cee75dae3d84e09d40dc416ecf713652, 'pendle', 'yield', 'ethereum')-- created by Penpie 0x0CdB34e6a4D635142BB92fe403D38F636BbB77b8
            , (0xd0354d4e7bcf345fb117cabe41acadb724eccca2, 'pendle', 'yield', 'ethereum')
            , (0x989aeb4d175e16225e39e87d0d97a3360524ad80, 'convex', 'yield', 'ethereum')
            , (0x307111465e4cedd89fa28b9768981b8768a3cabe, 'instadapp', 'defi_aggr', 'ethereum')
            , (0x01a9502c11f411b494c62746d37e89d6f7078657, 'balancer_v2', 'gauge', 'ethereum')
            , (0x4e079dca26a4fe2586928c1319b20b1bf9f9be72, 'ribbon_v2', 'gauge', 'ethereum')
            , (0xa976ea51b9ba3232706af125a92e32788dc08ddc, 'proxy', 'multisig', 'ethereum')
            , (0x34aacf00a25d7a871d77dbe0eae6ad448b58a91c, 'instadapp', 'defi_aggr', 'ethereum')
            , (0x7902d79ada34e3cb32a3faa5496334a004589925, 'gnosis_safe', 'multisig', 'ethereum')
            , (0xcec2981d8047c401f2a4e972a7e5ada3f5ecf838, 'euler', 'lending', 'ethereum')
            , (0xe979438b331b28d3246f8444b74cab0f874b40e8, 'proxy', 'multisig', 'ethereum')
            , (0x33333aea097c193e66081e930c33020272b33333, 'morpho_aave_v3', 'yield', 'ethereum') 
            , (0x777777c9898d384f785ee44acfe945efdff5f3e0, 'morpho_aave_v2', 'yield', 'ethereum')
            , (0xc374f7ec85f8c7de3207a10bb1978ba104bda3b2, 'pendle', 'yield', 'ethereum')
            , (0x6011436690a085d35d8d90ae417cbaf3767c0fca, 'gnosis_safe', 'multisig', 'ethereum') -- lufycz.eth
            , (0x22c5cf8fc9891f8ef5a5e8630b95115018a09736, 'euler', 'lending', 'ethereum')
            , (0x9600a48ed0f931d0c422d574e3275a90d8b22745, 'instadapp', 'defi_aggr', 'ethereum')
            , (0xfb633f47a84a1450ee0413f2c32dc1772ccaea3e, 'aragon_tresaury', 'treasury', 'ethereum')
            , (0xc977CBadD359aE06b236D9581e37fd5A03E54b84, 'paragons_dao', 'treasury', 'ethereum') --ds proxy not a maker 
            , (0x9162b49919a70c3dcec6ad3bfa0feffb6d14aa5a, 'others', 'others', 'ethereum') --created by eoa.bigcoffee.eth
		    , (0xa57b8d98dae62b26ec3bcc4a365338157060b234, 'aura', 'yield', 'ethereum')
		    , (0x1c9798db3773d30780ff6448e015e7775c1ae75b, 'gnosis_safe', 'multisig', 'ethereum') 
		    , (0xdafca7a5e3b67b8f36c1fdd7691ed85bbb54cc18, 'gnosis_safe', 'multisig', 'ethereum')
		    , (0x889edc2edab5f40e902b864ad4d7ade8e412f9b1, 'lido:withdrawal_queue', 'unstaking', 'ethereum')
		    , (0xf147b8125d2ef93fb6965db97d6746952a133934, 'yearn', 'yield', 'ethereum')
		    , (0xb9e66eae2b3b8e9fe201dd675f1f6f0f5aa02686, 'others', 'others', 'ethereum')
		    , (0x9e7234576a395a6b043fe994724f3ea0d48f5524, 'gnosis_safe', 'multisig', 'ethereum')
		    , (0x840cffa2a3a6f56eb2f205a06748a8284b683355, 'unknown15', 'unknown', 'ethereum') --created by pepes.eth
		    , (0xa8a8c7c4894d2c81d661902ab2daf3d665f3c3ee, 'argent', 'proxy', 'ethereum')
		    -----------------2023-08-18---------------------------
		    , (0x9a443ef0eeae228aaaef0df8b96ead1154bcc9c0, 'instadapp', 'defi_aggr', 'ethereum')
		    , (0x82562507429876486B60AF4F32390ef0947b3d13, 'aave_v3', 'lending', 'ethereum') --vesper stETH
		    , (0x5602d3237af32e50b10b7228335cc2e27c4c120f, 'gnosis_safe', 'multisig', 'ethereum')
		    , (0xd9134681c2c1b77c0422a7969f6a6ff95a4552a7, 'others', 'others', 'ethereum') --created by 0xwald.eth (0x4d73EF089CD9B59405eb303e08B76a4e8da3a1C9)
		    , (0x4c422508fac7e16655d40fda0d158fe997df43f6, 'others', 'others', 'ethereum')
		    , (0x685b819e649269fb362019d22a06517e2757c8f5, 'gnosis_safe', 'multisig', 'ethereum')
		    , (0xf6a7849c24d0392bc0af6dc4ccfc745073ccc539, 'instadapp', 'defi_aggr', 'ethereum') --AVOSAFE
		    , (0x64627901dadb46ed7f275fd4fc87d086cff1e6e3, 'equilibria', 'yield', 'ethereum') 
		    , (0x6d855d3292d28c33e303eea52e31b906dd572ca9, 'others', 'others', 'ethereum') --contract(Vault)created by 0x8Ea8212A240306b44EFc9383AC1908eA73C55d02
		    , (0x133dadace975ba195e3940bbf30f6f80ba90d5fb, 'gnosis_safe', 'multisig', 'ethereum')
		    , (0xea8d287e23f1e005fa8bd3c9d1efae2c726db9a4, 'proxy', 'multisig', 'ethereum')
		    ----2023-09-29---
		    , (0x225d3822De44E58eE935440E0c0B829C4232086e, '1inch', 'strategy', 'ethereum') --team investment fund
		    , (0x720D8790666bd40B9CA289CBe73cb1334f0aE7e3, '?1inch', 'multisig', 'ethereum') -- seems to be affiliated with 1inch foundation 
		    
    )x (address, namespace, category, blockchain)
    --------wsteth holders------------
    UNION
     SELECT * 
     FROM (values
            (0x10CD5fbe1b404B7E19Ef964B63939907bdaf42E2, 'maker', 'lending ', 'ethereum')
            , (0x0b925ed163218f6662a35e0f0371ac234f9e9371, 'aave_v3', 'lending ', 'ethereum')
            , (0xba12222222228d8ba445958a75a0704d566bf2c8, 'balancer_v2', 'liquidity_pool', 'ethereum')
            , (0xeF13101C5bbD737cFb2bF00Bbd38c626AD6952F7, 'paraswap_v5', 'others', 'ethereum') --FeeClaimer 
            , (0xE8A8B458BcD1Ececc6b6b58F80929b29cCecFF40, 'railgun', 'treasury', 'ethereum') --PausableUpgradableProxy
            , (0xfd3cF28E4A3f140fA8EfD5e72f8399FaCB443D05, 'others', 'others', 'ethereum') --hedgeysanta
            , (0xc5f2cf5C4C874C296281e2A73a2E44C9FBA55741, 'ribbon_v2', 'yield', 'ethereum') 
            , (0xbfD291DA8A403DAAF7e5E9DC1ec0aCEaCd4848B9, 'dforce', 'lending', 'ethereum') --TransparentUpgradeableProxy
            , (0x06a0CCFb89E9B2814afCA6637C22ed83909739Ee, 'spirals', 'yield', 'ethereum') --green.eth
            , (0xE76Ffee8722c21b390eebe71b67D95602f58237F, 'unsh.eth', 'strategy', 'ethereum') -- LSDVault 
            , (0x44afd57daf3fd5294c5d09465d368cef5ed1f83e, 'argent', 'proxy', 'ethereum') --Proxy
            , (0x22799bd5769cf44b8de4adedcd899f14ea89f20d, 'argent', 'proxy', 'ethereum') 
            , (0xcd91538b91b4ba7797d39a2f66e63810b50a33d0, 'arcx', '?yield', 'ethereum')
            , (0x9df182535986c1c9917ff893a75bbaff4906dcc5, 'others', 'others', 'ethereum') --Balancer Vault?
            , (0x73aaf8694BA137a7537E7EF544fcf5E2475f227B, 'angle_protocol', 'lending', 'ethereum') --TransparentUpgradeableProxy
            , (0x5364d336c2d2391717bD366b29B6F351842D7F82, 'yield_protocol', 'yield', 'ethereum') --joinfactory
            , (0xcbc72d92b2dc8187414f6734718563898740c0bc, 'pendle', 'yield', 'ethereum') 
            , (0xebfe63ba0264ad639b3c41d2bfe1ad708f683bc8, 'kyber', 'liquidity_pool', 'ethereum')     
            , (0x76943c0d61395d8f2edf9060e1533529cae05de6, 'optimism l1', 'bridge', 'ethereum')     
            , (0x34dcd573c5de4672c8248cd12a99f875ca112ad8, 'idle', 'yield', 'ethereum') 
            , (0x0f25c1dc2a9922304f2eac71dca9b07e310e8e5a, 'arbitrum l1', 'bridge', 'ethereum')    
            , (0x248ccbf4864221fc0e840f29bb042ad5bfc89b5c, 'maker', 'lending', 'ethereum') 
		    , (0x12B54025C112Aa61fAce2CDB7118740875A566E9, 'spark', 'lending', 'ethereum')
		    , (0xDAEada3d210D2f45874724BeEa03C7d4BBD41674, 'ribbon', 'yield', 'ethereum')
		    , (0x062bf725dc4cdf947aa79ca2aaccd4f385b13b5c, 'alchemix_v2', 'lending', 'ethereum') 
		    , (0x51a80238b5738725128d3a3e06ab41c1d4c05c74, 'unsh.eth:lsdvault', 'staking', 'ethereum') --staking?
		    , (0x5934807cc0654d46755ebd2848840b616256c6ef, 'opynfinance_v2', 'yield', 'ethereum') --Ribbon
		    , (0xcda2712b95bf79d64260032fcee623e7a930a6b9, 'others', 'others', 'ethereum') --OKX?
		    , (0xbc6b6c837560d1fe317ebb54e105c89f303d5afd, 'iron_bank', 'lending', 'ethereum')
		    , (0x40ec5b33f54e0e8a33a975908c5ba1c14e5bbbdf, 'polygon_bridge', 'bridge', 'ethereum')
		    , (0x401F6c983eA34274ec46f84D70b31C151321188b, 'polygon_bridge', 'bridge', 'ethereum')
		    , (0x7623e9dc0da6ff821ddb9ebaba794054e078f8c4, 'etherfi', 'staking', 'ethereum')--?
		    , (0xabea9132b05a70803a4e85094fd0e1800777fbef, 'zksync', 'bridge', 'ethereum')
		    , (0x674bdf20a0f284d710bc40872100128e2d66bd3f, 'loopring', 'bridge', 'ethereum')
		    , (0xa17581a9e3356d9a858b789d68b4d866e593ae94, 'compound_v3', 'lending', 'ethereum')
		    , (0xff1f2b4adb9df6fc8eafecdcbf96a2b351680455, 'aztec_v2', 'bridge', 'ethereum') --?
		    , (0x5d22045daceab03b158031ecb7d9d06fad24609b, 'diversiFi', 'bridge', 'ethereum') -- rhino.bridge
		    , (0x2ebe19aa2e29c8acadb14be3e7de153b0141e2aa, 'maverick', 'liquidity_pool', 'ethereum')
		    , (0x4f5717f1efdec78a960f08871903b394e7ea95ed, 'silo', 'lending', 'ethereum')
		    , (0x53773e034d9784153471813dacaff53dbbb78e8c, 'ribbon_v2', 'yield', 'ethereum')
		    , (0x447ddd4960d9fdbf6af9a790560d0af76795cb08, 'curve', 'liquidity_pool', 'ethereum') --Pool: rETH/wstETH
		    , (0xa4108aa1ec4967f8b52220a4f7e94a8201f2d906, 'gravity_bridge', 'bridge', 'ethereum')
		    , (0xd340b57aacdd10f96fc1cf10e15921936f41e29c, 'uniswap_v3', 'liquidity_pool', 'ethereum')
		    , (0x4622df6fb2d9bee0dcdacf545acdb6a2b2f4f863, 'uniswap_v3', 'liquidity_pool', 'ethereum')
		    , (0x341c05c0e9b33c0e38d64de76516b2ce970bb3be, 'index_protocol', 'yield', 'ethereum')--diversified steth
		    , (0x4aa42145Aa6Ebf72e164C9bBC74fbD3788045016, 'xdai_bridge', 'bridge', 'ethereum')
		    , (0x3ee18B2214AFF97000D974cf647E7C347E8fa585, 'wormhole', 'bridge', 'ethereum')
		    , (0x5f59b322eb3e16a0c78846195af1f588b77403fc, 'raft', 'lending', 'ethereum')
		    , (0x37417b2238aa52d0dd2d6252d989e728e8f706e4, 'curve', 'lending', 'ethereum')--llamma_crvusd_amm
		    , (0xbc33a1f908612640f2849b56b67a4de4d179c151, 'kyber_multisig', 'multisig', 'ethereum')--contract MultiSigWalletWithDailyLimit
		    , (0x0eb1c92f9f5ec9d817968afddb4b46c564cdedbe, 'maverick', 'liquidity_pool', 'ethereum')--?
		    , (0x2b0024ecee0626e9cfb5f0195f69dcac5b759dc9, 'gravita', 'lending', 'ethereum')
		    , (0x88ad09518695c6c3712ac10a214be5109a655671, 'gnosis_chain', 'bridge', 'ethereum') --Omni bridge
		    , (0x9e240daf92dd0edf903def1ff1dd036ca447aaf7, '?maker', 'lending', 'ethereum') --???
		    , (0x5d527c9641effeb3802f2ffafdd15a1b95e41c8c, '?maker', 'lending', 'ethereum') --???
		    , (0x608e1e01ef072c15e5da7235ce793f4d24eca67b, 'unknown6', 'unknown', 'ethereum')-- contract created by eridian.eth erc1967proxy
		    , (0xf5bce5077908a1b7370b9ae04adc565ebd643966, 'sushiSwap', 'yield', 'ethereum') --bentobox  v1
		    -----2023-08-01
		    , (0x997d1ed51ff7389883913311810176cbdbd5d1d5, 'gnosis_safe', 'multisig', 'ethereum') --??steth from Curve
	        , (0x78e99ed484605ba66ca9804b0b6fe700242c85bc, 'gnosis_safe', 'multisig', 'ethereum') --?? 
	        , (0xd69d7a1031e6e63a162414f9a77278757690c30e, 'kyber_multisig', 'multisig', 'ethereum')-- contract MultiSigWalletWithDailyLimit
	        , (0xd4578d7c4f1ea95dca09c9b5bb92e1b980a78c86, 'gnosis_safe', 'multisig', 'ethereum' )
	        -----2023-08-25
	        , (0x78605Df79524164911C144801f41e9811B7DB73D, 'mantle_dao', 'treasury', 'ethereum') 
	        , (0x8ad7e0e6edc61bc48ca0dd07f9021c249044ed30, 'curve', 'gauge', 'ethereum') -- ETHwstETH-f Gauge
	        , (0xe6253ef9b67f6ecd0202ad1f90f25a13282932ff, 'others', 'others', 'ethereum')
	        , (0x69580cd3327f22150e79cff8f70059ac56500198, 'unknown18', 'unknown', 'ethereum' ) --created by 0xF7B75183A2829843dB06266c114297dfbFaeE2b6
	        , (0x9008d19f58aabd9ed0d60971565aa8510560ab41, 'cow_protocol', '?defi_aggr', 'ethereum')
	        , (0xc2c2304e163e1ab53de2eeb08820a0b592bec20b, 'balancer_v2', 'gauge', 'ethereum')
	        , (0xa357af9430e4504419a7a05e217d4a490ecec6fa, 'idle', 'yield', 'ethereum')
	        , (0x8e0a8a5c1e5b3ac0670ea5a613bb15724d51fc37, 'idle', 'yield', 'ethereum')
	        , (0x19253228af13d221b8dd58fc24d63df63201401a, 'instadapp', 'defi_aggr', 'ethereum')
	        ------2023-08-30
	        , (0xcde525bd723090284ee2f958c729d83cf117aff9, 'gnosis_safe', 'multisig', 'ethereum')
	        , (0xf554e20a695ea338a126a3a7b5870f1f67253b01, 'flaimincome', '?yield', 'ethereum') --Strategy contract created by 0x9A6c318340e1fB13Fe0A3689e2fD0797191CA92f
	        , (0xb1a32fc9f9d8b2cf86c068cae13108809547ef71, 'nouns', '?treasury', 'ethereum'	) --NounsDAOExecutorProxy
	        , (0xf7b0751fea697cf1a541a5f57d11058a8fb794ee, 'balancer_v2', 'gauge', 'ethereum') --50wstETH-50ACX-gauge
	        , (0x8f157b9a0cc30c4d5d677984ca778b3ac08896c4, 'proxy', 'multisig', 'ethereum') -- created by hihiben.eth

	        ------2023-09-12
	        , (0x55Dd565C6f94B3Bad1f4A35398af4a526Fcd465f, 'nouns','?treasury', 'ethereum')--curlingstone.eth
	        , (0xc53127af77cba7d07dc08e271bd0826c55f97467, 'gnosis_safe', 'multisig', 'ethereum') --affiliated with czsamsunsb.eth
	        , (0xa980d4c0C2E48d305b582AA439a3575e3de06f0E, 'lybra_v2', 'lending', 'ethereum') -- lybra stETH Vault 
	        , (0xdB34FBB4E7989c3f8957e9E9b346bf46Ee0F0408, 'gnosis_safe', 'multisig', 'ethereum')
	        , (0xbf6883a03fd2fcfa1b9fc588ad6193b3c3178f8f, 'prisma', 'lending', 'ethereum')
	        , (0x9633030c27a1fc04d10d8ef9147fdae9de488030, 'unknown20', 'unknown', 'ethereum') -- WalletSimple contract created by 0x185954A55E13bccE634A89d98Ad8648E2755d075
		    --?, (0x05C34Ffaa76AE2E72Ec0dE40AA6bB84dbe34d859, 'unknown21','others', 'ethereum') 
		    , (0xb3295e739380bd68de96802f7c4dba4e54477206, 'element_finance', 'yield', 'ethereum')
		    , (0xa1b77ccf93a2b14174c322d673a87bfa0031a2d2, 'proxy', 'multisig', 'ethereum')
		    , (0x4cc7c3613407ba646b194e3ea880ec91f362446d, 'others', 'others', 'ethereum') 
		    , (0x1ebb09b49eb906b807412dd7e35c33ea8d994b28, 'others', 'others', 'ethereum') -- contract creator 0xA59C5bc33C9d705b738AA553B724D8C39324FD20
		    , (0x46e5a93a6c536f6a1052b7a646715915af14461e, 'unknown23', 'unknown', 'ethereum') -- aEthwstETH contract created by 0xF7B75183A2829843dB06266c114297dfbFaeE2b6
		    , (0x7f2e50105d3eea2247abfe45927a698b0f6a3e38, 'gnosis_safe', 'multisig', 'ethereum')
		    , (0x947f4e0fe9e111a7c085b9032d7d83995af19774, 'instadapp', 'defi_aggr', 'ethereum')
		    , (0x5e28b5858da2c6fb4e449d69eeb5b82e271c45ce, 'lybra_v2_peusd', 'lending', 'ethereum')
		    --2023-09-15
            , (0x73b59d25f472c8302f74651593b209b01eaa971a, 'gnosis_safe', 'multisig', 'ethereum')
            , (0xe313ba733305a6c0571aa0d8b2a2b9cab0e18dc3, 'gnosis_safe', 'multisig', 'ethereum')
            , (0x66767ba0fdd48ca144ef304405c1a5dbb842e75f, 'instadapp', 'defi_aggr', 'ethereum')
            , (0xc6d78e3d7edee32767f7338a1e070f33adb906d7, 'gnosis_safe', 'multisig', 'ethereum')
            , (0x7785ddcece9e3c7d86279cd5e79e4e155f8eb816, 'gnosis_safe', 'multisig', 'ethereum')
            , (0xbdcc8546d6fb1c0d28ddcd20c880f17188973a65, 'gnosis_safe', 'multisig', 'ethereum')
            , (0x2a3DD3EB832aF982ec71669E178424b10Dca2EDe, 'polygon_zkevm_bridge', 'bridge', 'ethereum')
            , (0x4d540d0a975351dbfe82b3af77ac9e52eecb54f3, 'gnosis_safe', 'multisig', 'ethereum') --contract creator j-ledger.silvavault.eth
		    , (0x6C5F35dfD2fA08f5fB2d35d5937181213c7D6a17, 'uniswap_v3', 'liquidity_pool', 'ethereum')
		    , (0x2889302a794dA87fBF1D6Db415C1492194663D13, 'curve', 'liquidity_pool', 'ethereum')--Curve TricryptoLLAMA
            , (0xf9b36e0b1ed967ee09884e5dc98d22ec6da19f2a, 'gnosis_safe', 'multisig', 'ethereum')
            , (0xa9034f72655ae24703901d00f2904ea4834bb38a, 'kyberswap', 'liquidity_pool', 'ethereum')
            , (0x6817CB23429C251155f55241Fc984654F23B0067, 'unknown2', 'unknown', 'ethereum' )--affiliated with 0x6890164c5C31c89F48104976DdE75555b7680841
            , (0x32653587385b364ab83f72c2fd759f5df466c325, 'unknown1', 'unknown', 'ethereum') --created by 0xD8762A742E65006618b3cd39E611e461A9a54291
            , (0x5faf6a2d186448dfa667c51cb3d695c7a6e52d8e, 'yearn', 'yield', 'ethereum') --yvCurve-stETH-WETH
            , (0x91ee5184763d0b80f8dfdcbde762b5d13ad295f4, 'yearn', 'yield', 'ethereum') --yvCurve-stETH-4646
            , (0xdda1c1e21853b5ab670bbd3564a42f18eef17928, 'argent', 'proxy', 'ethereum')
            , (0x7c7635935b079323c762bd40fa2146077f6de0c6, 'argent', 'proxy', 'ethereum')
            , (0xba1abfabae92d98cc8c40536af3d7590a58dc8d8, 'argent', 'proxy', 'ethereum')
            , (0x82ef450fb7f06e3294f2f19ed1713b255af0f541, 'element_finance', 'treasury', 'ethereum')
            , (0x0ea4dda80bec4e2cc4a7f09bc0362ebb6afd6603, 'instadapp','defi_aggr', 'ethereum')
            , (0x7446129e39fb87cd2064da041ad6df0a47e57fde, 'instadapp', 'defi_aggr', 'ethereum') --creatorr cucbku.eth
            , (0x57334aab534f2fb861461262b158b65f22b387e2, 'instadapp', 'defi_aggr', 'ethereum')
            , (0x5d8cca5e1b6983db986cf82784108478a02d0782, 'instadapp', 'defi_aggr', 'ethereum')
            , (0x1ab135b6e8c500e48f11db47b25992d59c43089a, 'others', 'others', 'ethereum')
            , (0x0fe20e0fa9c78278702b05c333cc000034bb69e2, 'galleon', 'yield', 'ethereum')
            , (0x34b1530a32272c63ce499975847669fb08bd272c, 'instadapp', 'defi_aggr', 'ethereum')
            , (0xd8af19cec55374cf424f98effe9c40fd45128ad1, 'instadapp', 'defi_aggr', 'ethereum')
            , (0xd3c79932541cebe473c783d4152532892323b044, 'instadapp', 'defi_aggr', 'ethereum')
            , (0x1d683ff816c4961b15b9a41fe751db4f4d545faf, 'instadapp', 'defi_aggr', 'ethereum')
            , (0xc9b0dce849e2d23cb1c33167e474d5f45926f024, 'instadapp', 'defi_aggr', 'ethereum')
            , (0x36756db0feb879f2f9ade7df3006df5c2dbaf5de, 'gnosis_safe', 'multisig', 'ethereum')
            , (0x53aeb1cd31bc9976c434c2a9ce1e004106a07a08, 'others', 'others', 'ethereum')
            , (0x129ac17d56e2f284ce13e7e259af8373dfffbcb2, 'others', 'others', 'ethereum')
            , (0x01500631c4de4c68584ee08eb4beda10030b2e55, 'others', 'others', 'ethereum')
            , (0x38906e2250c46209eb0840fd92cab8f52145ee41, 'others', 'others', 'ethereum')
            , (0x8dc4f13fd8cdbe62aa9c660945c038f31bf6067f, 'others', 'others', 'ethereum') --created digitaloil.eth
            , (0xe95858753b3c9488c803201496f051f50628b3bd, 'instadapp', 'defi_aggr', 'ethereum')
            , (0xea008b9e96a78ea0cd689b2953d0910d4394f604, 'others', 'others', 'ethereum')
            , (0x1ca75a5c619ab76ad05905eef25b780485e4bd5a, 'gnosis_safe', 'multisig', 'ethereum') --arbipay.eth
            , (0xd61e55ee2ab6a8c8728904cb2bd394822f5885d6, 'others', 'others', 'ethereum')--fabricatedabyss.eth
            , (0x8be08156153d445fa3d3c489075cc5efbfcf43b5, 'instadapp', 'defi_aggr', 'ethereum')
            , (0x788704a1b7e3c55be4ea20564493e2b6b0d84a4f, 'gnosis_safe', 'multisig', 'ethereum')
            , (0xf5307a74d1550739ef81c6488dc5c7a6a53e5ac2, 'vita_dao', 'treasury', 'ethereum')
            , (0xfb3bd022d5dacf95ee28a6b07825d4ff9c5b3814, 'idle', 'treasury', 'ethereum')
            , (0x30234f2afe32693f291b3574d99a55b05840aa05, 'kyberswap', 'liquidity_pool', 'ethereum')
            , (0x64793251cd71ec7437797275c2953cad11900fd7, 'gnosis_safe', 'multisig', 'ethereum') --created by murathan.eth
            , (0x9da53d7bf084005b6e15ffaf583648518743a8a2, 'gnosis_safe', 'multisig', 'ethereum')
            , (0x757aedf57a578a7bd2d06486c91a2223bf11e241, 'gnosis_safe', 'multisig', 'ethereum')
           
            -----2023-09-15 manual check
            , (0x1dea93f48CD2594E27DeB94D41C5ed97A711733d, 'unknown4', 'unknown', 'ethereum') --?wormhole
            , (0xf0743B6eA7673C0866767DA7A04e6574D6F5CA37, 'gnosis_safe', 'multisig', 'ethereum')
            , (0x17CC6042605381c158D2adab487434Bde79Aa61C, 'gnosis_safe', 'multisig', 'ethereum')
            , (0xa1998863c8CfFf63040530A376DE953c1c27833d, '?looper', 'yield', 'ethereum') --contract Vault, steth came from 0x28016e885acea6f4d4aD7F557565B65A52Eb97Ab 
            , (0x4523D43C75c7252A26DC5540985D0bc9670147c9, 'gnosis_safe', 'multisig', 'ethereum')
            , (0x0e5CAA5c889Bdf053c9A76395f62267E653AFbb0, 'aladdin_dao', '?yield', 'ethereum') --!!!
            , (0x39254033945aa2e4809cc2977e7087bee48bd7ab, 'origin_protocol', 'yield', 'ethereum') --!!!
            , (0x889d1ca5cc79cE90ae5a828637ba6Cd18CE3A286, 'gnosis_safe', 'multisig', 'ethereum')
            , (0xCC83a84db062C48f755b7048E1127674240EF68a, 'gnosis_safe', 'multisig', 'ethereum')
            , (0x3217b819EA2d25f1982BaE5dD9C8Fe4C6D546bfC, 'gnosis_safe', 'multisig', 'ethereum')
            , (0x0C402Eb72C506bfb31a54430Df0eA16Eda06116B, 'para_space', 'lending', 'ethereum')
            , (0x0034E8411d397C7377C06995565E61846D9aF957, 'gnosis_safe', 'multisig', 'ethereum')
            , (0x74C6CFc31e8C0eaFE38Cfc59930d00d06C3C1ce1, 'gnosis_safe', 'multisig', 'ethereum')
            , (0x7E8E3CC4EB5D901f552cC52aF3b97f408FAA4544, 'gnosis_safe', 'multisig', 'ethereum')
            , (0x8180D59b7175d4064bDFA8138A58e9baBFFdA44a, 'proxy', 'multisig', 'ethereum')
            , (0xbaaDf7CEFE37794a4286cF4678286d1cD9e83522, 'gnosis_safe', 'multisig', 'ethereum')
            , (0xa45321BED78e63fCdDcee440389F16137492EC6D, 'gnosis_safe', 'multisig', 'ethereum')
            , (0xaA6F9406240033D1dDE409a5a3a1a733592B39FB, 'gnosis_safe', 'multisig', 'ethereum')
            , (0x391382b0eDfBbfaA6059deFD9B8EEed25736b42f, 'gnosis_safe', 'multisig', 'ethereum')
            , (0x99cEF4A71d42C131fd20c0f24f30b0Eb0b22792C, 'decentral_game', 'treasury', 'ethereum')--!!!
            , (0xb059982C89C56724C297C933414aC8aB4518F0Fa, 'gnosis_safe', 'multisig', 'ethereum')
            , (0xb7E9EAaBcC063D3D4b4Df7cd75d1db8041F8Dd36, 'gnosis_safe', 'multisig', 'ethereum')
            , (0x9A9957D44066A7F0465e53b90c8c1567ad833C1a, 'gnosis_safe', 'multisig', 'ethereum') --creator snowsledge.eth
            , (0x15ecfC5b05F1db628f2cb7954Cf9384146f3A180, 'gnosis_safe', 'multisig', 'ethereum')
            , (0x1b6F8EDFdDB5345aF141B724753E34536Dac64eb, 'unknown5', 'unknown', 'ethereum')--?wormhole
            , (0xaFED6a1141813Ff61767D8Ef1d5088485aA87F91, 'gnosis_safe', 'multisig', 'ethereum') --treeverse:Deployer
            , (0xAF68769C720936F82A8046ec0687c019d7CaCE42, 'gnosis_safe', 'multisig', 'ethereum')
            , (0x1DCC9dFD23a4361cFe27146064E79Ac4029D626d, 'gnosis_safe', 'multisig', 'ethereum')
            , (0x2ae3ea98397547fBC1C2Ca77b5f41F146a970948, 'gnosis_safe', 'multisig', 'ethereum')
            , (0xf9B36e0B1ed967Ee09884e5dc98D22ec6DA19f2a, 'gnosis_safe', 'multisig', 'ethereum')
            , (0xBf67F59D2988A46FBFF7ed79A621778a3Cd3985B, 'starknet', '?bridge', 'ethereum')
            , (0x3c98d617db017f51C6A73a13E80E1FE14cD1D8Eb, 'low_carb_crusader', 'multisig', 'ethereum')
            , (0x6f0bC6217fAA5a2F503C057eE6964b756a09Ae2c, 'jade_protocol', 'multisig', 'ethereum') --created by 0xAdDaE8a6aEEa6B14574C2C44AD1A82C149C6458d
            , (0x2cced4ffA804ADbe1269cDFc22D7904471aBdE63, 'yearn', 'yield', 'ethereum') -- yETH weighted stableswap pool
            , (0x9AB6b21cDF116f611110b048987E58894786C244, 'tempus', 'yield', 'ethereum') --
            , (0x87D93d9B2C672bf9c9642d853a8682546a5012B5, 'lido:rewards_committee', 'multisig', 'ethereum')
            , (0x519eF5E6A412Ac44Bd42fE1b9BD0Fc32d3Dd8A72, 'others', 'others', 'ethereum')
            , (0xAABbA04C5beD2196097B13F4AbFD7Ff7C1c6594e, 'gnosis_safe', 'multisig', 'ethereum')
            , (0xD8Ee69652E4e4838f2531732a46d1f7F584F0b7f, 'bzx_protocol', '?others', 'ethereum') --len
            , (0x000000000dFDe7deaF24138722987c9a6991e2D4, 'mev_bot', '?others', 'ethereum')--???
            , (0xF8A37851656c8C1287A6e79D8835E309957951bF, 'proxy', 'multisig', 'ethereum')
            , (0xeB0Cda1a52f9ac0bD5293bd65b52eD07168e1E8e, 'gnosis_safe', 'multisig', 'ethereum')
            , (0xa9D5ae6B9634314468287f3e0EDB8760fC16212E, 'gnosis_safe', 'multisig', 'ethereum')
            , (0x524da079687A6661Bfb1C4cD91E44Ca6D3818Fad, 'gnosis_safe', 'multisig', 'ethereum')
            , (0xfb0A7bC31859B8D9ec36229b4CcfeA3A23FD936C, 'gnosis_safe', 'multisig', 'ethereum')
            , (0xc064C511Db5982D35A5761577cE6B0eF1184487B, 'proxy', 'multisig', 'ethereum')
            , (0x124b77607Bd162387cD32Cd655b44EC8337B13Db, 'gnosis_safe', 'multisig', 'ethereum')
            , (0x5A0506790310D37B663601128066C9d16ABc733d, 'gnosis_safe', 'multisig', 'ethereum')
            , (0x6f419390dA10911ABD1e1C962b569312A9C9C7B1, 'gnosis_safe', 'multisig', 'ethereum')
            , (0x16811f8aFeA766018AD6557d3BA6c58a7251C753, 'others', 'others', 'ethereum') --creator 0xc0B969A7F1F2fB450864D2880c7d9A8Bd75eFC1E
            , (0x79e50342b63486905Ccc408cB540E4B472B2249f, 'gnosis_safe', 'multisig', 'ethereum')
            , (0x2126C05bBd30c6c480bCC1843b85b10f3f412B9d, 'gnosis_safe', 'multisig', 'ethereum')
            , (0x9Ac21266F2f6b0a0da87e4df2002c6B7d8c714F9, 'gnosis_safe', 'multisig', 'ethereum')
            , (0x8cE9dF09496999016a3620b9c992706D7B0B345e, 'gnosis_safe', 'multisig', 'ethereum')
            , (0x4F4495243837681061C4743b74B3eEdf548D56A5, 'axelar', '?bridge', 'ethereum') -- ?
            , (0x0Dd3e7764081c3C0cd2d72cC09410c655CF7ff85, 'gnosis_safe', 'multisig', 'ethereum')
            , (0x0c466Dd48d39e2589aA463c149B918891c62Ae73, 'gnosis_safe', 'multisig', 'ethereum')
            , (0xCe80b5dB06BbB99833Bd6b372A7d416dEff986BA, 'gnosis_safe', 'multisig', 'ethereum')
            , (0xD2DC4C099D13AE4020B8BD085D06696cd15a06B5, 'gnosis_safe', 'multisig', 'ethereum')
            , (0x4aD91c3D23Ea57EE29203db7AE08631973dAE056, 'gnosis_safe', 'multisig', 'ethereum')
            , (0x60c5dE2C786bd25752945c59820090cC996d9432, 'gnosis_safe', 'multisig', 'ethereum')
            , (0xFC36454bCD49493a57A9B5482b22394245A5507e, 'gnosis_safe', 'multisig', 'ethereum')
            , (0x037D715BbCF6e6B9B7CcB108C2f822Ccf092BDC4, 'gnosis_safe', 'multisig', 'ethereum')
            , (0xc2AB6e42303adA5655A19B3b65c796B13f5Db345, 'gnosis_safe', 'multisig', 'ethereum')
            , (0x092DF71576b3505163BF7ad6EBAEbD325A61432D, 'gnosis_safe', 'multisig', 'ethereum')
            , (0x0c5FA111C6B2D12Aa372E963987e67A60fdE8D55, 'gnosis_safe', 'multisig', 'ethereum')
            , (0x14a09FA327D008A181ef56b067217772182F5D0D, 'gnosis_safe', 'multisig', 'ethereum')
            , (0x42852559DB15f23C0294Da87243047c7FE463e0A, 'gnosis_safe', 'multisig', 'ethereum')
            , (0x10B2d74822507DF9e478B5963C98D901caDA0f29, 'others', 'others', 'ethereum')
            , (0xcfdb0e7b9824633151cCa8982BD721a9a1684F20, 'others', 'others', 'ethereum')
            -----2023-09-20
            , (0x4f64951a6583d56004ff6310834c70d182142a07, 'pancakeswap_v3', 'liquidity_pool', 'ethereum')
            , (0x9040e41eF5E8b281535a96D9a48aCb8cfaBD9a48, 'across_protocol', '?bridge', 'ethereum')
            , (0xf20b338752976878754518183873602902360704, 'f2pool', 'others','ethereum' ) --mining, holds sparkwsteth
            , (0x49a8caf0daa83c510f349dd777d05a642ac43494, 'others', 'others', 'ethereum')
            , (0x6f2c9d3658c47e717c2652b884c06b5c2bc2694b, 'others', 'others', 'ethereum')
            , (0xf96c62f406e631a22ae2804b33508eacc7c5b6fb, 'others', 'others', 'ethereum')
            , (0x6f72c9fd9d50524716dddc55fdd41942e37d47cc, 'others', 'others', 'ethereum') --UniswapV2StEthWEthStrategy
             -----------------2023-09-27---------------------------
		    , (0x3fd49a8f37e2349a29ea701b56f10f03b08f1532, 'unknown7', 'unknown', 'ethereum')--???cian- strategy?
		    , (0xe84A061897afc2e7fF5FB7e3686717C528617487, 'proxy', 'multisig', 'ethereum')
		    , (0x482b2150889bfc8cad0548ebb006cfd643647b69, 'others', 'others', 'ethereum')
		    , (0x574053576d2493cb3aa3a482e6e16ea7bb41c6f8, 'gnosis_safe', 'multisig', 'ethereum')
		    , (0xfefe3d7c498ca1074a2d12644f827da828302520, 'instadapp', 'defi_aggr', 'ethereum')
		    , (0x76a523270c95499bcc1fe7061e97a0403e7069e1, 'unknown8', 'unknown', 'ethereum')

            
            
            
            
    )x (address, namespace, category, blockchain)
    --- 2023-07-27 opti holders 
    UNION
     SELECT *
     FROM (values
            (0xc45A479877e1e9Dfe9FcD4056c699575a1045dAA, 'aave_v3', 'lending', 'optimism')
            , (0x26AaB17f27CD1c8d06a0Ad8E4a1Af8B1032171d5, 'sonne_finance', 'lending', 'optimism')
            , (0x22ab31Cd55130435b5efBf9224b6a9d5EC36533F, 'exact.ly', 'lending', 'optimism')
            , (0x4B3488123649E8A671097071A02DA8537fE09A16, 'dforce', 'lending', 'optimism')
            , (0xb90b9b1f91a01ea22a182cd84c1e22222e39b415, 'curve', 'liquidity_pool', 'optimism')
            , (0x6dA98Bde0068d10DDD11b468b197eA97D96F96Bc, 'velodrome', 'liquidity_pool', 'optimism')
            , (0xb415597e800Fb64CC94Aae2cef712d4Ecccb2e91, 'gnosis_safe', 'proxy', 'optimism')--?
            , (0x926b92b15385981416a5e0dcb4f8b31733d598cf, 'mai_finance', 'lending', 'optimism')--?
            , (0x1a7450aacc67d90afb9e2c056229973354cc8987, 'granary', 'lending', 'optimism')
            , (0xC5c247580A4A6E4d3811c0DA6215057aaC480bAc, 'velodrome', 'liquidity_pool', 'optimism')
            , (0xdd63ae655b388Cd782681b7821Be37fdB6d0E78d, 'vesper', 'yield', 'optimism')
            , (0x7178f61694ba9109205b8d6f686282307625e62d, 'velodrome', 'liquidity_pool', 'optimism')
            , (0x04f6c85a1b00f6d9b75f91fd23835974cc07e65c, 'uniswap_v3', 'liquidity_pool', 'optimism')
            , (0x2b037456B95D37fb302ad361C2C0F50697AC37C9, 'beefy', 'yield', 'optimism')
            -- , (0x4C6bF87b7fc1C8Db85877151C6edE38Ed27c34f6, 'metronome', 'lending', 'optimism')
            , (0x498b990c15c31b41b19e3160b3767f513a8c0dbd, 'uniswap_v3', 'liquidity_pool', 'optimism')
            , (0xe3bb0b5847789eb0c89772af2d265e4c5bd9ceaf, 'uniswap_v3', 'liquidity_pool', 'optimism')
            , (0x7B50775383d3D6f0215A8F290f2C9e2eEBBEceb2, 'beethoven', 'liquidity_pool', 'optimism')
            ------2023-09-01
            , (0xba12222222228d8ba445958a75a0704d566bf2c8, 'beethoven', 'treasury', 'optimism') --vault
            , (0x97636e06930f31c0e5f42f4e66c15fe448fbb1d2, 'gnosis_safe', 'proxy', 'optimism') ---intercated with beethoven
            , (0xB9243C495117343981EC9f8AA2ABfFEe54396Fc0, 'toros_finance', 'yield', 'optimism')
            , (0x06a0f283fa9ab931db89ab5c71fdbf166171dd35, 'gnosis_safe', 'proxy', 'optimism') --exactly?
            , (0x83106ddcac5d119a3d0f551e06239e579299b7c4, 'mstable', 'yield', 'optimism')
           -- , (0x7ca75bdea9dede97f8b13c6641b768650cb837820002000000000000000000d5 Beethoven
            -- 0x098f32d98d0d64dba199fc1923d3bf4192e787190001000000000000000000d2)
            , (0x872103ee5d8e1b4e41284355b27b3d20afc3c08a, 'exact.ly', 'strategy', 'optimism') --contract StrategyExactlySupply
            , (0x881B922822668315867D32f674B3287193A17a6C, 'gnosis_safe', 'proxy', 'optimism')
            , (0x0d9b71891dc86400acc7ead08c80af301ccb3d71, 'gnosis_safe', 'proxy', 'optimism')
            , (0x92a22fb981187e2317b4aa993b18fe4e41851b5f, 'gnosis_safe', 'proxy', 'optimism')
            , (0x0bebFe7d613c625EFC7E09Cd7d7F8DE01292cD66, 'others', 'others', 'optimism')--Meth, earn Eth token
            -----2023-09-14
            , (0x93A5B25022aD5Ac93Dc13DFFd1C5c5269153b154, 'instadapp', 'defi_aggr', 'optimism') --AvoSafe contract
            , (0x96a528f4414ac3ccd21342996c93f2ecdec24286, 'pendle', 'yield', 'optimism')
            , (0xB1a8D1D6Dc07ca0e1E78a0004aa0bB034Fa73d60, 'mai_finance', 'lending', 'optimism')
            , (0x954aC12C339C60EAFBB32213B15af3F7c7a0dEc2, 'mai_finance', 'lending', 'optimism')
            , (0x56da1e11923b298d70dae1b4749f4cdd56a02532, 'others', 'others', 'optimism')--HorizonOP
            , (0xf2BcDf38baA52F6b0C1Db5B025DfFf01Ae1d6dBd, 'kyberswap', 'liquidity_pool', 'optimism')
            , (0x248213096ef0e7bf9a9049bb0508d769fcf7b8b5, 'nenofi', 'lending', 'optimism')--!!!
            , (0x794299137282e5d3af56616624ab918d1b2becf3, 'velodrome', 'liquidity_pool', 'optimism')
            , (0xb19f4d65882f6c103c332f0bc012354548e9ce0e, 'reaper_farm', 'yield', 'optimism')--!!
            , (0x8bEFba32E3f1b69b53Cf72D3114AFb1Ce1871878, 'mai_finance', 'lending', 'optimism')
            , (0xad09afbdbec15ab6e389a4340d7eef7c4913a5aa, 'gnosis_safe', 'proxy', 'optimism')
            , (0xff6771a9565f18638fab2972ba7fc798ad8bcad0, 'others', 'others', 'optimism')
            , (0x496bf70ed3a38ba616e2670ea8b62c2140e2309f, 'others', 'others', 'optimism') --Delta Neutral Dividend
            , (0x93bd4b152d11b444a96556848830dfdbf4a0cc59, 'others', 'others', 'optimism')
            , (0x359e29a7f8b83616754b40bde1a1b90c449a686b, 'nenofi', 'lending', 'optimism')--!!!
            
            
            
            
            
            
    )x (address, namespace, category, blockchain)
    -------- poly holders
    UNION
     SELECT *
     FROM (values
            (0xf59036caebea7dc4b86638dfa2e3c97da9fccd40, 'aave_v3', 'lending', 'polygon')
            , (0xcc03032fbf096f14a2de8809c79d8b584151212b, 'mai_finance', 'lending', 'polygon')
            , (0xba12222222228d8ba445958a75a0704d566bf2c8, 'balancer_v2', 'liquidity_pool', 'polygon')
            , (0xba12229072b5c36f3a28b8e34c8af913b2a3675b, 'kyberswap', 'liquidity_pool', 'polygon')
            , (0xa6b96e60648e11055e82f1b7b226a2aa453a29bb, 'uniswap_v3', 'liquidity_pool', 'polygon')
            -- , (0xba12229072b5c36f3a28b8e34c8af913b2a3675b, 'kyberswap', 'liquidity_pool', 'polygon')
            , (0x993defde3e6ef50610eb6d994823dc82565ad3ba, 'uniswap_v3', 'liquidity_pool', 'polygon')
            , (0xff69201019e25e3f8f3180fabdb58d60afed9a1d, 'uniswap_v3', 'liquidity_pool', 'polygon') 
            , (0x3b899f9a0f2a54a1ca0c6aca96851f0414e97d6e, 'others', 'others', 'polygon')--?jarvis jEUR
            , (0x89eb60faa4af132904748161aada014ecb89b213, 'others', 'others', 'polygon')--?jarvis jBRL
            , (0x96d75fd3047a0c960d4f6b71b1176ab6955cf99b, 'gnosis_safe', 'multisig', 'polygon')
            , (0x91bca6cbc144c2fd843534523eaa5e34686a9b19, 'gamma', 'liquidity_pool', 'polygon')--algebra pool
            , (0x0d212ad21be782a3656dda4fa74094ff454af2c7, 'uniswap_v3', 'liquidity_pool', 'polygon')
            , (0xa5adc5484f9997fbf7d405b9aa62a7d88883c345, 'others', 'others', 'polygon')--?mean_finance
            , (0xab08b0c9dadc343d3795dae5973925c3b6e39977, 'kyberswap', 'liquidity_pool', 'polygon')--Kyber Swap: Router
            , (0xCe4388465330a937929Ad892657640FB1805DA93, 'beefy', 'yield', 'polygon')
            , (0x370404A2A57eDfbEaF16Dc8ef8E2d1B0a2A9da15, 'gamma', 'liquidity_pool', 'polygon')--algebra pool
            , (0xCe4388465330a937929Ad892657640FB1805DA93, 'gamma', 'liquidity_pool', 'polygon')
            , (0x9AEa1545fA5093B7b0Ee2526Eb18A521F75004b9, 'gamma', 'liquidity_pool', 'polygon')
            ------2023-09-01
            , (0x0A206D1FAAaD51A99Ab36D0F15B264fD5a4fC7B8, 'instadapp', 'defi_aggr', 'polygon')
            , (0x96D75FD3047A0C960d4F6B71B1176ab6955cF99b, 'gnosis_safe', 'multisig', 'polygon')
            -----2023-09-14
            , (0x7D5ba536ab244aAA1EA42aB88428847F25E3E676, 'kyberswap', 'liquidity_pool', 'polygon')
            , (0x11ccd306f31c940f98be82a9b852680007056baa, 'enzyme_finance', 'defi_aggr', 'polygon')
            , ( 0x28c7df27e5bc7cb004c8d4bb2c2d91f246d0a2c9, 'others', 'others', 'polygon')
            , (0x10ebee1d8d831b21ed40098274633367d0f52516, 'gnosis_safe', 'multisig', 'polygon')
            , (0xb7d55bcb476be86c7bd361aa96089a5ffe8692e6, 'gnosis_safe', 'multisig', 'polygon')
            , ( 0xff69201019e25e3f8f3180fabdb58d60afed9a1d, 'uniswap_v3', 'liquidity_pool', 'polygon')
            , (0xe9ae2ec22dcd2a8242a80ecf7aaf1a2042ff07dd, 'enzyme_finance', 'defi_aggr', 'polygon') --?
            , (0xe6aef2bdfd6f78332747486e498a94d120adaeb7, 'instadapp', 'defi_aggr', 'polygon')
            , (0xf2bcdf38baa52f6b0c1db5b025dfff01ae1d6dbd, 'kyberswap', 'liquidity_pool', 'polygon')
            , (0x7c0a9bae6a79a424657f06b18b4bd0ecd1022f83, 'enzyme_finance', 'defi_aggr', 'polygon') --?
            , (0x11606d99ad8aac49e033b14c89552f585028ba7d, 'mai_finance', 'lending', 'polygon') -- VaultFeeManagerGamma 
            , (0xb2b89fc6dac21b553caa7b3e751089dc0cbd6344, 'others', 'others', 'polygon') -- --Delta Neutral Dividend
            , (0x1d8a6b7941ef1349c1b5e378783cd56b001ecfbc, 'mai_finance', 'lending', 'polygon')
            , (0xf0f5f7c21d181b7a1f9aa36ed46db3e620eda385, 'mai_finance', 'lending', 'polygon')
            , (0x9c90975b13d04d7d535359887c236ac51f2298ce, 'others', 'others', 'polygon')--ICHI Vault Liquidity
            
            
            
        
            
     )x (address, namespace, category, blockchain)
     
      -------- arbi holders
    UNION
     SELECT *
     FROM (values
            (0x513c7E3a9c69cA3e22550eF58AC1C0088e918FFf, 'aave_v3', 'lending', 'arbitrum')
            , (0x42c248d137512907048021b30d9da17f48b5b7b2, 'radiant', 'lending', 'arbitrum')
            , (0x80c12d5b6cc494632bf11b03f09436c8b61cc5df, 'pendle', 'yield', 'arbitrum')
            , (0xba12222222228d8ba445958a75a0704d566bf2c8, 'balancer_v2', 'liquidity_pool', 'arbitrum')
            , (0xa8bad6ce1937f8e047bca239cff1f2224b899b23, 'dforce', 'lending', 'arbitrum')
            , ( 0x6eb2dc694eb516b16dc9fbc678c60052bbdd7d80, 'curve', 'liquidity_pool', 'arbitrum')
            , (0x97893012fbe4ff00dfb18871e7dd7f6394711150, 'gnosis_safe', 'multisig', 'arbitrum')
            , (0xc32eb36f886f638fffd836df44c124074cfe3584, 'shell_protocol', '?defi_aggr', 'arbitrum')
            , (0xEB7e2f8Efac7Ab8079837417b65cD927f05F7465, 'wombat', 'liquidity_pool', 'arbitrum')
            , (0x02944e3fb72aa13095d7cebd8389fc74bec8e48e, 'gnosis_safe', 'multisig', 'arbitrum')
            , (0xBE3dE7fB9Aa09B3Fa931868Fb49d5BA5fEe2eBb1, 'vesta_finance', 'lending', 'arbitrum')
            , (0x5201f6482eea49c90fe609ed9d8f69328bac8dda, 'camelot', 'liquidity_pool', 'arbitrum')
            , (0xCe4388465330a937929Ad892657640FB1805DA93, 'beefy', 'yield', 'arbitrum')
            , (0xFd8AeE8FCC10aac1897F8D5271d112810C79e022, 'pendle', 'yield', 'arbitrum')
            , (0xC8fD1F1E059d97ec71AE566DD6ca788DC92f36AF, 'pendle', 'yield', 'arbitrum')
            , (0x08a152834de126d2ef83D612ff36e4523FD0017F, 'pendle', 'yield', 'arbitrum')
            , (0xCe4388465330a937929Ad892657640FB1805DA93, 'beefy', 'yield', 'arbitrum')
            , (0x9c93f2e2dad5373a0da85115055a362a9181ce6d, 'uniswap_v3', 'liquidity_pool', 'arbitrum')
            , (0x38c7d58601c0dedae623613671b13d514d1206a0, 'uniswap_v3', 'liquidity_pool', 'arbitrum')
            , (0x1f58673666f29c7780390ad22a3a8f8542332b82, 'uniswap_v3', 'liquidity_pool', 'arbitrum')
            , (0x4854ad1555d475c5c0d66589eb246fbe672129b3, 'uniswap_v3', 'liquidity_pool', 'arbitrum')
            , (0x63b2f35c5d99fc5efedf6fc4661b27a5066d39ba, 'uniswap_v3', 'liquidity_pool', 'arbitrum')
            , (0xb6e7871e7fd10b12153a6baaca3ae6eec53d1321, 'uniswap_v3', 'liquidity_pool', 'arbitrum')
            , (0xddbe747d357f0678193efc36a1ae20a2a55d01b4, 'uniswap_v3', 'liquidity_pool', 'arbitrum')
            , (0xf9f4263d519d1b5d87ed871ed54328ea47c803cf, 'uniswap_v3', 'liquidity_pool', 'arbitrum')
            , (0x2efe014c76c458b2e88f29351db4de87336fc856, 'uniswap_v3', 'liquidity_pool', 'arbitrum')
            , (0xd00477fad8a68309d76f9f86af878884f1341350, 'uniswap_v3', 'liquidity_pool', 'arbitrum')
            , (0x36bf227d6BaC96e2aB1EbB5492ECec69C691943f, 'balancer_v2', 'liquidity_pool', 'arbitrum')
            , (0x45C4D1376943Ab28802B995aCfFC04903Eb5223f, 'balancer_v2', 'liquidity_pool', 'arbitrum')
            ------2023-09-01
            , (0x61Ea41f0BffeE903BB90c69b69d4A833c7fb9d8a, '?vswsteth', '?liquidity_pool', 'arbitrum') ---Wrapped liquid staked Ether 2.0 vault shares
            , (0xa8897b4552c075e884bdb8e7b704eb10db29bf0d, 'silo_finance', 'lending', 'arbitrum')--!!!
            , (0x67a5246e2dbbd51250b41128ea277674c65e8dee, 'prepo', '?yield', 'arbitrum')--!!! prePO wstETH Collateral
            , (0x373217e8daee6744d4470e2b8955f4f86e70ecf3, 'gnd_protocol', '?yield', 'arbitrum') --!!!
            , (0xe5011a7cc5cda29f02ce341b2847b58abefa7c26, 'gnosis_safe', 'multisig', 'arbitrum')
            , (0xc631e2179862046a4da964a245559a53205b2bfd, 'premia_finance', 'yield', 'arbitrum') --!!!
            , (0xa5c1c5a67ba16430547fea9d608ef81119be1876, 'plutus_dao', '?yield', 'arbitrum')--!!!
            , (0x93a5b25022ad5ac93dc13dffd1c5c5269153b154, 'instadapp', 'defi_aggr', 'arbitrum') --AVOSAFE
            , (0xFca61E79F38a7a82c62f469f55A9df54CB8dF678, 'dopex_protocol', 'yield', 'arbitrum') --!!! stETH-WEEKLY-CALLS-SSOV-V3 contract 
            -----2023-09-13
            , (0x61fb28d32447ef7f4e85cf247cb9135b4e9886c2, 'liquid_finance', 'treasury', 'arbitrum')--!!!
            , (0xb1e6f8820826491fcc5519f84ff4e2bdbb6e3cad, 'others', 'others', 'arbitrum') --created by Carbon: Deployer
            , (0x2e9ee89099ee816eacb7301bcdb57a6375a1c6e1, 'plutus_dao', 'treasury', 'arbitrum') --!!!
            -- , (0x2e9ee89099ee816eacb7301bcdb57a6375a1c6e1, 'gnosis_safe', 'multisig', 'arbitrum')
            , (0xb329504622bd79329c6f82cf8c60c807df2090c4, 'cian', 'strategy', 'arbitrum')
            , (0x58f046c5374e9cf942b8eeb056126ce86dd63eeb, 'others', 'others', 'arbitrum') --WSTETHSVault
            , (0xdd36915a2657b02ea3e590720dae4c9fa24b6fdd, 'quoda_finance', 'lending', 'arbitrum')--!!!!!!!!
            , (0x0fd7599f94c503bd4b19257d6624db71cea11feb, 'para_space', 'lending', 'arbitrum')
            , (0x7d5ba536ab244aaa1ea42ab88428847f25e3e676, 'kyberswap', 'liquidity_pool', 'arbitrum')
            , (0x747282eadcd331e3a8725dcd9e358514d723b3a3, 'jojo', 'lending', 'arbitrum') --!!!
            , (0x30acd3e86f42fcc87c6fb9873058d8d7133785d4, 'others', 'others', 'arbitrum') -- MasterVault Token (MVT)
            , (0xd4f94d0aaa640bbb72b5eec2d85f6d114d81a88e, 'others', 'others', 'arbitrum') 
            , (0x2d4120138b2c731bad3955a49a1c78ec1ebf063c, 'gnosis_safe', 'multisig', 'arbitrum')
            , (0xde712fb3f860ec26d727a4fb4a914b1bdc93057f, 'theims', 'lending', 'arbitrum') --!!!
            , (0x489526b5f3c0a0e955978cacff7624538f5e2dd1, 'joe', 'liquidity_pool', 'arbitrum') ---!!!
            -----2023-09-29----
            , (0x84446698694b348eaece187b55df06ab4ce72b35, 'gravita', 'liquidity_pool', 'arbitrum')
            , (0x5F41FfF9d70c734eB012F1A0A322980C1863aba4, 'gnosis_safe', 'multisig', 'arbitrum')
            , (0x1344a36a1b56144c3bc62e7757377d288fde0369, 'others', 'others', 'arbitrum')
            , (0x32a958d7094d04e0baaad2f768ab5c0a94b9ca6f, 'gnosis_safe', 'multisig', 'arbitrum')
     
     
     )x (address, namespace, category, blockchain)


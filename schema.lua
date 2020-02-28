return {
	name = "auth-before-proxy",
	fields = {
		{ config = {
				type = "record",
				fields = {
					{ authservice = {type = "string", required = true,}, },  
				},
			},
		},
	},
}


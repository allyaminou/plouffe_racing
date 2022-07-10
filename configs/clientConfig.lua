Races = {Creator = {}, Ui = {}, Hacking = {
	strings = {
		hieroglyphs = {
			'𓀀',
			'𓀁',
			'𓀂',
			'𓀃',
			'𓀄',
			'𓀅',
			'𓀆',
			'𓀇',
			'𓀈',
			'𓀉',
			'𓀊',
			'𓀋',
			'𓀌',
			'𓀍',
			'𓀎',
			'𓀏',
			'𓀐',
			'𓀑',
			'𓀒',
			'𓀓',
			'𓀔',
			'𓀕',
			'𓀖',
			'𓀗',
			'𓀘',
			'𓀙',
			'𓀚',
			'𓀛',
			'𓀜',
			'𓀝',
			'𓀞',
			'𓀟',
			'𓀠',
			'𓀡',
			'𓀢',
			'𓀣',
			'𓀤',
			'𓀥',
			'𓀦',
			'𓀧',
			'𓀨',
			'𓀩',
			'𓀪',
			'𓀫',
			'𓀬',
			'𓀭',
			'𓀮',
			'𓀯',
			'𓀰',
			'𓀱',
			'𓀲',
			'𓀳',
			'𓀴',
			'𓀵',
			'𓀶',
			'𓀷',
			'𓀸',
			'𓀹',
			'𓀺',
			'𓀻',
			'𓀼',
			'𓀽',
			'𓀾',
			'𓀿',
			'𓁀',
			'𓁁',
			'𓁂',
			'𓁃',
			'𓁄',
			'𓁅',
			'𓁆',
			'𓁇',
			'𓁈',
			'𓁉',
			'𓁊',
			'𓁋',
			'𓁌',
			'𓁍',
			'𓁎',
			'𓁏',
			'𓁐',
			'𓁑',
			'𓁒',
			'𓁓',
			'𓁔',
			'𓁕',
			'𓁖',
			'𓁗',
			'𓁘',
			'𓁙',
			'𓁚',
			'𓁛',
			'𓁜',
			'𓁝',
			'𓁞',
			'𓁟',
			'𓁠',
			'𓁡',
			'𓁢',
			'𓁣',
			'𓁤',
			'𓁥',
			'𓁦',
			'𓁧',
			'𓁨',
			'𓁩',
			'𓁪',
			'𓁫',
			'𓁬',
			'𓁭',
			'𓁮',
			'𓁯',
			'𓁰',
			'𓁱',
			'𓁲',
			'𓁳',
			'𓁴',
			'𓁵',
		},
		chinese = {
			'诶',
			'比',
			'西',
			'迪',
			'伊',
			'吉',
			'艾',
			'杰',
			'开',
			'哦',
			'屁'
		},
		numbers = {
			'0',
			'1',
			'2',
			'3',
			'4',
			'5',
			'6',
			'7',
			'8',
			'9'
		},
		symbols = {
			'!',
			'@',
			'#',
			'$',
			'%',
			'^',
			'&',
			'*',
			'+',
			':',
			'?',
			',',
			'.'
		},
		alphabet = {
			'A',
			'B',
			'C',
			'D',
			'E',
			'F',
			'G',
			'H',
			'I',
			'J',
			'K',
			'L',
			'M',
			'N',
			'O',
			'P',
			'Q',
			'R',
			'S',
			'T',
			'U',
			'V',
			'W',
			'X',
			'Y',
			'Z'
		}
	}
}}

TriggerServerEvent("plouffe_racing:sendConfig")

RegisterNetEvent("plouffe_racing:getConfig",function(list)
	if not list then
		while true do
			Races = nil
		end
	else
		for k,v in pairs(list) do
			Races[k] = v
		end

		Races:Start()
	end
end)
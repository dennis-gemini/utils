#!/bin/sh

#
# @author Dennis Chen
#
# Translate human-readable keys into a series of keyboard scancodes
# Especially designed for VirtualBox
#
# Example Usage:
#
#	VBoxManage controlvm <vmname> keyboardputscancode $(echo "${keystorkes}" | ./scancode.sh)
#
#	or
#
#	cat<<-EOF | VBoxManage controlvm <vmname> keyboardputscancode $(./scancode.sh)
#	.....
#	EOF
#

awk 'BEGIN {
	key_down["`"             ] = "29"      ; key_up["`"             ] = "a9"         # `
	key_down["~"             ] = "2a 29"   ; key_up["~"             ] = "a9 aa"      # ~
	key_down["1"             ] = "02"      ; key_up["1"             ] = "82"         # 1
	key_down["!"             ] = "2a 02"   ; key_up["!"             ] = "82 aa"      # !
	key_down["2"             ] = "03"      ; key_up["2"             ] = "83"         # 2
	key_down["@"             ] = "2a 03"   ; key_up["@"             ] = "83 aa"      # @
	key_down["3"             ] = "04"      ; key_up["3"             ] = "84"         # 3
	key_down["#"             ] = "2a 04"   ; key_up["#"             ] = "84 aa"      # #
	key_down["4"             ] = "05"      ; key_up["4"             ] = "85"         # 4
	key_down["$"             ] = "2a 05"   ; key_up["$"             ] = "85 aa"      # $
	key_down["5"             ] = "06"      ; key_up["5"             ] = "86"         # 5
	key_down["%"             ] = "2a 06"   ; key_up["%"             ] = "86 aa"      # %
	key_down["6"             ] = "07"      ; key_up["6"             ] = "87"         # 6
	key_down["^"             ] = "2a 07"   ; key_up["^"             ] = "87 aa"      # ^
	key_down["7"             ] = "08"      ; key_up["7"             ] = "88"         # 7
	key_down["&"             ] = "2a 08"   ; key_up["&"             ] = "88 aa"      # &
	key_down["8"             ] = "09"      ; key_up["8"             ] = "89"         # 8
	key_down["*"             ] = "2a 09"   ; key_up["*"             ] = "89 aa"      # *
	key_down["9"             ] = "0a"      ; key_up["9"             ] = "8a"         # 9
	key_down["("             ] = "2a 0a"   ; key_up["("             ] = "8a aa"      # (
	key_down["0"             ] = "0b"      ; key_up["0"             ] = "8b"         # 0
	key_down[")"             ] = "2a 0b"   ; key_up[")"             ] = "8b aa"      # )
	key_down["-"             ] = "0c"      ; key_up["-"             ] = "8c"         # -
	key_down["_"             ] = "2a 0c"   ; key_up["_"             ] = "8c aa"      # _
	key_down["="             ] = "0d"      ; key_up["="             ] = "8d"         # =
	key_down["+"             ] = "2a 0d"   ; key_up["+"             ] = "8d aa"      # +
	key_down["<backspace>"   ] = "0e"      ; key_up["<backspace>"   ] = "8e"         # backspace
	key_down["\b"            ] = "0e"      ; key_up["\b"            ] = "8e"         # backspace
	key_down["<tab>"         ] = "0f"      ; key_up["<tab>"         ] = "8f"         # tab
	key_down["\t"            ] = "0f"      ; key_up["\t"            ] = "8f"         # tab
	key_down["q"             ] = "10"      ; key_up["q"             ] = "90"         # q
	key_down["Q"             ] = "2a 10"   ; key_up["Q"             ] = "90 aa"      # Q
	key_down["w"             ] = "11"      ; key_up["w"             ] = "91"         # w
	key_down["W"             ] = "2a 11"   ; key_up["W"             ] = "91 aa"      # W
	key_down["e"             ] = "12"      ; key_up["e"             ] = "92"         # e
	key_down["E"             ] = "2a 12"   ; key_up["E"             ] = "92 aa"      # E
	key_down["r"             ] = "13"      ; key_up["r"             ] = "93"         # r
	key_down["R"             ] = "2a 13"   ; key_up["R"             ] = "93 aa"      # R
	key_down["t"             ] = "14"      ; key_up["t"             ] = "94"         # t
	key_down["T"             ] = "2a 14"   ; key_up["T"             ] = "94 aa"      # T
	key_down["y"             ] = "15"      ; key_up["y"             ] = "95"         # y
	key_down["Y"             ] = "2a 15"   ; key_up["Y"             ] = "95 aa"      # Y
	key_down["u"             ] = "16"      ; key_up["u"             ] = "96"         # u
	key_down["U"             ] = "2a 16"   ; key_up["U"             ] = "96 aa"      # U
	key_down["i"             ] = "17"      ; key_up["i"             ] = "97"         # i
	key_down["I"             ] = "2a 17"   ; key_up["I"             ] = "97 aa"      # I
	key_down["o"             ] = "18"      ; key_up["o"             ] = "98"         # o
	key_down["O"             ] = "2a 18"   ; key_up["O"             ] = "98 aa"      # O
	key_down["p"             ] = "19"      ; key_up["p"             ] = "99"         # p
	key_down["P"             ] = "2a 19"   ; key_up["P"             ] = "99 aa"      # P
	key_down["["             ] = "1a"      ; key_up["["             ] = "9a"         # [
	key_down["{"             ] = "2a 1a"   ; key_up["{"             ] = "9a aa"      # {
	key_down["]"             ] = "1b"      ; key_up["]"             ] = "9b"         # ]
	key_down["}"             ] = "2a 1b"   ; key_up["}"             ] = "9b aa"      # }
	key_down["\\"            ] = "2b"      ; key_up["\\"            ] = "ab"         # \
	key_down["|"             ] = "2a 2b"   ; key_up["|"             ] = "ab aa"      # |
	key_down["<capslock>"    ] = "3a"      ; key_up["<capslock>"    ] = "ba"         # caps lock
	key_down["a"             ] = "1e"      ; key_up["a"             ] = "9e"         # a
	key_down["A"             ] = "2a 1e"   ; key_up["A"             ] = "9e aa"      # A
	key_down["s"             ] = "1f"      ; key_up["s"             ] = "9f"         # s
	key_down["S"             ] = "2a 1f"   ; key_up["S"             ] = "9f aa"      # S
	key_down["d"             ] = "20"      ; key_up["d"             ] = "a0"         # d
	key_down["D"             ] = "2a 20"   ; key_up["D"             ] = "a0 aa"      # D
	key_down["f"             ] = "21"      ; key_up["f"             ] = "a1"         # f
	key_down["F"             ] = "2a 21"   ; key_up["F"             ] = "a1 aa"      # F
	key_down["g"             ] = "22"      ; key_up["g"             ] = "a2"         # g
	key_down["G"             ] = "2a 22"   ; key_up["G"             ] = "a2 aa"      # G
	key_down["h"             ] = "23"      ; key_up["h"             ] = "a3"         # h
	key_down["H"             ] = "2a 23"   ; key_up["H"             ] = "a3 aa"      # H
	key_down["j"             ] = "24"      ; key_up["j"             ] = "a4"         # j
	key_down["J"             ] = "2a 24"   ; key_up["J"             ] = "a4 aa"      # J
	key_down["k"             ] = "25"      ; key_up["k"             ] = "a5"         # k
	key_down["K"             ] = "2a 25"   ; key_up["K"             ] = "a5 aa"      # K
	key_down["l"             ] = "26"      ; key_up["l"             ] = "a6"         # l
	key_down["L"             ] = "2a 26"   ; key_up["L"             ] = "a6 aa"      # L
	key_down[";"             ] = "27"      ; key_up[";"             ] = "a7"         # ;
	key_down[":"             ] = "2a 27"   ; key_up[":"             ] = "a7 aa"      # :
	key_down["'\''"          ] = "28"      ; key_up["'\''"          ] = "a8"         # '\''
	key_down["\""            ] = "2a 28"   ; key_up["\""            ] = "a8 aa"      # "
	key_down["<enter>"       ] = "1c"      ; key_up["<enter>"       ] = "9c"         # enter
	key_down["<lshift>"      ] = "2a"      ; key_up["<lshift>"      ] = "aa"         # lshift
	key_down["<shift>"       ] = "2a"      ; key_up["<shift>"       ] = "aa"         # shift = lshift
	key_down["z"             ] = "2c"      ; key_up["z"             ] = "ac"         # z
	key_down["Z"             ] = "2a 2c"   ; key_up["Z"             ] = "ac aa"      # Z
	key_down["x"             ] = "2d"      ; key_up["x"             ] = "ad"         # x
	key_down["X"             ] = "2a 2d"   ; key_up["X"             ] = "ad aa"      # X
	key_down["c"             ] = "2e"      ; key_up["c"             ] = "ae"         # c
	key_down["C"             ] = "2a 2e"   ; key_up["C"             ] = "ae aa"      # C
	key_down["v"             ] = "2f"      ; key_up["v"             ] = "af"         # v
	key_down["V"             ] = "2a 2f"   ; key_up["V"             ] = "af aa"      # V
	key_down["b"             ] = "30"      ; key_up["b"             ] = "b0"         # b
	key_down["B"             ] = "2a 30"   ; key_up["B"             ] = "b0 aa"      # B
	key_down["n"             ] = "31"      ; key_up["n"             ] = "b1"         # n
	key_down["N"             ] = "2a 31"   ; key_up["N"             ] = "b1 aa"      # N
	key_down["m"             ] = "32"      ; key_up["m"             ] = "b2"         # m
	key_down["M"             ] = "2a 32"   ; key_up["M"             ] = "b2 aa"      # M
	key_down[","             ] = "33"      ; key_up[","             ] = "b3"         # ,
	key_down["<"             ] = "2a 33"   ; key_up["<"             ] = "b3 aa"      # <
	key_down["."             ] = "34"      ; key_up["."             ] = "b4"         # .
	key_down[">"             ] = "2a 34"   ; key_up[">"             ] = "b4 aa"      # >
	key_down["/"             ] = "35"      ; key_up["/"             ] = "b5"         # /
	key_down["?"             ] = "2a 35"   ; key_up["?"             ] = "b5 aa"      # ?
	key_down["<rshift>"      ] = "36"      ; key_up["<rshift>"      ] = "b6"         # rshift
	key_down["<lctrl>"       ] = "1d"      ; key_up["<lctrl>"       ] = "9d"         # lctrl
	key_down["<ctrl>"        ] = "1d"      ; key_up["<ctrl>"        ] = "9d"         # ctrl = lctrl
	key_down["<lalt>"        ] = "38"      ; key_up["<lalt>"        ] = "b8"         # lalt
	key_down["<alt>"         ] = "38"      ; key_up["<alt>"         ] = "b8"         # alt = lalt
	key_down["<space>"       ] = "39"      ; key_up["<space>"       ] = "b9"         # space
	key_down["<sp>"          ] = "39"      ; key_up["<sp>"          ] = "b9"         # sp = space
	key_down[" "             ] = "39"      ; key_up[" "             ] = "b9"         # space
	key_down["<ralt>"        ] = "e0 38"   ; key_up["<ralt>"        ] = "e0 b8"      # ralt
	key_down["<rctrl>"       ] = "e0 1d"   ; key_up["<rctrl>"       ] = "e0 9d"      # rctrl
	key_down["<insert>"      ] = "e0 52"   ; key_up["<insert>"      ] = "e0 d2"      # insert
	key_down["<delete>"      ] = "e0 53"   ; key_up["<delete>"      ] = "e0 d3"      # delete
	key_down["<del>"         ] = "e0 53"   ; key_up["<del>"         ] = "e0 d3"      # del = delete
	key_down["<home>"        ] = "e0 47"   ; key_up["<home>"        ] = "e0 c7"      # home
	key_down["<end>"         ] = "e0 4f"   ; key_up["<end>"         ] = "e0 cf"      # end
	key_down["<pageup>"      ] = "e0 49"   ; key_up["<pageup>"      ] = "e0 c9"      # page up
	key_down["<pagedown>"    ] = "e0 51"   ; key_up["<pagedown>"    ] = "e0 d1"      # page down
	key_down["<left>"        ] = "e0 4b"   ; key_up["<left>"        ] = "e0 cb"      # left
	key_down["<up>"          ] = "e0 48"   ; key_up["<up>"          ] = "e0 c8"      # up
	key_down["<down>"        ] = "e0 50"   ; key_up["<down>"        ] = "e0 b0"      # down
	key_down["<right>"       ] = "e0 4d"   ; key_up["<right>"       ] = "e0 cd"      # right
	key_down["<numlock>"     ] = "45"      ; key_up["<numlock>"     ] = "c5"         # num lock
	key_down["<keypad-7>"    ] = "47"      ; key_up["<keypad-7>"    ] = "c7"         # keypad-7 / home
	key_down["<keypad-4>"    ] = "4b"      ; key_up["<keypad-4>"    ] = "cb"         # keypad-4 / left
	key_down["<keypad-1>"    ] = "4f"      ; key_up["<keypad-1>"    ] = "cf"         # keypad-1 / end
	key_down["<keypad-/>"    ] = "e0 35"   ; key_up["<keypad-/>"    ] = "e0 b5"      # keypad-/
	key_down["<keypad-8>"    ] = "48"      ; key_up["<keypad-8>"    ] = "c8"         # keypad-8 / up
	key_down["<keypad-5>"    ] = "4c"      ; key_up["<keypad-5>"    ] = "cc"         # keypad-5
	key_down["<keypad-2>"    ] = "50"      ; key_up["<keypad-2>"    ] = "d0"         # keypad-2 / down
	key_down["<keypad-0>"    ] = "52"      ; key_up["<keypad-0>"    ] = "d2"         # keypad-0 / ins
	key_down["<keypad-*>"    ] = "37"      ; key_up["<keypad-*>"    ] = "b7"         # keypad-*
	key_down["<keypad-9>"    ] = "49"      ; key_up["<keypad-9>"    ] = "c9"         # keypad-9 / pgup
	key_down["<keypad-6>"    ] = "4d"      ; key_up["<keypad-6>"    ] = "cd"         # keypad-6 / right
	key_down["<keypad-3>"    ] = "51"      ; key_up["<keypad-3>"    ] = "d1"         # keypad-3 / pgdn
	key_down["<keypad-.>"    ] = "53"      ; key_up["<keypad-.>"    ] = "d3"         # keypad-. / del
	key_down["<keypad-->"    ] = "4a"      ; key_up["<keypad-->"    ] = "ca"         # keypad--
	key_down["<keypad-+>"    ] = "4e"      ; key_up["<keypad-+>"    ] = "ce"         # keypad-+
	key_down["<keypad-enter>"] = "e0 1c"   ; key_up["<keypad-enter>"] = "e0 9c"      # keypad-enter
	key_down["<esc>"         ] = "01"      ; key_up["<esc>"         ] = "81"         # esc
	key_down["<f1>"          ] = "3b"      ; key_up["<f1>"          ] = "bb"         # f1
	key_down["<f2>"          ] = "3c"      ; key_up["<f2>"          ] = "bc"         # f2
	key_down["<f3>"          ] = "3d"      ; key_up["<f3>"          ] = "bd"         # f3
	key_down["<f4>"          ] = "3e"      ; key_up["<f4>"          ] = "be"         # f4
	key_down["<f5>"          ] = "3f"      ; key_up["<f5>"          ] = "bf"         # f5
	key_down["<f6>"          ] = "40"      ; key_up["<f6>"          ] = "c0"         # f6
	key_down["<f7>"          ] = "41"      ; key_up["<f7>"          ] = "c1"         # f7
	key_down["<f8>"          ] = "42"      ; key_up["<f8>"          ] = "c2"         # f8
	key_down["<f9>"          ] = "43"      ; key_up["<f9>"          ] = "c3"         # f9
	key_down["<f10>"         ] = "44"      ; key_up["<f10>"         ] = "c4"         # f10
	key_down["<f11>"         ] = "57"      ; key_up["<f11>"         ] = "d7"         # f11
	key_down["<f12>"         ] = "58"      ; key_up["<f12>"         ] = "d8"         # f12
	key_down["<prtscr>"      ] = "e0 37"   ; key_up["<prtscr>"      ] = "e0 b7"      # print screen
	key_down["<alt-sysrq>"   ] = "54"      ; key_up["<alt-sysrq>"   ] = "d4"         # alt-sysrq
	key_down["<scrolllock>"  ] = "46"      ; key_up["<scrolllock>"  ] = "c6"         # scroll lock
	key_down["<pause>"       ] = "e1 1d 45"; key_up["<pause>"       ] = "e1 1d c5"   # pause
	key_down["<ctrl-break>"  ] = "e0 46"   ; key_up["<ctrl-break>"  ] = "e0 c6"      # ctrl-break
	key_down["<lwin>"        ] = "e0 5b"   ; key_up["<lwin>"        ] = "e0 db"      # lwin
	key_down["<win>"         ] = "e0 5b"   ; key_up["<win>"         ] = "e0 db"      # win = lwin
	key_down["<rwin>"        ] = "e0 5c"   ; key_up["<rwin>"        ] = "e0 dc"      # lwin
	key_down["<menu>"        ] = "e0 5d"   ; key_up["<menu>"        ] = "e0 dd"      # menu
	key_down["<sleep>"       ] = "e0 5f"   ; key_up["<sleep>"       ] = "e0 df"      # sleep
	key_down["<power>"       ] = "e0 5e"   ; key_up["<power>"       ] = "e0 de"      # power
	key_down["<wake>"        ] = "e0 63"   ; key_up["<wake>"        ] = "e0 e3"      # wake

	#self-check
	for(key in key_down) {
		if(key in key_up) {
			if(length(key_down[key] == length(key_up[key]))) {
				continue;
			}
		}
		print "Defect found, checking typo at: ", key
	}
}

function translate(key)
{
	str = "";

	while(key != "") {
		ch = substr(key, 1, 1);

		if(ch == "<") {
			ndx = index(key, ">");

			if(ndx > 0 && ndx > i + 2) {
				mnemonic = tolower(substr(key, 1, ndx));
				keycode  = key_down[mnemonic];

				if(keycode != "") {
					str = str " " keycode " " key_up[mnemonic];
				} else {
					split(substr(mnemonic, 2, length(mnemonic) - 2), compound, "-")

					for(j = 1; j <= length(compound); j++) {
						if(length(compound[j]) > 1) {
							keycode = key_down["<" compound[j] ">"];
						} else {
							keycode = key_down[compound[j]];
						}

						if(keycode != "") {
							str = str " " keycode
						} else {
							str = str " (undef)"
						}
					}

					for(j = length(compound); j >= 1; j--) {
						if(length(compound[j]) > 1) {
							keycode = key_up["<" compound[j] ">"];
						} else {
							keycode = key_up[compound[j]];
						}

						if(keycode != "") {
							str = str " " keycode
						} else {
							str = str " (undef)"
						}
					}
				}
				key = substr(key, ndx + 1, length(key) - ndx)
				continue;
			}
		}

		keycode = key_down[ch];

		if(keycode != "") {
			str = str " " keycode " " key_up[ch];
		} else {
			str = str " (undef)"
		}
		key = substr(key, 2, length(key) - 1)
	}
	return str
}

{
	result=""
	
	if(NR > 1) {
		result = translate("<enter>");
	} 
	
	result = result translate($0);
	
	if(NR > 1) { 
		printf("%s", result);
	} else {
		printf("%s", substr(result, 2, length(result) - 1));
	}
}
'

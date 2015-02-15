mj_path = "./mahjong/"

package.path = package.path..";"..mj_path.."mod/?.lua;"..mj_path.."lib/?.lua;"..mj_path.."pp/?.lua;"..mj_path.."proto/?.lua;"..mj_path.."test/?.lua"

--print("now package path ", package.path)
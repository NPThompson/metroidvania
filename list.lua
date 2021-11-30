-- list.lua



list_remove_first_of = function(cur, val)
	if cur == nil then return nil end
	if cur.car == val then return cur.cdr else cur.cdr = list_remove_first_of(cur.cdr, val) end
	return cur
end



list = function()
	return 
	{	head    = nil
	   ,prepend = function(ls, val)
			ls.head = {car = val, cdr = ls.head}
	   end
	   
	   ,rm = function(ls, val)
			ls.head = list_remove_first_of(ls.head, val)
	   end
	   
	   ,for_each = function(ls, p)
			local cur = ls.head
			while cur do
				p(cur.car)
				cur = cur.cdr
			end
	   end
	   
	   ,handshake = function(ls, p)
			local cur1 = ls.head
			local cur2 
	   
			while cur1 do 
				cur2 = cur1.cdr
				
				while cur2 do
					p(cur1.car, cur2.car)
					cur2 = cur2.cdr
				end
				
				cur1 = cur1.cdr
			end
	   end
	}
end


elems = function(ls)
	local cur = ls.head
	
	return function()
		if cur then 
			elem = cur.car
			cur  = cur.cdr
			return elem
		else
			return nil
		end
	end
end




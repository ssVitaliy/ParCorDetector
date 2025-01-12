function findextrems(arr, half_win, trig_level; max_cnt=2)
	
	pos = Int[]
	pos_num = 1
	max_val = 0
	cur_pos = 0
	dir = 1
	trig_level *= 2*half_win + 1

	for x in 1+half_win:length(arr)-half_win	
		winsum = sum(arr[x-half_win:x+half_win])-dir*trig_level
		if abs(winsum) > 0
			if dir*winsum > dir*max_val
				max_val = winsum
				cur_pos = x
			elseif abs(winsum) < 0.7*abs(max_val)
				push!(pos, cur_pos)
				pos_num+=1
				max_val = 0
				dir *= -1
			end
		end
		if pos_num > max_cnt
			break
		end
		if pos_num > 2 && x - pos[end] > 2*(pos[2] - pos[1])
			break
		end 
	end
	return pos
end

function freqbyextrems(arr, time_step)
    hp_num = length(arr)-1 # Number of half-periods

    #hp_time - Median time of 1 half-period
    hp_time = sum([arr[i+1]-arr[i] for i in 1:hp_num])/hp_num

    # Return frequency
    (time_step*2*hp_time)^-1
end


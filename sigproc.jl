function find_extrems(arr, half_win, low_limit; max_cnt=2)
	
	pos = Int[]
	pos_num = 1
	maxval = 0
	cur_pos = 0
	dir = 1

	for x in 1+half_win:length(arr)-half_win	
		winsum = sum(arr[x-half_win:x+half_win])-dir*low_limit
		if abs(winsum) > 0
			if dir*winsum > dir*maxval
				maxval = winsum
				cur_pos = x
			elseif abs(winsum) < 0.7*abs(maxval)
				push!(pos, cur_pos)
				pos_num+=1
				maxval = 0
				dir *= -1
			end
		end
		if pos_num > max_cnt
			break
		end
#		if pos_num > 2 && cur_pos > 2*(pos[end] - pos[end-1])
#			break
#		end 
	end
	return pos
end

function calc_freq_by_extrems(arr, time_step)
    hp_num = length(arr)-1 # Number of half-periods
    hp_time{Float64} # Median time of 1 half-period

    hp_time = sum([arr[i+1]-arr[i] for i in 1:hp_num])/hp_num
    # Return frequency
    (time_step*2*hp_time)^-1
end

